%% Fit model to training set
[B,dev,stats] = mnrfit(Xtrain,Ytrain,'interactions','on');

%% Predict probabilities for test set
Predicted_probabilities = mnrval(B, Xtest);

%% Count how many predictions were correct

for i=1:length(Ytest)
    predictedClassification(i) = categorical(round(Predicted_probabilities(i,2)-0.05));
end

%% Print out the % of predictions that were correct
percent_correct = 100*correct_predictions/length(Ytest)

%% Confusion matrices

confusion = confusionmat(Ytest, predictedClassification)
TrueNeg = confusion(1,1);
FalsePos = confusion(1,2);
FalseNeg = confusion(2,1);
TruePos = confusion(2,2);

accuracy = (TrueNeg + TruePos)/length(Ytest)
TruePosRate = TruePos/ActualYes;
TrueNegRate = TrueNeg/ActualNo;
ActualNo = FalseNeg+TruePos;
ActualYes = TrueNeg+FalsePos;

    