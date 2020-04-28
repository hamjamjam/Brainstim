%% Inputs we change
N = 50; %number of trials
mu = 0.15; %underlying mu
sigma = 0.05; %underlying sigma
plot_on = 0; %you can change this to 1 and see what happens. This is 0 when running many simulations at once

%% Inputs we generally don't change
guess_rate = 0.5; %this indicates that when they subject has no idea, they are right 50% of the time
lapse_rate = 0; %we assume the subjects are good at telling us when they lapse
sigma_guess = sigma; %The function used to fit the cumulative Gaussian needs a starting point
mu_guess = mu; %
initla_stim = 0.5;

%% Simulation
%the line of code below calls the simulation script that works for the visual and tactile tasks. The simulation script
%outputs a set of simulated trials.
[X, Y, cor, lapses] = pest_mod_2int(N, mu, sigma, guess_rate, lapse_rate, plot_on, initial_stim);
%the line below calls the simulation script that works for the auditory
%task.
%[X, Y, cor, lapses] = pest_mod_2int_Audio(N, mu, sigma, guess_rate, lapse_rate, plot_on, initial_stim);


%the line of code below calls a function that fits the cumulative gaussian
%to the input trial data and stores its paramteres in 'x'
x = fminsearch(@(x) two_int_fit_simp(x, X, cor), [mu_guess, sigma_guess]);

%this line just prints the threshold that was stored in the 'x' variable
x(1)