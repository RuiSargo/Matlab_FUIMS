function beacons=get_beacons
%
%  beacons=get_beacons
%
% HDW 28/04/00
% function to graphically input beacon locations
% beacons is 2*N matrix containing x,y locations of beacons

globals;

beacons=zeros(1,2);
beacon_make = [50, 150, 250, 350, 450, 450, 450, 450, 450, 350, 250, 150,  50,  50,  50,  50,...
               50, 50,  50,  50,  50,  150, 250, 350, 450, 450, 450, 450, 450, 350, 250, 150];
beacons = reshape(beacon_make, 16, 2);

% set up the figure
figure(PLAN_FIG)
clf
v=[0 WORLD_SIZE 0 WORLD_SIZE];
axis(v);
hold on;

hold off
