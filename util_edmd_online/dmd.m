function [Phi, lambda] = dmd(big_X, r)
    % function [Phi,omega,lambda,b,Xdmd] = DMD(X1,X2,r,dt)
    % Computes the Dynamic Mode Decomposition of X1, X2
    %
    % INPUTS: 
    % X1 = X, data matrix
    % X2 = X', shifted data matrix
    % Columns of X1 and X2 are state snapshots 
    % r = target rank of SVD
    % dt = time step advancing X1 to X2 (X to X')
    %
    % OUTPUTS:
    % Phi, the DMD modes
    % omega, the continuous-time DMD eigenvalues
    % lambda, the discrete-time DMD eigenvalues
    % b, a vector of magnitudes of modes Phi
    % Xdmd, the data matrix reconstrcted by Phi, omega, b

    %% DMD
    [~, col_size] = size(big_X);
    X1 = big_X(:, 1:col_size-1);
    X2 = big_X(:, 2:col_size);

    [U, S, V] = svd(X1, 'econ');
    r = min(r, size(U,2));

    U_r = U(:, 1:r); % truncate to rank-r
    S_r = S(1:r, 1:r);
    V_r = V(:, 1:r);
    Atilde = U_r' * X2 * V_r / S_r; % low-rank dynamics
    [W_r, D] = eig(Atilde);
    Phi = X2 * V_r / S_r * W_r; % DMD modes
    lambda = D; % discrete-time eigenvalues
end