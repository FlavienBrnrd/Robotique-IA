function u = PID(error)
  Kp = 300;
  Ki = 0.1;
  Kd = 20;
  u = Kp*error(1) + Kd*error(2);
endfunction
