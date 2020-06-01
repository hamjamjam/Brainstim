function [StandardDeviationIncludingBest] = standardDeviationThresholdsVSR(i,thresholds,sigma)
 
    StandardDeviationIncludingBest(i) = sqrt(var(thresholds(:,i)))/sigma; %taking a sqrt of variance give standard deviation. Normalized by sham.
   
    
    % uncomment the following if you want to change to exclude min threshold value
%     sixthColumn(:,i) = thresholds(:,i);
%     [a(i),index] = min(sixthColumn(:,i));
%     sixthColumn(sixthColumn == a(i)) = mean(thresholds(:,i));
%     excludingBest = sqrt(var(sixthColumn(:,i)))/sigma; 
%     features(i,6) = excludingBest;

end