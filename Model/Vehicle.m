classdef Vehicle < handle
    
    properties
        type
        v
        vmax
        gewechselt
        length
        troedelwsnlkt 
        ueberholwsnlkt 
    end 
    
    methods
        function obj = Vehicle(type, length, v, vmax, tp , uep)
            obj.type = type;
            obj.v = v;
            obj.vmax = vmax;
            obj.gewechselt = 0; % Mainly for visualization
            obj.length = length;
            obj.troedelwsnlkt = tp;
            obj.ueberholwsnlkt = uep;
        end
    end
end