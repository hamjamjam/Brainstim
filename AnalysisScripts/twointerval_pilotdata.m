%Modified two interval sim to plot threshold curves from pilot data

clear all; close all; clc; 

%tic
%% Perform the 3 down 1 up staircase, simulating the subject's responses
N = 400;       % number of trials in the simulated session


sigma = 0.2;  % sigma value, "slope" of psychometric curve
mu = 0.5;   % underlying "threshold" at which subject gets 75% correct


lapse_rate = 0; % we assuming the underlying lapse rate is 0 (i.e., the subject never lapses)
initial_stim = 1; %staircase
guess_rate = 0.5;  % the level at which subject guesses correctly, normally 0.5
plot_on = 1;
plot_on2 = 1;

[X, Y, cor, lapses] = pest_mod_2int(N, mu, sigma, guess_rate, lapse_rate, plot_on, initial_stim);

%Sasha's pilot testing data
master = importdata('BSRA1_017_Visual_0uA_0dB.xls');

X = master.data(:,2);
%X = abs(X);
%cor = master.data(:,3);

%% Fit the binary psychometric curve using the simple Gaussian from 0.5 to 1

mu_guess = 4;
sigma_guess = 1;
x = fminsearch(@(x) two_int_fit_simp(x, X, cor), [mu_guess, sigma_guess]);
mu_bi = x(1);
sigma_bi = x(2);
thresh_794_bi = icdf('norm', (0.794 - guess_rate)/(1-guess_rate), mu_bi, sigma_bi);


%% Fit the binary psychometric curve with a guess rate differing from 0.5 and a non-zero lapse rate
lambda_max = 0.06;
gamma_max = 0.06;
x = fminsearch(@(x) two_int_fit_guesslapse(x, X, cor, lambda_max, gamma_max), [0 0 mu_guess sigma_guess]);
lambda_hat = x(1);
gamma_hat = x(2);
mu_hat = x(3);
sigma_hat = x(4);
thresh_794_hat = icdf('norm', (0.794 - guess_rate - gamma_hat)/(1-0.5-gamma_hat-lambda_hat), mu_hat, sigma_hat);


%% Plot the results
% Set up a x-vector for fitting
xmax = max(abs(X));
xval = linspace(0, xmax);

% Cumulative normal distribution of the fitted psychometric curve
prob_bi = guess_rate + (1-guess_rate-0)*cdf('norm', xval, mu_bi, sigma_bi);

% Cumulative normal distribution of the fitted psychometric curve with
% a guess rate differing from 0.5 and non-zero lapse rate
prob_hat = guess_rate + gamma_hat + (1-0.5-gamma_hat-lambda_hat)*cdf('norm', xval, mu_hat, sigma_hat);

% Cumulative normal distribution of the underlying psychometric curve
% (note: this is never known in a real subject)
prob = guess_rate + (1-guess_rate-0)*cdf('norm', xval, mu, sigma);

if plot_on2==1
    figure;
    plot(xval, prob, '--'); hold on; % plot the underlying psychometric curve
    plot(xval, prob_bi);            % plot the fitted psychometric curve (simple)
    plot(xval, prob_hat, '--');   % plot the fitted psychometric curve (guess and lapse rates)
else
end

% plot the mean probabilities with the size of the marker representing the
% number of trials at that particular stimulus level
[Xunique, ix, ixu] = unique(X); % find the unique stimuli levels tested
% Average the Y outcomes at each unique X value
sumUnique = zeros(2,length(Xunique));
Punique = zeros(2,length(Xunique));
Lunique = zeros(1,length(Xunique));
for i = 1:length(Xunique)
    coratXunique = cor(ixu == i);          % find the correct outcomes for the ith unique X value
    sumUnique(:,i) = sum(coratXunique,'double');   % total number of correct responses for the ith unique X value
    Lunique(i) = length(coratXunique);    % find the number of trials for the ith unique X value
    Punique(:,i) = sumUnique(:,i)/Lunique(i);      % find the probabilities for a correct response at the ith unique X value
end
for i = 1:length(Xunique)% find the marker size with a max of 12 and a min of 4    
    if max(Lunique) == min(Lunique)
        msize = 8;
    else
        msize = (12-4)/(max(Lunique)-min(Lunique)) * (Lunique(i)-min(Lunique)) + 4;
    end
    
    if plot_on2==1
        plot(Xunique(i), Punique(2,i), 'ko', 'MarkerSize', msize); % plot marker with the correct size
    else
    end
    %     if SPMdata(2,i)>= 5 && SPMdata(3,i) >=5  % need at least 5 of each type of response to use this approximation of CI, otherwise have to use exact methods, which I have not implemented yet
    %         plot(Xunique(i)*[1 1], Punique(2,i)+1.96*sqrt(Punique(2,i)*(1-Punique(2,i))/Lunique(i))*[-1 1], 'k');  % plot 95% confidence intervals
    %     end
end
if plot_on2==1
    legend('underlying', 'fitted simple', 'fitted guess/lapse', 'data', 'Location', 'SouthEast')
    xlabel('Stimulus (e.g., tactile vibration magnitude)'); ylabel('Likelihood of Correct Response')
    ylim([0 1.05])
else
end
