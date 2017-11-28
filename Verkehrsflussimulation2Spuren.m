
clear;


csize=7.5; %Zellengr��e
zellen=100; %L�nge der Strecke
vmax=3; %Max Geschwindigkeit
rho=[0.16 0.2 0.25]; %Mittlere Dichte

tp=[0 0.2 0.5 0.8]; %Tr�delwahrscheinlichkeit
troedelwsnlkt=tp(2);

lanes=2; %Anzahl an Spuren
strasse=cell(lanes,zellen); %Strecke

%Anzahl der Fahrzeuge
nvecs=zellen*rho(2);

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

PlotHighway(strasse);

%%% Check wie viele Autos sich auf der Strasse befinden
summe=0;
for i=1:lanes
    for j=1:zellen
        if~isempty(strasse{i,j})
            summe=summe+1;
        end
    end
end

idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;

%lane = 1 : linke Fahrbahn
%lane = 2 : rechte Fahrbahn
while dt>-dtmax
    dt=dt-0.2;
    
    neueStrasse = cell(lanes,zellen);
    
    for lane=1:lanes
        for zelle = 1:zellen
            
            vehicle = strasse{lane,zelle};
            if  ~isempty(vehicle)
                
                % Beschleunigen
                vehicle.v = min(vehicle.v+1, vehicle.vmax);
                
                %lane = 1 : linke Fahrbahn
                %lane = 2 : rechte Fahrbahn
                
                % Nach links wechseln
                tempLane=lane;
                
                % Nach rechts wechseln
%                 tempLane=lane;
                %Nach rechts wechseln, wenn genau rechts neben Auto frei
                if lane<lanes &&...
                        CheckLane(lane+1,zelle,strasse,0,0)>-1 %rechte Spur ist frei
                    tempLane=lane+1;
                    vehicle.gewechselt=true;
                end     
                
                %Auf aktueller Spur muss gebremst werden
                if ~vehicle.gewechselt &&...
                        CheckLane(lane,zelle,strasse,1,vehicle.v)<vehicle.v
                    %Nach links wechslen, wenn genau links neben Auto frei
                    if lane>1 && CheckLane(lane-1,zelle,neueStrasse,0,0)>-1
                        tempLane=lane-1;
                        vehicle.gewechselt=true;
                    end
                end
                
                neueStrasse{tempLane,zelle} = vehicle;
            end
        end
    end
    
    strasse = neueStrasse;
    neueStrasse = cell(lanes,zellen);
    
    for lane=1:lanes
        for zelle = 1:zellen
            
            vehicle = strasse{lane,zelle};
            if  ~isempty(vehicle)
                
                if vehicle.gewechselt
                    vehicle.gewechselt=false;
                end
                
                %Bremsen
                vehicle.v=CheckLane(lane,zelle,strasse,1,vehicle.v);
                
                % Tr�deln
%                 vehicle.v = vehicle.v - (vehicle.v ~= 0 && rand()+troedelwsnlkt > 1);
                
                % Bewegen
                neueStrasse{lane,idxmod(zelle+vehicle.v,zellen)} = vehicle;
            end
        end
    end
    strasse = neueStrasse;
    
    PlotHighway(strasse);
    
    %%% Check wie viele Autos sich auf der Strasse befinden
    summe=0;
    for i=1:lanes
        for j=1:zellen
            if~isempty(strasse{i,j})
                summe=summe+1;
            end
        end
    end
    
    
    pause(0.51);
end




