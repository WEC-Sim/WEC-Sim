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

clear mcr imcr i j k l1 l2 m n name nseed kkk len numConditions
clear body waves simu output pto constraint ptoSim
% open the local cluster profile
p = parcluster('local');

% open the parallel pool, recording the time it takes
tic;
parpool(p); % open the pool
fprintf('Opening the parallel pool took %g seconds.\n', toc)

  evalc('wecSimInputFile');

if isempty(simu.mcrCaseFile) == 0
    load(simu.mcrCaseFile);
else
    kkk=0;
    mcr.header = {'waves.H','waves.T'};
    if isempty(waves.statisticsDataLoad) == 0
        mcr.waveSS = xlsread(waves.statisticsDataLoad);
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
        for i=1:length(waves.H)
            for j=1:length(waves.T)
                kkk = kkk+1;
                mcr.cases(kkk,1) = waves.H(i);
                mcr.cases(kkk,2) = waves.T(j);
            end
        end
    end
    
    numConditions=2;
    if length(waves.phaseSeed)>1;
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
            if (length(pto(n).c)>1 || length(pto(n).k)>1)
                numConditions=numConditions+2;
                name = sprintf('pto(%i).c', n);
                mcr.header{numConditions-1} = name;
                name = sprintf('pto(%i).k', n);
                mcr.header{numConditions  } = name;
                
                len = length(mcr.cases(:,1)); kkk = 0;
                for l2=1:length(pto(n).k)
                    for l1=1:length(pto(n).c)
                        kkk=kkk+1;
                        mcr.cases(len*(kkk-1)+1:len*(kkk-1)+len,1:numConditions-2) = mcr.cases(1:len,1:numConditions-2);
                        mcr.cases(len*(kkk-1)+1:len*(kkk-1)+len,  numConditions-1) = pto(n).c(l1);
                        mcr.cases(len*(kkk-1)+1:len*(kkk-1)+len,    numConditions) = pto(n).k(l2);
                    end
                end
            end
        end; clear i j k l1 l2 m n name nseed kkk len numConditions
    end
end
%%
% % Check to see if changing h5 file between runs
% % If one of the MCR headers is body(#).h5File, then the hydro data will be
% % loaded from the h5 file for each condition run.
% % reloadHydroDataFlag = true;
% if isempty(cell2mat(regexp(mcr.header, 'body\(\d+\).h5File')))
%     reloadHydroDataFlag = false;
%     clear hydroData
% end
%%
pause(1)
delete savedLog*
parfor imcr=1:length(mcr.cases(:,1))
    t = getCurrentTask();
    filename = sprintf('savedLog%03d.txt', t.ID);
    parallelComputing_dir = sprintf('parallelComputing_dir_%g', t.ID);
    mkdir(parallelComputing_dir) 
    fileID = fopen(filename,'a');
    fprintf(fileID,'wecSimMCR Case %g/%g\n',imcr,length(mcr.cases(:,1)));
% Run WEC-Sim
    wecSimFcn(imcr,parallelComputing_dir);   
    fclose(fileID);
end

clear imcr
delete(gcp); % close the parallel pool


