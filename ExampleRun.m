% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 3;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
highway = Highway(nLanes, nCells);

tp = [0 0.2 0.5 0.8]; %Trödelwahrscheinlichkeiten

uep = [0 0.2 0.5 0.8 1]; %Überholwahrscheinlichkeit

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .2;
rhoLkw = .1;

nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
nLkw = floor(rhoLkw * highway.nLanes * highway.nCells);


vehicles = cell(nPkw+nLkw, 1);

for iVehicle = 1 : nLkw
    iLkwVMax = 3;
    vehicles{iVehicle} = Vehicle('LKW', 2, highway.rng.randi(iLkwVMax), iLkwVMax, tp(1), uep(end));    
end

for iVehicle = nLkw+1 : (nLkw+nPkw)
    iPkwVMax = highway.rng.randi(3) + 3; % 4-6
    vehicles{iVehicle} = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), iPkwVMax, tp(1), uep(end));    
end
highway.placeVehicles(vehicles);

% -------------------------------------------------------------------------
% Run Simulation
% -------------------------------------------------------------------------
simulationTime = 10; % seconds

for iIime = 1:simulationTime
    highway.Simulate();
    animateHighway(highway.highway,highway.maxLengthTruck);
    % do some other analysis
end

% Print some end result