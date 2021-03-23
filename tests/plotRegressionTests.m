%% Plot Solver Comparisons
if plotSolvers==1    
    if runReg==1
        cd(fullfile(testDir,'RegressionTests'))
        cd RegularWaves; printPlotRegular;
    end
    if runIrreg==1
        cd(fullfile(testDir,'RegressionTests'))
        cd IrregularWaves; printPlotIrregular;
    end
end

%% Open new vs. org Comparisons
if openCompare==1
    if runReg==1
        cd(fullfile(testDir,'RegressionTests'))
        cd RegularWaves; openfig('figReg.fig'); openfig('figRegCIC.fig'); openfig('figRegSS.fig');
    end
    if runIrreg==1
        cd(fullfile(testDir,'RegressionTests'))
        cd IrregularWaves; openfig('figIrregCIC.fig'); openfig('figIrregSS.fig');
    end
    if runYaw==1
        cd(fullfile(testDir,'RegressionTests'))
        cd PassiveYaw; open('figYawReg.fig'); open('figYawIrr.fig'); 
    end
end

cd(wsDir)