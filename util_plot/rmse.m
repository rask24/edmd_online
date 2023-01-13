function ret = rmse(mat_1, mat_2)
    ret = sqrt(mean((mat_1 - mat_2).^2, 'all'));
end