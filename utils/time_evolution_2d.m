function [ret1, ret2] = time_evolution_2d(input1, input2)
    theta = 0.1;
    mat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    tmp = mat * [input1 ; input2];
    ret1 = [1 0] * tmp;
    ret2 = [0 1] * tmp;
    % ret1 = sin(ret1);
    % ret2 = sin(ret2);
end