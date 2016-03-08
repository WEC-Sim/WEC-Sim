%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                        Free Decay                               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;

%% Heave Decay
cd heaveDecay\heaveDecay_damping\
wecSimMCR
plotHeaveDecay
clear all
cd ../..

%% Pitch Decay
cd pitchDecay\pitchDecay_damping\
wecSimMCR
plotPitchDecay
clear all
cd ../..

%% Surge Decay
cd surgeDecay\surgeDecay_stiffness_damping\
wecSimMCR
plotSurgeDecay
clear all
cd ../..
