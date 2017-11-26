classdef Vehicle
    
    properties
        type
        v
        vmax
        hasChangedLane
    end 
    
    methods
        function obj = Vehicle(type,v,vmax)
            obj.type = type;
            obj.v = v;
            obj.vmax = vmax;
            obj.hasChangedLane = false;
        end
    end
end







