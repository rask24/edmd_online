function [ret1, ret2] = linear_time_variant(input1, input2, mod)
    theta = 0.005;
    mat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    if mod == 1
        r = 1.001;
        add = 0;
    else
        r = 1.01;
        add = 0.0001;
    end
    tmp = mat * [input1 ; input2];
    ret1 = [1 0] * tmp;
    ret2 = [0 1] * tmp;
    ret1 = r * ret1 + add;
    ret2 = r * ret2;
end