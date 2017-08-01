function [oris, choice, rt] = extract_cond(oris, mods, cohs, choice, rt, ...
                                           extract_mod, extract_coh)
%% returns trial data corresponding to the specified condition
%
% oris, mods, cohs, choice, and rt are vectors specifying per-trial
% conditions and responses, as specified in vis_vest_README.txt.
%
% The condition is specified by the extract_mod and extract_coh
% combination. extract_mod specifies the modalities, with 1 = visual, 2 =
% vestibular, and 3 = combined. For visual/combined, extract_coh specifies
% the visual coherence, which can be one of 0.25, 0.37, or 0.70. For
% vestibular, extract_coh is optional and ignored.
%
% The function returns orientations, choices, and reaction times
% corresponding to the specified condition.
%
% Jan Drugowitsch, July 2017

%% process arguments
if ~any(extract_mod == [1 2 3])
    error('extract_mod needs to be either 1, 2, or 3');
end
if any(extract_mod == [1 3]) && ~any(extract_coh == [0.25 0.37 0.7])
    error('extract_coh needs to be either 0.25, 0.37, or 0.7');
end


%% extract trials
if any(extract_mod == [1 3])
    % visual or combined -> coherence matters
    trials = (mods == extract_mod) & (cohs == extract_coh);
else
    % vestibular -> ignore coherence
    trials = mods == extract_mod;
end
oris = oris(trials);
choice = choice(trials);
rt = rt(trials);
