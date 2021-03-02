function Xdot = WaterTankModel(t, X, u)
  % Unpack the State X
  waterVolume = X;
  
  % Water density is constant
  rho = 1000;
  
  Xdot = (waterVolume/rho) + u;
  
endfunction
