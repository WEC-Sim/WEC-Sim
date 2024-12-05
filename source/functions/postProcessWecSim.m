%% postProcessWecSim
% Post processing and Saving Results, called from stopWecSim.m

fprintf('\nPost-processing and saving...   \n')

% Update simulation class with actual simulation time
simu.time = clock_out.time;
clear clock_out

% Bodies
for iBod = 1:length(body(1,:))
    eval(['body' num2str(iBod) '_out.name = body(' num2str(iBod) ').name;']);    
    eval(['body' num2str(iBod) '_out.centerGravity = body(' num2str(iBod) ').centerGravity;']); 

    if iBod == 1
        bodiesOutput = body1_out; 
    end
    bodiesOutput(iBod) = eval(['body' num2str(iBod) '_out']);
    eval(['clear body' num2str(iBod) '_out'])
end

% Add hydrostatic and FK pressures to bodiesOutput if required.
for iBod = 1:length(body(1,:))
     if body(iBod).nonlinearHydro~=0 && body(iBod).nonHydro==0 && simu.pressure == 1 
        % hydrostatic pressure
        eval(['bodiesOutput(' num2str(iBod) ').hspressure = body' num2str(iBod) '_hspressure_out;']);
        % wave (Froude-Krylov) nonlinear pressure
        eval(['bodiesOutput(' num2str(iBod) ').wpressurenl = body' num2str(iBod) '_wavenonlinearpressure_out;']);
        % wave (Froude-Krylov) linear pressure
        eval(['bodiesOutput(' num2str(iBod) ').wpressurel = body' num2str(iBod) '_wavelinearpressure_out;']);
    else
        if body(iBod).nonlinearHydro == 0 && simu.pressure == 1 
            warning('Pressure distribution only written for nonlinear hydro bodies (``body.nonlinearHydro=1 or 2``)')
        end
        bodiesOutput(iBod).hspressure = [];
        bodiesOutput(iBod).wpressurenl = [];
        bodiesOutput(iBod).wpressurel = [];
     end
    % Add yaw to structure
    bodiesOutput(iBod).yaw = body(iBod).yaw.option;
end; clear iBod

% Record hydroForceIndex from variable hydro. If nonvariable hydro, add
% a placeholder so the bodiesOutput structures are similar and concatenable
for iBod = 1:length(body(1,:))
        eval(['bodiesOutput(' num2str(iBod) ').variableHydroOption = body(' num2str(iBod) ').variableHydro.option;']);
    if body(iBod).variableHydro.option == 1
        eval(['bodiesOutput(' num2str(iBod) ').hydroForceIndex = body' num2str(iBod) '_hydroForceIndex.signals.values;']); 
    else
        eval(['bodiesOutput(' num2str(iBod) ').hydroForceIndex = ones(size(bodiesOutput(iBod).time,1),1);']);
    end
end
clear body*_hydroForceIndex bus_*

% PTOs
if exist('pto','var')
    for iPto = 1:simu.numPtos
        eval(['pto' num2str(iPto) '_out.name = pto(' num2str(iPto) ').name;'])
        if iPto == 1; ptosOutput = pto1_out; end
        ptosOutput(iPto) = eval(['pto' num2str(iPto) '_out']);
        eval(['clear pto' num2str(iPto) '_out'])
    end; clear iPto
else
    ptosOutput = 0;
end

% Constraints
if exist('constraint','var')
    for iCon = 1:simu.numConstraints
        eval(['constraint' num2str(iCon) '_out.name = constraint(' num2str(iCon) ').name;'])
        if iCon == 1; constraintsOutput = constraint1_out; end
        constraintsOutput(iCon) = eval(['constraint' num2str(iCon) '_out']);
        eval(['clear constraint' num2str(iCon) '_out'])
    end; clear iCon
else
    constraintsOutput = 0;
end

% Cable
if exist('cable','var')
    for iCab = 1:simu.numCables
        eval(['cable' num2str(iCab) '_out.name = cable(' num2str(iCab) ').name;'])
        if iCab == 1; cablesOutput =cable1_out; end
        cablesOutput(iCab) = eval(['cable' num2str(iCab) '_out']);
        eval(['clear cable' num2str(iCab) '_out']);
    end; clear iCab
else
    cablesOutput = 0;
end

% Mooring
if exist('mooring','var')
    for iMoor = 1:simu.numMoorings
        eval(['mooring' num2str(iMoor) '_out.name = mooring(' num2str(iMoor) ').name;']);
        if iMoor == 1; mooringOutput = mooring1_out; end
        mooringOutput(iMoor) = eval(['mooring' num2str(iMoor) '_out']);
        eval(['clear mooring' num2str(iMoor) '_out']);
    end; clear iMoor
else
    mooringOutput = 0;
end

% PTO-Sim
if exist('ptoSim','var')
    for iPtoB = 1:simu.numPtoSim
        %iPtoB
        %eval(['ptoSim' num2str(iPtoB) '_out.name = ptoSim(' num2str(iPtoB) ').name;'])
        eval(['ptoSim' num2str(iPtoB) '_out.typeNum = ptoSim(' num2str(iPtoB) ').typeNum;'])
        if iPtoB == 1; ptosimOutput = ptoSim1_out; end
        ptosimOutput(iPtoB) = eval(['ptoSim' num2str(iPtoB) '_out']);
        eval(['clear ptoSim' num2str(iPtoB) '_out'])
    end; clear iPtoB
else
    ptosimOutput = 0;
end

% Waves
if strcmp(simu.solver,'ode4')~=1    % Re-calculate wave elevation for variable time-step solver
    waves.calculateElevation(simu.rampTime,bodiesOutput(1).time);
end
waveOutput = struct();
waveOutput.type = waves.type;
waveOutput.waveAmpTime = waves.waveAmpTime;

% Wind Turbine
if exist('windTurbine','var')
    for iTurb = 1:length(windTurbine)
        windTurbineOutput(iTurb) = eval(['windTurbine' num2str(iTurb) '_out']);
        windTurbineOutput(iTurb).name = windTurbine(iTurb).name;
        eval(['clear windTurbine' num2str(iTurb) '_out'])
    end; clear iTurb
else
    windTurbineOutput = 0;
end

% All
output = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput,cablesOutput,mooringOutput,waveOutput,windTurbineOutput);
clear bodiesOutput ptosOutput constraintsOutput ptosimOutput cablesOutput mooringOutput waveOutput windTurbineOutput

% MoorDyn
for iMoor = 1:simu.numMoorings
    if mooring(iMoor).moorDyn==1
        output.loadMoorDyn(mooring(iMoor).moorDynLines, mooring(iMoor).moorDynInputFile);
    end
end; clear iMoor

% Added mass correction
% 1. Update mass properties and added mass coefficients from stored valued
% 2. Store the applied added mass force
% 3. Remove applied added mass force from total
% 4. Calculate the actual added mass force
% 5. Add actual added mass force to total
for iBod = 1:simu.numHydroBodies
    body(iBod).restoreMassMatrix();
    body(iBod).storeForceAddedMass(output.bodies(iBod).forceAddedMass, output.bodies(iBod).forceTotal);
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal + output.bodies(iBod).forceAddedMass;
    output.bodies(iBod).forceAddedMass = body(iBod).calculateForceAddedMass(output.bodies(iBod).acceleration);
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal - output.bodies(iBod).forceAddedMass;
end; clear iBod
