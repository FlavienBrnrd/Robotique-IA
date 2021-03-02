function Xdot = drone_model2(t, X, com, struct_drone)
  % constant
  g = 9.81;
  
  % unpack state vector
  x = X(1); y = X(2); z = X(3);
  phi = X(4); th = X(5); psi = X(6);
  u = X(7); v = X(8); w = X(9);
  p = X(10); q = X(11); r = X(12);
  
  
  w1 = com(1); w2 = com(2); w3 = com(3); w4 = com(4);
  W = [w1 w2 w3 w4]';
  w2 = W.*abs(W);

  tau = struct_drone.B * w2
      
  v_r = [u v w]';
  w_r = [p q r]';
  p_dot = rot(phi, th, psi) * v_r
  angle_dot = derivative_euler_rot(phi, th, psi) * w_r;
  v_r_dot = rot(phi, th, psi)'*[0 0 g]' + [0 0 -tau(1)/struct_drone.m]' - cross(w_r, v_r);
  w_r_dot = pinv(struct_drone.I) * ([tau(2) tau(3) tau(4)]' - cross(w_r, (struct_drone.I * w_r)));
  
  Xdot = [p_dot' angle_dot' v_r_dot' w_r_dot'];
endfunction
