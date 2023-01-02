function ret = mat_to_mat_tilde(input, expand)
    % input n * m matrix
    % return nn * nm matrix
    [row, col] = size(input);
    ret = zeros(expand * row, expand * col);
    for iter_row = 1:row
        for iter_col = 1:col
            for iter_diag = 1:expand
                ret((iter_row - 1) * expand + iter_diag, (iter_col - 1) * expand + iter_diag) = input(iter_row, iter_col);
            end
        end
    end
end