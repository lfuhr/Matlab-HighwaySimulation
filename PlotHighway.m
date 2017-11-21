function [] = PlotHighway( strasse )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


[lanes, zellen]=size(strasse);

    clf
    hold on;
    for i=1:zellen
        for j=1:lanes
            if ~isempty(strasse{j,i})
                if j==1
                    rectangle('position',[i-0.5 -j-0.5 0.9 0.9],'facecolor','blue');
                else
                    rectangle('position',[i-0.5 -j-0.5 0.9 0.9],'facecolor','red');
                end
            end
        end
    end
    axis([0 zellen+1 -lanes-1 0]);

end

