function [numberOfThresholdsAboveSham] = ThresholdsAboveSham(i,thresholds,sham)
        %if thresholds(i+1
        numberOfThresholdsAboveSham(i) = sum(thresholds(2:end,:) > sham); %Find the number of thresholds above sham
        
        
end