clear all;
clf;
close all;

% **** Simulateur du Double Pendule et linÃ©arisation **** %

% ---- Initialisation de la figure ---- %
fig1 = figure('Name','Simulateur','NumberTitle','off'); clf; hold on; axis(4*[-10 10 -10 10],'tic[xyz]','square');
grid('on')
set(gca, 'color', 'k');
temps = title("");

% ---- Initialisation du SytÃ¨me du double Pendule ---- %
[x,th1,th2,etat] = init_system();

% ---- Création de la structure ROBOT ---- %
rob.m0 = 2;
rob.m1 = 2;
rob.m2 = 2;
rob.L1 = 5;
rob.L2 = 5; 
rob.J1 = (rob.m1*(rob.L1)^2)/12;
rob.J2 = (rob.m2*(rob.L2)^2)/12;
rob.m = rob.m1 + rob.m0 + rob.m2;

% ---- Pointeurs pour l'affichage ---- %
rob.ptr1 = plot(x,0,'sy','markersize', 15);
rob.ptr2 = line([x x+rob.L1*cos(th1)],[0 0+rob.L1*sin(th1)],'Color','red');
rob.ptr3 = line([x+rob.L1*cos(th1) x+rob.L1*cos(th1)+rob.L2*cos(th1+th2)],[rob.L1*sin(th1) rob.L1*sin(th1)+rob.L2*sin(th1+th2)],'Color','green');
traj = [x+rob.L1*cos(th1)+rob.L2*cos(th1+th2) rob.L1*sin(th1)+rob.L2*sin(th1+th2)]'; % trajectoire bout du pendule double
traj2 = [x+rob.L1*cos(th1) 0+rob.L1*sin(th1)]';
rob.ptr4 = plot(traj(1), traj(2));%,'markersize', 1,'y');
rob.ptr5 = plot(traj2(1), traj2(2));%,'markersize', 1,'w');

% ---- Variables pour la boucle d'intÃ©gration "Simulation" ---- %
Tmax = 60;
dt = 0.09;
idx = 0;
lim = 25;

% ---- Linéarisation --- %
etat_des = [0 pi/2 0 0 0 0]';
poles=[-5 -5 -5 -1 -.5 -0.52];

% ---- But ---- %
goal.ptr1 = plot(etat_des(1),0,'sg','markersize', 15);
goal.ptr2 = line([etat_des(1) etat_des(1)+rob.L1*cos(etat_des(2))],[0 0+rob.L1*sin(etat_des(2))],'Color','green');
goal.ptr3 = line([etat_des(1)+rob.L1*cos(etat_des(2)) etat_des(1)+rob.L1*cos(etat_des(2))+rob.L2*cos(etat_des(2)+etat_des(3))],[rob.L1*sin(th1) rob.L1*sin(etat_des(2))+rob.L2*sin(etat_des(2)+etat_des(3))],'Color','green');


% boucle Principale du simulateur ---- %
for t=0 : dt : Tmax
  idx = idx + 1;

  % ---- Commande par pseudo-linéarisation ---- %
  commande=linearise(etat,etat_des,rob,poles); % Commande par pseudo linéarisation
%    commande=0;

  value = @(t,etat) model_robot(t, etat, commande, rob);
  [t45, x45] = ode45(value, [0 dt], etat);
  l45 = length(t45);
  etat = x45(l45,:)';

  set(temps, 'string', num2str(t));
  
  % ---- mise à  jour des Pointeurs ---- %
  traj = [traj [etat(1)+rob.L1*cos(etat(2))+rob.L2*cos(etat(2)+etat(3));rob.L1*sin(etat(2))+rob.L2*sin(etat(2)+etat(3))]];
  traj2 = [traj2 [etat(1)+rob.L1*cos(etat(2));rob.L1*sin(etat(2))]];
  if idx > lim
    set(rob.ptr4, 'xdata', traj(1,idx-lim:idx), 'ydata', traj(2,idx-lim:idx));
    set(rob.ptr5, 'xdata', traj2(1,idx-lim:idx), 'ydata', traj2(2,idx-lim:idx));
  else
    set(rob.ptr4, 'xdata', traj(1,:), 'ydata', traj(2,:));
    set(rob.ptr5, 'xdata', traj2(1,:), 'ydata', traj2(2,:));
  end
  set(rob.ptr1,'xdata', etat(1));
  set(rob.ptr2, 'xdata', [etat(1) etat(1)+rob.L1*cos(etat(2))], 'ydata', [0 0+rob.L1*sin(etat(2))]);
  set(rob.ptr3, 'xdata', [etat(1)+rob.L1*cos(etat(2)) etat(1)+rob.L1*cos(etat(2))+rob.L2*cos(etat(2)+etat(3))], 'ydata', [rob.L1*sin(etat(2)) rob.L1*sin(etat(2))+rob.L2*sin(etat(2)+etat(3))]);
  
  drawnow;
end
