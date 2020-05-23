function [features] = standard_deviation_thresholds(i,thresholds,sigma,features)
 
    includingbest = sqrt(var(thresholds(:,i)))/sigma;
    
    seventhcolumn(:,i) = thresholds(:,i);
    [a(i),index] = min(seventhcolumn(:,i));
    seventhcolumn(seventhcolumn == a(i)) = mean(thresholds(:,i));

    excludingbest = sqrt(var(seventhcolumn(:,i)))/sigma; 
    features(i,6) = includingbest;
    
end