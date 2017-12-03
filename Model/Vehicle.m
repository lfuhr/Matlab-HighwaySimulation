classdef Vehicle
    
    properties
        type
        v
        vmax
        gewechselt
        length
    end 
    
    methods
        function obj = Vehicle(type, length, v, vmax)
            obj.type = type;
            obj.v = v;
            obj.vmax = vmax;
            obj.gewechselt = 0; % Mainly for visualization
            obj.length = length;
        end
    end
end