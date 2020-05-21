k  = 15;
correct = 0;

M = ones(1,length(Xtrain(i,:)));
M = [0.95 1 1.2 1.3 1.2];
Xtrain_KNN = Xtrain;
Xtest_KNN = Xtest;
for i = 1:length(M)
    M(i) = M(i)/mean(Xtrain(:,i));
    Xtrain_KNN(:,i) = Xtrain(:,i)*M(i);
    Xtest_KNN(:,i) = Xtest(:,i)*M(i);
end

for i = 1:length(Ytest)
    predictedClassification(i) = KNN(Xtrain_KNN, Ytrain, Xtest_KNN(i,:), k);
    if predictedClassification(i) == Ytest(i)
        correct = correct+1;
    end
end

confusion = confusionmat(Ytest, predictedClassification)
TrueNeg = confusion(1,1);
FalsePos = confusion(1,2);
FalseNeg = confusion(2,1);
TruePos = confusion(2,2);

accuracy = (TrueNeg + TruePos)/length(Ytest)
TruePosRate = TruePos/ActualYes;
TrueNegRate = TrueNeg/ActualNo;
ActualNo = FalseNeg+TruePos;
ActualYes = TrueNeg+FalsePos;

    