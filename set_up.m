% script file to set up a vehicle run for subsequent
% filtering and localisation algorithms
% HDW 28/04/00
clear all;
close all;
clc;

globals; 	% define global variables
ginit;  		% set global variables

distance_gt=0;
distance_m=0;


%load('add_beacons.mat')
%load('add_path.mat')
% first step is to input beacons
disp('Input Beacon Locations via mouse. Press return to end');

%beacons=get_beacons;
beacons=get_saved_beacons;


[n_beacons,temp]=size(beacons);
buf=sprintf('%d Beacons read\n',n_beacons);
disp(buf);

% Next, input path spline points and compute path
disp('Input path spline points via mouse. Press return to end');
%path=get_path(beacons);
path=get_path2(beacons);

[temp,n_path]=size(path);
buf=sprintf('%d Path points of total Length %f meters read\n',n_path,n_path*LINC);
disp(buf);
disp('Press Return to continue'); 
pause;

%%

% do controller to build true path and control vectors
% initialise
time=0:DT:TEND;
[temp,tsize]=size(time);

xtrue=zeros(4,tsize);	% needed for reseting between runs
utrue=zeros(3,tsize);	% and again
xtrue(1,1)=path(1,1);	% initial x
xtrue(2,1)=path(2,1);	% initial y
xtrue(3,1)=atan2(path(2,2)-path(2,1),path(1,2)-path(1,1)); % initial phi
xtrue(4)=0;					% time=0;
utrue(1)=VVEL;				% velocity set at 2 m/s
utrue(2)=0;					% initial steer is zero
utrue(3)=0;					% time=0

% loop control
buf=sprintf('Beginning Simulation, please wait\n');
disp(buf);

%%
check_errs=zeros(4,tsize);

index = 1;
for i=1:(tsize-1)
   % find error
   [perr,oerr,index,d]=get_err(xtrue(:,i),path,index);
   %__
   check_errs(:,i) = [perr,oerr,index,d];
   %__
   
   % compute next state
   [xtrue(:,i+1),utrue(:,i+1)]=get_control(xtrue(:,i),utrue(:,i),perr,oerr,DT);
   %__
   if abs(utrue(2,i+1) - utrue(2,i)) > 1
      fprintf('utrue_dif=%f index=%d', utrue(2,i+1) - utrue(2,i), i);
      fprintf(', perr=%f, oerr=%f, index=%d, d=%f\n',perr,oerr,index,d);
   end
   %__
   if d >10  % test for end of path
      break;
   end
end

% shorten vectors to end length
xtrue=xtrue(:,1:i);
utrue=utrue(:,1:i);
utrue(1,:)=utrue(1,:)/WHEEL_RADIUS; % make speed into rads/s

% add noise if required
uz(1,:)=utrue(1,:)+GSIGMA_WHEEL*randn(size(utrue(1,:)));
uz(2,:)=utrue(2,:)+GSIGMA_STEER*randn(size(utrue(2,:)));


%% Trying to pass uz control to x, y and theta
uz_size = size(uz,ndims(uz));
uz2xyt = zeros(4, uz_size);
first_heading = atan2(path(2,2)-path(2,1),path(1,2)-path(1,1));

% Start converting uz controls to x, y and theta
uz2xyt(1,1) = xtrue(1,1);
uz2xyt(2,1) = xtrue(2,1);
uz2xyt(3,1) = xtrue(3,1);
uz2xyt(4,1) = 0;

for j=2:(uz_size)
    %uz2xyt(3,j) = uz2xyt(3,j-1) + uz(2,j) * DT * KO;
    %uz2xyt(3,j) = mod(uz2xyt(3,j) + pi, 2*pi) - pi;
    %uz2xyt(1,j) = uz2xyt(1,j-1) + uz(1,j) * DT * WHEEL_RADIUS * cos(uz2xyt(3,j));
    %uz2xyt(2,j) = uz2xyt(2,j-1) + uz(1,j) * DT * WHEEL_RADIUS * sin(uz2xyt(3,j));
    %uz2xyt(4,j) = uz2xyt(4,j) + DT;
    
    uz2xyt(1,j) = uz2xyt(1,j-1) + DT*uz(1,j)*cos(uz2xyt(3,j-1) + uz(2,j))*WHEEL_RADIUS;
    uz2xyt(2,j) = uz2xyt(2,j-1) + DT*uz(1,j)*sin(uz2xyt(3,j-1) + uz(2,j))*WHEEL_RADIUS;
    uz2xyt(4,j) = uz2xyt(4,j)   + DT;
    uz2xyt(3,j) = uz2xyt(3,j-1) + DT*uz(1,j)*sin(uz(2,j))* WHEEL_RADIUS/WHEEL_BASE;
    uz2xyt(3,j) = mod(uz2xyt(3,j) + pi, 2*pi) - pi;
    %fprintf('j=%d cos()=%d sin()=%d uz2xyt(1,j)=%d uz2xyt(2,j)=%d uz2xyt(3,j)=%d\n', j, cos(uz2xyt(3,j)), sin(uz2xyt(3,j)), uz2xyt(1,j), uz2xyt(2,j), uz2xyt(3,j));
end
%__

buf=sprintf('simulation terminating at time %f\n',i*DT);
disp(buf);
figure(PLAN_FIG)
hold on
scatter(beacons(:,1),beacons(:,2),'pentagram','r','filled')
plot(xtrue(1,:),xtrue(2,:),'g')
plot(uz2xyt(1,:),uz2xyt(2,:),'b')
hold off