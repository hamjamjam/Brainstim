function [features,direction,m,n,directionchange] = direction_changes(i,thresholds,features)

        direction(:,i) = diff(thresholds(:,i));
        [m,n] = size(direction);
        directionchange = zeros(length(direction),2);
    
        for j = 1:(m-1)
            if (direction(j+1,i) > 0) && (direction(j,i) < 0) || (direction(j+1,i) < 0) && (direction(j,i) > 0)
                directionchange(j,1) = 1;
            else 
                directionchange(j,1) = 0;
            end
        end
        numofdirectionchanges = sum(directionchange(:,1));
        features(i,3) = numofdirectionchanges;
end