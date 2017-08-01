function c = cond_color(c_mod, c_coh)
%% returns the plot color for the given condition
%
% The condition is specified through a combination of modality c_mod (1 =
% visual, 2 = vestibular, 3 = combined) and coherence c_coh (one of 0.25,
% 0.37, 0.70). For c_mod = 2, c_coh is ignored.
%
% Jan Drugowitsch, July 2017

%% assign color
switch c_mod
    case 1
        % visual
        switch c_coh
            case 0.25
                c = [0 0 0.8];
            case 0.37
                c = [0 0.4 0.8];
            case 0.7
                c = [0 0.8 0.8];
            otherwise
                error('Unknown coherence c_coh');
        end
    case 2
        % vestibular
        c = [0 0.8 0];
    case 3
        % combined
        switch c_coh
            case 0.25
                c = [0.8 0 0];
            case 0.37
                c = [0.8 0.4 0];
            case 0.7
                c = [0.8 0.8 0];
            otherwise
                error('Unknown coherence c_coh');
        end
    otherwise
        error('Unknown modality c_mod');
end
