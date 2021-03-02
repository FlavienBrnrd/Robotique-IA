function drone = init_drone(Xini)
  % PHANTOM 3 Standar dimension
  % Lenght between each motors f
  drone.l = 1;
  
  % Mass of the Drone
  drone.m = 10;
  
  % Thrust coefficient
  drone.r = 0.35; % proppeler radius;
  drone.A = pi*(drone.r)^2; % area of the propeller disk
  rho = 1.16; % air density
  drone.CT = 1; % thrust factor
  %drone.b = drone.CT * rho * drone.A * (drone.r)^2;
  drone.b = 2;
  
  % Drag coefficient
  drone.CP = 1; % power factor
  %drone.d = drone.CP * rho * drone.A * (drone.r)^3; 
  drone.d =1;
  
  % Inertia matrix (symmetrical structure)
  Ixx = 10;
  Iyy = Ixx;
  Izz = 20;
  drone.I = [Ixx 0 0;
             0 Iyy 0;
             0 0 Izz;];
  
  % Propeller coefficient Matrix
  drone.B = [drone.b drone.b drone.b drone.b;
             -drone.b*drone.l 0 drone.b*drone.l 0;
             0 -drone.b*drone.l 0 drone.b*drone.l;
             -drone.d drone.d -drone.d drone.d];
  
  M0 = [[drone.l, -drone.l, 0, 0, 0];
       [0, 0, 0, drone.l, -drone.l];
       [0, 0, 0, 0, 0];
       [1, 1, 1, 1, 1]];
       
  % Euler tranformation
  E = rot(Xini(4), Xini(5), Xini(6));
  R = [E,[Xini(1); Xini(2); Xini(3)]; 0 0 0 1];
  M = R * M0;
  
  % draw body
  drone.ptr1 = plot3(M(1,:), M(2,:),M(3,:), 'Color', 'k');
  drone.ptr2 = plot3(M(1,3),M(2,3),M(3,3), 'o', 'Color','m');
  
  % draw scatter for each blades
  drone.ptr3 = plot3(M(1,1),M(2,1),M(3,1), 'o', 'Color','r');
  drone.ptr4 = plot3(M(1,2),M(2,2),M(3,2), 'o', 'Color','g');
  drone.ptr5 = plot3(M(1,4),M(2,4),M(3,4), 'o', 'Color','c');
  drone.ptr6 = plot3(M(1,5),M(2,5),M(3,5), 'o', 'Color','b');

  % draw shadow
  hold on;
  drone.ptr7 = plot3(M(1,:), M(2,:),0*M(3,:), 'LineWidth', 2, 'k');
endfunction
