function [p_chi2] = chi_sq(ActualNo,PredictedNo,ActualYes,PredictedYes,TrueNeg,FalseNeg,FalsePos,TruePos)

predictedvals(1,1) = ActualNo*PredictedNo / (ActualNo + ActualYes);
predictedvals(1,2) = ActualNo*PredictedYes / (ActualNo + ActualYes);
predictedvals(2,1) = ActualYes*PredictedNo / (ActualNo + ActualYes);
predictedvals(2,2) = ActualYes*PredictedYes / (ActualNo + ActualYes);

percentages(1,1) = (predictedvals(1,1)-TrueNeg)^2/predictedvals(1,1);
percentages(2,1) = (predictedvals(2,1)-FalseNeg)^2/predictedvals(2,1);
percentages(1,2) = (predictedvals(1,2)-FalsePos)^2/predictedvals(1,2);
percentages(2,2) = (predictedvals(2,2)-TruePos)^2/predictedvals(2,2);
sumofpercent = percentages(1,1)+percentages(1,2)+percentages(2,1)+percentages(2,2);


p_chi2 = chi2cdf(sumofpercent,1,'upper');

end
