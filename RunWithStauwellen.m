% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc; clf;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------

% Um Stauwellen zu plotten darf die Anzahl an Spuren nicht größer als 2
% sein

nLanes = 2;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
mlRng.rand = @rand; mlRng.randi = @randi; % can pass this instead of LCG
highway = Highway(nLanes, nCells,LCG(912915758),1);

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .2;  
rhoLkw = .1;
sizeLkw = 2;
pTroedel = .2;  
pOvertake = .1;

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
simulationTime = 100; % seconds

highway_array=cell(simulationTime,1);
Mode=true; % Plot Stauwellen getrennt, oder zusammen 


figure('units','normalized','outerposition',[0 0 1 1]) % Vollbild
for iTime = 1:simulationTime
    highway.Simulate();
    animateHighway(highway.highway,sizeLkw);
    if(nLanes<=2)
        highway_array{iTime,1}=highway.highway;
    end
end

figure('units','normalized','outerposition',[0 0 1 1])
plotStauwellen(highway_array, Mode);



