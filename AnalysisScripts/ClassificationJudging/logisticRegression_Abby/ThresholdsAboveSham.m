function [features] = ThresholdsAboveSham(i,thresholds,features,sham)

        threshabovesham = sum(thresholds(2:end,:) > sham); %Find the number of thresholds above sham
        features(i,2) = threshabovesham; %Put in the 2nd column of 'features'
        
end