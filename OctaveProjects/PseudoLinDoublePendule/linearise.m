function [ commande ] = linearise( etat, xbar, param_rob,poles)
  gravite = -9.81; k_f = 0.1; k_char = 10;
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

  M = Z + Z';
 
  A=zeros(6);
  B=zeros(6,1);
  A(1,4)=1;
  A(2,5)=1;
  A(3,6)=1;
  A(4:6,:) = inv(M)*[0 0 0 -k_char 0 0; 0 -(M1/2 + M2)*gravite*l1-(M2*gravite*l2/2) -(M2*gravite*l2/2) 0 -k_f 0; 0 -(M2*gravite*l2/2) -(M2*gravite*l2/2) 0 0 -k_f];
  B(4:6) = inv(M)*[1;0;0];
  
  R = place(A,B,poles)
  erreur_etat=etat-xbar;
  commande= -R*erreur_etat
  
end

