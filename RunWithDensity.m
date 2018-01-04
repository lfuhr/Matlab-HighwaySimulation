% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 1;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
highway = Highway(nLanes, nCells);

tp = [0 0.2 0.5 0.8 1]; %Trödelwahrscheinlichkeiten

uep = [0 0.2 0.5 0.8 1]; %Überholwahrscheinlichkeit

colors={'blue' 'magenta' 'cyan' 'red' 'black'};
% -------------------------------------------------------------------------
% Initialize Highway with Vehicles
% -------------------------------------------------------------------------

rhoPkw = .01;
rhoLkw = .0;

% clf;
subplot(2,1,1)
hold on;
subplot(2,1,2)
hold on;


steps = 100;

%Initialisierung mit verschiedenen Trödelwahrscheinlichkeiten
for iTp = 1:length(tp)
    
    density = zeros(steps,2);
    rhoHighway = zeros(steps,1);
    
    for iRhoPKW = 1 : steps
        rhoPkw = iRhoPKW/steps;
        
        highway = Highway(nLanes, nCells);
        
        nPkw = floor(rhoPkw * highway.nLanes * highway.nCells);
        nLkw = floor(rhoLkw * highway.nLanes * highway.nCells);
        
        
        vehicles = cell(nPkw+nLkw, 1);
        
        for iVehicle = 1 : nLkw
            iLkwVMax = 3;
            vehicles{iVehicle} = Vehicle('LKW', 2, highway.rng.randi(iLkwVMax), iLkwVMax, tp(1), uep(end));
        end
        
        for iVehicle = nLkw+1 : (nLkw+nPkw)
            %             iPkwVMax = highway.rng.randi(3) + 3; % 4-6
            iPkwVMax = 5; % 4-6
            % LCG Random Function            
            vehicles{iVehicle} = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), iPkwVMax, tp(iTp), uep(end));
            %Matlab Random Function
%             vehicles{iVehicle} = Vehicle('PKW', 1, randi(iPkwVMax), iPkwVMax, tp(iTp), uep(end));
        end
        highway.placeVehicles(vehicles);
        
        % -------------------------------------------------------------------------
        % Run Simulation
        % -------------------------------------------------------------------------
        simulationTime = 20; % seconds
        
        % localIntervall = [1 100];
        
        for iTime = 1:simulationTime
            highway.Simulate();
            %     animateHighway(highway.highway,highway.maxLengthTruck);
            % do some other analysis
        end
        density(iRhoPKW,:) = SaveFlux(highway);
        rhoHighway(iRhoPKW) = (nPkw+nLkw)/(nLanes*nCells);
    end
    
    % Print some end result
    % clf;
    
    for iDensity = 1:length(density)
        subplot(2,1,1)
        plot(rhoHighway(iDensity),density(iDensity,1),[colors{iTp} 'o']);
        ylabel('mean(v) / cell/sec');
        subplot(2,1,2)
        plot(rhoHighway(iDensity),density(iDensity,2),[colors{iTp} 'o']);
        xlabel('Dichte/ rho');
        ylabel('Fluss');
    end
    disp(num2str(tp(iTp)));
    pause(1);
end
% subplot(2,1,1)
% legend(num2str(tp(1)),num2str(tp(2)),num2str(tp(3)),num2str(tp(4)),num2str(tp(5)));