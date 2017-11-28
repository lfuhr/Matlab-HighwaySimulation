% 
function [ vPossible ] = CheckLane( lane, CellNo, street, vStart, vEnd )
    lengthStreet = length(street(1,:));
    vPossible = vEnd;
    idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;

    for iOffset = vStart:vEnd
        if ~ isempty(street{lane, idxmod(CellNo + iOffset, lengthStreet) })
            vPossible = iOffset - 1;
            return;
        end
    end
end

