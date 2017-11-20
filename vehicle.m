classdef vehicle
    
    properties
        type
        v
        vmax
    end 
    
    methods
        function obj = vehicle(type,v,vmax)
            obj.type=type;
            obj.v = v;
            obj.vmax=vmax;
        end
    end
end







