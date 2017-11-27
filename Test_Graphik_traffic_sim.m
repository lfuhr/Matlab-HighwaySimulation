
pause on;

for i=1:80
clf;

if(i<30)
    a=rectangle('Position',[i 2 6 4],'Curvature',[0.5,1]);
%     a =rectangle('Position',[i 2 6 4]);
    set(a, 'FaceColor', 'red')
    

    b =rectangle('Position',[i+10 2 10 4]);
    set(b, 'FaceColor', 'green')
   

else
    a=rectangle('Position',[i 10 6 4],'Curvature',[0.5,1]);
%     a=rectangle('Position',[i 10 6 4] );
    set(a, 'FaceColor', 'red')
    b =rectangle('Position',[i+10 2 10 4]);
    set(b, 'FaceColor', 'green')
    set(b,'EdgeColor', 'green')
      
end

axis([0 100 0 100])
pause(0.05);
end



% rectangle('Position',[6 0 2 4],'Curvature',[0.5,1])