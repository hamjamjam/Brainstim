function [features,direction] = DirectionChanges(i,thresholds,features)

        direction(:,i) = diff(thresholds(:,i)); %First needed to find the difference between each threshold per simulation
        [m,n] = size(direction);
        directionchange = zeros(n,2); %initialize a matrix the correct size to fill
    
        for j = 1:(m-1) % determine if the direction has changed or not
            if (direction(j+1,i) > 0) && (direction(j,i) < 0) || (direction(j+1,i) < 0) && (direction(j,i) > 0)
                directionchange(j,1) = 1;
            else 
                directionchange(j,1) = 0;
            end
        end
        numofdirectionchanges = sum(directionchange(:,1)); %add up all of the ones to create a number of changes
        features(i,3) = numofdirectionchanges; %3rd column of 'features'
end