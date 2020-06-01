%% Simulate a whole subject
%N = number of trials
%mu = underlying baseline mu
%sigma = underlying sigma
%levels = what SR noise levels are we operating on?
%withSR = do we have underlying SR? 0 for no SR 1 for SR
%initial_stim = initial stimulus of the task being simulated

function [thresholds]=simulateSubject(mu, sigma, levels, withSR, N, initial_stim)

%% set up of threshold estimate simulations
guess_rate = 0.5; %at really small stim levels, 50% correct
lapse_rate = 0; %perfect/no lapses
plot_on = 0; %don't want any plots
sigma_guess = sigma; %starting point is real sigma

%We need to pick an underlying mu for each SR Noise level
if withSR == 1
    underlyingMus = mu*underlyingMuRatiosVSR(levels); %this calls another function - for now, don't worry about that function
else
    underlyingMus = mu*ones(1,length(levels));
end

%% initilaize list of thresholds
thresholds = zeros(1,length(levels));

%% simulate
%we are running that single threshold estimate simulation for every SR Noise Level
%in the 'levels' list because we want to assign a simulated threshold to to
%each SR Noise Level
for i = 1:length(levels)
    mutemp = underlyingMus(i); %the mu we
    [X, Y, cor, lapses] = pest_mod_2int(N, mutemp, sigma, guess_rate, lapse_rate, plot_on, initial_stim);
    mu_guess = mutemp;
    x = fminsearch(@(x) two_int_fit_simp(x, X, cor), [mu_guess, sigma_guess]);
    
    thresholds(i) = x(1); %add the simulated threshold to the list of thresholds
end

end