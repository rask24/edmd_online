clear;

%% init
addpath("./utils/")

%% define constant value
N = 10;															% sampled data length
S = 1000;														% full data length
M = 1;															% dimension of state space
L = 2;															% demension of feature space
online_len = 100;												% size of X_online
eval_len = S - online_len;

%% define toy data
X_org = zeros(M, S);											% original data of X
X_org(1) = 1;													% initial value of X
for iter = 2:S													% define whole X value with time evolution
	X_org(iter) = time_evolution(X_org(iter-1));
end

X_smp = X_org(:, 1:N);											% define sampled vlaue of X
X_online = X_org(:, N+1:S);										% define sampled vlaue of X for online

%% 1. EDMD part
X_est_edmd = zeros(M, S);										% estimated value of X with edmd
Y_edmd = zeros(L, S);											% define datesets of feature space
Y_edmd_smp = zeros(L, N);										% define sampled datasets of feature space for dmd
for iter = 1:N													% mapping to feature space from state space
	[Y_edmd_smp(1, iter), Y_edmd_smp(2, iter)] ...
		= nonlinear_mapping(X_smp(1, iter));
end

[Phi_edmd, eigs_edmd] = dmd(Y_edmd_smp);						% dmd
Y_edmd(:, 1) = Y_edmd_smp(:, 1);								% initialize Y_edmd with sampled data
b_edmd = pinv(Phi_edmd) * Y_edmd(:, 1);							% for computing
for iter = 2:S												% determine whole value of Y_edmd
	Y_edmd(:, iter) = Phi_edmd * (eigs_edmd^(iter-1)) * b_edmd;
end

K_0 = Phi_edmd * eigs_edmd * pinv(Phi_edmd);

X_est_edmd(:, 1) = X_smp(:, 1);									% inital value of X_est_edmd is initial vlaue of sampled value of X
for iter = 1:S													% mapping to state space from feature space
	X_est_edmd(1, iter) = nonlinear_mapping_inv(Y_edmd(1, iter));
end

%% 2. EDMD online part
X_est_online = zeros(M, S, online_len);							% estimated value of X, M times S matrix with S-N sheets
Y_online = zeros(L, S);
Y_online(:, 1:N) = Y_edmd_smp;
K_online = zeros(L, L, online_len);
step_size = 1;

for iter = 1:online_len
	X_est_online(:, 1:N, iter) = X_smp(:, :);
	for sub_iter = 1:iter
		X_est_online(:, N+sub_iter, iter) = X_online(:, sub_iter);
	end
	[Y_online(1, N+iter), Y_online(2, N+iter)] = ...
		nonlinear_mapping(X_online(:, iter));
	
	if iter == 1
		K_prev = K_0;
	else
		K_prev = K_online(:, :, iter - 1);
	end
	K_online(:, :, iter) = ...
		next_mat_K(Y_online(:, iter+1:N+iter), K_0, step_size);
	
	for sub_iter = N+iter+1:S
		tmp = K_online(:, :, iter)^(sub_iter - N - iter) * Y_online(:, N+iter);
		X_est_online(1, sub_iter, iter) = nonlinear_mapping_inv(tmp(1, 1));
	end
end

% start
% K_new = next_mat_K(Y_online(:, 2:N+1), K_0, 0.1);
% end

% for iter = N+2:S
% 	tmp = zeros(L, 1);
% 	tmp(:, 1) = K_o^(iter - N - 1) * Y_online(:, N+1);
% 	X_est_online(1, iter, 1) = nonlinear_mapping_inv(tmp(1, 1));
% end

%% plot error
figure(1);
err_0 = zeros(1, S);
for iter = 1:S
	err_0(1, iter) = abs(X_org(1, iter) - X_est_edmd(1, iter));
end
semilogy(1:S, err_0, 'DisplayName', 'K_0');
hold on;
for iter = 1:10:online_len
	err_tmp = zeros(1, S);
	for sub_iter = 1:S
		err_tmp(1, sub_iter) = (X_org(1, sub_iter) - X_est_online(1, sub_iter, iter))^2;
	end
	semilogy(1:S, err_tmp, 'DisplayName', join(['K_{', num2str(iter), '}']));
end
lgd = legend;
lgd.NumColumns = 2;
hold off;

figure(2);
err_online = zeros(1, online_len+1);
eval_start = S - eval_len;
for iter = eval_start:S
	err_online(1, 1) = err_online(1, 1) + (X_org(1, iter) - X_est_edmd(1, iter))^2;
end
for iter = 1:online_len
	for sub_iter = eval_start:S
		err_online(1, iter+1) = err_online(1, iter+1) + (X_org(1, sub_iter) - X_est_online(1, sub_iter, iter))^2;
	end
end
semilogy(0:online_len, err_online);