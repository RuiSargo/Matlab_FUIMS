function [obs_calc]=calc_dist_beacons(k_loc,beacons)

globals;

sigma_sensor = SIGMA_SENSOR; % = 0.30;




[n_beacons,temp]=size(beacons);
obs_calc=zeros(n_beacons+1,1);

x_robot=k_loc(1);
y_robot=k_loc(2);
for i=1:n_beacons
    x_beacon=beacons(i,1);
    y_beacon=beacons(i,2);
    distance = sqrt((x_beacon-x_robot)^2+(y_beacon-y_robot)^2);
    % distance_gt=[distance_gt,distance];
    % distance_m=[distance_m,distance + randn(1)*sigma_sensor];
    if (distance<=R_MAX_RANGE)
        obs_calc(i) = distance + randn(1)*sigma_sensor;
    else
        obs_calc(i) = NaN;
    end
    
end

obs_calc(n_beacons+1)=k_loc(4);
end

