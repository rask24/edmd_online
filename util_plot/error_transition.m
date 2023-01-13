function err_online = error_transition(X_org, X_est_edmd, X_est_online, sample_len, online_len, whole_len)
    err_online = zeros(1, online_len+1);
    eval_start = sample_len + online_len + 1;
    err_online(1, 1) = ...
        rmse(X_org(:, eval_start:whole_len), X_est_edmd(:, eval_start:whole_len));
    for k = 1:online_len
        err_online(1, k+1) = ...
            rmse(X_org(:, eval_start:whole_len), X_est_online(:, eval_start:whole_len, k));
    end
end