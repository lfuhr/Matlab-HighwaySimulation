classdef Highway
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        nLanes
        nCells
        cells
        rand
        randi
        maxLengthTruck % nur zur Visualisierung
        speedLimit
    end
    
    methods
        function obj = Highway(nLanes, nCells, speedLimit)
            obj.nLanes = nLanes;
            obj.nCells = nCells;
            obj.speedLimit = speedLimit;
            
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
        
        function placeVehicles(vehicles)
            
            
            for vehicle = vehicles
                
                zr = obj.randi(nCells);
                lr = obj.randi(lanes);
                
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
            
            
        end
    end
end

