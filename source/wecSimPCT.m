%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National
% Technology & Engineering Solutions of Sandia, LLC (NTESS).
% Under the terms of Contract DE-NA0003525 with NTESS,
% the U.S. Government retains certain rights in this software.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wecSimPCT
% WEC-Sim parallel computing toolbox executable
clear mcr imcr i j k l1 l2 m n name nseed kkk len numConditions
clear body waves simu output pto constraint ptoSim
global mcr

% open the local cluster profile
p = parcluster('local');
totalNumOfWorkers=p.NumWorkers;

% open the parallel pool, recording the time it takes
tic;
parpool(p); % open the pool

fprintf('Opening the parallel pool took %g seconds.\n', toc)

evalc('wecSimInputFile');

if isempty(simu.mcrMatFile) == 0
    load(simu.mcrMatFile);
else
    kkk=0;
    mcr.header = {'waves.height','waves.period'};
    if isempty(simu.mcrExcelFile) == 0
        mcr.waveSS = xlsread(simu.mcrExcelFile);
        mcr.waveSS(isnan(mcr.waveSS))=0;
        for i=2:length(mcr.waveSS(:,1))
            for j=2:length(mcr.waveSS(1,:))
                if (mcr.waveSS(i,j)>0)
                    kkk = kkk+1;
                    mcr.cases(kkk,1) = mcr.waveSS(i,1);
                    mcr.cases(kkk,2) = mcr.waveSS(1,j);
                end
            end
        end
    else
        for i=1:length(waves.height)
            for j=1:length(waves.period)
                kkk = kkk+1;
                mcr.cases(kkk,1) = waves.height(i);
                mcr.cases(kkk,2) = waves.period(j);
            end
        end
    end
    
    numConditions=2;
    if length(waves.phaseSeed)>1
        numConditions=numConditions+1;
        mcr.header{numConditions} = 'waves.phaseSeed';
        len = length(mcr.cases(:,1));
        for nseed=1:length(waves.phaseSeed)
            mcr.cases(len*(nseed-1)+1:len*(nseed-1)+len,1:numConditions-1) = mcr.cases(1:len,1:numConditions-1);
            mcr.cases(len*(nseed-1)+1:len*(nseed-1)+len,    numConditions) = waves.phaseSeed(nseed);
        end
    end
    
    if exist('pto','var')
        for n=1:size(pto,2)
            if (length(pto(n).damping)>1 || length(pto(n).stiffness)>1)
                numConditions=numConditions+2;
                name = sprintf('pto(%i).damping', n);
                mcr.header{numConditions-1} = name;
                name = sprintf('pto(%i).stiffness', n);
                mcr.header{numConditions  } = name;
                
                len = length(mcr.cases(:,1)); kkk = 0;
                for l2=1:length(pto(n).stiffness)
                    for l1=1:length(pto(n).damping)
                        kkk=kkk+1;
                        mcr.cases(len*(kkk-1)+1:len*(kkk-1)+len,1:numConditions-2) = mcr.cases(1:len,1:numConditions-2);
                        mcr.cases(len*(kkk-1)+1:len*(kkk-1)+len,  numConditions-1) = pto(n).damping(l1);
                        mcr.cases(len*(kkk-1)+1:len*(kkk-1)+len,    numConditions) = pto(n).stiffness(l2);
                    end
                end
            end
        end; clear i j k l1 l2 m n name nseed kkk len numConditions
    end
end

%% Execute wecSimPCT
pause(1)
delete savedLog*
parfor imcr=1:length(mcr.cases(:,1))
    warning('off', 'MATLAB:MKDIR:DirectoryExists');
    t = getCurrentTask();
    filename = sprintf('savedLog%03d.txt', t.ID);
    pctDir = sprintf('pctDir_%g', t.ID);
    getAttachedFilesFolder(pctDir);
    fileID = fopen(filename,'a');
    fprintf(fileID,'wecSimPCT Case %g/%g on Worker Number %g/%g \n',imcr,length(mcr.cases(:,1)),t.ID,totalNumOfWorkers);
    % Run WEC-Sim
    wecSimFcn(imcr,mcr,pctDir,totalNumOfWorkers);   
    fclose(fileID);
    rmdir(pctDir, 's')    
end

clear imcr totalNumOfWorkers
delete(gcp); % close the parallel pool


