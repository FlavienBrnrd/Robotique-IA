function InitFigure()
  fig1 = figure('Name','Water tank','NumberTitle','off');
  clf; hold on;
  ylabel (sprintf ("Water volume", 1, 3));
  title (sprintf ("Water tank volume traking", 1, 3));
  grid on; 
  axis([0, 5, 0, 10]); axis equal;
endfunction
