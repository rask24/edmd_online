clear;

%% define constant value
N = 10;															% sampled data length
S = N * 100;													% full data length
M = 1;															% dimension of state space
L = 2;															% demension of feature space

%% define toy data
X_org = zeros(M, S);											% original data of X
X_org(1) = 1;													% initial value of X
for iter = 2:S													% define whole X value with time evolution
	X_org(iter) = time_evolution(X_org(iter-1));
end

X_smp = X_org(:, 1:N);											% define sampled vlaue of X

%% 1. DMD only
% X_est_dmd = zeros(M, S);                                        % estimated value of X with dmd
% X_est_dmd(:, 1) = X_smp(:, 1);                                  % inital value of X_est_dmd is initial vlaue of sampled value of X
% [Phi_dmd, eigs_dmd] = dmd(X_smp, 1);                               % dmd
% b_dmd = pinv(Phi_dmd) * X_est_dmd(:, 1);                        % 
% for iter = 2:S                                                  % determine whole value of estimated X with dmd
%     X_est_dmd(iter) = Phi_dmd * (eigs^iter) * b_dmd;
% end

%% 2. EDMD
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
for iter = 2:100												% determine whole value of Y_edmd
	Y_edmd(:, iter) = Phi_edmd * (eigs_edmd^(iter-1)) * b_edmd;
end

X_est_edmd(:, 1) = X_smp(:, 1);									% inital value of X_est_edmd is initial vlaue of sampled value of X
for iter = 1:S													% mapping to state space from feature space
	X_est_edmd(1, iter) = nonlinear_mapping_inv(Y_edmd(1, iter));
end

%% 3. EDMD online

