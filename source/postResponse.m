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

%% Create Output Struct
output=struct;

%% Body Elements Outputs
output.bodies=struct;
L=length(body);
for i=1:L
    eval(['output.bodies(' num2str(i) ').name=''' body(i).name ''';']); 
    eval(['output.bodies(' num2str(i) ').time = '... 
        body(i).name '_out.time;']);
    eval(['output.bodies(' num2str(i) ').position = '... 
        body(i).name '_out.signals.values(:,1:6);']);
    eval(['output.bodies(' num2str(i) ').velocity = '... 
        body(i).name '_out.signals.values(:,7:12);']);
    eval(['output.bodies(' num2str(i) ').acceleration = '... 
        body(i).name '_out.signals.values(:,13:18);']);
    
    eval(['output.bodies(' num2str(i) ').forceTotal = '... 
        body(i).name '_out.signals.values(:,19:24);']);
    eval(['output.bodies(' num2str(i) ').forceExcitation = '... 
        body(i).name '_out.signals.values(:,25:30);']);
    eval(['output.bodies(' num2str(i) ').forceRadiation = '... 
        body(i).name '_out.signals.values(:,31:36);']);
    eval(['output.bodies(' num2str(i) ').forceRestoring = '... 
        body(i).name '_out.signals.values(:,37:42);']);
    eval(['output.bodies(' num2str(i) ').forceViscous = '... 
        body(i).name '_out.signals.values(:,43:48);']);
    eval(['output.bodies(' num2str(i) ').forceMooring = '... 
        body(i).name '_out.signals.values(:,49:54);']);
    eval(['clear ' body(i).name '_out;']);
end

%% PTOs Outputs
if exist('pto','var')
    output.ptos=struct;
    L=length(pto);
    for i=1:L
        eval(['output.ptos(' num2str(i) ').name=''' pto(i).name ''';']); 
        eval(['output.ptos(' num2str(i) ').time = '... 
            pto(i).name '_out.time;']);
        eval(['output.ptos(' num2str(i) ').forceOrTorque = '... 
            pto(i).name '_out.signals.values(:,1);']);
        eval(['output.ptos(' num2str(i) ').power = '... 
            pto(i).name '_out.signals.values(:,2);']);
        eval(['output.ptos(' num2str(i) ').constraintForces = '... 
            pto(i).name '_out.signals.values(:,3:8);']);
        eval(['clear ' pto(i).name '_out;']);
    end
end

%% Constraints Outputs
if exist('constraint','var')
    output.constraints=struct;
    L=length(constraint);
    for i=1:L
        eval(['output.constraints(' num2str(i) ').name=''' constraint(i).name ''';']); 
        eval(['output.constraints(' num2str(i) ').time = '... 
            constraint(i).name '_out.time;']);
        eval(['output.constraints(' num2str(i) ').constraintForces = '... 
            constraint(i).name '_out.signals.values(:,1:6);']);
        eval(['clear ' constraint(i).name '_out;']);
    end
end

%% Clear and Save
clear L i
save(simu.outputFileName,'output')
