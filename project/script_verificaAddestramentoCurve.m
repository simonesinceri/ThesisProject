% Script per visualizzare graficamente se l'addestramento è efficace
clc
clear

%load test_sim_10000Ep_v12_G_oldScen.mat
%load test_sim_10000Ep_v1_dist.mat

%load test_sim_10984Ep_vOld_dist.mat

%load test_sim_2375Ep_v13.mat
%load test_sim_3275Ep_v14.mat

%load circuit_10000_P2.mat
%load circuit_20000_newV.mat
%load pippo600_P3.mat
%%%%%% only yaw %%%%%%%
%load circuit_52000_P3_v3_newReward.mat
%load circuit_newPasso.mat
%load circuit_65000_P3_v3_newReward.mat 
%load circuit_curve_V3_2300.mat
%load circuit_curve_V3_10000.mat
%load circuit_curve_riprova_20000_P1.mat

load prof_curve_V3_500.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("BusActors1.mat")
load("BusActors1Actors.mat")


eps = 0;
%P1
%  x_0 = 22-rand*1.5;
%  y_0 = -(-14);
%  yaw_0 = deg2rad(98);
%P2
x_0 = 5;
y_0 = -(1-2.1*rand);
yaw_0 = deg2rad(15);


s = [x_0;-y_0;0;0;-yaw_0];

%s = [x_0;-y_0;0;0;0]


x_0 = s(1);
y_0 = -s(2);

a_in = eps_greedy(s, w, 0, gridx, gridy,gridvx, gridvy, gridyaw, M, N, A);
[az_1,az_2] = ind2sub([3 3], a_in);

% in qst funz switch versione dei modelli -> OLD VERSION onlyDist, onyYaw
[st ,r ,output] = simulation2D(w,gridx,gridy,gridvx,gridvy,gridyaw,M,N,A);

%graphicSimulation2D(st,r);


% cosa salvare su file
% save test_sim.mat w Ts gridx gridy gridvx gridvy gridyaw M N A passo_v passo_steerang d egoID lby uby lbx ubx lbvx ubvx lbvy ubvy safetyDist leftDistCG retroDistCG frontDistCG
