
clear;


csize=7.5; %Zellengr��e
zellen=10; %L�nge der Strecke
vmax=5; %Max Geschwindigkeit
rho=[0.16 0.2 0.25]; %Mittlere Dichte
tp=[0 0.2 0.5 0.8]; %Tr�delwahrscheinlichkeit

lanes=2; %Anzahl an Spuren
strasse=cell(lanes,zellen); %Strecke

%Anzahl der Fahrzeuge
nvecs=zellen*rho(1);

%Initialize
for ln=1:lanes
    for i=1:nvecs
        j=randi(zellen);
        v=randi(vmax);
        while ~isempty(strasse{ln,j})
            j=randi(zellen);
        end
        strasse{ln,j}=vehicle('PKW',v,vmax);
        %     s(2,j)=v;
    end
end


dt=0;
dtmax=30;

clf;
hold on;
for i=1:zellen
    for j=1:2
        if ~isempty(strasse{j,i})
            plot(i,-j,'blue.');
        end
    end
end
% axis([1 ls -dtmax 1]);
axis([0 zellen+1 -3 0]);



idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;


while dt>-dtmax
    dt=dt-0.2;
    
    neueStrasse = cell(lanes,zellen);
    
    for lane=1:lanes
        for zelle = 1:zellen
            vehicle = strasse{lane,zelle};
            if  ~isempty(vehicle)
                % Beschleunigen
                vehicle.v = min(vehicle.v+1, vehicle.vmax);
                % Bremsen
                for idx=1:vehicle.v
                    if ~isempty(strasse{lane,idxmod(zelle+idx,zellen)})
                        vehicle.v=idx-1;
                        break;
                    end
                end
                % Tr�deln
%                 vehicle.v = vehicle.v - (vehicle.v ~= 0 && rand()+troedelwsnlkt > 1);
                % Bewegen
                neueStrasse{lane,idxmod(zelle+vehicle.v,zellen)} = vehicle;
            end
        end
    end
    strasse = neueStrasse;
    
    clf
    hold on;
    for i=1:zellen
        for j=1:2
            if ~isempty(strasse{j,i})
                plot(i,-j,'blue.');
            end
        end
    end
    axis([0 zellen+1 -3 0]);
    
    pause(0.01);
end




