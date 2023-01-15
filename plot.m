if exist(SymConfig.RESULT_FILE_PATH, 'file') == 2
    load(SymConfig.RESULT_FILE_PATH);
else
    disp(strcat(SymConfig.RESULT_FILE_PATH, ' does not exist.'));
    disp('please execute main.m before executing plot.m');
end

% plot error corespoinding online iteration
err_online = error_transition(X_org, X_est_edmd, ...
    X_est_online, SymConfig.SAMPLE_LEN, SymConfig.ONLINE_LEN, SymConfig.WHOLE_LEN);
transition_plot_range = SymConfig.SAMPLE_LEN-1:SymConfig.SAMPLE_LEN+SymConfig.ONLINE_LEN-1;
figure(1);
semilogy(transition_plot_range, err_online, '-o');
xlabel('index of K');
ylabel('RMSE');

% plot trajectory
figure(2);
hold on;
scatter(X_org(1, :), X_org(2, :), 'o');
scatter(X_est_edmd_only(1, :), X_est_edmd_only(2, :), 'x');
scatter(X_est_online(1, :, SymConfig.ONLINE_LEN), X_est_online(2, :, SymConfig.ONLINE_LEN), '+');
legend('Toy data', 'EDMD', 'EDMD online')
xlabel('x_1');
ylabel('x_2');

% calculate rmse EDMD online vs EDMD only
disp('EDMD');
disp(rmse(X_org(:, SymConfig.EVAL_RANGE), X_est_edmd_only(:, SymConfig.EVAL_RANGE)));
disp('');
disp('EDMD online');
disp(err_online(1, SymConfig.ONLINE_LEN+1));