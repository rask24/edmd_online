function X_org = create_toy_data()
%create_toy_data - Description
% % Syntax: ret = create_toy_data()
% Long description
    X_org = zeros(SymConfig.STATE_DIM, SymConfig.WHOLE_LEN);

    if strcmp(SymConfig.TARGET_FILENAME,'linear_time_variant')
        X_org(:, 1) = [1 ; 0];
        for k = 2:SymConfig.WHOLE_LEN
            if k < 200
                [X_org(1, k), X_org(2, k)] = ...
                    linear_time_variant(X_org(1, k-1), X_org(2, k-1), 1);
            elseif k < 400
                [X_org(1, k), X_org(2, k)] = ...
                    linear_time_variant(X_org(1, k-1), X_org(2, k-1), 2);
            else
                [X_org(1, k), X_org(2, k)] = ...
                    linear_time_variant(X_org(1, k-1), X_org(2, k-1), 1);
            end
        end
    elseif strcmp(SymConfig.TARGET_FILENAME, 'nonlinear_sin_rot')
        X_org(:, 1) = [1 ; 0];
        for k = 2:SymConfig.WHOLE_LEN
            [X_org(1, k), X_org(2, k)] = ...
                nonlinear_sin_rot(X_org(1, k-1), X_org(2, k-1), 1);
        end
    else
        X_org(:, 1) = [1 ; 0];
        for k = 2:SymConfig.WHOLE_LEN
            X_org(1, k) = X_org(1, k-1);
            X_org(2, k) = X_org(2, k-1);
        end
    end
end