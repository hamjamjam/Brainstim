clear all; close all; clc;
%
%% parameters that must match up to real life experiment
%these parameters are kept outside any for loops
%currently set for the visual task with VSR
N = 50;
levels = [0:0.1:1]; %VSR
initial_stim = 0.5; %visual task initially at 0.5 contrast

%% parameters that we change
%the rest of this file can go inside a for loop if we are simulating lots of
%subjects in one go
% withSR = zeros(1,2);
sim_number = 2000;
mumean = 0.15;
muSD = 0.05;

%% Initializing Values that needed to be initialized outside of the for loops
thresholds = zeros(length(levels), sim_number);
[m,n] = size(thresholds);
withSRi = zeros(1,sim_number);
withSRi(1:2:end) = 1;
features = zeros(sim_number,6);

%% Run the number of simulations (100) 5 times
%for l = 1:5

%% Run 100 simulations
for i = 1:sim_number
    
    %Initializing values needed to run the simulations
        running_sim_number = i;
        features(i,1) = i;
        mu = normrnd(mumean, muSD); %pick mu
        withSR = withSRi(i);%randi([0 1],1,1);  %we want to be able to choose if they have sr or not, CHANGE TO 50/50
        sigma = mu*0.33; % we want this to be a function of mu for now 
    
    %% Simulate a subject and create features table
    
        %we get back a list of their thresholds for each stimulus level
        [thresholds(:,i)]= simulateSubject(mu, sigma, levels, withSR, N, initial_stim);
        
    %% Number of threshold values above sham, 2nd column of 'features'
    
        %we get back the sham for each simulation, as well as the second column of the 'features matrix', which is the number of threshold
        %values above sham for any specified simulation
        sham(i) = thresholds(1,i); 
        [features] = thresholds_above_sham(i,thresholds(:,i),features,sham(i));
       
    %% Number of direction changes ignoring first and last values, 3rd column of 'features'

        % returns the number of direction changes that each simulation has, excluding first and last values. This is the third column of 'features'
        [features] = direction_changes(i,thresholds,features);
    
    %% Ratio of best threshold to sham, 4th column of 'features'
    
        % returns the ratio of lowest threshold value to sham value for each simulaiton. Fourth column of 'features'
        features(i,4) = min(thresholds(2:end,i))/sham(i);
        
    %% Avg of best and 2 neighboring, 5th column of 'features'

        % returns the average value of the lowest threshold and the two surrounding it for each simulation. Fifth column of 'features'
        [features] = avg_of_best_and_2_neighboring(i,thresholds,sham,features);
        
    %% Clarify if the subject has SR or no SR
        
        %This tells the simulation whether there is an underlying SR or Not
        if withSR == 1
            SRvsNoSR(i,1) = 1;
        else
            SRvsNoSR(i,1) = 0;
        end

    %% Variance / STD of Threshold Values, 6th column of 'features'
        
        % This is the standard deviation of all threshold values for each simulation including the lowest threshold value
        [features] = standard_deviation_thresholds(i,thresholds,sigma,features);
        
        % COULD NOT TELL A DIFFERENCE BETWEEN STD AND VARIANCE, OR BETWEEN INCLUDING BEST AND EXCLUDING BEST
    
    %% plot if running 10 simulations
    
        %SubplotSR(thresholds,i,levels,withSR)
     
end

%% Plotting with GPlotMatrix (Blue and Green Dots)

    % This is useful when visually comparing more than one feature with another
    %plotmatrix(features,SRvsNoSR)
    
%% Split data into training and test sets

    split_ind = floor(0.8*length(features)); 

    Xtrain = features(1:split_ind,2:end);
    Ytrain = categorical(SRvsNoSR(1:split_ind,1));
    Xtest = features((split_ind+1):end,2:end);
    Ytest = categorical(SRvsNoSR((split_ind+1):end,1));

%% Fit model to training set

    [B,dev,stats] = mnrfit(Xtrain,Ytrain,'interactions','on');

%% Predict probabilities for test set

    Predicted_probabilities = mnrval(B, Xtest);

%% Confusion matrices

    % This helps us understand the accuracy of the code. Returns a confusion matrix and tells us certain things about it 
    [YPredicted,confusion, Accuracy, ActualNo, PredictedNo, ActualYes, PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos] = confusion_matrix(Predicted_probabilities,Ytest);

%% Chi^2 and p val based on excel 

    % Chi^2 
    [p_chi2] = chi_sq(ActualNo,PredictedNo,ActualYes,PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos);
    
%% Correlation Coefficients
 
   [Rval,Pval,Pval2,R,P,idx1,R2,P2,idx2,s,YPredict,Ytest] = correlation_coefficient(features,sham,SRvsNoSR,Xtest,YPredicted,Ytest);
 
%% End outer for loop

%end