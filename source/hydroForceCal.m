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

% HydroForce Calculations

switch waves.type
%   Regular waves sinusoidal steady-state
    case 'Regular'
    hydroForce = hydroForcePre(waves,body.hydro,)
%     [hydroForce] = hydroForce_RegExt(hydro,waves);
%     [hydroForce] = hydroForce_intpAddMassDamping(hydro, hydroForce, waves, simulation.CIkt);
%     
% %   Regular waves convolutional integral calculation
%     case 'RegularCIC'
%     [hydroForce] = hydroForce_RegExt(hydro,waves);
%     [hydroForce] = hydroForce_IRK(hydro, hydroForce, simulation, waves.numFqs);
%     
% %   Regular waves convolutional integral calculation
%     case 'Irregular' 
%     [hydroForce] = hydroForce_IrrExt(hydro, waves);
%     [hydroForce] = hydroForce_IRK(hydro, hydroForce, simulation, waves.numFqs);
    
    otherwise
    warning('Unexpected wave environment type setting');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book keeping. Will be changed after the class is built
for i=1:hydro.WAMIT.NBODY
    temp(:,:)=hydro.model.HGRes(:,:,i);
    evalc(['Force' num2str(i) '.HGRes' '= temp']); 
    clear temp;
    temp(:,:)=hydroForce.Fadm(:,:,i);
    evalc(['Force' num2str(i) '.Fadm' '= temp']); 
    clear temp;
    temp(:,:)=hydroForce.Fdmp(:,:,i);
    evalc(['Force' num2str(i) '.Fdmp' '= temp']); 
    clear temp;
end

switch waves.type
    case {'Regular','RegularCIC'}
        for i=1:hydro.WAMIT.NBODY
            temp(:,1)=hydroForce.Fext.Im(:,i);
            evalc(['Force' num2str(i) '.Fext.Im' '= temp']); 
            clear temp;
            temp(:,1)=hydroForce.Fext.Re(:,i);
            evalc(['Force' num2str(i) '.Fext.Re' '= temp']); 
            clear temp;
        end
    case 'Irregular' 
        for i=1:hydro.WAMIT.NBODY
            temp(:,:)=hydroForce.Fext.Im(:,:,i);
            evalc(['Force' num2str(i) '.Fext.Im' '= temp']); 
            clear temp;
            temp(:,:)=hydroForce.Fext.Re(:,:,i);
            evalc(['Force' num2str(i) '.Fext.Re' '= temp']); 
            clear temp;
        end        
end

for i=1:hydro.WAMIT.NBODY
    temp(:,:,:)=hydroForce.IRKA(:,:,:,i);
    evalc(['Force' num2str(i) '.IRKA' '= temp']);  
    clear temp;
    temp(:,:,:)=hydroForce.IRKB(:,:,:,i);
    evalc(['Force' num2str(i) '.IRKB' '= temp']); 
    clear temp;
end

clear i ans hydroForce;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%