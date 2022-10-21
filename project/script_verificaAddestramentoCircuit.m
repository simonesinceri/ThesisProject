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
load circuit_65000_P3_v3_newReward.mat 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("BusActors1.mat")
load("BusActors1Actors.mat")


eps = 0;
% x_0 = -10; 
% y_0 = -(-29 - rand*6);
% yaw_0 = deg2rad(13);
%P2
%x_0 = -20.5 - rand*7;  
%y_0 = -(-30);
%yaw_0 = deg2rad(35);
%P3
x_0 = -30;
y_0 = -(-20 - rand*6);
yaw_0 = deg2rad(34);

%P4
% y_0 = 0;
% x_0 = -39.5 - rand*6.5;
% yaw_0 = deg2rad(90);

%P5
%x_0 = -30;
%y_0 = -(20+rand*7);
%yaw_0 = deg2rad(145);


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
