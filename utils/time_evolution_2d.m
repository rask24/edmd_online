function [ret1, ret2] = time_evolution_2d(input1, input2, mod)
    if mod == 1
        theta = 0.005;
        mat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    elseif mod == 2
        theta = 0.0001;
        mat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    else
        mat = eye(2);
    end
    tmp = mat * [input1 ; input2];
    ret1 = [1.001 0] * tmp;
    ret2 = ([0 1] * tmp)^2;
end