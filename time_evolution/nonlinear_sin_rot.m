function [ret1, ret2] = nonlinear_sin_rot(input1, input2, index)
%myFun - Description
% Syntax: ret = myFun(input)
% Long description
    theta = 0.005;
    mat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    r = 1 + sin(index/100);
    tmp = mat * [input1 ; input2];
    ret1 = [1 0] * tmp;
    ret2 = [0 1] * tmp;
    ret1 = r * ret1;
    ret2 = r * ret2;
end