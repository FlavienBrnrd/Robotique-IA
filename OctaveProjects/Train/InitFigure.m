function InitFigure()
  fig1 = figure('Name','Train','NumberTitle','off');
  clf; hold on;
  xlabel("X[m]");
  ylabel("Y[m]");
  title("Train PID control");
  grid on; 
  axis([-5, 5, 0, 5]); axis equal;
endfunction
