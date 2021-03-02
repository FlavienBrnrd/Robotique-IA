% Simulation and control of a Train
clf; close all; clc; clear;

% Simulation variable
dt = 0.01;
tMax = 10;

% Init the figure
InitFigure();

% Initial position of the train
trainState = [0 0]'; % x position, dx speed

% Desired position to reach
Xdes = [0 0]';

% Train structure
train.m = 5;
train.ptr1 = plot(trainState(1), 0,'s');

for t=0:dt:tMax
 % Compute the error
 error = Xdes - trainState;
 u = PID(error);
 
 % ode45 intergrator
 value = @(t, trainState) TrainModel(t, trainState, u, train);
 [t45, x45] = ode45(value, [0 dt], trainState);
 l45 = length(t45);
 trainState = x45(l45,:)';
 
 % Draw the new location
 set(train.ptr1, 'xdata', trainState(1));
 pause(dt); 
endfor
