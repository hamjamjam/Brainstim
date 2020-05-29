function [features] = avg_of_best_and_2_neighboring(i,thresholds,sham,features)
    if min(thresholds(2:end-1,i)) < sham(i)
            [m,n] = min(thresholds(1:end-1,i));
            minthresholds = [ thresholds(n,i), thresholds(n-1,i),  thresholds(n+1,i)];                    
        elseif min(thresholds)==sham(i)
            minthresholds = [ thresholds(1,i), thresholds(2,i),  thresholds(3,i)];
        else
            minthresholds = [ thresholds(end,i), thresholds(end-1,i),  thresholds(end-2,i)]; 
        end
        avgofbest = mean(minthresholds)/sham(i); 
        features(i,5) = avgofbest;
end