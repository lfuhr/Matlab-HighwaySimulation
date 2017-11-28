classdef PKW
    
    properties
        type
        v
        vmax
        gewechselt
    end 
    
    methods
        function obj = PKW(type,v,vmax)
            obj.type=type;
            obj.v = v;
            obj.vmax=vmax;
            obj.gewechselt=0;
        end
    end
end

