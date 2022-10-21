% Funzione che mi restituisce l'azione epsgreedy da scegliere

function a = eps_greedy(s, w, eps, gridx, gridy, gridvx, gridvy, gridyaw, M, N, A)

if rand < eps   % azione random
    a = randi(A); % da 1 a 9 se uso indice
else
    q = zeros(A, 1);
    for a = 1:A  % valuto tutte le azioni che posso prendere
        q(a) = w'*get_features(s, a, gridx, gridy, gridvx, gridvy, gridyaw, M, N, A); % approsimazione della funz qualità
    end        % pesi per vett features
    a = find(q == max(q), 1, 'first'); % scelgo quella con funz qualità massima
end