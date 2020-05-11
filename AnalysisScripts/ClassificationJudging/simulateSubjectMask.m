%%Simulate a whole subject
%N = number of trials
%mu = underlying baseline mu
%sigma = underlying sigma
%levels = what SR noise levels are we operating on?
%withSR = do we have underlying SR?
%initial_stim = initial stimulus of the task being simulated

function [thresholds]=simulateSubjectMask(mu, sigma, levels, withSR, N, initial_stim, masking_slope)

%% set up
guess_rate = 0.5;
lapse_rate = 0;
plot_on = 0;
sigma_guess = sigma;

%What are the undrelying mus?
if withSR == 1
    underlyingMus = underlyingMuDropsASRaud(levels, masking_slope);
else
    underlyingMus = underlyingMuDropsMask(levels, masking_slope);
end

%% initilaize thresholds data structure
thresholds = zeros(1,length(levels));

%% simulate
for i = 1:length(levels)
    mutemp = mu + underlyingMus(i);
    [X, Y, cor, lapses] = pest_mod_2int_Audio(N, mutemp, sigma, guess_rate, lapse_rate, plot_on, initial_stim);
    mu_guess = mutemp;
    x = fminsearch(@(x) two_int_fit_simp(x, X, cor), [mu_guess, sigma_guess]);
    thresholds(i) = x(1);
end

end