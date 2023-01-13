classdef SymConfig
    properties (Constant)
        % target
        TARGET_FILENAME = 'linear_time_variant';

        % csc options
        LAMBDA = 1e-6;
        CSC_OPTS = struct( ...
            'max_iter', 800, ...
            'show_progress', 0, ...
            'check_grad', false, ...
            'tol', 1e-8, ...
            'verbose', true ...
        );

        % data length
        SAMPLE_LEN = 100;
        WHOLE_LEN = 3000;
        ONLINE_LEN = 600;
        WINDOW_LEN = 50;

        % dimension of space
        STATE_DIM = 2;
        FEATURE_DIM = 4;

        % step size of update K
        STEP_SIZE = 0.1;

        % data path
        TOY_DATA_PATH = './data/toy_data/';
        RESULT_PATH = './data/result/'
        ORIGINAL_DATA_PATH = strcat(SymConfig.TOY_DATA_PATH, SymConfig.TARGET_FILENAME, '.mat');
        RESULT_FILE_PATH = strcat(SymConfig.RESULT_PATH, SymConfig.TARGET_FILENAME, '.mat'); 
    end
end