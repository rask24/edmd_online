%% EDMD only
% timer start
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

% timer stop
edmd_only_execution_time = toc;
disp(edmd_only_execution_time);

% save variable to result
save(SymConfig.RESULT_FILE_PATH);