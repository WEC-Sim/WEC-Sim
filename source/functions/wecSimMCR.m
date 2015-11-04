clear mcr imcr i j k l1 l2 m n name nseed kkk len numConditions
clear body waves simu output pto constraint ptoSim

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
    if length(waves.randPreDefined)>1;
        numConditions=numConditions+1;
        mcr.header{numConditions} = 'waves.randPreDefined';
        len = length(mcr.cases(:,1));
        for nseed=1:length(waves.randPreDefined)
            mcr.cases(len*(nseed-1)+1:len*(nseed-1)+len,1:numConditions-1) = mcr.cases(1:len,1:numConditions-1);
            mcr.cases(len*(nseed-1)+1:len*(nseed-1)+len,    numConditions) = waves.randPreDefined(nseed);
        end
    end
    
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

% Run WEC-Sim
warning('off','MATLAB:DELETE:FileNotFound'); delete('mcrCase*.mat')
for imcr=1:length(mcr.cases(:,1))
    wecSim;
    if exist('userDefinedFunctionsMCR.m','file') == 2; userDefinedFunctionsMCR; end
end; clear imcr ans;
