%% Simple implementation of K nearest neighbours
% inputs: Xtrain, Ytrain, newObservation, k
% Xtrain = features training set matrix
% Ytrain = classifications training set vector
% newObservation = vector containing features of the new observation
% k = number of nearest neighbours to comapre to
% This is written to use Euclidian Distance. Additional distance algorithms
% can be used
% Outputs classification of same type as each element of Ytrain

function [classification] = KNN(Xtrain,Ytrain, newObservation, k)
    distances = zeros(1,length(Ytrain));
    for i = 1:length(Ytrain)
        distances(i) = EuclidianDistance(Xtrain(i,:),newObservation);
    end
   
    [B,I] = mink(distances,k);
    
    classification = mode(Ytrain(I));
end

function [distance] = EuclidianDistance(A,B)
    distance = 0;
    for i = 1:length(A)
        distance = distance + (A(i)-B(i))^2;
    end
    
    distance = sqrt(distance);
end