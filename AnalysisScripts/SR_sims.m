clear all; close all; clc; 

tic

N = 50;       % number of trials in the simulated session

mu_sd = 1;
sig_mean = 0.3;
sig_sd = 0.2;
globalmu = 1; %globalmu;
sigma = 0.3;   
percentSR = 0.5;
     
plot_count=2000;
inputs = zeros(plot_count,4);
key = ones(1,plot_count);
plot_on = 0;
for M=1:plot_count    
%% Set up loop for different trial numbers
    q = [0 1 2 3 4 5]; %SR stim levels
    K = length(q); %Number of data points per subject at each SR stim level 
    mu_bi_vect=zeros(1,K);
    mu_vect=zeros(1,K);
    mu_vect(1,1) = globalmu;


    %q = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %SR stim levels
    

    q2=linspace(0.01,5);

    lam = 4; %set constant
    w=1; %set constant

    A0 = 1; %needs to be 1 for % imp.
    r = lam*exp(-lam./(2.*q.^2)); %intermediate calc
    A = -A0.*(1./q.^2).*(r./(sqrt(4*r + w))); %vector of percent improvements
    r2 = lam*exp(-lam./(2.*q2.^2)); %intermediate calc for linspace of A as per q2
    A2 = -A0.*(1./q2.^2).*(r2./(sqrt(4*r2 + w))); %linspace of A as per q2
    mu_underlying = (1.+A2)*globalmu;
    A(1)=0;

    x = rand();
    inputs(M, 4) = 1;
    if x > percentSR
        A = zeros(1,length(q));
        key(M) = 0;
        inputs(M,4) = 0;
    end

    A = 1.+A;

    for i = 1:length(A)
        mu_vect(1,i) = A(i)*globalmu;
    end



    for n=1:K 


        mu=mu_vect(1,n);
            %% Parameters of the "theoretical" subject's underlying values

            guess_rate = 0.5;  % the level at which subject guesses correctly, normally 0.5
            initial_stim=5;
            
            lapse_rate = 0; % we assuming the underlying lapse rate is 0 (i.e., the subject never lapses)

            % pest_mod_2int performs the 3 down 1 up staircase for a 2 interval
            % detection task
            [X, Y, cor, lapses] = pest_mod_2int(N, mu, sigma, guess_rate, lapse_rate, plot_on, initial_stim);
            % lapses = 1 if lapses, 0 if not. since we are assuming no lapses, these
            % will all be 0's
            X = X';             % the simuli levels, negative values correspond to first interval and positive to second inteval, the absolute value is the magnitude of the stimulus
            Ybi = [~Y'; Y'];    % the subject's responses. 0 = respond stim is in first interval, 1 = respond stim is in second interval
            cor = cor';         % cor = 0 if incorrect, = 1 if the responses is correct
            
            %% Fit the binary psychometric curve using the simple Gaussian from 0.5 to 1
            mu_guess = mu;
            sigma_guess = 0.3;
            x = fminsearch(@(x) two_int_fit_simp(x, X, cor), [mu_guess, sigma_guess]);
            mu_bi = x(1);
            sigma_bi = x(2);
            
            mu_bi_vect(1,n)=mu_bi;

    end
    below = 0;
    zeroX = 0;
    
    if mu_bi_vect(2)<mu_bi_vect(1) %which way are we trending to start?
        tempX = 0; %trending down
    else
        tempX = 1; %trending up
    end
    
    for i=2:K
        if mu_bi_vect(i)<mu_bi_vect(1) %are we above or below sham?
            below = below + 1;
        end
        
        if mu_bi_vect(i-1)<mu_bi_vect(i)%are we trending up
            if tempX == 0 %were we trending down before
                zeroX = zeroX + 1;
            end
            tempX = 1; %update to say we are trending up
        else %if we aren't trending up then we are trending down
            if tempX == 1 %were we trending up before?
                zeroX = zeroX + 1;
            end
            tempX = 0; %update to say we are trending down
        end
    end
    
    inputs(M,1) = zeroX;
    inputs(M,2) = below;
    inputs(M,3) = min(mu_bi_vect)/mu_bi_vect(1);
end
    
            
            

%%


filename = 'simSRdata5.csv';
dlmwrite(filename,inputs);

toc