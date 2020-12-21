function [x, th1, th2, etat] = init_system ()
  printf("Reset the system\n");
  x = 0, xd = 0
  th1 = pi/4, th1d = 0
  th2 = 0, th2d = 0
  etat = [x th1 th2 xd th1d th2d]
endfunction
