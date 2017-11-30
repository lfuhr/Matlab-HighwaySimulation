function [strasse] = animateHighway(strasse,maxLengthTruck)


idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;
fps=30;
dt=1/fps;
[Spur, zellen]=size(strasse);
BreiteSpur=10;
HoeheStrasse=-50;
% xlim([0 zellen*7.5]);
% ylim([0 Spur*50])
axis([0 zellen*7.5 0 Spur*30])
lengthZelle=7.5;

for frame=1:fps
    clf
    hold on
    axis equal
        axis off
    
    if Spur>=1
        a=rectangle('Position',[-maxLengthTruck*lengthZelle -HoeheStrasse-BreiteSpur*Spur (zellen+maxLengthTruck+1)*lengthZelle Spur*BreiteSpur]);
        set(a, 'FaceColor', [0.5278 0.5278 0.5278])
        for k=1:Spur-1
            x = [-maxLengthTruck*lengthZelle (zellen+maxLengthTruck+1)*lengthZelle];
            y = [HoeheStrasse+k*BreiteSpur HoeheStrasse+k*BreiteSpur];
            line(x,-y,'Color','white','LineStyle','--')
        end
        
        
    end
    
    
    for i=1:Spur
        for j=1:zellen
            if ~isempty(strasse{i,j})
                if(strcmp(strasse{i,j}.type, 'LKW1'))% && str2double(strasse{i,j}.type(end))==1)
                    car=rectangle('Position',[idxmod(((j-strasse{i,j}.v)+dt*frame*strasse{i,j}.v)*lengthZelle,zellen*7.5)-(strasse{i,j}.length-1)*lengthZelle ...
                        -(HoeheStrasse+BreiteSpur*(1/2+i-strasse{i,j}.gewechselt-1)+BreiteSpur*frame*dt*strasse{i,j}.gewechselt) 4*strasse{i,j}.length 2]);
                    set(car, 'FaceColor', 'black','EdgeColor', 'black')
                end
                
                if(strcmp(strasse{i,j}.type,'PKW'))
                    car=rectangle('Position',[idxmod(((j-strasse{i,j}.v)+dt*frame*strasse{i,j}.v)*7.5,zellen*7.5)...
                        -(HoeheStrasse+BreiteSpur*(1/2+i-strasse{i,j}.gewechselt-1)+BreiteSpur*frame*dt*strasse{i,j}.gewechselt) 4 2],'Curvature',[0.5,1]);
                    set(car, 'FaceColor', 'red','EdgeColor', 'red')
                end
                
                
                
                %                 car=rectangle('Position',[idxmod(((j-strasse{i,j}.v)+dt*frame*strasse{i,j}.v)*7.5,zellen*7.5)...
                %                     -(HoeheStrasse+BreiteSpur*(1/2+i-strasse{i,j}.gewechselt-1)+BreiteSpur*frame*dt*strasse{i,j}.gewechselt) 4 2],'Curvature',[0.5,1]);
                %                 set(car, 'FaceColor', 'red','EdgeColor', 'red')
                if frame==fps
                    strasse{i,j}.gewechselt=0;
                    
                end
            end
            
            
        end
        
        
        
    end
    pause(1/(fps*4));
end










end

