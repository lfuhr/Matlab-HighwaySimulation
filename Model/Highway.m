classdef Highway < handle
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        nLanes
        nCells
        highway
        rand
        randi
        maxLengthTruck % nur zur Visualisierung
        speedLimit
    end
    
    methods
        function obj = Highway(nLanes, nCells)
            obj.nLanes = nLanes;
            obj.nCells = nCells;
            obj.highway = cell(nLanes,nCells);
            obj.speedLimit = 0;
            obj.maxLengthTruck = 0;
            
            % Setup Pseudo RNG
            rng = LCG(912915758);
            obj.rand = rng.random;
            obj.randi = @(x) ceil(x * rng.random);
        end        
       
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function placeVehicles(obj, vehicles)
            
            for vehicle = vehicles
                if obj.maxLengthTruck < vehicle.length
                    obj.maxLengthTruck = vehicle.length;
                end
                
                randCell = obj.randi(obj.nCells);
                randLane = obj.randi(obj.nLanes);
                
                % Finde Lücke die für Fahrzeug groß genug ist                  
                isEmpty = 0;                
                while ~ isEmpty                    
                    isEmpty = 1;
                    for iVehicleLength = 1:vehicle.length
                        if ~ isempty(obj.highway{ randLane, obj.idxmod(randCell+1-iVehicleLength, obj.nCells) })
                            isEmpty = 0;
                            randCell = obj.randi(obj.nCells);
                            randLane = obj.randi(obj.nLanes);
                        end
                    end
                end
                
                % Vorderes Ende  =  1 / Hinteres Ende  =  Vehicle.length
                for iVehicleLength = 1:vehicle.length
                    if iVehicleLength == 1
                        obj.highway{randLane, obj.idxmod(randCell + 1 - iVehicleLength, obj.nCells)} = vehicle;
                    else
                        obj.highway{randLane, obj.idxmod(randCell + 1 - iVehicleLength, obj.nCells)} = Vehicle([vehicle.type num2str(iVehicleLength)], 0, 0, 0);
                    end
                end
            end         
        end % function placeVehicles
        
        function Simulate(obj)
           
            % Zurücksetzen
            RobustCellFun(@Highway.Reset, obj.highway);
   
            % Beschleunigen
            RobustCellFun(@Highway.Accelerate, obj.highway); 
                        
            % Wechseln
            obj.highway = Highway.ChangeLane(obj.highway);
            
            % Bremsen
            obj.highway = Highway.SlowDown(obj.highway);
            
            % Trödeln
            RobustCellFun(@obj.Dawdle, obj.highway);
            
            % Bewegen
            obj.highway = Highway.Move(obj.highway);
        end
        
        function Dawdle(obj, vehicle)
            vehicle.v = vehicle.v - (vehicle.v ~= 0 && obj.rand(vehicle.troedelwsnlkt));
        end
        
        function neueStrasse = Move(obj, altestrasse)
            neueStrasse = cell(lanes, obj.nCells);
            for lane=1:lanes
                for zelle = 1:obj.nCells
                    
                    vehicle = altestrasse{lane, zelle};
                    if  ~ isempty(vehicle) && (strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW1'))             
                        
                        neueStrasse{lane, idxmod(zelle + vehicle.v, obj.nCells)} = vehicle;
                        if strcmp(vehicle.type, 'LKW1')
                            for iTruck = 1:vehicle.length - 1
                                neueStrasse{lane, idxmod(zelle + vehicle.v-iTruck, obj.nCells)} ...
                                    = altestrasse{lane,idxmod(zelle - iTruck, obj.nCells)};
                            end
                        end
        
                    end
                    
                end
            end
        end
        
        
    end
    methods (Static)
        
        function highway = ChangeLane(highway)
            % not implemented
        end
        
        function highway = SlowDown(highway)
            % not implemented
        end
        
        function Reset(vehicle)
            vehicle.gewechselt = 0;
        end
                
        function Accelerate(vehicle)
            vehicle.v = min(vehicle.v + 1, vehicle.vmax);
        end
        
        function y = idxmod(x, indexRange)
            y = mod(x - 1, indexRange) + 1;
        end
    end
end
