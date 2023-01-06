function ret = projection_onto_range_mat(vec, mat)
    % input
    % vec: projecting vector
    % mat: matrix spanning vector space
    % ret: projected vector

    % [row, col] = size(mat);

    % mat_gram = zeros(col, col);
    % for iter_1 = 1:col
    %     for iter_2 = 1:col
    %         mat_gram(iter_1, iter_2) = dot(mat(:, iter_2), mat(:, iter_1));
    %     end
    % end

    % b = zeros(col, 1);
    % for iter = 1:col
    %     b(iter, 1) = dot(vec, mat(:, iter));
    % end

    % sol = linsolve(mat_gram, b);
    % ret = zeros(row, 1);
    % for iter = 1:col
    %     ret = ret + sol(iter, 1) * mat(:, iter);
    % end

    [orthogonal_basis, ~, ~] = svd(mat, 'econ');
    [~, col_size] = size(orthogonal_basis);
    gram_mat_T = zeros(col_size);
    b = zeros(col_size, 1);
    for k = 1:col_size
        for l = 1:col_size
            gram_mat_T(k, l) = dot(orthogonal_basis(:, l), orthogonal_basis(:, k));
        end
    end
    for k = 1:col_size
        b(k, 1) = dot(vec, orthogonal_basis(:, k));
    end
    ret = orthogonal_basis * (gram_mat_T \ (gram_mat_T * b));
end