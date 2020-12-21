clear all;
clf;
close all;

% **** Simulateur du Double Pendule et linéarisation **** %

% ---- Initialisation de la figure ---- %
fig1 = figure('Name','Simulateur','NumberTitle','off'); clf; hold on; axis([-10 10 -10 10]);
set(gca, 'color', 'k');
temps = title("");

% ---- Initialisation du Sytème du double Pendule ---- %
[x,th1,th2,etat] = init_system()

% ---- Création de la structure ROBOT ---- %
rob.m0 = 2;
rob.m1 = 2;
rob.m2 = 2;
rob.L1 = 4;
rob.L2 = 4; 
rob.J1 = (rob.m1*(rob.L1)^2)/12;
rob.J2 = (rob.m2*(rob.L2)^2)/12;
rob.m = rob.m1 + rob.m0 +rob.m2;

% ---- Pointeurs pour l'affichage ---- %
rob.ptr1 = plot(x,0,'sy','markersize', 15);
rob.ptr2 = line([x x+rob.L1*cos(th1)],[0 0+rob.L1*sin(th1)],'Color','red');
rob.ptr3 = line([x+rob.L1*cos(th1) x+rob.L1*cos(th1)+rob.L2*cos(th1+th2)],[rob.L1*sin(th1) rob.L1*sin(th1)+rob.L2*sin(th1+th2)],'Color','green');
traj = [x+rob.L1*cos(th1)+rob.L2*cos(th1+th2) rob.L1*sin(th1)+rob.L2*sin(th1+th2)]'; % trajectoire bout du pendule double
traj2 = [x+rob.L1*cos(th1) 0+rob.L1*sin(th1)]';
rob.ptr4 = plot(traj(1), traj(2),'LineWidth', 1,'y');
rob.ptr5 = plot(traj2(1), traj2(2),'LineWidth', 1,'w');

% ---- Variables pour la boucle d'intégration "Simulation" ---- %
Tmax = 10;
dt = 0.1;
idx = 0;
lim = 200;

% ---- Linéarisation --- %
etat_des = [0 pi/2 0]';

% boucle Principale du simulateur ---- %
for t=0 : dt : Tmax
  idx = idx + 1;

  % ---- Commande par pseudo-linéarisation ---- %
  commande = pi/2;
  
  
  value = @(t,etat) model_robot(t, etat, commande, rob);
  [t45, x45] = ode45(value, [0 dt], etat);
  l45 = length(t45);
  etat = x45(l45,:)';

  % set(temps, "string", num2str(t));
  
  % ---- mise à jour des Pointeurs ---- %

  traj = [traj [etat(1)+rob.L1*cos(etat(2))+rob.L2*cos(etat(2)+etat(3));rob.L1*sin(etat(2))+rob.L2*sin(etat(2)+etat(3))]];
  traj2 = [traj2 [etat(1)+rob.L1*cos(etat(2));rob.L1*sin(etat(2))]];
  if idx > lim
    set(rob.ptr4, 'xdata', traj(1,idx-lim:idx), 'ydata', traj(2,idx-lim:idx));
    set(rob.ptr5, 'xdata', traj2(1,idx-lim:idx), 'ydata', traj2(2,idx-lim:idx));
  else
    set(rob.ptr4, 'xdata', traj(1,:), 'ydata', traj(2,:));
    set(rob.ptr5, 'xdata', traj2(1,:), 'ydata', traj2(2,:));
  endif
  set(rob.ptr1,'xdata', etat(1));
  set(rob.ptr2, 'xdata', [etat(1) etat(1)+rob.L1*cos(etat(2))], 'ydata', [0 0+rob.L1*sin(etat(2))]);
  set(rob.ptr3, 'xdata', [etat(1)+rob.L1*cos(etat(2)) etat(1)+rob.L1*cos(etat(2))+rob.L2*cos(etat(2)+etat(3))], 'ydata', [rob.L1*sin(etat(2)) rob.L1*sin(etat(2))+rob.L2*sin(etat(2)+etat(3))]);
  
  drawnow;
endfor
