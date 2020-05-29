function [features] = standardDeviationThresholds(i,thresholds,sigma,features)
 
    includingBest = sqrt(var(thresholds(:,i)))/sigma; %this is the 6th column of 'features'
    features(i,6) = includingBest;
    
    % uncomment the following if wanting to change to exclude min threshold value
%     sixthColumn(:,i) = thresholds(:,i);
%     [a(i),index] = min(sixthColumn(:,i));
%     sixthColumn(sixthColumn == a(i)) = mean(thresholds(:,i));
%     excludingBest = sqrt(var(sixthColumn(:,i)))/sigma; 
%     features(i,6) = excludingBest;

end