clear;

% 0. init
% 1. EDMD part
% 2. EDMD online part
% 3. performance evaluation

%% 0. init
% set path
addpath('./utils/');
addpath('./plot/');
addpath(genpath('./DICTOL/'));

% csc options
lambda             = 1e-4;
opts.max_iter      = 500;
opts.show_progress = 0;
opts.check_grad    = false;  
opts.tol           = 1e-8;  
opts.verbose       = true;

% define constant value
% data length
sample_len = 10;
whole_len = 100;
online_len = 30;
eval_len = whole_len - online_len - sample_len;

% dimension of space
state_dim = 2;
feature_dim = 10;

% define toy data
% original data
X_org = zeros(state_dim, whole_len);
X_org(:, 1) = [1 ; 0];
for iter = 2:whole_len
    [X_org(1, iter), X_org(2, iter)] = ...
        time_evolution_2d(X_org(1, iter-1), X_org(2, iter-1));
end

% sample data
X_smp = X_org(:, 1:sample_len);

% online data
X_online = X_org(:, sample_len+1:whole_len);

% step size of update K
step_size = 0.1;

%% 1. EDMD part
% estimate X with EDMD only
% execute blow steps
% 1. init X_est_edmd
% 2. compute
%    a. Dictionary 'D'
%    b. sparse coefficients 'Y' (feature space)
% 3. DMD on feature space
% 4. reconstruction X form D with D

X_est_edmd = zeros(state_dim, whole_len);
X_est_edmd(:, 1:sample_len) = X_org(:, 1:sample_len);
[D, Y_edmd] = ODL(X_smp, feature_dim, lambda, opts, 'fista');
D_pinv = pinv(D);
[Phi_edmd, eigs_edmd] = dmd(Y_edmd, feature_dim);

b = pinv(Phi_edmd) * Y_edmd(:, sample_len);
for k = sample_len+1:whole_len
    b = eigs_edmd * b;
    X_est_edmd(:, k) = D * Phi_edmd * b;
end

K_0 = Phi_edmd * eigs_edmd * pinv(Phi_edmd);

%% 2. EDMD online
% 1. define data
% 2. iteration
X_est_online = zeros(state_dim, whole_len, online_len);
Y_online = zeros(feature_dim, whole_len); % sample_len + online_len 
Y_online(:, 1:sample_len) = Y_edmd;
K_online = zeros(feature_dim, feature_dim, online_len);

for k = 1:online_len
    X_est_online(:, 1:sample_len, k) = X_smp;
    for l = 1:k
        X_est_online(:, sample_len+l, k) = X_online(:, l);
    end
    Y_online(:, sample_len+k) = D_pinv * X_online(:, k);

    if k == 1
        K_prev = K_0;
    else
        K_prev = K_online(:, :, k-1);
    end

    K_online(:, :, k) = ...
        next_mat_K(Y_online(:, k+1:k+sample_len), K_prev, step_size);
    
    for l = sample_len+k+1:whole_len
        X_est_online(:, l, k) = ...
            D * K_online(:, :, k)^(l - sample_len - k) * Y_online(:, sample_len+k);
    end
end

%% 3. performance evaluation
% figure(1)
% plot error corespoinding online iteration
figure(1);
err_online = error_transition(X_org, X_est_edmd, ...
    X_est_online, sample_len, online_len, whole_len);
semilogy(0:online_len, err_online);