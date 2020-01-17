addpath(genpath('.\tests'))
addpath(genpath('.\source'))
run_wecSim_tests
% setting up Jenkins CI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regular Wave Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% regular
%% regular Body1
load('regular.mat')
% load('.\RegularWaves\regular\regular.mat')
tol = 1e-10;
org = regular.B1.WEC_Sim_org.heave;
new = regular.B1.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% regular Body 2
load('regular.mat')
% load('.\RegularWaves\regular\regular.mat')
tol = 1e-10;
org = regular.B2.WEC_Sim_org.heave;
new = regular.B2.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% regular Relative Motion
load('regular.mat')
% load('.\RegularWaves\regular\regular.mat')
tol = 1e-10;
org = regular.Rel.WEC_Sim_org.heave;
new = regular.Rel.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

% regularCIC
%% regularCIC Body1
load('regularCIC.mat')
% load('.\RegularWaves\regularCIC\regularCIC.mat')
tol = 1e-10;
org = regularCIC.B1.WEC_Sim_org.heave;
new = regularCIC.B1.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% regularCIC Body 2
load('regularCIC.mat')
% load('.\RegularWaves\regularCIC\regularCIC.mat')
tol = 1e-10;
org = regularCIC.B2.WEC_Sim_org.heave;
new = regularCIC.B2.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% regularCIC Relative Motion
load('regularCIC.mat')
% load('.\RegularWaves\regularCIC\regularCIC.mat')
tol = 1e-10;
org = regularCIC.Rel.WEC_Sim_org.heave;
new = regularCIC.Rel.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

% regularSS
%% regularSS Body1
load('regularSS.mat')
% load('.\RegularWaves\regularSS\regularSS.mat')
tol = 1e-10;
org = regularSS.B1.WEC_Sim_org.heave;
new = regularSS.B1.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% regularSS Body 2
load('regularSS.mat')
%load('.\RegularWaves\regularSS\regularSS.mat')
tol = 1e-10;
org = regularSS.B2.WEC_Sim_org.heave;
new = regularSS.B2.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% regularSS Relative Motion
load('regularSS.mat')
%load('.\RegularWaves\regularSS\regularSS.mat')
tol = 1e-10;
org = regularSS.Rel.WEC_Sim_org.heave;
new = regularSS.Rel.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Irregular Wave Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% irregularCIC
%% Test irregularCIC Body1
load('irregularCIC.mat')
%load('.\IrregularWaves\irregularCIC\irregularCIC.mat')
tol = 1e-10;
org = irregularCIC.B1.WEC_Sim_org.heave;
new = irregularCIC.B1.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% irregularCIC Body 2
load('irregularCIC.mat')
%load('.\IrregularWaves\irregularCIC\irregularCIC.mat')
tol = 1e-10;
org = irregularCIC.B2.WEC_Sim_org.heave;
new = irregularCIC.B2.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% irregularCIC Relative Motion
load('irregularCIC.mat')
%load('.\IrregularWaves\irregularCIC\irregularCIC.mat')
tol = 1e-10;
org = irregularCIC.Rel.WEC_Sim_org.heave;
new = irregularCIC.Rel.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

% irregularSS
%% irregularSS Body 1
load('irregularSS.mat')
%load('.\IrregularWaves\irregularSS\irregularSS.mat')
tol = 1e-10;
org = irregularSS.B1.WEC_Sim_org.heave;
new = irregularSS.B1.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% irregularSS Body 2
load('irregularSS.mat')
%load('.\IrregularWaves\irregularSS\irregularSS.mat')
tol = 1e-10;
org = irregularSS.B2.WEC_Sim_org.heave;
new = irregularSS.B2.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)

%% irregularSS Relative Motion
load('irregularSS.mat')
%load('.\IrregularWaves\irregularSS\irregularSS.mat')
tol = 1e-10;
org = irregularSS.Rel.WEC_Sim_org.heave;
new = irregularSS.Rel.WEC_Sim_new.heave;
assert(max(abs(org-new)) <= tol)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Test Cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%runtests
