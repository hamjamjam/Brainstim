function [features] = thresholds_above_sham(i,thresholds,features,sham)
%         sham(i) = thresholds(1,i);
        threshabovesham = sum(thresholds(2:end,:) > sham);
        features(i,2) = threshabovesham;
end