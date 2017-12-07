classdef Highway
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        nLanes
        nCells
        highway
        rand
        randi
        maxLengthTruck % nur zur Visualisierung
        speedLimit        
        idxmod  =  @(x, indexRange) mod(x - 1, indexRange) + 1;
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
        
        function obj = placeVehicles(obj, vehicles)
            
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
            
%             set.highway(obj.highway);
        end %end of function placeVehicles
        
        function obj = simulate(obj)
           
            
            
        end
        
    end
end
