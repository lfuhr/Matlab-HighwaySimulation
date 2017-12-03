classdef Highway
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        nLanes
        nCells
        cells
        rand
        randi
    end
    
    methods
        function obj = Highway(nLanes,nCells)
            obj.nLanes = nLanes;
            obj.nCells = nCells;
            
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
    end
end

