% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 2;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
% highway = Highway(nLanes, nCells);

tp = [0 0.2 0.5 0.8 1]; %Trödelwahrscheinlichkeiten

uep = [0 0.2 0.5 0.8 1]; %Überholwahrscheinlichkeit

colors={'blue' 'magenta' 'cyan' 'red' 'black'};
% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------

% rhoPkw + rhoLkw <= 1 !
staticRhoLkw = [0 0.2 0.5 0.8 1];
staticRhoPkw = 1-staticRhoLkw;

sizeLkw = 2;

simulationTime = 20; % seconds
rhoSteps = 100;
results=cell(5,4);

legends={'TrödelP = 0.0','0.2','0.5','0.8','1.0'};

%Beachte: Die Regeln für Überholen müssen in Model\Highway in der Funktion
% "ChangeLane" geändert werden
for nLanes=2:2
    
    plots=[];
    
    for i = 1:5
        
        fluxs = zeros(rhoSteps,2);
        rhosHighway = zeros(rhoSteps,1);
        
        %Initialisierung mit verschiedenen Gesamtdichten und Simulation
        for iRhoHighway = 1 : rhoSteps
            
            rhoPkw = (iRhoHighway * staticRhoPkw(2))/rhoSteps;
            rhoLkw = (iRhoHighway * staticRhoLkw(2))/rhoSteps;
            
            % mlRng.rand = @rand; mlRng.randi = @randi; % can pass this instead of LCG
            highway = Highway(nLanes, nCells,LCG(912915758),1);
            
            nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
            nLkw = floor(rhoLkw * highway.nLanes * highway.nCells / sizeLkw);
            
            
            vehicles = cell(nPkw+nLkw, 1);
            
            for iVehicle = 1 : nLkw
                iLkwVMax = 3;
                vehicles{iVehicle} = Vehicle('LKW', sizeLkw, randi(iLkwVMax), iLkwVMax, tp(i), uep(1));
            end
            
            for iVehicle = nLkw+1 : (nLkw+nPkw)
                %             iPkwVMax = highway.rng.randi(3) + 3; % 4-6
                iPkwVMax = 5; % 4-6
                vehicles{iVehicle} = Vehicle('PKW', 1, randi(iPkwVMax), iPkwVMax, tp(i), uep(1));
            end
            highway.placeVehicles(vehicles);
            
            % -------------------------------------------------------------------------
            % Run Simulation
            % -------------------------------------------------------------------------
            
            for iTime = 1:simulationTime
                highway.Simulate();
                %             animateHighway(highway.highway,highway.maxLengthTruck);
            end
            fluxs(iRhoHighway,:) = SaveFlux(highway);
            rhosHighway(iRhoHighway) = (nPkw+nLkw*sizeLkw)/(nLanes*nCells);
        end
        disp(['noch' num2str(5-i)]);
        results{i,1}=highway;
        results{i,2}=rhosHighway;
        results{i,3}=fluxs;
        results{i,4}=legends;
    end
end
plotFlux(results,legends);
disp('fertig');



