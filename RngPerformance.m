addpath Model;


tic
rng = LCG(912915758);
for i = 1:1000000
    a = rng.rand();
end
disp(['Time LCG ',num2str(toc)])

tic;
for i = 1:1000000
    a = rand;
end
disp(['Time Matlab ',num2str(toc)])