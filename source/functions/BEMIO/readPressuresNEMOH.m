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

hydro(F).pressureData.centroids = pressureRad(:,1:3);
hydro(F).pressureData.meshNormals = pressureRad(:,4:6);
hydro(F).pressureData.elementsArea = pressureRad(:,7);
hydro(F).pressureData.pressureRad = pressureRad(:,8:9,:);
hydro(F).pressureData.pressureDiff = pressureDiff(:,8:9,:);