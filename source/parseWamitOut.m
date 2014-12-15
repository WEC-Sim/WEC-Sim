%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hydro]= parseWamitOut(fname)
  %% simulation parameters and hydrostatic restoring  
    hydro.numBodies = 0;
    hydro.numPeriods = -2;
    
    fid = fopen(fname, 'r');
    if fid == -1; error(['ERROR: Could not locate and open file ' fname]); end
    readingInput = 'reading';
    while readingInput == 'reading'
        temp = fgetl(fid);
        if temp == -1;
            break;
        end
        
        tmp = 'Total panels:';
        if isempty(strfind(temp, tmp)) == 0
           hydro.numBodies=hydro.numBodies+1; 
        end
        
        tmp = ' Wave period';
        if isempty(strfind(temp, tmp)) == 0
            hydro.numPeriods = hydro.numPeriods+1;
        end
        
        tmp = ' Volumes (VOLX,VOLY,VOLZ):';
        if isempty(strfind(temp, tmp)) == 0
           hydro.vol{hydro.numBodies}=textscan(temp(length(tmp)+1:end),'%f');
        end
        
        tmp = ' Water depth:';
        if isempty(strfind(temp, tmp)) == 0
            A=textscan(temp(length(tmp)+1:end), '%f');
            hydro.waterDepth=A{1};
        end
              
        tmp = ' XBODY =';
        if isempty(strfind(temp, tmp)) == 0
            hold = textscan(temp,'%s %s %f %s %s %f %s %s %f %s %s %f');
            hydro.cg{hydro.numBodies} = [hold{3} hold{6} hold{9}];
            hydro.phiBody{hydro.numBodies} = hold{12};
        end
               
        n=strfind(temp, 'Hydrostatic and gravitational')';
        len=length(n);
        if len~=0;
           hydro.linearHyroRestCoef{hydro.numBodies} = zeros(6,6);
           temp = fgetl(fid);        
           n=find(temp==':')';
           A=textscan(temp(n+1:end), '%f');
           hydro.linearHyroRestCoef{hydro.numBodies}(3,3:5)=A{1};
           
           temp = fgetl(fid);
           n=find(temp==':')';
           A=textscan(temp(n+1:end), '%f');
           hydro.linearHyroRestCoef{hydro.numBodies}(4,4:6)=A{1};
           
           temp = fgetl(fid);        
           n=find(temp==':')';
           A=textscan(temp(n+1:end), '%f');
           hydro.linearHyroRestCoef{hydro.numBodies}(5,5:6)=A{1};
        end
        
end;
        
        
%% DIFFRACTION EXCITING FORCES AND MOMENTS
frewind(fid)
readingInput = 'reading';
size=hydro.numBodies*6;
k=0;
while strcmp(readingInput, 'reading')
    temp = fgetl(fid);
    if temp == -1;
        break;
    end
    n0=strfind(temp, 'Wave period')';    
    n1=strfind(temp, 'Wave period = infinite')';
    n2=strfind(temp, 'Wave period = zero')';
    len0=length(n0);
    len1=length(n1);
    len2=length(n2);

    if len0~=0 && len1==0 && len2==0;   
       n=find(temp=='=')';
       A=textscan(temp(n+1:end), '%f');
       k=k+1; kd=0;
       hydro.period(k) = A{1};
       readingData = 'reading';
       while strcmp(readingData, 'reading')
             temp = fgetl(fid); 
             n=strfind(temp, 'DIFFRACTION EXCITING FORCES AND MOMENTS')';
             if length(n)~=0
                temp = fgetl(fid);   
                temp = fgetl(fid);   
                n1=strfind(temp, 'Wave Heading (deg)')'; 
                if length(n1)~=0
                   n=find(temp==':')';
                   A=textscan(temp(n+1:end), '%f');
                   kd=kd+1;
                   hydro.WaveDirection(kd) = A{1};         
                   temp = fgetl(fid);   
                   temp = fgetl(fid);
                   temp = fgetl(fid);
                   readingDiffractionExcitation = 'reading';
                   while strcmp(readingDiffractionExcitation, 'reading')             
                         temp = fgetl(fid);
                         A=textscan(temp(1:end), '%f %f %f');  
                         if A{1}>=1 && A{1}<=size
                            hydro.fExt.mag(A{1},k,kd)= A{2};
                            hydro.fExt.pha(A{1},k,kd)= A{3};
                            hydro.fExt.re(A{1},k,kd)= hydro.fExt.mag(A{1},k,kd) ...
                            *cos(hydro.fExt.pha(A{1},k,kd)*pi/180);
                            hydro.fExt.im(A{1},k,kd)= hydro.fExt.mag(A{1},k,kd) ...
                            *sin(hydro.fExt.pha(A{1},k,kd)*pi/180);
                         end
                         if A{1}==size 
                            readingDiffractionExcitation = 'StopLoop';   
                            readingData = 'StopLoop';        
                         end
                   end
                end
             end             
       end
    end
end
    
%% Added mass and damping
frewind(fid)
readingInput = 'reading';
size=hydro.numBodies*6;
k=0;
hydro.fAddedMassInf(1:size,1:size) = 0.0;
hydro.fDampingInf(1:size,1:size) = 0.0;
hydro.fAddedMassZero(1:size,1:size) = 0.0;
hydro.fDampingZero(1:size,1:size) = 0.0;
while strcmp(readingInput, 'reading')
    temp = fgetl(fid);
    if temp == -1;
        break;
    end
    n0=strfind(temp, 'Wave period')';    
    n1=strfind(temp, 'Wave period = infinite')';
    n2=strfind(temp, 'Wave period = zero')';
    len0=length(n0);
    len1=length(n1);
    len2=length(n2);

% Added-mass for Wave period at infinity
    if len0~=0 && len1~=0;   
       readingData = 'reading';
       while strcmp(readingData, 'reading')
             temp = fgetl(fid); 
             n=strfind(temp, 'ADDED-MASS COEFFICIENTS')';
             if length(n)~=0
                temp = fgetl(fid);
                temp = fgetl(fid);
                readingAddedMass = 'reading';
                while strcmp(readingAddedMass, 'reading')             
                     temp = fgetl(fid);
                      A=textscan(temp(1:end), '%f %f %f');  
                      if A{1}>=1 && A{1}<=size
                         hydro.fAddedMassInf(A{1},A{2})= A{3};
                         hydro.fDampingInf(A{1},A{2})= 0;
                      end
                      if A{1}==size && A{2}==size
                         readingAddedMass = 'StopLoop';   
                         readingData = 'StopLoop';        
                      end
                end
             end             
       end
    end

% Added-mass for Wave period at zero
    if len0~=0 && len2~=0;   
       readingData = 'reading';
       while strcmp(readingData, 'reading')
             temp = fgetl(fid); 
             n=strfind(temp, 'ADDED-MASS COEFFICIENTS')';
             if length(n)~=0
                temp = fgetl(fid);
                temp = fgetl(fid);
                readingAddedMass = 'reading';
                while strcmp(readingAddedMass, 'reading')             
                     temp = fgetl(fid);
                      A=textscan(temp(1:end), '%f %f %f');  
                      if A{1}>=1 && A{1}<=size
                         hydro.fAddedMassZero(A{1},A{2})= A{3};
                         hydro.fDampingZero(A{1},A{2})= 0;
                      end
                      if A{1}==size && A{2}==size
                         readingAddedMass = 'StopLoop';   
                         readingData = 'StopLoop';        
                      end
                end
             end             
       end
    end    

% Added-mass and radiation damping for other cases   
    if len0~=0 && len1==0 && len2==0;
       n=find(temp=='=')';
       A=textscan(temp(n+1:end), '%f');
       k=k+1;
       hydro.period(k) = A{1};
       readingData = 'reading';
       while strcmp(readingData, 'reading')
             temp = fgetl(fid); 
             n=strfind(temp, 'ADDED-MASS AND DAMPING COEFFICIENTS')';
             if length(n)~=0
                temp = fgetl(fid);
                temp = fgetl(fid);
                readingAddedMassDamping = 'reading';
                while strcmp(readingAddedMassDamping, 'reading')             
                     temp = fgetl(fid);
                      A=textscan(temp(1:end), '%f %f %f %f');  
                      if A{1}>=1 && A{1}<=size
                         hydro.fAddedMass(A{1},A{2},k)= A{3};
                         hydro.fDamping(A{1},A{2},k)= A{4};
                      end
                      if A{1}==size && A{2}==size
                         readingAddedMassDamping = 'StopLoop';   
                         readingData = 'StopLoop';        
                      end
                end
             end             
       end
    end  
    
end;


fclose(fid);


end