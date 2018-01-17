classdef Highway < handle
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        nLanes
        nCells
        highway
        tempHighway
        rng
        speedLimit
        useCellfun
        indices 
    end
    
    methods
        function obj = Highway(nLanes, nCells, rng, varargin)
            obj.nLanes = nLanes;
            obj.nCells = nCells;
            obj.highway = cell(nLanes,nCells);
            obj.speedLimit = 0;
            obj.rng = rng;
            obj.useCellfun = nargin > 3;
            
            % Generate an index array
            [X,Y] = meshgrid(1:nLanes,1:nCells);
            obj.indices = num2cell([X(:) Y(:)],2);
        end

        function placeVehicles(obj, vehicles)
            
            for iVehicle = 1:length(vehicles)
                vehicle = vehicles{iVehicle};
                
                randCell = obj.rng.randi(obj.nCells);
                randLane = obj.rng.randi(obj.nLanes);
                
                % Finde Lücke die für Fahrzeug groß genug ist
                errorCounter = 0;
                isEmpty = 0;
                while ~ isEmpty
                    isEmpty = 1;
                    for iVehicleLength = 1:vehicle.length
                        if ~ isempty(obj.highway{ randLane, obj.idxCellsMod(randCell+1-iVehicleLength) })
                            isEmpty = 0;
                            randCell = obj.rng.randi(obj.nCells);
                            randLane = obj.rng.randi(obj.nLanes);
                        end
                    end
                    errorCounter = errorCounter + 1;
                    if errorCounter > 20*obj.nCells*obj.nLanes
                        clc;
                        disp('Fehler bei voller Platzierung der Fahrzeuge.. Kein freier Platz auf Highway gefunden');
                        break;
                    end
                end
                
                
                % Vorderes Ende  =  1 / Hinteres Ende  =  Vehicle.length
                for iVehicleLength = 1:vehicle.length
                    if iVehicleLength == 1
                        obj.highway{randLane, obj.idxCellsMod(randCell + 1 - iVehicleLength)} = vehicle;
                    else
                        obj.highway{randLane, obj.idxCellsMod(randCell + 1 - iVehicleLength)} = Vehicle([vehicle.type num2str(iVehicleLength)], 0, 0, 0, 0, 0);
                    end
                end
            end         
        end % function placeVehicles
        
        function Simulate(obj)  
            if (obj.useCellfun)
                obj.SimulateUsingCellfun
            else
                obj.SimulateUsingFor
            end
        end
        
        
        function SimulateUsingCellfun(obj)

            % Beschleunigen
            RobustCellFun(@obj.Accelerate, obj.highway); 

            % Wechseln
            obj.PerformUsingCellfun(@obj.ChangeLane);

            % Bremsen
            cellfun(@(x)obj.PerformUsingCellfunAux(x, @Highway.SlowDown,obj.highway), obj.indices)

            % Trödeln
            RobustCellFun(@(x)Highway.Dawdle(obj.rng,x), obj.highway);

            % Bewegen
            obj.PerformUsingCellfun(@obj.Move);

        end
        
        
        function SimulateUsingFor(obj)
            
            oldHighway = obj.highway;
            obj.highway = cell(obj.nLanes, obj.nCells);
            for lane=1:obj.nLanes
                for zelle = 1:obj.nCells                    
                    vehicle = oldHighway{lane, zelle};                    
                    if  ~ isempty(vehicle)

                        % Beschleunigen
                        Highway.Accelerate(vehicle); 

                        % Wechseln
                        obj.ChangeLane(lane, zelle, vehicle, oldHighway); 

                    end
                end
            end
            
            oldHighway = obj.highway;
            obj.highway = cell(obj.nLanes, obj.nCells);
            for lane=1:obj.nLanes
                for zelle = 1:obj.nCells                    
                    vehicle = oldHighway{lane, zelle};                    
                    if  ~ isempty(vehicle)

                        % Bremsen
                        Highway.SlowDown(lane, zelle, vehicle, oldHighway)

                        % Trödeln (obj, wegen rng)
                        Highway.Dawdle(obj.rng, vehicle);

                        % Bewegen
                        obj.Move(lane, zelle, vehicle, oldHighway);

                    end
                end
            end
        end
        
        % Bewegen
        function Move(obj, lane, zelle, vehicle, oldHighway)
            if (strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW'))

                obj.highway{lane, obj.idxCellsMod(zelle + vehicle.v)} = vehicle;
                if strcmp(vehicle.type, 'LKW')
                    for iTruck = 1:vehicle.length - 1
                        obj.highway{lane, obj.idxCellsMod(zelle + vehicle.v-iTruck)} ...
                            = oldHighway{lane,obj.idxCellsMod(zelle - iTruck)};
                    end
                end

            end
        end
        
        function PerformUsingCellfun(obj, f)
            alteStrasse = obj.highway;
            obj.highway = cell(obj.nLanes, obj.nCells);
            cellfun(@(x)Highway.PerformUsingCellfunAux(x, f, alteStrasse), obj.indices)
        end
        
        %Wechseln
        function ChangeLane(obj, lane, zelle, vehicle, oldHighway)
            if strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW')
                % Spur wechseln
                tempLane = lane;


                %Auf aktueller Spur muss gebremst werden
                if Highway.CheckLane(lane, zelle, 1, vehicle.v,oldHighway) <= vehicle.v
                %Nach links wechslen, wenn genau links neben Auto frei

                %Mit Vorausschauen Wechseln: Highway.CheckLane(lane-1, zelle, x, vehicle.v, alteStrasse) > vehicle.v
                %Ohne Vorausschauen Wechseln: Highway.CheckLane(lane-1, zelle, x, 0,alteStrasse) > 0
                %Rücksichtsvolles Wechseln: Highway.CheckLane(lane-1, zelle, -vehicle.v-vehicle.length+1, x, alteStrasse) > x
                %Rücksichtsloses Wechseln: Highway.CheckLane(lane-1, zelle, -vehicle.length+1, x, alteStrasse) > x
                %Genauso auch bei der Nach-Rechts-Wechseln-Abfrage unten
                    if lane>1 && Highway.CheckLane(lane-1, zelle, -vehicle.v-vehicle.length+1, vehicle.v, oldHighway) > vehicle.v &&...
                            ((obj.rng.rand() - vehicle.ueberholwsnlkt) < 0)
                        tempLane=lane-1;
                        vehicle.gewechselt=-1;
                    end
                end

                % Nach rechts wechseln
                %Nach rechts wechseln, wenn genau rechts neben Auto frei
                if lane < obj.nLanes && ((obj.rng.rand() - vehicle.ueberholwsnlkt) < 0) &&...
                        Highway.CheckLane(lane+1, zelle, -vehicle.v-vehicle.length+1, vehicle.v, oldHighway) > vehicle.v %rechte Spur ist frei
                    tempLane=lane+1;
                    vehicle.gewechselt=+1;
                end
                
                %Fehlerbehebung für Fahrzeugeliminierung bei mehr als 2
                %Spuren (noch nicht ausgereift)
                
%                 if Highway.CheckLane(tempLane, zelle, -vehicle.length+1, 0, obj.highway) == 0
                    obj.highway{tempLane,zelle} = vehicle;
                    if strcmp(vehicle.type,'LKW')
                        for iTruck=1:vehicle.length-1
                            obj.highway{tempLane,obj.idxCellsMod(zelle-iTruck)} ...
                                = oldHighway{lane,obj.idxCellsMod(zelle-iTruck)};
                        end
                    end
%                 else
%                     obj.highway{lane,zelle} = vehicle;
%                     vehicle.gewechselt=0;
%                 end
            end
        end
        
        function result = idxCellsMod(obj,x)
            result = mod(x - 1, obj.nCells) + 1;
        end
        
        
    end
    methods (Static)
        
        %CheckLane
        function iBlocked = CheckLane(lane, zelle, startv, endv, highway )
            iBlocked = endv+1;             
            for idx=startv:endv
                if ~isempty(highway{lane, mod(zelle+idx-1, size(highway,2)) + 1})                    
                    iBlocked = idx;
                    return;
                end
            end  
        end

        %Bremsen
        function SlowDown(lane, zelle, vehicle, highway)            
            if strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW')      
                vehicle.v = Highway.CheckLane(lane, zelle, 1, vehicle.v, highway) - 1;                            
            end
        end
        
        % Trödeln
        function Dawdle(rng, vehicle)
            vehicle.v = vehicle.v - (vehicle.v ~= 0 && ((rng.rand() - vehicle.troedelwsnlkt) < 0));
        end
        
        function PerformUsingCellfunAux(indices,f,oldHighway) 
                lane = indices(1);
                zelle = indices(2);
                vehicle = oldHighway{lane, zelle};
                if  ~ isempty(vehicle)
                    f(lane, zelle, vehicle, oldHighway);
                end
        end
        
        function Reset(vehicle)
            vehicle.gewechselt = 0;
        end
                
        function Accelerate(vehicle)
            vehicle.v = min(vehicle.v + 1, vehicle.vmax);
        end
    end
end
