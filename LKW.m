classdef LKW
    
    properties
        type
        v
        vmax
        gewechselt
    end 
    
    methods
        function obj = LKW(type,v,vmax)
            obj.type=type;
            obj.v = v;
            obj.vmax=vmax;
            obj.gewechselt=0;
        end
    end
end

