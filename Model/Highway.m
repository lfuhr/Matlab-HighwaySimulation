classdef Highway < handle
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        nLanes
        nCells
        highway
        rng
        speedLimit
        idxCellsMod
    end
    
    methods
        function obj = Highway(nLanes, nCells)
            obj.nLanes = nLanes;
            obj.nCells = nCells;
            obj.highway = cell(nLanes,nCells);
            obj.speedLimit = 0;
            
            % Setup Pseudo RNG
            obj.rng = LCG(912915758);
            
            % Define idxCellsMod
            obj.idxCellsMod = @(x) mod(x - 1, nCells) + 1;
        end        
       
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function placeVehicles(obj, vehicles)
            
            for iVehicle = 1:length(vehicles)
                vehicle=vehicles{iVehicle};
                
%                 randCell = obj.rng.randi(obj.nCells);
%                 randLane = obj.rng.randi(obj.nLanes);
                randCell = randi(obj.nCells);
                randLane = randi(obj.nLanes);
                
                % Finde Lücke die für Fahrzeug groß genug ist                  
                isEmpty = 0;                
                while ~ isEmpty                    
                    isEmpty = 1;
                    for iVehicleLength = 1:vehicle.length
                        if ~ isempty(obj.highway{ randLane, obj.idxCellsMod(randCell+1-iVehicleLength) })
                            isEmpty = 0;
%                             randCell = obj.rng.randi(obj.nCells);
%                             randLane = obj.rng.randi(obj.nLanes);
                            randCell = randi(obj.nCells);
                            randLane = randi(obj.nLanes);
                        end
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
           
            % Wechselvariablen zurücksetzen
            RobustCellFun(@obj.Reset, obj.highway);
   
            % Beschleunigen
            RobustCellFun(@obj.Accelerate, obj.highway); 
                        
            % Wechseln
            obj.highway = obj.ChangeLane(); 
            
            % Bremsen
            obj.SlowDown();
            
            % Trödeln
            RobustCellFun(@obj.Dawdle, obj.highway);
            
            % Bewegen
            obj.highway = obj.Move();
            % obj.Move3(); // cellfun alternative
        end
        
        % Trödeln
        function Dawdle(obj, vehicle)
%             vehicle.v = vehicle.v - (vehicle.v ~= 0 && ((obj.rng.rand() - vehicle.troedelwsnlkt) < 0));
            vehicle.v = vehicle.v - (vehicle.v ~= 0 && ((rand() - vehicle.troedelwsnlkt) < 0));
        end
        
        % Bewegen
        function neueStrasse = Move(obj)
            neueStrasse = cell(obj.nLanes, obj.nCells);
            for lane=1:obj.nLanes
                for zelle = 1:obj.nCells
                    
                    vehicle = obj.highway{lane, zelle};
                    if  ~ isempty(vehicle) && (strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW'))
                        
                        neueStrasse{lane, obj.idxCellsMod(zelle + vehicle.v)} = vehicle;
                        if strcmp(vehicle.type, 'LKW')
                            for iTruck = 1:vehicle.length - 1
                                neueStrasse{lane, obj.idxCellsMod(zelle + vehicle.v-iTruck)} ...
                                    = obj.highway{lane,obj.idxCellsMod(zelle - iTruck)};
                            end
                        end
                        
                    end
                    
                end
            end
        end
        
        % Cellfun alternative for to move
%         function Move3(obj)
%             alteStrasse = obj.highway;
%             obj.highway = cell(obj.nLanes, obj.nCells);
%             cellfun(@(x)obj.Move2(x, alteStrasse), obj.getIndices(obj.highway))
%         end
%         function Move2(obj,indices, altestrasse)
%                 lane = indices(1);
%                 zelle = indices(2);
%                 vehicle = altestrasse{lane, zelle};
%                 if  ~ isempty(vehicle) && (strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW'))
%                     obj.highway{lane, obj.idxCellsMod(zelle + vehicle.v)} = vehicle;
%                     if strcmp(vehicle.type, 'LKW')
%                         for iTruck = 1:vehicle.length - 1
%                             obj.highway{lane, obj.idxCellsMod(zelle + vehicle.v-iTruck)} ...
%                                 = altestrasse{lane,obj.idxCellsMod(zelle - iTruck)};
%                         end
%                     end
% 
%                 end
%         end
        
        %CheckLane
        function iBlocked = CheckLane(obj, lane, zelle, startv, endv )
                        
            iBlocked = endv+1;            
            
            for idx=startv:endv
                if ~isempty(obj.highway{lane, obj.idxCellsMod(zelle+idx)})                    
                    iBlocked = idx;
                    return;
                end
            end
            
        end
        

        %Bremsen
        function SlowDown(obj)
            
            for lane=1:obj.nLanes
                for zelle = 1:obj.nCells                    
                    vehicle = obj.highway{lane, zelle};                    
                    if  ~ isempty(vehicle)
                        if strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW')      
                            vehicle.v = obj.CheckLane(lane, zelle, 1, vehicle.v) - 1;                            
                        end
                    end
                end
            end

        end
        
        %Wechseln
        function neueStrasse = ChangeLane(obj)
            neueStrasse = cell(obj.nLanes, obj.nCells);
            for lane=1:obj.nLanes
                for zelle = 1:obj.nCells
                    vehicle = obj.highway{lane, zelle};
                    if  ~ isempty(vehicle)
                        if strcmp(vehicle.type, 'PKW') || strcmp(vehicle.type, 'LKW')
                            % Spur wechseln
                            tempLane = lane;
                            
                            %Auf aktueller Spur muss gebremst werden
                            if obj.CheckLane(lane, zelle, 1, vehicle.v) <= vehicle.v
                                %Nach links wechslen, wenn genau links neben Auto frei
                                if lane>1 && obj.CheckLane(lane-1, zelle, -vehicle.vmax, vehicle.v) > vehicle.v &&...
                                        rand(vehicle.ueberholwsnlkt)
                                    tempLane=lane-1;
                                    vehicle.gewechselt=-1;
                                end
                            end
                            
                            % Nach rechts wechseln
                            %Nach rechts wechseln, wenn genau rechts neben Auto frei
                            if lane < obj.nLanes && rand(vehicle.ueberholwsnlkt) &&...
                                    obj.CheckLane(lane+1, zelle, -vehicle.length+1, vehicle.v) > vehicle.v %rechte Spur ist frei
                                tempLane=lane+1;
                                vehicle.gewechselt=+1;
                            end
                            
                            
                            neueStrasse{tempLane,zelle} = vehicle;
                            if strcmp(vehicle.type,'LKW')
                                for iTruck=1:vehicle.length-1
                                    neueStrasse{tempLane,obj.idxCellsMod(zelle-iTruck)} ...
                                        = obj.highway{lane,obj.idxCellsMod(zelle-iTruck)};
                                end
                            end
                        end
                    end
                end
            end
        end
        
    end
    methods (Static)               

        function indices = getIndices(cellArray)
            s = size(cellArray);
            [X,Y] = meshgrid(1:s(1),1:s(2));
            indices = num2cell([X(:) Y(:)],2);
        end
        
        function Reset(vehicle)
            vehicle.gewechselt = 0;
        end
                
        function Accelerate(vehicle)
            vehicle.v = min(vehicle.v + 1, vehicle.vmax);
        end
    end
end
