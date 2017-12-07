clear; clc;
addpath Model;
addpath Visualization;

figure('units', 'normalized', 'outerposition', [0 0 1 1])
lanes = 3; %Anzahl an Spuren
nCells = 100; %Länge der Strecke

vmaxCars = [5 6 7 8 9]; %Max Geschwindigkeit PKW
maxVMax = max(vmaxCars);
rV = [0.16 0.2 0.5]; %Mittlere Dichte Fahrzeuge
rhoVehicles = rV(3);

vMaxTruck = 3; %Max Geschwindigkeit LKW
rT = [0.2 0.5 0.8]; % prozentualer Anteil an LKW
ratioTrucks = rT(1);
lengthTrucks = [3 6]; %Zellenlänge pro LKW
maxLengthTrucks = max(lengthTrucks);

tp = [0 0.2 0.5 0.8]; %Trödelwahrscheinlichkeit
troedelwsnlkt = tp(2);

op = [0 0.2 0.5 0.8 1]; %Überholwahrscheinlichkeit
ueberholwsnlkt = op(end);

strasse = cell(lanes, nCells); %Strecke

%Anzahl der Fahrzeuge pro Fahrspur
nVehicles = nCells * rhoVehicles;
nTrucks = nVehicles * ratioTrucks;
nCars = nVehicles - nTrucks;

% Funktion für Ringstrasse
idxmod  =  @(x, indexRange) mod(x - 1, indexRange) + 1;

% Override Rng
rng = LCG(912915758);
rand = rng.random;
randi = @(x) ceil(x * rng.random);


%Initialize
sumTrucks = 0;
for i = 1:nVehicles
    zr = randi(nCells);
    lr = randi(lanes);
    
    % Place Truck
    if lr > lanes - 2 && sumTrucks < nTrucks   
        
        % Finde Lücke die für LKW groß genug ist
        isEmpty = 0;  
        tempLengthTruck = 0;  
        while ~ isEmpty
            
            isEmpty = 1;
            tempLengthTruck = lengthTrucks(randi(length(lengthTrucks)));
            for iTruck = 1:tempLengthTruck
                if ~ isempty(strasse{ lr, idxmod(zr+1-iTruck, nCells) })
                    isEmpty = 0;
                    zr = randi(nCells);
                    lr = lanes - randi(2) + 1;
                end
            end
        end
        
        % Vorderes Ende  =  1 / Hinteres Ende  =  lengthTruck
        for iTruck = 1:tempLengthTruck
            vT = randi(vMaxTruck);
            if iTruck > 1
                strasse{lr, idxmod(zr + 1 - iTruck, nCells)} = Vehicle(['LKW' num2str(iTruck)], 0, 0, 0);
            else
                strasse{lr, idxmod(zr + 1 - iTruck, nCells)} = Vehicle(['LKW' num2str(iTruck)], tempLengthTruck, vT, vMaxTruck);
            end
        end
        
        sumTrucks = sumTrucks + 1;
        
    % Place Car
    else
        
        while ~ isempty(strasse{lr,zr})
            zr = randi(nCells);
            lr = randi(lanes);
        end
        tempVMax = vmaxCars(randi(length(vmaxCars)));
        strasse{lr,zr} = Vehicle('PKW', 1, randi(tempVMax), tempVMax);
        
    end
end


% animateHighway(strasse,maxLengthTrucks);

%%% Check wie viele Autos sich auf der Strasse befinden
%%% nur für Implementation
% summe = 0;
% sumTrucks = 0;
% for i = 1:lanes
%     for j = 1:zellen
%         if~isempty(strasse{i,j})
%             if strcmp(strasse{i,j}.type,'LKW')
%                 sumTrucks = sumTrucks+1;
%             end
%             summe = summe+1;
%         end
%     end
% end


%lane  =  1 : linkeste Fahrbahn
%lane  =  n : rechteste Fahrbahn

simulationTime = 150;
for iIime = 1:simulationTime
  
    neueStrasse = cell(lanes,nCells);
    
    for lane = 1:lanes
        for zelle = 1:nCells
            
            vehicle = strasse{lane,zelle};
            if  ~ isempty(vehicle)
                    
                if strcmp(vehicle.type,'PKW') || strcmp(vehicle.type, 'LKW1')
                    % Beschleunigen
                    vehicle.v = min(vehicle.v + 1, vehicle.vmax);
                    
                    %lane = 1 : linkeste Fahrbahn
                    %lane = n : rechteste Fahrbahn
                    
                    % Spur wechseln
                    tempLane = lane;
                    
                    %Auf aktueller Spur muss gebremst werden
                    if vehicle.gewechselt == 0 && ...
                            CheckLane(lane, zelle, strasse, 1, vehicle.v) <= vehicle.v
                        %Nach links wechslen, wenn genau links neben Auto frei
                        if lane>1 && CheckLane(lane-1, zelle, neueStrasse, -maxVMax, vehicle.v) > vehicle.v &&...
                                rand(ueberholwsnlkt)
                            tempLane=lane-1;
                            vehicle.gewechselt=-1;
                        end
                    end
                    
                    % Nach rechts wechseln
                    %Nach rechts wechseln, wenn genau rechts neben Auto frei
                    if vehicle.gewechselt == 0 && lane < lanes && rand(ueberholwsnlkt) &&...
                            CheckLane(lane+1,zelle,strasse,-vehicle.length+1,vehicle.v) > vehicle.v %rechte Spur ist frei
                        tempLane=lane+1;
                        vehicle.gewechselt=+1;
                    end
                    
                    
                    neueStrasse{tempLane,zelle} = vehicle;
                    if strcmp(vehicle.type,'LKW1')
                        for iTruck=1:vehicle.length-1
                            neueStrasse{tempLane,idxmod(zelle-iTruck,nCells)} ...
                                = strasse{lane,idxmod(zelle-iTruck,nCells)};
                        end
                    end
                    
                end
            end
        end
    end
    
    strasse = neueStrasse;
    neueStrasse = cell(lanes,nCells);
    
    for lane=1:lanes
        for zelle = 1:nCells
            
            vehicle = strasse{lane, zelle};
            if  ~ isempty(vehicle)                
                if strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW1')
                    
                    %Bremsen
                    vehicle.v = CheckLane(lane, zelle, strasse, 1, vehicle.v)-1;
                    
                    % Trödeln
                    % vehicle.v = vehicle.v - (vehicle.v ~= 0 && rand(troedelwsnlkt));
                    
                    % Bewegen
                    neueStrasse{lane, idxmod(zelle + vehicle.v, nCells)} = vehicle;
                    if strcmp(vehicle.type, 'LKW1')
                        for iTruck = 1:vehicle.length - 1
                            neueStrasse{lane, idxmod(zelle + vehicle.v-iTruck, nCells)} ...
                                = strasse{lane,idxmod(zelle - iTruck, nCells)};
                        end
                    end
                    
                end
            end
        end
    end
    strasse = neueStrasse;
    
    animateHighway(strasse,maxLengthTrucks);
    strasse = RobustCellFun(@reset,strasse);
    
    
    % Check wie viele Autos sich auf der Strasse befinden
    % nur für Implementation
% summe=0;
% sumTrucks=0;
% for i=1:lanes
%     for j=1:zellen
%         if~isempty(strasse{i,j})
%             if strcmp(strasse{i,j}.type(1),'L')
%                 sumTrucks=sumTrucks+1;
%             end
%             summe=summe+1;
%         end
%     end
% end
    
    
    
end




function vehicle = reset(vehicle)
        vehicle.gewechselt=0;
end


