%% Read the pressures solved on the body surface
counterE = 1;
counterO = 1;
for p = 1:hydro(F).Nf * (1 + size(hydro(F).A,1))
    FileNam  = sprintf('pressure.%05d.dat', p);
    fileID = fopen(fullfile(filedir,'results',FileNam));
    PressureFileRaw = textscan(fileID,'%[^\n\r]');
    PressureFileRaw = PressureFileRaw{:};
    fclose(fileID);
    if mod(p,2) == 0
        [PressureRad(:,:,counterE),Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw);
        counterE = counterE + 1;
    else
        [PressureDiff(:,:,counterO),Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw);
        counterO = counterO + 1;
    end
    
end
hydro(F).PressureRad = PressureRad;
hydro(F).PressureDiff = PressureDiff;
