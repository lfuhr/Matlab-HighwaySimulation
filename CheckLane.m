function [ possibleV ] = CheckLane( lane,zelle,strasse,startv,endv )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

zellen = length(strasse(1,:));

possibleV=endv;

idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;

for idx=startv:endv
    if ~isempty(strasse{lane,idxmod(zelle+idx,zellen)})
        possibleV=idx-1;
        return;
    end
end

end

