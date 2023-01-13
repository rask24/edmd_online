clear;

% 0. init
% 1. EDMD for online part
% 2. EDMD online part
% 3. EDMD only part

%% 0. init
% warning off
warning('off', 'all');

% set path
addpath('./util_edmd_online/');
addpath('./time_evolution/');
addpath('./util_plot/');
addpath(genpath('./DICTOL/'));

% define toy data
if exist(SymConfig.ORIGINAL_DATA_PATH, 'file') == 2
    load(SymConfig.ORIGINAL_DATA_PATH);
else
    X_org = create_toy_data();
    save(SymConfig.ORIGINAL_DATA_PATH, 'X_org');
end

% sample data
X_smp = X_org(:, 1:SymConfig.SAMPLE_LEN);
% online data
X_online = X_org(:, SymConfig.SAMPLE_LEN+1:SymConfig.WHOLE_LEN);

%% 1. EDMD for online part
% estimate X with EDMD only
% execute blow steps
% 1. init X_est_edmd
% 2. compute
%    a. Dictionary 'D'
%    b. sparse coefficients 'Y' (feature space)
% 3. DMD on feature space
% 4. reconstruction X form D with D

% timer start
tic

X_est_edmd = zeros(SymConfig.STATE_DIM, SymConfig.WHOLE_LEN);
X_est_edmd(:, 1:SymConfig.SAMPLE_LEN) = X_org(:, 1:SymConfig.SAMPLE_LEN);
[D, Y_edmd] = ODL(X_smp, SymConfig.FEATURE_DIM, SymConfig.LAMBDA, SymConfig.CSC_OPTS, 'fista');
D_pinv = pinv(D);
[Phi_edmd, eigs_edmd] = dmd(Y_edmd, SymConfig.FEATURE_DIM);

b = pinv(Phi_edmd) * Y_edmd(:, SymConfig.SAMPLE_LEN);
for k = SymConfig.SAMPLE_LEN+1:SymConfig.WHOLE_LEN
    b = eigs_edmd * b;
    X_est_edmd(:, k) = D * Phi_edmd * b;
end

K_0 = Phi_edmd * eigs_edmd * pinv(Phi_edmd);
K_0 = real(K_0);

% complex to double
X_est_edmd = real(X_est_edmd);

%% 2. EDMD online
% 1. define data variable
% 2. EDMD online -> update K
X_est_online = zeros(SymConfig.STATE_DIM, SymConfig.WHOLE_LEN, SymConfig.ONLINE_LEN);
Y_online = zeros(SymConfig.FEATURE_DIM, SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN); 
Y_online(:, 1:SymConfig.SAMPLE_LEN) = Y_edmd;
K_online = zeros(SymConfig.FEATURE_DIM, SymConfig.FEATURE_DIM, SymConfig.ONLINE_LEN);

K_prev = K_0;
for k = 1:SymConfig.ONLINE_LEN
    X_est_online(:, 1:SymConfig.SAMPLE_LEN, k) = X_smp;
    for l = 1:k
        X_est_online(:, SymConfig.SAMPLE_LEN+l, k) = X_online(:, l);
    end
    Y_online(:, SymConfig.SAMPLE_LEN+k) = D_pinv * X_online(:, k);

    window_range = SymConfig.SAMPLE_LEN+k-SymConfig.WINDOW_LEN+1:SymConfig.SAMPLE_LEN+k;
    K_online(:, :, k) = ...
        next_mat_K(Y_online(:, window_range), K_prev, SymConfig.STEP_SIZE);
    
    for l = SymConfig.SAMPLE_LEN+k+1:SymConfig.WHOLE_LEN
        X_est_online(:, l, k) = ...
            D * K_online(:, :, k)^(l - SymConfig.SAMPLE_LEN - k) * Y_online(:, SymConfig.SAMPLE_LEN+k);
    end
    % complex to double
    X_est_online(:, :, k) = real(X_est_online(:, :, k));

    K_prev = K_online(:, :, k);
end

% timer stop
edmd_online_execution_time = toc;
disp(edmd_online_execution_time);

%% EDMD only
tic
X_est_edmd_only = zeros(SymConfig.STATE_DIM, SymConfig.WHOLE_LEN);
X_est_edmd_only(:, 1:SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN) = X_org(:, 1:SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN);
[D_edmd_only, Y_edmd_only] = ODL(X_est_edmd_only(:, 1:SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN), ...
    SymConfig.FEATURE_DIM, SymConfig.LAMBDA, SymConfig.CSC_OPTS, 'fista');
[Phi_edmd_only, eigs_edmd_only] = dmd(Y_edmd_only, SymConfig.FEATURE_DIM);

b_edmd_only = pinv(Phi_edmd_only) * Y_edmd_only(:, SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN);
for k = SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN+1:SymConfig.WHOLE_LEN
    b_edmd_only = eigs_edmd_only * b_edmd_only;
    X_est_edmd_only(:, k) = D_edmd_only * Phi_edmd_only * b_edmd_only;
end

% complex to double
X_est_edmd_only = real(X_est_edmd_only);

edmd_only_execution_time = toc;
disp(edmd_only_execution_time);

save(SymConfig.RESULT_FILE_PATH);