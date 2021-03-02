%% Drone simulation
% clean everything and initialize the figure
clc; clf; clear; close all;
% scale is the size of the environment
scale = 1;
init_fig(scale);

% Global variable for the Simulation
tmax = 3;
dt = 0.01;

% initial pose of the drone in it own frame
drone_state = [0 0 5 ... % x, y, z
               3 0 1 ... % phi, th, psi
               0 0 0 ... % u, v, w
               0 0 0];   % p, q, r

% create drone structure
drone = init_drone(drone_state);

for t=0:dt:tmax
 
  % command entry for each motor => w1, w2, w3, w4
  u = drone_control(drone_state, drone);
  
  % ode45 intergrator
  value = @(t, drone_state) drone_model2(t, drone_state, u, drone);
  [t45, x45] = ode45(value, [0 dt], drone_state);
  l45 = length(t45);
  drone_state = x45(l45,:)';
  
  % update the drone pose
  draw_drone(drone_state, drone);
  pause(dt);
  if (drone_state(3) <= 0)
    break;
  endif
endfor


##R = rot(phi, th , psi);
##T = derivative_euler_rot(phi, th, psi);
##J = [R Mat_033;
##     Mat_033 T];
##     
##% Drone kinematics equation (6 DOF)
##% depsilon is the velicity vector in the Earth frame
##depsilon = J * nu;