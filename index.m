clear;

%% init
addpath('./utils/');
addpath(genpath('./DICTOL/'));

% options
opts.max_iter      = 500;
opts.show_progress = 0;
opts.check_grad    = false;  
opts.tol           = 1e-8;  
opts.verbose       = true;

lambda = 0.001;

%% define constant value
sample_len = 10;
whole_len = 100;
dim_state = 2;
dim_feature = 10;

% original data
X_org = zeros(dim_state, whole_len);
X_org(:, 1) = [1 ; 0];
for iter = 2:whole_len
    [X_org(1, iter), X_org(2, iter)] = time_evolution_2d(X_org(1, iter-1), X_org(2, iter-1));
end

% dictionary and sparse 
[D, Y] = ODL(X_org, dim_feature, lambda, opts, 'fista');
recont = D * Y;