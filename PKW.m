classdef PKW
    
    properties
        type
        v
        vmax
        gewechselt
        length
    end 
    
    methods
        function obj = PKW(type,length,v,vmax)
            obj.type=type;
            obj.v = v;
            obj.vmax=vmax;
            obj.gewechselt=0;
            obj.length=length;
        end
    end
end