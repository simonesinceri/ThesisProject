% Costruisce la grigliatura
% grigliatura uniforme divido upper e lower bound in modo da avere 
% numero celle di uguale dimensione, devo agg ulteriore cella per poter
% fare spostamenti

function [gridx, gridy, gridvx, gridvy, gridyaw] = construct_tiles(lbx, ubx, lby, uby, lbvx, ubvx,lbvy, ubvy, lbyaw, ubyaw, M, N)

off = [1; 3; 5 ; 7; 9]; % offset 1 in una direzioe 3 nell'altra
off = off./max(off); % devo normalizzare qst offset in modo che le mie
% griglie non escono dalla regione operativa
% un po starborda dato l'offset ma non mi interessa

dx = (ubx - lbx)/M; % qnt posso muovermi al massimo
TX = lbx - dx:dx:ubx; % Tiles su x, parto un dx prima
% aggiungo così una cella a SX in modo che dopo potrò fare l'offset di
% quanto mi serve, faccio lo stesso su y(ovvero la velocità)

dy = (uby - lby)/M; 
TY = lby - dy:dy:uby;

dvx = (ubvx - lbvx)/M; 
TVX = lbvx - dvx:dvx:ubvx;

dvy = (ubvy - lbvy)/M; 
TVY = lbvy - dvy:dvy:ubvy;

dyaw = (ubyaw - lbyaw)/M; 
TYAW = lbyaw - dyaw:dyaw:ubyaw;

% costruisco le griglie lungo x e lungo y(velocità)
gridx = zeros(N, length(TX)); % tante righe quante le griglie da generare
gridy = zeros(N, length(TY));
gridvx= zeros(N, length(TVX));
gridvy = zeros(N, length(TVY));
gridyaw = zeros(N, length(TYAW));


% prima riga già costruita pari a TX
gridx(1, :) = TX;
gridy(1, :) = TY;
gridvx(1, :) = TVX;
gridvy(1, :) = TVY;
gridyaw(1, :) = TYAW;

% succesive righe da offsettare di una piccola quantità
for ii = 2 : N
    gridx(ii, :) = TX + off(1)*dx/N*(ii-1); % diviso num celle N ->sposto ogni griglia di un po
    gridy(ii, :) = TY + off(2)*dy/N*(ii-1);
    gridvx(ii, :) = TVX + off(3)*dvx/N*(ii-1); % (ii-1) per non avere pezzi inutili fuori
    gridvy(ii, :) = TVY + off(4)*dvy/N*(ii-1);
    gridyaw(ii, :) = TYAW + off(5)*dyaw/N*(ii-1);
end