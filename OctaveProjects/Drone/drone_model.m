function Xdot_body = drone_model(t, X, com, struct_drone)
  % constant
  g = 9.81;
  
  % unpack state vector
  x = X(1); y = X(2); z = X(3);
  phi = X(4); th = X(5); psi = X(6);
  u = X(7); v = X(8); w = X(9);
  p = X(10); q = X(11); r = X(12);
  
  % unpack control entry
  %com = (com*pi)/30;
  w1 = com(1); w2 = com(2); w3 = com(3); w4 = com(4);
  w1_2 = w1*abs(w1);
  w2_2 = w2*abs(w2);
  w3_2 = w3*abs(w3);
  w4_2 = w4*abs(w4);
  %w_2 = [w1_2 w2_2 w3_2 w4_2]';
  
  % epsilon is the vector of the position and attitude of the Drone
  ksi = [x y z]; % Position
  etha = [phi th psi]; % Attitude
  epsilon = [ksi etha]';
  
  % nu is the velocity vector in the Body frame (Drone coordinate system)
  v_body = [u v w]; % velocity vector (u, v, w)
  w_body = [p q r]; % angular velocity (p, q, r) 
  nu = [v_body w_body]';
  
  % Roation and transformation matrix from the Body frame to Earth coordinate system
  Mat_033 = zeros(3,3);
  R = rot(phi, th , psi);
  
  % Identity matrix
  M_I33 = eye(3,3);
  
  % M_body is the system inertia matrix
  M_body = [struct_drone.m*M_I33 Mat_033;
            Mat_033 struct_drone.I];
            
  % C_body is the coriolis - centripetal effect
  C_body = [cross(w_body',struct_drone.m*v_body');
            cross(w_body',struct_drone.I*w_body')];
  
  % lambda is vector of the generalized forces applied to the drone
  % first component : gravitational vector g_body
  % second : gyroscopic torque vector o_body
  % third : movement vector u_body
  Vec_03 = [0 0 0]';
  fg_b = R' * [0 0 (-struct_drone.m*g)]';
  g_body = [fg_b; Vec_03];
  
  
  W = [w1 w2 w3 w4];
  for k=1:1:4
    Gamma_g = -struct_drone.I*cross(w_body', [0 0 1]')*(-1)^k * W(k);
  endfor
  o_body = [Vec_03; Gamma_g];
    
  % Control vector
  %U = struct_drone.B * w_2;
  U1 = struct_drone.b * (w1_2 + w2_2 + w3_2 + w4_2);
  U2 = struct_drone.b * struct_drone.l*(w4_2 - w2_2);
  U3 = struct_drone.b * struct_drone.l*(w3_2 - w1_2);
  U4 = struct_drone.d * (-w1_2 + w2_2 - w3_2 + w4_2);
  u_body = [0 0 U1 U2 U3 U4]';
  
  lambda = g_body + o_body + u_body;
 
  Xdot_body = [nu;
               pinv(M_body) * (C_body + lambda)];
endfunction
