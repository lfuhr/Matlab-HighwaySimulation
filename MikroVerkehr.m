clear;
global LEER vMax zellen;
zellen = 600;
vMax = 10;
dichte = .5;
LEER = -1;
iterationen = 1000;
troedelwsnlkt =  0.2;

idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;

strasse = zeros(1,zellen) - 1;
while (sum(strasse ~= -1) < dichte * zellen)
    strasse(randi(zellen)) = randi(vMax + 1) - 1;
end

sss = strasse;

for i = 1:iterationen
    neueStrasse = zeros(1,zellen) - 1;
    for zelle = 1:zellen
        v = strasse(zelle);
        if  v ~= LEER
            % Beschleunigen
            v = min(v+1, vMax);
            % Bremsen
            davor = find(strasse(idxmod(zelle+1:zelle+vMax, zellen))+1);
            if ~ isempty(davor)
                v = min(v, davor(1) - 1);
            end
            % Trödeln
            v = v - (v ~= 0 && rand()+troedelwsnlkt > 1);
            % Bewegen
            neueStrasse(idxmod(zelle+v,zellen)) = v;
        end
    end
    strasse = neueStrasse;
    dsp(strasse)
    pause(.0005)
end

function result = farbe(wert)
    global LEER vMax;  
    result = (wert == LEER) .* 1 + (wert ~= LEER) .* (wert * 0.6 / vMax);
    result = [result; result; result];
end

function dsp(strasse)
    global zellen;
    scatter(cos((1:zellen)*2*pi/zellen), sin((1:zellen)*2*pi/zellen),[] ...
        , farbe(strasse)' );
end