clear all
set_up

run_obs



csvwrite('path.csv', path');
csvwrite('uz.csv', uz');
csvwrite('xtrue.csv', xtrue');
csvwrite('obs.csv', obs');
csvwrite("beacons.csv",beacons);

save run.mat