function init_fig(s)
  fig1 = figure('Name','Drone simulation','NumberTitle','off');
  clf; hold on;
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  grid on;
  view(45, 20); 
  axis(s*[-10, 10, -10, 10, -1,10]); axis equal;
endfunction
