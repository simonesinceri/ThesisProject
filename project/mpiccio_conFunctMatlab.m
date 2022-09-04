clc
clear
close all

init_position = [10 0 0];
v_init = 5;

for i=1:3

% devo creare copia modello simulink che mi ritorna solo "a"
% simulato per 0.1 sec
% basta che metto un toWorkspace
    [allData, scenario, sensors] = mf_with_trajectory_parking_Scenario(init_position,a,v_init,v_next );

    %%%%%% ATTENZIONE ALL'ID DELL'ATTORE

    %init_position = allData.ActorPoses(); % aggiorno la posizione del mio attore
    % aggiorno anche la velocità

    %plot(scenario)

end

% alternativa simulare modello simulink per un episodio, terminarlo 
% con stop condition e aggiornare tutti i valori così in loop