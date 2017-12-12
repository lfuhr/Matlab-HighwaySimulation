function [ blockedI ] = CheckLane( lane,zelle,strasse,startv,endv )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

zellen = length(strasse(1,:));

blockedI = endv+1;

idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;

for idx=startv:endv
    if ~isempty(strasse{lane, idxmod(zelle+idx,zellen)})
        
        blockedI = idx;
        return;
    end
end

end

