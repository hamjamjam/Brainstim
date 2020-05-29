function [YPredicted,confusion, Accuracy, ActualNo, PredictedNo, ActualYes, PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos] = confusionMatrix(Predicted_probabilities,Ytest)
 
 YPredicted = categorical(round(Predicted_probabilities(:,2))); %Creating the prediction for if there is underlying SR or not
 confusion = confusionmat(Ytest,YPredicted); % Confusion matrix 

 TrueNeg = confusion(1,1); %predicted negative and actually was negative
 FalsePos = confusion(1,2); %predicted positive and actually was negative
 FalseNeg = confusion(2,1); %predicted negative and actually was positive
 TruePos = confusion(2,2); %predicted positive and actually was positive
 
 ActualYes = FalseNeg+TruePos; % 2nd row of 'confusion' matrix
 ActualNo = TrueNeg+FalsePos; %1st row of 'confusion' matrix
 PredictedNo = TrueNeg+FalseNeg; % 1st column of 'confusion' matrix
 PredictedYes = FalsePos+TruePos; % 2nd column of 'confusion' matrix
 
 % Create Labeled Table to print in command window
 rowNames = {'ActualNo', 'ActualYes'};
 colNames = {'ClassedAsNo', 'ClassedAsYes'};
 sTable = array2table(confusion,'VariableNames',colNames,'RowNames',rowNames)
 
 % Useful Information, Analyzing data
 Accuracy = (TrueNeg + TruePos)/length(Ytest)*100 %In percent. This is what we are trying to increase for Undergrad Games
 Misclassification = (FalsePos + FalseNeg)/length(Ytest);
 TruePosRate = TruePos/ActualYes;
 FalsoPosRate = FalsePos/ActualNo;
 TrueNegRate = TrueNeg/ActualNo;
 Precision = TruePos/PredictedYes;
 Prevelance = ActualYes/length(Ytest);
 
end