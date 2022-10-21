% Script per visualizzare graficamente se l'addestramento è efficace
clc
clear

%load test_sim_10000Ep_v12_G_oldScen.mat
%load test_sim_10000Ep_v1_dist.mat

%load test_sim_10984Ep_vOld_dist.mat

%load test_sim_2375Ep_v13.mat
%load test_sim_3275Ep_v14.mat

%load test_sim_5000Ep_v1_yaw.mat
load test_sim_25000Ep_v2_dist.mat  Ts gridx gridy gridvx gridvy gridyaw M N A passo_v passo_steerang d egoID lby uby lbx ubx lbvx ubvx lbvy ubvy safetyDist leftDistCG retroDistCG frontDistCG ub_angSt lb_angSt

%%
struct1 = load('test_sim_20000Ep_v2_dist.mat','w');  % da qua w2
w1 = struct1.w;


%%%%%% only yaw %%%%%%%
struct2 = load('test_sim_35000Ep_v6_onlyYaw.mat','w');  % da qua w2
w2 = struct2.w;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("BusActors1.mat")
load("BusActors1Actors.mat")
%%
ubyaw = 90;
lbyaw = -90;
safetyDist = 0.3;

%ub_angSt = 1080;
%lb_angSt = -1080;

eps = 0;
% old
%s = [15*rand+5; 5*rand; 0; 0;0]
% new
% [(7 17) (0.2 9.2)]
%s = [2; 2; 0; 0;0]
%s = [20*rand+2; (5*rand+0.2); 0; 0;0]
%s = [18; 2; 0; 0;0] % comportamento strano laterale


% % x_0 = 20*rand+2;
% % if((x_0 <= 13.8) && (x_0 >= 6))
% %     y_0 = -(7*rand+2.2);
% % else
% %     y_0 = -(3*rand+2.2);
% % end
% % s = [x_0;-y_0;0;0;0]

% stato caso normale
x_0 = 2*rand+19;  
y_0 = -(2.5*rand+2.5);
%y_0 = -(4.5);
yaw_0 = 0;
s = [x_0;-y_0;0;0;0]


%%%%%%%%%%%%%%%%%
% stato iniziale only yaw
% yaw_0 = deg2rad(65*rand + 5); % range (-5,-70)  DEVE ESSERE IN RADIANTI
% x_0 = 7*rand+7;  % sist qui
% y_0 = -(0.7*rand+8.5);
% s = [x_0;-y_0;0;0;-yaw_0]

x_0 = s(1);
y_0 = -s(2);
                   % uso w1
a_in = eps_greedy(s, w1, 0, gridx, gridy,gridvx, gridvy, gridyaw, M, N, A);
[az_1,az_2] = ind2sub([3 3], a_in);

% in qst funz switch versione dei modelli -> OLD VERSION onlyDist, onyYaw
% all comp
[st ,r ,output] = simulation2D(w1,gridx,gridy,gridvx,gridvy,gridyaw,M,N,A);

%graphicSimulation2D(st,r);


% cosa salvare su file
% save test_sim.mat w Ts gridx gridy gridvx gridvy gridyaw M N A passo_v passo_steerang d egoID lby uby lbx ubx lbvx ubvx lbvy ubvy safetyDist leftDistCG retroDistCG frontDistCG
