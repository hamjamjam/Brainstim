clear all; close all; clc;

%% parameters that must match up to real life experiment
%these parameters are kept outside any for loops

%currently set for the ASR Auditory
N = 50; %Number of trials per simulation
levels = [0:5:50]; %ASR Aud
initial_stim = 0.5; %visual task initially at 0.5 contrast

%% parameters that we change
sim_number = 10; %number of simulations
mumean = 0.15;
muSD = 0.05;

%% Initializing values that needed to be initialized outside of the for loops
thresholds = zeros(length(levels), sim_number);
[m,n] = size(thresholds);
withSRInitial = zeros(1,sim_number); 
withSRInitial(1:2:end) = 1;
features = zeros(sim_number,6); %if adding another feature, add another column

%% Run the number of simulations multiple times to check consistency in accuracy of predictions
%for l = 1:5

%% Run many simulations
for i = 1:sim_number
    
    %Initializing values needed to run the simulations
        running_sim_number = i; %if running into errors, unsuppress this and you can see how many times the loop is running
        mu = normrnd(mumean, muSD); %pick mu
        withSR = withSRInitial(i);%randi([0 1],1,1);  %we want to be able to choose if they have sr or not
        sigma = mu*0.33; % we want this to be a function of mu for now 
    
    %% Simulate a subject
    
        %we get back a list of their thresholds for each stimulus level
        [thresholds(:,i),underlyingMus]= simulateSubjectMask(mu, sigma, levels, withSR, N, initial_stim);
        
    %% Number of threshold values above sham, 2nd column of 'features'
    
        %we get back the sham for each simulation, as well as the second column of the 'features matrix', which is the number of threshold
        %values above sham for any specified simulation
        sham(i) = thresholds(1,i); %sham is the first threshold value for each simulation
        [numberOfThresholdsAboveSham] = ThresholdsAboveSham(i,thresholds(:,i),sham(i)); %this tells us the number of thresholds above sham for each simulation

    %% Number of direction changes ignoring first and last values, 3rd column of 'features'

        % returns the number of direction changes that each simulation has, excluding first and last values. This is the third column of 'features'
        [numberOfDirectionChanges] = DirectionChanges(i,thresholds);
        
    %% Ratio of best threshold to sham, 4th column of 'features'
    
        % returns the ratio of lowest threshold value to sham value for each simulaiton. Fourth column of 'features'
        diffOfBestvsSham(i) = sham(i) - min(thresholds(2:end,i)); 
        %did not create a separate feature because it was just one line of code
       
    %% Avg of best and 2 neighboring, 5th column of 'features'

        % returns the average value of the lowest threshold and the two surrounding it for each simulation. Fifth column of 'features'
        [avgOfBestand2Neighboring] = AvgBestand2Neighboring(i,thresholds,sham);
           
    %% Variance / STD of Threshold Values, 6th column of 'features'
        
        % This is the standard deviation of all threshold values for each simulation including the lowest threshold value
        [StandardDeviationIncludingBest] = standardDeviationThresholds(i,thresholds,sigma);
        
        %No clear difference between standard deviation and variance, or
        %between including lowest threshold value and excluding lowest
        %threshold value. Currently set to be standard deviation including best
        
     %% Clarify if the subject has SR or no SR
        
        %This tells the simulation whether there is an underlying SR or Not.
        %also creates an array of 1's and 0's for the analyses done later
        if withSR == 1
            SRvsNoSR(i,1) = 1;
        else
            SRvsNoSR(i,1) = 0;
        end

   
%% Features Matrix
features(i,1) = i; %the first column of 'features' is the simulation number
features(i,2) = numberOfThresholdsAboveSham(i);
features(i,3) = numberOfDirectionChanges(i);    
features(i,4) = diffOfBestvsSham(i);
features(i,5) = avgOfBestand2Neighboring(i);
features(i,6) = StandardDeviationIncludingBest(i);


 %% plot if running 10 simulations
    
        SubplotSR(thresholds,i,levels,withSR)
end        
%% Features Table
 featureTitles = {'Sim Number','Number Above Sham','Number of Direction Changes','Ratio Best to Sham','Avg of best and 2 Neighboring','SD Including Best'};
 featuresTable = array2table(features,'VariableNames',featureTitles);

%% Plotting with GPlotMatrix (Blue and Green Dots)

    % This is useful when visually comparing more than one feature with another
    %plotmatrix(features,SRvsNoSR)
    
%% Split data into training and test sets

    split_ind = floor(0.8*length(features)); %taking 80% of the sumulations as the training and 20% as test

    Xtrain = features(1:split_ind,2:end); % 80% of features
    Ytrain = categorical(SRvsNoSR(1:split_ind,1)); % 80% of the 1's and 0's array 
    Xtest = features((split_ind+1):end,2:end); % 20% of features
    Ytest = categorical(SRvsNoSR((split_ind+1):end,1)); % 20% of the 1's and 0's array

%% Fit model to training set

    [B,dev,stats] = mnrfit(Xtrain,Ytrain,'interactions','on');
    % Matlab's built in multinominal logistic regression function

%% Predict probabilities for test set

    Predicted_probabilities = mnrval(B, Xtest);

%% Confusion matrices

    % This helps us understand the accuracy of the code. Returns a confusion matrix and tells us certain things about it 
    [YPredicted,confusion, Accuracy, ActualNo, PredictedNo, ActualYes, PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos] = confusionMatrix(Predicted_probabilities,Ytest);

%% Chi^2 and p val based on excel 

    % Chi^2 test gives p-value
    [p_chi2] = chiSquared(ActualNo,PredictedNo,ActualYes,PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos);
    
%% Correlation Coefficients
 
   [Rval,Pval,Pval2,R,P,idx1,R2,P2,idx2,Ytest] = correlationCoefficient(features,sham,SRvsNoSR,Xtest,YPredicted,Ytest,featuresTable);
 
%% End outer for loop where you can run the entire thing multiple times to see if accuracy is consistent 
%end