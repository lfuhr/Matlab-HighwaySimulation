% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 5;                 %Anzahl an Spuren
nCells = 50;               %Länge der Strecke
mlRng.rand = @rand; mlRng.randi = @randi; % can pass this instead of LCG
highway = Highway(nLanes, nCells,LCG(912915758),1);

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoGesamt = 0.17;
rhoPkw = rhoGesamt * .6;  
rhoLkw = rhoGesamt - rhoPkw;
sizeLkw = 2;
pTroedel = .1;  
pOvertake = 0.8;

nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
nLkw = floor(rhoLkw * highway.nLanes * highway.nCells / sizeLkw);
vehicles = cell(nPkw+nLkw, 1);
nVmax=5;
for iVehicle = 1 : nLkw
    iLkwVMax = 3; %highway.rng.randi(sizeLkw)+1 
    vehicles{iVehicle} = Vehicle('LKW', sizeLkw, highway.rng.randi(iLkwVMax), ...
            iLkwVMax, pTroedel, pOvertake);    
end

for iVehicle = nLkw+1 : (nLkw+nPkw)
    iPkwVMax = highway.rng.randi(nVmax) + 3; % 4-6
    vehicles{iVehicle} = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), ...
            iPkwVMax, pTroedel, pOvertake);    
end
highway.placeVehicles(vehicles);

% -------------------------------------------------------------------------
% Run Simulation
% -------------------------------------------------------------------------
simulationTime = 100; % seconds

figure('units','normalized','outerposition',[0 0 1 1]) % Vollbild
for iIime = 1:simulationTime
    highway.Simulate();
    animateHighway(highway.highway, sizeLkw);
    % do some other analysis
end

% Print some end result