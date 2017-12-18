function [Dichte, Fluss,v] = checkDichteFluss(strasse,intervall)

[spur, zellen]=size(strasse);
hold on
Fluss=0;
Dichte=0;
cars=0;
v=0;
for i=1:spur
    for j=1:zellen
        
%         if(~isempty(strasse{i,j})&&(strcmp(strasse{i,j}.type,'PKW')|| strcmp(strasse{i,j}.type,'LKW1')))            
%             v=v+strasse{i,j}.v;
%         end
        
        if(j>=intervall(1)&& j<=intervall(2)&& ~isempty(strasse{i,j})&&(strcmp(strasse{i,j}.type,'PKW')|| strcmp(strasse{i,j}.type,'LKW1')))
            cars=cars+1;
             v=v+strasse{i,j}.v;
        end
    
    end
end


Dichte = cars/((intervall(2)-intervall(1))+1);
Fluss= cars;
% v=(v*3.6*7.5)/(zellen*7.5*(1/1000));
v=(v*3.6*7.5)/((intervall(2)-intervall(1)+1)*7.5*(1/1000));

end

