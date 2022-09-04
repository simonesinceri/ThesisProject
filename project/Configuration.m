% Script configurazione per modello simulink
clc
clear 

% Ts tempo di campionamento dello scenario reader
% lo utilizzo per rate tra le porte
load("BusActors1.mat")
load("BusActors1Actors.mat")

% Parametri CAR presi da scenario

% non ho ben capito se coincidono con quelli del bloccho simulink
% però le mie misure le prendo dallo scenario quindi per collisioni ok
% se coincidono azioni prese saranno leggermente diverse dalla realtà
length_car = 4.7;
width_car = 1.8;
height_car = 1.4;

% Safety dist
safetyDist = 0.5;  % new change
%safetyDist = 0.3;

lateralSft = 1;
frontSft = 1;
retroSft = 1;

% distanze CG da lati veicolo
leftDistCG = 0.9;
retroDistCG = 1;
frontDistCG = 3.7;

% egoID, ID del veiocolo controllato
egoID = 1;

% limiti spaziali ambiente simulazione
%lby = -10; %limSx = 10;
%lby = 0;      % proviamo questa per ovviare altra linea

lby = 2;

uby = 10; %limDx = -10;
lbx = 0; %limUp = 25;       % attenzione qui -> ricontrollare
ubx = 25; %limDown = 0;
% limiti su vx e vy
lbvx = -2;
ubvx = 2;
lbvy = -20; % queste possono anche essere inferiori
ubvy = 20;

%lbyaw = -360;
%ubyaw = 360;
lbyaw = -90;
ubyaw = 90;



Ts = 0.1; % tempo campionamento scenario
numEpisodes = 10000;
epsilon = 1e-1;
alpha = 1e-3;
gamma = 0.9; %1
lambda = 0.8; 


M = 5; % numero celle  
N = 10; % numero griglie  num righe

A = 3*3; % numero azioni [-1,0,1] su vlong e [-1 0 1] su angsterzo
% azione vettore 2*1
passo_v = 0.5;   %0.1 
passo_steerang = 180; %30

% ub_angSt = 1080;
% lb_angSt = -1080;
ub_angSt = 900;
lb_angSt = -900;


nCells = (M + 1)^5;
d = A*N*nCells;

[gridx, gridy, gridvx, gridvy, gridyaw] = construct_tiles(lbx, ubx, lby, uby, lbvx, ubvx, lbvy, ubvy, lbyaw, ubyaw, M, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%w = zeros(d, 1);                                        % attention !!!
load test_sim_10000Ep_v1_dist.mat w
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% devo definire range stato iniziale
% x -> [5 20] y -> [5 0] 
%x_0 = 10;
%y_0 = 5;
v_longitudinal = 0;  % sta roba va portata dentro il for ,tutto stato iniz
v_lateral = 0;
yaw_in = 0;

%Azioni iniziali  , pure questo devo portarlo dentro il for
% [-1, 0, 1]
% sottraggo (-2)
%az_1 = 2;  %x_dot_in = 0;
%az_2 = 2;   %steerang_in = 0;
% 1 1 qui siamo ancora con indici 1 2 3 devo sommare -2 per portare in
% azione vera


%x_in = [x_0;y_0;v_longitudinal;v_lateral];


load_system("Vehicle_dynamics_Radar")
%open_system("Vehicle_dynamics_Radar")

%tic
for i=1:numEpisodes
    % For ET
    z_in = zeros(d,1);

    % stato iniziale random
    %x_0 = 10*rand+7;  
    %y_0 = 9*rand+0.2;
    %s = [10*rand+7; 9*rand; 0; 0;0];
    %x_in = [x_0;y_0;v_longitudinal;v_lateral;yaw_in];

    % devo mettere dei meno dato inversione asse y
%     x_0 = 20*rand+2;
%     if((x_0 <= 13.8) && (x_0 >= 6))
%         y_0 = -(7*rand+2.2);  
%     else
%         y_0 = -(3*rand+2.2);
%     end
    x_0 = 2*rand+19;  
    y_0 = -(3.5*rand+2);
    x_in = [x_0;-y_0;v_longitudinal;v_lateral;yaw_in];
    % azionne iniziale epsgreedy

    % errore qui a_in sempre 1, capiree cme vuole lo stato
    a_in = eps_greedy(x_in, w, epsilon, gridx, gridy, gridvx, gridvy, gridyaw, M, N, A);
    [az_1, az_2] = ind2sub([3 3], a_in);
  

    % simulazione episodio e aggiornamento parametri con modello simulink
    set_param("Vehicle_dynamics_Radar",'FastRestart','on')
    simEp = sim("Vehicle_dynamics_Radar");

%     if(mod(i,10)==0)
%         disp(i)
%     end
    disp(i)
    disp(simEp.rewEp)
    %disp(simEp.stato_s.Data(5))

    % da qua finito episodio
    % w passati su MATLAB con assignin
 end

%toc

save test_sim_20000Ep_v2_dist.mat w Ts lb_angSt ub_angSt gridx gridy gridvx gridvy gridyaw M N A passo_v passo_steerang d egoID lby uby lbx ubx lbvx ubvx lbvy ubvy lbyaw ubyaw safetyDist leftDistCG retroDistCG frontDistCG