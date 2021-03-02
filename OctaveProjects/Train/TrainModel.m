function Xdot = TrainModel(t, X, u, struct_rob)
  g = 9.81;
  % Unpack State X
  v = X(2);
  
  Xdot = [v;
          (-g + (u/struct_rob.m))];
endfunction
