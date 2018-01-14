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

for nLanes=1:2
    figure
    % clf;
    subplot(2,1,1)
    hold on;
    subplot(2,1,2)
    hold on;
    
    
    rhoSteps = 200;
    
    for i = 1:5
        
        fluxs = zeros(rhoSteps,2);
        rhosHighway = zeros(rhoSteps,1);
        
        %Initialisierung mit verschiedenen Gesamtdichten und Simulation
        for iRhoHighway = 1 : rhoSteps
            
            rhoPkw = (iRhoHighway * staticRhoPkw(1))/rhoSteps;
            rhoLkw = (iRhoHighway * staticRhoLkw(1))/rhoSteps;
            
            highway = Highway(nLanes, nCells,1);
            
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
                % LCG Random Function
                %             vehicles{iVehicle} = Vehicle('PKW', 1, highway.rng.randi(iPkwVMax), iPkwVMax, tp(iTp), uep(end));
                %Matlab Random Function
                vehicles{iVehicle} = Vehicle('PKW', 1, randi(iPkwVMax), iPkwVMax, tp(i), uep(1));
            end
            highway.placeVehicles(vehicles);
            
            % -------------------------------------------------------------------------
            % Run Simulation
            % -------------------------------------------------------------------------
            simulationTime = 20; % seconds
            
            % localIntervall = [1 100];
            
            for iTime = 1:simulationTime
                highway.Simulate();
                %             animateHighway(highway.highway,highway.maxLengthTruck);
                % do some other analysis
            end
            fluxs(iRhoHighway,:) = SaveFlux(highway);
            rhosHighway(iRhoHighway) = (nPkw+nLkw*sizeLkw)/(nLanes*nCells);
        end
        
        %%%%%%%%%%%%%%%%%% Plot results %%%%%%%%%%%%%%%%%%%%%
        
        for iPlot = 1:2
            for iFlux = 1:length(fluxs)
                subplot(2,1,iPlot)
                if iFlux == 1 && iPlot == 1
                    plots(end + 1) = scatter(rhosHighway(iFlux),fluxs(iFlux,iPlot),colors{i},'filled');
                else
                    scatter(rhosHighway(iFlux),fluxs(iFlux,iPlot),colors{i},'filled');
                end
                if iFlux > 1
                    plot([rhosHighway(iFlux-1) rhosHighway(iFlux)], [fluxs(iFlux-1,iPlot) fluxs(iFlux,iPlot)],colors{i});
                end
            end
        end
        disp(['noch' num2str(5-i)]);
        pause(1);
    end
    subplot(2,1,1)
    legend(plots,legends);
    ylabel('mean(v)');
    subplot(2,1,2)
    legend(plots,legends);
    xlabel('Dichte/ rho');
    ylabel('Fluss');
end


