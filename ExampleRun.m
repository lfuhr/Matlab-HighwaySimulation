% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc; clf;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 2;                 %Anzahl an Spuren
nCells = 100;               %L�nge der Strecke
<<<<<<< HEAD
highway = Highway(nLanes, nCells, LCG(912915758));
=======
highway = Highway(nLanes, nCells,1);
>>>>>>> 4e0cb261502313bfc79c2a7f5d17a04f60ed73de

% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------
rhoPkw = .2;  rhoLkw = .7;
sizeLkw = 2;
pTroedel = .2;  pOvertake = .0;

nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
nLkw = floor(rhoLkw * highway.nLanes * highway.nCells / sizeLkw);
vehicles = cell(nPkw+nLkw, 1);

for iVehicle = 1 : nLkw
    iLkwVMax = 3;
<<<<<<< HEAD
    vehicles{iVehicle} = Vehicle('LKW', sizeLkw, ...
        highway.rng.randi(iLkwVMax), iLkwVMax, pTroedel, pOvertake);    
=======
    vehicles{iVehicle} = Vehicle('LKW', sizeLkw, randi(iLkwVMax), ...
            iLkwVMax, pTroedel, pOvertake);    
>>>>>>> 4e0cb261502313bfc79c2a7f5d17a04f60ed73de
end

for iVehicle = nLkw+1 : (nLkw+nPkw)
    iPkwVMax = randi(3) + 3; % 4-6
    vehicles{iVehicle} = Vehicle('PKW', 1, randi(iPkwVMax), ...
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