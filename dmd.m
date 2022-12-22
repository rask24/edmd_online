function [Phi, eigenvalues] = dmd(big_X)
    [~, col_size] = size(big_X);
    X1 = big_X(:, 1:col_size-1);
    X2 = big_X(:, 2:col_size);
    [U, S, V] = svd(X1, 'econ');
    Atilde = U' * X2 * V * inv(S);
    [W, eigenvalues] = eig(Atilde);
    Phi = X2 * V * inv(S) * W;
end