classdef Highway
    %HIGHWAY Models the highway as a snapshot and its transitions
    
    properties
        Property1
    end
    
    methods
        function obj = Highway(inputArg1,inputArg2)
            %HIGHWAY Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

