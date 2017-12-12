% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 5;                 %Anzahl an Spuren
nCells = 20;               %Länge der Strecke
highway = Highway(nLanes, nCells);

tp = [0 0.2 0.5 0.8]; %Trödelwahrscheinlichkeiten

uep = [0 0.2 0.5 0.8 1];

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .2;
rhoLkw = .1;

nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
nLkw = floor(rhoLkw * highway.nLanes * highway.nCells);


vehicles = repmat(Vehicle('LKW', 2, 1, 3, tp(1), uep(end)),1, nPkw+nLkw);
for iVehicle = nLkw+1 : (rhoPkw * nCells)
    iPkwVMax = highway.rng.randi(3) + 3; % 4-6
    vehicles(iVehicle) = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), iPkwVMax, tp(1), uep(end));    
end
highway.placeVehicles(vehicles);

% -------------------------------------------------------------------------
% Run Simulation
% -------------------------------------------------------------------------
simulationTime = 150; % seconds

for iIime = 1:simulationTime
    highway.Simulate();
    animateHighway(highway.highway,highway.maxLengthTruck);
    % do some other analysis
end

% Print some end result