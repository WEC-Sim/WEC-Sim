%% Read the pressures solved on the body surface
nFreq  = hydro(F).Nf;            % number of frequencies
nDOF   = size(hydro(F).A,1);     % number of DOFs 
nBeta  = hydro(F).Nb;            % number of wave directions 

counterDiff = 1;
counterRad  = 1;

for iF = 1:nFreq
    for iP = 1:(nBeta + nDOF)
        p = (iF-1)*(nBeta+nDOF) + iP;
        FileNam  = sprintf('pressure.%05d.dat', p);
        fileID = fopen(fullfile(filedir,'results',FileNam));
        PressureFileRaw = textscan(fileID,'%[^\n\r]');
        PressureFileRaw = PressureFileRaw{:};
        fclose(fileID);

        if iP <= nBeta
            % diffraction problems
            [pressureDiff(:,:,counterDiff), Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw);
            counterDiff = counterDiff + 1;
        else
            % radiation problems
            [pressureRad(:,:,counterRad), Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw);
            counterRad = counterRad + 1;
        end
    end
end

% for p = 1:hydro(F).Nf * (1 + size(hydro(F).A,1))
%     FileNam  = sprintf('pressure.%05d.dat', p);
%     fileID = fopen(fullfile(filedir,'results',FileNam));
%     PressureFileRaw = textscan(fileID,'%[^\n\r]');
%     PressureFileRaw = PressureFileRaw{:};
%     fclose(fileID);
%     if mod(p,2) == 0
%         [pressureRad(:,:,counterE),Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw);
%         counterE = counterE + 1;
%     else
%         [pressureDiff(:,:,counterO),Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw);
%         counterO = counterO + 1;
%     end
% 
% end
hydro(F).pressureData.centroids = pressureRad(:,1:3);
hydro(F).pressureData.meshNormals = pressureRad(:,4:6);
hydro(F).pressureData.elementsArea = pressureRad(:,7);
hydro(F).pressureData.pressureRad = pressureRad(:,8:9,:);
hydro(F).pressureData.pressureDiff = pressureDiff(:,8:9,:);
