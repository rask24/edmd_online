function [ret1, ret2] = linear_time_variant_theta(input1, input2, mod)
%myFun - Description
% Syntax: ret = myFun(input)
% Long description
    if mod == 0
        theta = 0.005;
    else
        theta = 0.01;
    end
    r = 1.0001;
    mat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    tmp = mat * [input1 ; input2];
    ret1 = [r 0] * tmp;
    ret2 = [0 r] * tmp;
end