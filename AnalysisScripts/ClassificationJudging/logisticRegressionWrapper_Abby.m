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
sim_number = 10;
mumean = 0.15;
muSD = 0.05;

%% Setting up Features matrix
thresholds = zeros(length(levels), sim_number);
[m,n] = size(thresholds);
withSRi = zeros(1,sim_number);
withSRi(1:2:end) = 1;
features = zeros(sim_number,6);

%for l = 1:5
for i = 1:sim_number
    running_sim_number = i;
    features(i,1) = i;
    mu = normrnd(mumean, muSD); %pick mu
    withSR = withSRi(i);%randi([0 1],1,1);  %we want to be able to choose if they have sr or not, CHANGE TO 50/50
    sigma = mu*0.33; % we want this to be a function of mu for now 
    
    %% Simulate a subject and create features table
        %we get back a list of their thresholds for each stimulus level
        [thresholds(:,i)]= simulateSubject(mu, sigma, levels, withSR, N, initial_stim);
    %% Number of threshold values above sham, 2nd column of 'features'
        sham(i) = thresholds(1,i);
%             features(i,2) = sum(thresholds(2:end,i) > sham(i));
         
       [features] = thresholds_above_sham(i,thresholds(:,i),features,sham(i));
    %% Number of direction changes ignoring first and last values, 3rd column of 'features'
%         direction(:,i) = diff(thresholds(:,i));
%         [m,n] = size(direction);
%         directionchange = zeros(length(direction),2);
%     
%         for j = 1:(m-1)
%             if (direction(j+1,i) > 0) && (direction(j,i) < 0) || (direction(j+1,i) < 0) && (direction(j,i) > 0)
%                 directionchange(j,1) = 1;
%             else 
%                 directionchange(j,1) = 0;
%             end
%         end
%         features(i,3) = sum(directionchange(:,1));
    [features,direction,m,n,directionchange] = direction_changes(i,thresholds,features);
    %% Ratio of best threshold to sham, 4th column of 'features'
        features(i,4) = min(thresholds(2:end,i))/sham(i);
        
    %% Avg of best and 2 neighboring, 5th column of 'features'

        if min(thresholds(2:end-1,i)) < sham(i)
            [m,n] = min(thresholds(1:end-1,i));
            minthresholds = [ thresholds(n,i), thresholds(n-1,i),  thresholds(n+1,i)];                    
        elseif min(thresholds)==sham(i)
            minthresholds = [ thresholds(1,i), thresholds(2,i),  thresholds(3,i)];
        else
            minthresholds = [ thresholds(end,i), thresholds(end-1,i),  thresholds(end-2,i)]; 
        end
        features(i,5) = mean(minthresholds)/sham(i); 
    %% Clarify if the subject has SR or no SR
       
        if withSR == 1
            SRvsNoSR(i,1) = 1;
        else
            SRvsNoSR(i,1) = 0;
        end

        %% Variance / STD of Threshold Values, 6th column of 'features'
        
        features(i,6) = sqrt(var(thresholds(:,i)))/sigma;
        
        %% Variance / STD of Threshold Values EXCLUDING BEST, 7th column of 'features'
        
        seventhcolumn(:,i) = thresholds(:,i);
        [a(i),index] = min(seventhcolumn(:,i));
        seventhcolumn(seventhcolumn == a(i)) = mean(thresholds(:,i));

        %features(i,6) = var(seventhcolumn(:,i))/sigma;
        
        %DID NOT TELL A DIFFERENCE BETWEEN STD AND VARIANCE, OR BETWEEN
        %INCLUDING BEST AND EXCLUDING BEST
    
     %% plot
     SubplotSR(thresholds,i,levels,withSR)
     
end

%% Plotting with GPlotMatrix (Blue and Green Dots)
% figure(2)
% A = features(:,[4 5]); % the columns 
% B = features(:,[6]); % the rows
% [~,ax] = gplotmatrix(A,B,SRvsNoSR(:)) % categorizing them based on if they have SR or not
% ax(1,1).YLabel.String = 'Standard Deviation of Thresholds';
% ax(1,1).XLabel.String = 'Ratio of Best to Sham';
% ax(1,2).XLabel.String = 'Avg of Best and Two Neighboring';
% title('100 Simulations with N=50')

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

%% Count how many predictions were correct

correct_predictions = 0;
for i=1:length(Ytest)
    predict_i = categorical(round(Predicted_probabilities(i,2)));
    if predict_i == Ytest(i)
        correct_predictions = correct_predictions + 1;
    end
end

%% Print out the % of predictions that were correct
percent_correct = 100*correct_predictions/length(Ytest)

%% Confusion matrices
 YPredicted = categorical(round(Predicted_probabilities(:,2)));
 confusion = confusionmat(Ytest,YPredicted);

 TrueNeg = confusion(1,1);
 FalsePos = confusion(1,2);
 FalseNeg = confusion(2,1);
 TruePos = confusion(2,2);
 
 ActualYes = FalseNeg+TruePos;
 ActualNo = TrueNeg+FalsePos;
 PredictedNo = TrueNeg+FalseNeg;
 PredictedYes = FalsePos+TruePos;
 
 % Create Labeled Table
 rowNames = {'ActualNo', 'ActualYes'};
 colNames = {'ClassedAsNo', 'ClassedAsYes'};
 sTable = array2table(confusion,'VariableNames',colNames,'RowNames',rowNames)
 
 % Useful Information
 Accuracy = (TrueNeg + TruePos)/length(Ytest);
 Misclassification = (FalsePos + FalseNeg)/length(Ytest);
 TruePosRate = TruePos/ActualYes;
 FalsoPosRate = FalsePos/ActualNo;
 TrueNegRate = TrueNeg/ActualNo;
 Precision = TruePos/PredictedYes;
 Prevelance = ActualYes/length(Ytest);

%% Chi^2 and p val based on excel 

predictedvals(1,1) = ActualNo*PredictedNo / (ActualNo + ActualYes);
predictedvals(1,2) = ActualNo*PredictedYes / (ActualNo + ActualYes);
predictedvals(2,1) = ActualYes*PredictedNo / (ActualNo + ActualYes);
predictedvals(2,2) = ActualYes*PredictedYes / (ActualNo + ActualYes);

percentages(1,1) = (predictedvals(1,1)-TrueNeg)^2/predictedvals(1,1);
percentages(2,1) = (predictedvals(2,1)-FalseNeg)^2/predictedvals(2,1);
percentages(1,2) = (predictedvals(1,2)-FalsePos)^2/predictedvals(1,2);
percentages(2,2) = (predictedvals(2,2)-TruePos)^2/predictedvals(2,2);
sumofpercent = percentages(1,1)+percentages(1,2)+percentages(2,1)+percentages(2,2);


p = chi2cdf(sumofpercent,1,'upper')
%end