function [features] = standardDeviationThresholds(i,thresholds,sigma,features)
 
    includingBest = sqrt(var(thresholds(:,i)))/sigma; %taking a sqrt of variance give standard deviation. Normalized by sham.
    features(i,6) = includingBest; %this is the 6th column of 'features'
    
    % uncomment the following if wanting to change to exclude min threshold value
%     sixthColumn(:,i) = thresholds(:,i);
%     [a(i),index] = min(sixthColumn(:,i));
%     sixthColumn(sixthColumn == a(i)) = mean(thresholds(:,i));
%     excludingBest = sqrt(var(sixthColumn(:,i)))/sigma; 
%     features(i,6) = excludingBest;

end