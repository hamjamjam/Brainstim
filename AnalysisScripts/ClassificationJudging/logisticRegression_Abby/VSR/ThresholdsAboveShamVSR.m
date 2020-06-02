function [numberOfThresholdsAboveSham] = ThresholdsAboveShamVSR(i,thresholds,sham)

        numberOfThresholdsAboveSham(i) = sum(thresholds(2:end,:) > sham); %Find the number of thresholds above sham
        
        
end