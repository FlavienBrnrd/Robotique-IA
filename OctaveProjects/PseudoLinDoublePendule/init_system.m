function [x, th1, th2, etat] = init_system ()
  disp("Reset the system\n");
  x = -20; xd = 0.1;
  th1 = pi/2; th1d = 0;
  th2 = 0; th2d = 0;
  etat = [x th1 th2 xd th1d th2d]';
end
