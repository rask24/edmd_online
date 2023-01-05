function K_next = next_mat_K(Y_input, K_prev, step_size)
    [L, N] = size(Y_input);
    Y_before = Y_input(:, 1:N-1);
    Y_after = Y_input(:, 2:N);

    Y_before_tilde = mat_to_mat_tilde(Y_before', L);
    Y_after_check = mat_to_vec_check(Y_after);

    Y_projection = projection_onto_range_mat(Y_after_check, Y_before_tilde);
    null_space_Y_before_tilde = null(Y_before_tilde);

    if isempty(null_space_Y_before_tilde)
        sol = Y_before_tilde \ Y_projection;
        K_tmp = reshape(sol, [L, L]);
    else
        K_tmp = K_prev;
    end

    K_next = step_size * K_tmp + (1 - step_size) * K_prev; 
end