function obs_sec=obs_seq(state,beacons)


% HDW 15/12/94, modified 17/05/00
% function to gather a complete observation sequence
% inputs are

globals;

% state vector, containing x,y,phi,t
[XSIZE,N_STATES]=size(state);
if XSIZE ~= 4
  error('Incorrect state dimension')
end

% obs=zeros(4,N_STATES);
[n_beacons,temp]=size(beacons);
obs_sec=zeros(n_beacons+1,N_STATES);

for i=1:N_STATES
  start_loc=state(:,i);
%   obs(:,i)=rad_sim(start_loc, beacons);
    obs_sec(:,i)=calc_dist_beacons(start_loc, beacons);
end