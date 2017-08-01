function sim_behavior()
%% simulate behavior across different modalities and coherences
%
% The script simulates the same conditions (modalities / coherences /
% heading directions) as used for the human subjects. It generates choices
% and reaction times by diffusion model simulations, using reliabilties for
% the different modalities that depends on the modality and, for the visual
% modality also on the coherence. You should complete/adjust the following
% sections of the script:
%
% - ddm_sim() (function at bottom): complete the diffusion model simulation
%   to correctly generate the momentary evidence, and to accumulated this
%   momentary evidence in a weighted fashion. Furthermore, set to choice
%   variable to specify the choice that was made.
%
% - kcomb = ..., dn = ...: the script currently ignores the vestibular
%   modality in the combined condition, by setting kcomb = kvis, dn = vn.
%   Update kcomb and dn to reflect the reliability and reliability
%   time-course resulting from optimal combination of the visual and
%   vestibular modalities.
%
% - kvest / kvis / thetas / tnd: the current parameters simulate behavior
%   that qualitatively differs from that featured by the subjects. Adjust
%   these parameters to get closer to subject behavior. To do so, consider
%   the effects of changing reliability (drift) and boundary height on
%   reaction times and choice probabilities.
%
% Jan Drugowitsch, July 2017


%% settings
% simulation setting - DO NOT CHANGE THESE
dt = 0.01;                          % simulate time-steps
unique_cohs = [0.25 0.37 0.70];     % visual coherences
unique_oris = [0.686 1.96 5.6 16];  % heading directions in deg
trials_per_cond = 5000;             % number of trials to simulate per cond.
% evidence settings - MODIFY THESE TO MODULATE BEHAVIOR
kvest = 30;                         % vestibular reliability 
kvis = [30 80 120];                 % visual reliability for coh [0.25 0.37 0.7]
thetas = [0.1 0.1 0.1];             % decision bounds for [vis vest comb] mod.
tnd = 0.3;                          % non-decision time

% reliability time-course
[vn,an,~] = va_profile(dt);


%% reserve space for per-trial data
signed_oris = [-fliplr(unique_oris) unique_oris];
ncohs = length(unique_cohs);
% coherence only comes into play in the visual/combined condition.
ncond = 1 + 2 * ncohs;   % vestibular + visual/combined
trials = ncond * trials_per_cond;
% pre-allocate vectors
oris = NaN(1, trials);
mods = NaN(1, trials);
cohs = NaN(1, trials);
choice = NaN(1, trials);
rt = NaN(1, trials);


%% generate vestibular trial data
% these will have indices 1..trials_per_cond
% random orientations
oris(1:trials_per_cond) = draw_unif(signed_oris, trials_per_cond);
% coherences are 0 (not specified) in vestibular condition
cohs(1:trials_per_cond) = 0;
mods(1:trials_per_cond) = 2;    % code for vestibular modality
for trial = 1:trials_per_cond
    [choice(trial), rt(trial)] = ...
        sim_ddm(kvest * sin(oris(trial)*pi/180), an, thetas(2), tnd, dt);
end


%% generate visual and combined trial data
% these will have indicies starting at (trials_per_cond+1), with visual
% trials for all coherences followed by combined trials for all coherences.
% individual trials have random orientation assignments
oris((trials_per_cond+1):end) = draw_unif(signed_oris, ncohs * trials_per_cond * 2);
mods((trials_per_cond+1):(4*trials_per_cond)) = 1;  % visual modalitiy
mods((4*trials_per_cond+1):end) = 3;                % both modalities
% simulate per coherence
for icoh = 1:ncohs
    % base indicies - 1
    visbase = trials_per_cond * icoh;
    combbase = visbase + trials_per_cond * ncohs;
    % assign coherence
    cohs((visbase+1):(visbase+trials_per_cond)) = unique_cohs(icoh);
    cohs((combbase+1):(combbase+trials_per_cond)) = unique_cohs(icoh);
    % reliability in the combined condition.
    % THE BELOW CURRENTLY IGNORES THE VESTIBULAR MODALITY - ADJUST TO
    % COMBINE BOTH VISUAL AND VESTIBULAR INFORMATION
    kcomb = kvis(icoh);
    dn = vn;
    % simulate individual trials
    for trial = 1:trials_per_cond
        [choice(visbase+trial), rt(visbase+trial)] = ...
            sim_ddm(kvis(icoh) * sin(oris(visbase+trial)*pi/180), vn, thetas(1), tnd, dt);
        [choice(combbase+trial), rt(combbase+trial)] = ...
            sim_ddm(kcomb * sin(oris(combbase+trial)*pi/180), dn, thetas(3), tnd, dt);        
    end
end


%% plot resulting behavior
plot_psych_chron(oris, mods, cohs, choice, rt);


function x = draw_unif(unique_x, trials)
%% returns x with 'trials' draws from unique_x, roughly uniform

% x will be vector with roughly equal number of each unique_x(i)
nx = length(unique_x);
x = unique_x(floor(linspace(1,nx * (trials-1)/trials + 1, trials)));

% shuffle trial order
x = x(randperm(trials));


function [choice, rt] = sim_ddm(ksinh, dn, theta, tnd, dt)
%% simulated a diffusion model and returns the choice and reaction time
%
% The parameters are the following:
% - ksinh: overall reliability k * sinh(h), where h is heading direction
%          and k is reliability of the modality / coherence.
% - dn: reliability time-course in steps of dt.
% - theta: diffusion model bound at which choice is triggered
% - tnd: non-decision time, will be added to decision time
% - dt: time-steps for simulation.
%
% The function simulates a diffusion model performing weighted evidence
% accumulation, in steps of dt, for all steps provided in dn. The choice
% is 1 if the bound theta is reached, and 0 if the bound -theta is reached.
% rt will be the bound-hitting time + tnd. If no bound is reached by the
% end of dn, the choice depends on the sign of the current particle
% location (x > 0 -> choice = 1; x < 0 -> choice = 0).

sqrtdt = sqrt(dt);
x = 0;
n = length(dn);
for i = 2:n   % start at second step, as x = 0 is first step
    % GENERATE MOMENTARY EVIDENCE, dx ~ N(ksinh * dn(i) * dt, dt),
    % WITH MEAN ksinh * dn(i) * dt AND VARIANCE dt
    dx = % TODO
    
    % ADD MOMENTARY EVIDENCE TO CURRENT PARTICLE LOCATION, OBEYING RULES OF
    % BAYES-OPTIMAL EVIDENCE ACCUMULATION
    x = x + % TODO
    
    if abs(x) > theta
        rt = i * dt + tnd;
        % SET choice DEPENDING ON IF UPPER OR LOWER BOUNDARY WERE REACHED
        % TODO: set choice
        
        return
    end
end

rt = n * dt + tnd;
% BOUNDARIES WERE NOT REACHED BEFORE END OF dn -> SET CHOICE ACCORDING TO
% SIGN OF x
% TODO: set choice
