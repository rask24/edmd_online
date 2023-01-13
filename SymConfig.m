classdef SymConfig
    properties (Constant)
        % csc options
        LAMBDA = 1e-6;
        CSC_OPTS = struct( ...
            'max_iter', 600, ...
            'show_progress', 0, ...
            'check_grad', false, ...
            'tol', 1e-8, ...
            'verbose', true ...
        );

        % data length
        SAMPLE_LEN = 100;
        WHOLE_LEN = 5000;
        ONLINE_LEN = 600;
        WINDOW_LEN = 50;

        % dimension of space
        STATE_DIM = 2;
        FEATURE_DIM = 4;

        % step size of update K
        STEP_SIZE = 0.1;
    end
end