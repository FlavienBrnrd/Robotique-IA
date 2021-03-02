% Control the level of a water tank
% Close and clear everything
clc; clf; clear; close all;

% init the figure
InitFigure();
tMax = 3;
dt = 0.01;

vDes = [2 5 1 8]; % Desired volumes
vDesd = 3;
waterTankState = 0; % Initial value of the water volume

%waterTank.ptr1 =  line ([-5 5], [waterTankState waterTankState], "color", "b");

waterTank.ptr1 = rectangle ("Position", [0, 0, 5, waterTankState]);
set(waterTank.ptr1, "FaceColor", [41, 143, 245]/255);
desired.ptr1 =  line ([0 5], [vDes(1) vDes(1)], "color", "r");

for i=1:1:length(vDes)
  set(desired.ptr1, 'ydata',   [vDes(i) vDes(i)]);
  for t=0:dt:tMax
    error = vDes(i) - waterTankState(1);
    % PID controller
    u = PID(error);
    
    % ode45 intergrator
    value = @(t, waterTankState) WaterTankModel(t, waterTankState, u);
    [t45, x45] = ode45(value, [0 dt], waterTankState);
    l45 = length(t45);
    waterTankState = x45(l45,:)';
    
    set(waterTank.ptr1, "Position", [0, 0, 5, waterTankState]);
    pause(dt);
  endfor
endfor