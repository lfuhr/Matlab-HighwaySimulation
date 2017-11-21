classdef vehicle
    
    properties
        type
        v
        vmax
        gewechselt
    end 
    
    methods
        function obj = vehicle(type,v,vmax)
            obj.type=type;
            obj.v = v;
            obj.vmax=vmax;
            obj.gewechselt=false;
        end
    end
end







