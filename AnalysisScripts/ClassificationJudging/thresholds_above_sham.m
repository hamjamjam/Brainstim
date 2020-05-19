function [features] = thresholds_above_sham(thresholds,sham)
        %sham(i) = thresholds(1,i);
        features(i,2) = sum(thresholds(2:end,:) > sham);
end