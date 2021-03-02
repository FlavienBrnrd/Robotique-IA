function d_mat_rot = derivative_euler_rot(phi, th, psi)
  d_mat_rot = [1 tan(th)*sin(phi) tan(th)*cos(phi);
               0 cos(phi) -sin(phi);
               0 (sin(phi)/cos(th)) (cos(phi)/cos(th))];
endfunction
