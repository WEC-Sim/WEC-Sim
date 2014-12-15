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

function [data] = readWamitData(fname,bodyNum,simu)
% Read Data From WAMIT from *.out file

% Create file name and call parser
[data.raw] = parseWamitOut(fname);

% Dimensionalize the WAMIT output using density and gravity
data.raw.frequency         = 2*pi./data.raw.period;

% Loop throught each frequency to calculate the dimensional damping force
for i=1:data.raw.numPeriods
    data.raw.fDamping(:,:,i)=data.raw.fDamping(:,:,i).*data.raw.frequency(i);
end

% Pull out individual body data
data.waterDepth             = data.raw.waterDepth;
data.period                 = data.raw.period;
data.frequency              = data.raw.frequency;

data.cg                     = data.raw.cg{bodyNum};
data.vol                    = cell2mat(data.raw.vol{bodyNum});
data.vol                    = data.vol(3); % taking the z-direction volume only according to reccomendation in wamit model

data.linearHyroRestCoef = data.raw.linearHyroRestCoef{bodyNum}+data.raw.linearHyroRestCoef{bodyNum}'-diag(diag(data.raw.linearHyroRestCoef{bodyNum}));

rowColStart = (bodyNum-1)*6+1;
rowColEnd   = bodyNum*6;
data.fDamping          = data.raw.fDamping      (rowColStart:rowColEnd,rowColStart:rowColEnd,:);
data.fAddedMass        = data.raw.fAddedMass    (rowColStart:rowColEnd,rowColStart:rowColEnd,:);      
data.fAddedMassInf     = data.raw.fAddedMassInf (rowColStart:rowColEnd,rowColStart:rowColEnd,:);
data.fAddedMassZero    = data.raw.fAddedMassZero(rowColStart:rowColEnd,rowColStart:rowColEnd,:);
data.fExt.Mag          = data.raw.fExt.mag      (rowColStart:rowColEnd,:);         
data.fExt.Re           = data.raw.fExt.re       (rowColStart:rowColEnd,:);          
data.fExt.Im           = data.raw.fExt.im       (rowColStart:rowColEnd,:);   

% Dimensionalize
data.linearHyroRestCoef = data.linearHyroRestCoef .* simu.rho*simu.g;

data.fDamping = data.fDamping * simu.rho;
data.fAddedMass = data.fAddedMass * simu.rho;
data.fAddedMassInf = data.fAddedMassInf * simu.rho;
data.fAddedMassZero = data.fAddedMassZero * simu.rho;

data.fExt.Mag = data.fExt.Mag * simu.rho*simu.g;
data.fExt.Re = data.fExt.Re * simu.rho*simu.g;
data.fExt.Im = data.fExt.Im * simu.rho*simu.g;

