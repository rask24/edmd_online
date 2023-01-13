clear;

addpath('./util_plot/');

target_filename = 'linear_time_variant';
result_file_path = strcat(SymConfig.RESULT_PATH, target_filename, '.mat');

if exist(result_file_path, 'file') == 2
    load(result_file_path);
else
    disp(strcat(result_file_path, ' does not exist.'));
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