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

%% Post processing and Saving Results
fprintf('\nPost-processing and saving...   \n')
% Bodies
for iBod = 1:length(body(1,:))
    eval(['body' num2str(iBod) '_out.name = body(' num2str(iBod) ').name;']);
    if iBod == 1; bodiesOutput = body1_out; end
    bodiesOutput(iBod) = eval(['body' num2str(iBod) '_out']);
    eval(['clear body' num2str(iBod) '_out'])
end; clear iBod
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
if exist('ptosim','var')
    ptosimOutput = ptosim.response;
else
    ptosimOutput = 0;
end
% Cell-by-cell values
hspressure = {};
wpressurenl = {};
wpressurel = {};
for ii = 1:length(body(1,:))
    if simu.nlHydro~=0 && body(ii).nhBody==0 && simu.pressureDis == 1 
        % hydrostatic pressure
        eval(['hspressure{' num2str(ii) '} = body' num2str(ii) '_hspressure_out;']);
        % wave (Froude-Krylov) nonlinear pressure
        eval(['wpressurenl{' num2str(ii) '} = body' num2str(ii) '_wavenonlinearpressure_out;']);
        % wave (Froude-Krylov) linear pressure
        eval(['wpressurel{' num2str(ii) '} = body' num2str(ii) '_wavelinearpressure_out;']);
    else
        hspressure{ii} = [];
        wpressurenl{ii} = [];
        wpressurel{ii} = [];
    end
end; clear ii
% All
output = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput,mooringOutput,waves.type,waves.waveAmpTime,hspressure, wpressurenl, wpressurel, simu.yawNonLin);
clear bodiesOutput ptosOutput constraintsOutput ptosimOutput mooringOutput
% MoorDyn
for iMoor = 1:simu.numMoorings
    if mooring(iMoor).moorDyn==1
        output.loadMoorDyn(mooring(iMoor).moorDynLines);
    end
end; clear iMoor
% Calculate correct added mass and total forces
for iBod = 1:simu.numWecBodies
    body(iBod).restoreMassMatrix
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal + output.bodies(iBod).forceAddedMass;
    output.bodies(iBod).forceAddedMass = body(iBod).forceAddedMass(output.bodies(iBod).acceleration,simu.b2b);
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal - output.bodies(iBod).forceAddedMass;
end; clear iBod

