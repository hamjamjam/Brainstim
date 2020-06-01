function [avgOfBestand2Neighboring] = AvgBestand2NeighboringVSR(i,thresholds,sham)

    if min(thresholds(2:end-1,i)) < sham(i) %if the min threshold value is below sham
            [m,n] = min(thresholds(1:end-1,i)); %index its location
            minthresholds = [ thresholds(n,i), thresholds(n-1,i),  thresholds(n+1,i)]; %array of that lowest value and its two neighbors                    
        
    elseif min(thresholds)==sham(i) %or if the min threshold value is sham
            minthresholds = [ thresholds(1,i), thresholds(2,i),  thresholds(3,i)]; %array of first 3 thresholds
        
    else %if the last point is the lowest
            minthresholds = [ thresholds(end,i), thresholds(end-1,i),  thresholds(end-2,i)]; %array of the last 3 thresholds
        
    end
        avgOfBestand2Neighboring(i) = mean(minthresholds)/sham(i); %find average of each array created
       
        
end