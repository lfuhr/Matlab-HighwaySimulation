function [density] = SaveFlux(obj)

tempV = 0;
vehicleCount = 0;
for iZelle = 1:obj.nCells
    for iLane = 1:obj.nLanes
        vehicle = obj.highway{iLane,iZelle};
        if ~isempty(vehicle)
            vehicleCount = vehicleCount+1;
            if isnan(str2double(vehicle.type(end)))
                tempV = tempV + vehicle.v;
            end
        end
    end
end
density = [tempV/vehicleCount tempV/(obj.nCells*obj.nLanes)];

end