classdef Vehicle
    
    properties
        type
        v
        vmax
        gewechselt
        length
    end 
    
    methods
        function vehicle = Vehicle(type, length, v, vmax)
            vehicle.type = type;
            vehicle.v = v;
            vehicle.vmax = vmax;
            vehicle.gewechselt = 0; % Mainly for visualization
            vehicle.length = length;
        end
        
        function vehicle = Accelerate(vehicle)
            vehicle.v = min(vehicle.v + 1, vehicle.vmax);
        end
    end
end