% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 2;                 %Anzahl an Spuren
nCells = 100;               %L�nge der Strecke
highway = Highway(nLanes, nCells);

tp = [0 0.2 0.5 0.8]; %Tr�delwahrscheinlichkeiten

uep = [0 0.2 0.5 0.8 1]; %�berholwahrscheinlichkeit

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .2;
rhoLkw = .1;

nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
nLkw = floor(rhoLkw * highway.nLanes * highway.nCells);

nVmax=5; % Anzahl der Maximalgeschwindigkeiten
vehicles = cell(nPkw+nLkw, 1);

for iVehicle = 1 : nLkw
    iLkwVMax = 3;
    vehicles{iVehicle} = Vehicle('LKW', 2, highway.rng.randi(iLkwVMax), iLkwVMax, tp(3), uep(end));    
end

for iVehicle = nLkw+1 : (nLkw+nPkw)
    iPkwVMax = highway.rng.randi(nVmax) + 3; % 4-6
    vehicles{iVehicle} = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), iPkwVMax, tp(3), uep(end));    
end
highway.placeVehicles(vehicles);

% -------------------------------------------------------------------------
% Run Simulation
% -------------------------------------------------------------------------
simulationTime = 150; % seconds
highway_array=cell(simulationTime,1);
Mode=true; % Plot Stauwellen getrennt, oder zusammen 


figure('units','normalized','outerposition',[0 0 1 1]) % Vollbild
for iTime = 1:simulationTime
    highway.Simulate();
    animateHighway(highway.highway,highway.maxLengthTruck);
    if(nLanes<=2)
        highway_array{iTime,1}=highway.highway;
    end
end

figure('units','normalized','outerposition',[0 0 1 1])
plotStauwellen(highway_array, Mode);


