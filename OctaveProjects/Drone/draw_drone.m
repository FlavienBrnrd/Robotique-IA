function draw_drone(X, struct_drone)
  
  M0 = [[struct_drone.l, -struct_drone.l, 0, 0, 0];
       [0, 0, 0, struct_drone.l, -struct_drone.l];
       [0, 0, 0, 0, 0];
       [1, 1, 1, 1, 1]];
       
  % Euler tranformation
  E = rot(X(4), X(5), X(6));
  R = [E,[X(1);X(2);X(3)]; 0 0 0 1];
  M = R * M0;
  
  % draw body
  set(struct_drone.ptr1, 'xdata', M(1,:), 'ydata', M(2,:), 'zdata', M(3,:));
  set(struct_drone.ptr2, 'xdata', M(1,3), 'ydata', M(2,3), 'zdata', M(3,3));
  
  % draw blades
  set(struct_drone.ptr3, 'xdata', M(1,1), 'ydata', M(2,1), 'zdata', M(3,1));
  set(struct_drone.ptr4, 'xdata', M(1,2), 'ydata', M(2,2), 'zdata', M(3,2));
  set(struct_drone.ptr5, 'xdata', M(1,4), 'ydata', M(2,4), 'zdata', M(3,4));
  set(struct_drone.ptr6, 'xdata', M(1,5), 'ydata', M(2,5), 'zdata', M(3,5));

  % draw shadow
  set(struct_drone.ptr7, 'xdata', M(1,:), 'ydata', M(2,:), 'zdata', 0*M(3,:));
   
endfunction
