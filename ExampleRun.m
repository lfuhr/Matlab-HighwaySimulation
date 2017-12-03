% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 5;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
highway = Highway(2, 100);


% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .4;
rhoLkw = .1;

PKWs = zeros(1, rhoPkw);
for iPkw = 1 : (rhoPkw * nCells)
    iPkwVMax = highway.randi(3) + 3; % 4-6
    PKWs(iPKW) = Vehicle("PKW", 1, highway.randi(iPkwVMax), iPkwVMax);
end
LKWs = repmat(Vehicle("LKW", 2, 1, 3), 1, rhoPKW);
highway.initialize([LKWs, PKWs])


% -------------------------------------------------------------------------
% Run Simulation
% -------------------------------------------------------------------------
simulationTime = 150; % seconds

for iIime = 1:simulationTime
    higway.simulate()
    PlotHighway.plot()
    % do some other analysis
end

% Print some end result