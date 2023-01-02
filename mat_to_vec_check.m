function ret = mat_to_vec_check(input)
    % input n * m matrix
    % return nm * 1 matrix (vector)
    [row, col] = size(input);
    % ret = zeros(row * col, 1);
    % for iter_col = 1:col
    %     for iter_row = 1:row
    %         iter_col, iter_row, input(iter_row, iter_col)
    %         ret(row * (iter_col - 1) + iter_row, 1) = input(iter_row, iter_col);
    %     end
    % end
    ret = reshape(input, [row * col, 1]);
end