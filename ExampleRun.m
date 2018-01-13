% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc; clf;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 2;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
mlRng.rand = @rand; mlRng.randi = @randi; % can pass this instead of LCG
highway = Highway(nLanes, nCells,LCG(912915758));

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .2;  rhoLkw = .1;
sizeLkw = 2;
pTroedel = .2;  pOvertake = .0;

nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
nLkw = floor(rhoLkw * highway.nLanes * highway.nCells / sizeLkw);
vehicles = cell(nPkw+nLkw, 1);

for iVehicle = 1 : nLkw
    iLkwVMax = 3;
    vehicles{iVehicle} = Vehicle('LKW', sizeLkw, highway.rng.randi(iLkwVMax), ...
            iLkwVMax, pTroedel, pOvertake);    
end

for iVehicle = nLkw+1 : (nLkw+nPkw)
    iPkwVMax = highway.rng.randi(3) + 3; % 4-6
    vehicles{iVehicle} = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), ...
            iPkwVMax, pTroedel, pOvertake);    
end
highway.placeVehicles(vehicles);

% -------------------------------------------------------------------------
% Run Simulation
% -------------------------------------------------------------------------
simulationTime = 150; % seconds

for iIime = 1:simulationTime
    highway.Simulate();
    animateHighway(highway.highway, sizeLkw);
    % do some other analysis
end

% Print some end result