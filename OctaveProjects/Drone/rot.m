function mat_rot = rot(phi, th, psi)
  rot_x = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
  rot_y = [cos(th) 0 sin(th); 0 1 0; -sin(th) 0 cos(th)];
  rot_z = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
  mat_rot = rot_z * rot_y * rot_x;
endfunction
