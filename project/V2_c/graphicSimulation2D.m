function graphicSimulation2D(st,r)

% Carico eventuali dati addestrati,devo prima fare il load
% prima il load dei parametri che servono
% load test_sim.mat

%s = [15*rand+5; 5*rand; 0; 0]
%x_0 = s(1);
%y_0 = s(2);

% Con epsgreedy prende anche az causale -> gli do epsilon = 0
%a_in = eps_greedy(s, w, 0, gridx, gridy,gridvx, gridvy, M, N, A);
%[az_1,az_2] = ind2sub([3 3], a_in);

%output = sim("model_graphicSim.slx");

% Eventuale visualizzione di r,a per vedere come si comporta
%fprintf("r = %f a = %f \n", r, (a_in-2))

%output.reward % printo rewardsS

%fprintf("Fine Episodio \n")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% output.stato -> from simulink model
lenEp = size(st,3);
state = zeros(lenEp,3);
vel = zeros(lenEp,1); % velx e vely mi interesa solo sux o devo calcolare la vel tot
yaw_a = zeros(lenEp,1);
for i=1:lenEp
    app = st(:,:,i);
    %proviamo a invertire la y
    %state(i,1:2) = [app(1) -app(2)];
    state(i,1:2) = [app(1) app(2)];
    vel(i) = app(3);
    %yaw_a(i) = app(5);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% st = output.stato;
% r = output.reward;

close all
parking_Scenario_Sim(state, vel, yaw_a);  % funzione matlab esportata da drivingScenario
% display stato finale
st_final = st(:,:,end)
final_reward = r(end)
end