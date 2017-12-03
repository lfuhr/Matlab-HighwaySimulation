clear;
clc;

figure('units', 'normalized', 'outerposition', [0 0 1 1])
lanes = 5; %Anzahl an Spuren
zellen = 100; %Länge der Strecke

vmaxCars = [5 6 7 8 9]; %Max Geschwindigkeit PKW
maxVMax = max(vmaxCars);
rV = [0.16 0.2 0.5]; %Mittlere Dichte Fahrzeuge
rhoVehicles = rV(3);

vmaxTruck = 3; %Max Geschwindigkeit LKW
rT = [0.2 0.5 0.8]; % prozentualer Anteil an LKW
ratioTrucks = rT(1);
lengthTrucks = [3 6]; %Zellenlänge pro LKW
maxLengthTrucks = max(lengthTrucks);

tp = [0 0.2 0.5 0.8]; %Trödelwahrscheinlichkeit
troedelwsnlkt = tp(2);

op = [0 0.2 0.5 0.8 1]; %Überholwahrscheinlichkeit
ueberholwsnlkt = op(end);

strasse = cell(lanes,zellen); %Strecke

%Anzahl der Fahrzeuge pro Fahrspur
nVehicles = zellen * rhoVehicles;
nTrucks = nVehicles * ratioTrucks;
nCars = nVehicles - nTrucks;

% Funktion für Ringstrasse
idxmod  =  @(x, indexRange) mod(x - 1, indexRange) + 1;

% Funktion für Würfeln
dice  =  @(wsnlkt) rand() + wsnlkt > 1;

%Initialize
sumTrucks = 0;
for i = 1:nVehicles
    zr = randi(zellen);
    lr = randi(lanes);
    
    % Place Truck
    if lr > lanes-2 && sumTrucks < nTrucks   
        
        % Finde Lücke die für LKW groß genug ist
        isEmpty = 0;  
        tempLengthTruck = 0;  
        while ~ isEmpty
            
            isEmpty = 1;
            tempLengthTruck = lengthTrucks(randi(length(lengthTrucks)));
            for iTruck = 1:tempLengthTruck
                if ~ isempty(strasse{ lr, idxmod(zr+1-iTruck, zellen) })
                    isEmpty = 0;
                    zr = randi(zellen);
                    lr = lanes - randi(2) + 1;
                end
            end
        end
        
        % Vorderes Ende  =  1 / Hinteres Ende  =  lengthTruck
        for iTruck = 1:tempLengthTruck
            vT = randi(vmaxTruck);
            if iTruck > 1
                strasse{lr, idxmod(zr+1 - iTruck,zellen)} = Vehicle(['LKW' num2str(iTruck)], 0, 0, 0);
            else
                strasse{lr, idxmod(zr+1 - iTruck, zellen)} = Vehicle(['LKW' num2str(iTruck)], tempLengthTruck, vT, vmaxTruck);
            end
        end
        
        sumTrucks = sumTrucks + 1;
        
    % Place Car
    else
        
        while ~ isempty(strasse{lr,zr})
            zr = randi(zellen);
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

dt = 0;
dtmax = 30;
while dt > -dtmax
    dt = dt - 0.2;
    
    neueStrasse = cell(lanes,zellen);
    
    for lane = 1:lanes
        for zelle = 1:zellen
            
            vehicle = strasse{lane,zelle};
            if  ~ isempty(vehicle)
                    
                if strcmp(vehicle.type,'PKW') || strcmp(vehicle.type, 'LKW1')
                    % Beschleunigen
                    vehicle.v = min(vehicle.v+1, vehicle.vmax);
                    
                    %lane = 1 : linkeste Fahrbahn
                    %lane = n : rechteste Fahrbahn
                    
                    % Spur wechseln
                    tempLane = lane;
                    
                    %Auf aktueller Spur muss gebremst werden
                    if vehicle.gewechselt == 0 &&...
                            CheckLane(lane, zelle, strasse, 1, vehicle.v) <= vehicle.v
                        %Nach links wechslen, wenn genau links neben Auto frei
                        if lane>1 && CheckLane(lane-1, zelle, neueStrasse, -maxVMax, vehicle.v) > vehicle.v &&...
                                dice(ueberholwsnlkt)
                            tempLane=lane-1;
                            vehicle.gewechselt=-1;
                        end
                    end
                    
                    % Nach rechts wechseln
                    %Nach rechts wechseln, wenn genau rechts neben Auto frei
                    if vehicle.gewechselt == 0 && lane < lanes && dice(ueberholwsnlkt) &&...
                            CheckLane(lane+1,zelle,strasse,-vehicle.length+1,vehicle.v) > vehicle.v %rechte Spur ist frei
                        tempLane=lane+1;
                        vehicle.gewechselt=+1;
                    end
                    
                    
                    neueStrasse{tempLane,zelle} = vehicle;
                    if strcmp(vehicle.type,'LKW1')
                        for iTruck=1:vehicle.length-1
                            neueStrasse{tempLane,idxmod(zelle-iTruck,zellen)} ...
                                = strasse{lane,idxmod(zelle-iTruck,zellen)};
                        end
                    end
                    
                end
            end
        end
    end
    
    strasse = neueStrasse;
    neueStrasse = cell(lanes,zellen);
    
    for lane=1:lanes
        for zelle = 1:zellen
            
            vehicle = strasse{lane, zelle};
            if  ~ isempty(vehicle)                
                if strcmp(vehicle.type, 'PKW')||strcmp(vehicle.type, 'LKW1')
                    
                    %Bremsen
                    vehicle.v=CheckLane(lane, zelle, strasse, 1, vehicle.v)-1;
                    
                    % Trödeln
                    % vehicle.v = vehicle.v - (vehicle.v ~= 0 && dice(troedelwsnlkt));
                    
                    % Bewegen
                    neueStrasse{lane, idxmod(zelle + vehicle.v, zellen)} = vehicle;
                    if strcmp(vehicle.type, 'LKW1')
                        for iTruck = 1:vehicle.length-1
                            neueStrasse{lane, idxmod(zelle + vehicle.v-iTruck, zellen)} ...
                                = strasse{lane,idxmod(zelle-iTruck,zellen)};
                        end
                    end
                    
                end
            end
        end
    end
    strasse = neueStrasse;
    
    strasse = animateHighway(strasse,maxLengthTrucks);
    
    %%% Check wie viele Autos sich auf der Strasse befinden
    %%% nur für Implementation
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




