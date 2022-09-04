function [st ,r ,output] = simulation2D(w,gridx,gridy,gridvx,gridvy,gridyaw,M,N,A)

% Carico eventuali dati addestrati,devo prima fare il load
% prima il load dei parametri che servono
% load test_sim.mat

%s = [15*rand+5; 5*rand; 0; 0]
%x_0 = s(1);
%y_0 = s(2);

% Con epsgreedy prende anche az causale -> gli do epsilon = 0
%a_in = eps_greedy(s, w, 0, gridx, gridy,gridvx, gridvy, M, N, A);
%[az_1,az_2] = ind2sub([3 3], a_in);

output = sim("model_graphicSim.slx");
%output = sim("model_graphicSim_OnlyDist.slx");

st = output.stato;
r = output.reward;
% Eventuale visualizzione di r,a per vedere come si comporta
%fprintf("r = %f a = %f \n", r, (a_in-2))

%output.reward % printo rewardsS

fprintf("Fine Episodio \n")
end