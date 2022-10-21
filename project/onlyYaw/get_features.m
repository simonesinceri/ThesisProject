% Dato uno stato(x,y,vx,vy) vogliamo trovare le features
% anche azioni perchè stiamo facendo controllo

function x = get_features(s, a, gridx, gridy, gridvx, gridvy, gridyaw, M, N, A)

% numero celle, +1 perchè ne ho aggiunta una
nCells = (M + 1)^5; % dimensione features per una cella
d = A*N*nCells; % dimensione vettore pesi da aggiornare
x = zeros(d, 1);

for ii = 1 : N
    xxx = gridx(ii, :);
    yyy = gridy(ii, :);
    vxvxvx = gridvx(ii, :);
    vyvyvy = gridvy(ii, :); 
    yawyawyaw = gridyaw(ii, :);
    % capire in quale cella mi trovo, trovo indice lungo x e lungo y
    ix = find(s(1) >= xxx(1:end-1) & s(1) <= xxx(2:end), 1, 'first');
    iy = find(s(2) >= yyy(1:end-1) & s(2) <= yyy(2:end), 1, 'first');
    ivx = find(s(3) >= vxvxvx(1:end-1) & s(3) <= vxvxvx(2:end), 1, 'first');
    ivy = find(s(4) >= vyvyvy(1:end-1) & s(4) <= vyvyvy(2:end), 1, 'first');
    iyaw = find(s(5) >= yawyawyaw(1:end-1) & s(5) <= yawyawyaw(2:end), 1, 'first');

    % a_ind = sub2ind([3 3],a(1),a(2)); non serve gli passo indice poi da
    % indice a azione quando la uso in dinamica
    % dato doppia dim dell'azione devo subind anche a ???

    %ind = sub2ind([M + 1, M + 1, M + 1, M + 1, N, A], ix, iy, ivx, ivy, ii, a);
    ind = sub2ind([M + 1, M + 1, M + 1, M + 1, M + 1, N, A], ix, iy, ivx, ivy, iyaw, ii, a);
    x(ind) = 1; % valore corrispondente alla cella
    % vett features ha un 1 per ogni griglia
end

