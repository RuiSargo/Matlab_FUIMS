function [obs_p,state_p]=p_obs_2(obs,state,beacons)

globals;
ginit;

[emp,OSIZE]=size(obs);
[temp,SSIZE]=size(state);

[n_beacons,temp]=size(beacons);

if (SSIZE ~= OSIZE)
  error('Unmatched state and observation dimensions')
end

obs_p=zeros(2,SSIZE*n_beacons);
% state_p=zeros(2,SSIZE); Para que é que precisamos do state_p se não
% mudamos nada nele e sim, só o tamanho de colunas SSIZE para nr_obs?

nr_obs=0;
for t=1:SSIZE
     rx = state(1,t);
     ry = state(2,t);
     for b_index=1:n_beacons
        dist_obs = obs(b_index, t);
        if ~(isnan(dist_obs))
            nr_obs=nr_obs+1;
            dist_obs = obs(b_index,t);
            
            bx = beacons(b_index,1);
            by = beacons(b_index,2);
            
            angle_tan = atan2((by-ry),(bx-rx));
            %dist_true = sqrt((bx-rx)^2+(by-ry)^2);
            % obs_p(1,nr_obs)= rx + (dist_true * cos(angle_tan));
            % obs_p(2,nr_obs)= ry + (dist_true * sin(angle_tan));            
            obs_p(1,nr_obs)= rx + (dist_obs * cos(angle_tan));
            obs_p(2,nr_obs)= ry + (dist_obs * sin(angle_tan));    
%             state_p(1,nr_obs)=rx;
%             state_p(2,nr_obs)=ry;
        end
    end
end

obs_p=obs_p(:,1:nr_obs);
% state_p=state_p(:,1:nr_obs);
state_p = state;

end

