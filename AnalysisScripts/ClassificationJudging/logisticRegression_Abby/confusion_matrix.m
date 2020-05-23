function [YPredicted,confusion, Accuracy, ActualNo, PredictedNo, ActualYes, PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos] = confusion_matrix(Predicted_probabilities,Ytest)
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
end