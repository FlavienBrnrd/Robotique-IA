function [etatdot] = model_robot (t,etat,commande,param_rob)
  gravite = -9.81; k_f = 0.1; k_char = 1;
  q = [etat(1);etat(2);etat(3)];
  dq = [etat(4);etat(5);etat(6)];
  c1 = cos(etat(2)); s1 =sin(etat(2)); s2 =sin(etat(3)); c2 = cos(etat(3));
  c12 = cos(etat(2)+etat(3)); s12 = sin(etat(2)+etat(3));
  M1 = param_rob.m1; M = param_rob.m; M2 = param_rob.m2;
  I1 = param_rob.J1; I2 = param_rob.J2;
  l1 = param_rob.L1; l2 = param_rob.L2;
  
  Z = zeros(3);
  Z(1,1) = M/2;
  Z(1,2) = ((-(M1*l1)/2)-M2*l1)*s1-(M2*l2*s12)/2;
  Z(1,3) = (-M2*l2*s12)/2; 
  Z(2,2) = (((l1^2)*(M1+M2)+4*(I1+I2))/8)+(M2/2)*((l1^2)+((l2^2)/4)+c2*l1*l2+(I2/2));
  Z(2,3) = (M2/2)*((l2^2)/2)+l1*l2*c2+I2;
  Z(3,3) = M2*(((l2^2)/8)+(I2/4));
 
  dZ_dx = zeros(3);
  
  dZ_dth1 = zeros(3);
  dZ_dth1(1,2) = ((-(M1*l1)/2)-M2*l1)*c1-(M2*l2*c12)/2;
  dZ_dth1(1,3) = (-M2*l2*c12)/2;  
  
  dZ_dth2 = zeros(3);
  dZ_dth2(1,2) = -(M2*l2*c12)/2;
  dZ_dth2(1,3) = -(M2*l2*c12)/2;
  dZ_dth2(2,2) = -(M2*l1*l2*s2)/2;
  dZ_dth2(2,3) = -(M2*l1*l2*s2)/2;
  
  U = ((M1/2)+M2)*gravite*l1*s1 + M2*gravite*(l2/2)*s12;
  dU_dq = zeros(3,1);
  dU_dq(2,1) = (((M1/2)+M2)*gravite*l1*c1)+M2*gravite*(l2/2)*c12;
  dU_dq(3,1) = M2*gravite*(l2/2)*c12;
  
  dZ_dt = zeros(3);
  dZ_dt(1,2) = ((-(M1*l1)/2)-M2*l1)*c1*etat(5)-(etat(5)+etat(6))*(M2*l2*c12)/2;
  dZ_dt(1,3) = (etat(5)+etat(6))*(-M2*l2*c12)/2;
  dZ_dt(2,2) = -(M2*l1*l2*s2*etat(6))/2;
  dZ_dt(2,3) = -(M2*l1*l2*s2*etat(6))/2;

  M = Z + Z';
  dM_dt = dZ_dt + dZ_dt';
  
  dL_dx = dq'*dZ_dx*dq+dU_dq(1,1);
  dL_dth1 = dq'*dZ_dth1*dq+dU_dq(2,1);
  dL_dth2 = dq'*dZ_dth2*dq+dU_dq(3,1);
  
  C = zeros(3,1);
  C(1,1) = ([1 0 0]*dM_dt*dq)-dL_dx;
  C(2,1) = ([0 1 0]*dM_dt*dq)-dL_dth1;
  C(3,1) = ([0 0 1]*dM_dt*dq)-dL_dth2;
  
  Q = zeros(3,1);
  Q(1) = - k_char * etat(4);
  Q(2) = - k_f * etat(5);
  Q(3) = - k_f * etat(6);
  
  etatdot(1:3) = dq;
  etatdot(4:6) = inv(M) * (Q - C);
endfunction
