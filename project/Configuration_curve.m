% Script configurazione per modello simulink
clc
%clear 

% Ts tempo di campionamento dello scenario reader
% lo utilizzo per rate tra le porte
load("BusActors1.mat")
load("BusActors1Actors.mat")

% Parametri CAR presi da scenario
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limiti per circuit
lby = -36;
uby = 6; 
lbx = -8;        
ubx = 25; 
% limiti su vx e vy
lbvx = 0;
ubvx = 25;
lbvy = -20; % queste possono anche essere inferiori
ubvy = 20;

lbyaw = -360;
ubyaw = 360;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% definiamo il TRAGUARDO
% x = 10 /20   Compreso in qst intervallo è terminale
% y = -28.8/-38.8
% mi basta bucarlo e terminare, attenzione agli stati
% che potrebbero influire
 
% stati iniz -> primo step  x = -10 y = -28/-35
% yaw_0 = -13;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ts = 0.1; % tempo campionamento scenario
Ts = 0.1;
numEpisodes = 10000;
epsilon = 1e-1;
alpha = 1e-3;
gamma = 0.9; %1
lambda = 0.8; 

% 5 10
M = 5; % numero celle  
N = 10; % numero griglie  num righe

A = 3*3; % numero azioni [-1,0,1] su vlong e [-1 0 1] su angsterzo
% azione vettore 2*1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
passo_v = 0.5;
%passo_v = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%passo_steerang = 180;  % vediamo come si comporta questo
passo_steerang = 90;

ub_angSt = 1260;
lb_angSt = -1260;



nCells = (M + 1)^5;
d = A*N*nCells;

[gridx, gridy, gridvx, gridvy, gridyaw] = construct_tiles(lbx, ubx, lby, uby, lbvx, ubvx, lbvy, ubvy, lbyaw, ubyaw, M, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%w = zeros(d, 1);                                        % attention !!!
%load circuit_curve_V3_2300.mat w
%load circuit_curve_v3_10000.mat w
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

v_longitudinal = 0;  % sta roba va portata dentro il for ,tutto stato iniz
v_lateral = 0;

%P1
%yaw_0 = deg2rad(98); % DEVE ESSERE IN RADIANTI
%P2
yaw_0 = deg2rad(15);


load_system("Vehicle_dynamics_Curve")
%open_system("Vehicle_dynamics_Radar")

%tic
for i=1:numEpisodes
    % For ET
    z_in = zeros(d,1);

    % stati inziali, cambiano dopo tot episodi, anche yaw
    % P1
    %x_0 = 22-rand*1.5;  
    %y_0 = -(-14);
    %P2
    
    x_0 = 5;  
    y_0 = -(1-2.1*rand);

    %P3
%      x_0 = -3;
%      y_0 = -(-20 - rand*6);

    %P4
%     y_0 = 0;
%     x_0= -39.5 - rand*6.5;
    

    %P5
%     x_0 = -30;
%     y_0 = -(20+rand*7);

    x_in = [x_0;-y_0;v_longitudinal;v_lateral;-yaw_0];
    
    % azionne iniziale epsgreedy
    a_in = eps_greedy(x_in, w, epsilon, gridx, gridy, gridvx, gridvy, gridyaw, M, N, A);
    [az_1, az_2] = ind2sub([3 3], a_in);
  

    % simulazione episodio e aggiornamento parametri con modello simulink
    set_param("Vehicle_dynamics_Curve",'FastRestart','on')
    simEp = sim("Vehicle_dynamics_Curve");

%     if(mod(i,10)==0)
%         disp(i)
%     end
    disp(simEp.rewEp)
    disp(i)

 end

%toc

% nuovo save P5
save circuit_curve_V3_30000_P2.mat w Ts lb_angSt ub_angSt gridx gridy gridvx gridvy gridyaw M N A passo_v passo_steerang d egoID lby uby lbx ubx lbvx ubvx lbvy ubvy safetyDist leftDistCG retroDistCG frontDistCG ub_angSt lb_angSt