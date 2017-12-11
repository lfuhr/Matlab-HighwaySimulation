classdef Vehicle < handle
    
    properties
        type
        v
        vmax
        gewechselt
        length
        troedelwsnlkt
    end 
    
    methods
        function vehicle = Vehicle(type, length, v, vmax)
            vehicle.type = type;
            vehicle.v = v;
            vehicle.vmax = vmax;
            vehicle.gewechselt = 0; % Mainly for visualization
            vehicle.length = length;
        end
    end
end