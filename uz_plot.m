

clear x y h heading errors gt measures sigmas

[n_beacons,temp]=size(obs);




x=zeros(1,temp);
y=zeros(1,temp);
heading=zeros(1,temp);

x(1)=xtrue(1,1);
y(1)=xtrue(2,1);
heading(1)=xtrue(3,1);

for j=2:temp

x(j)=x(j-1)             + DT*uz(1,j)*cos(heading(j-1)+uz(2,j))*WHEEL_RADIUS;
y(j)=y(j-1)             + DT*uz(1,j)*sin(heading(j-1)+uz(2,j))*WHEEL_RADIUS;
heading(j)=heading(j-1) + DT*uz(1,j)*WHEEL_RADIUS*sin(uz(2,j))/WHEEL_BASE;


%xnext(1)=x(1) + dt*unext(1)*cos(x(3)+unext(2));
%xnext(2)=x(2) + dt*unext(1)*sin(x(3)+unext(2));
%xnext(3)=x(3) + dt*unext(1)*sin(unext(2))/WHEEL_BASE;


end

figure;

hold on
v=[0 WORLD_SIZE 0 WORLD_SIZE];
axis(v);
plot(x,y,"b")
plot(xtrue(1,:),xtrue(2,:),'g')


measures=[x;y;heading];
gt=xtrue(1:3,:);
errors=gt-measures;
sigmas=[0,0,0];
for i=100:100:temp-200

errors2=errors(:,i:i+100);

sigmas=[sigmas;var(errors2')];


end


mean_sigmas=mean(sigmas);

distance_error=distance_gt-distance_m;
mean_distance=mean(distance_error);