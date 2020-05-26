function [Rval,Pval,Pval2,R,P,idx1,R2,P2,idx2,s,YPredict,Ytest] = correlation_coefficient(features,sham,SRvsNoSR,Xtest,YPredicted,Ytest)

%% Setting up a matrix that can be indexed later

HelpfulMatrix{1,1} = features(:,2);
HelpfulMatrix{1,2} = features(:,3);
HelpfulMatrix{2,1} = features(:,2);
HelpfulMatrix{2,2} = features(:,4);
HelpfulMatrix{3,1} = features(:,2);
HelpfulMatrix{3,2} = features(:,5);
HelpfulMatrix{4,1} = features(:,2);
HelpfulMatrix{4,2} = features(:,6);

HelpfulMatrix{5,1} = features(:,3);
HelpfulMatrix{5,2} = features(:,4);
HelpfulMatrix{6,1} = features(:,3);
HelpfulMatrix{6,2} = features(:,5);
HelpfulMatrix{7,1} = features(:,3);
HelpfulMatrix{7,2} = features(:,6);

HelpfulMatrix{8,1} = features(:,4);
HelpfulMatrix{8,2} = features(:,5);
HelpfulMatrix{9,1} = features(:,4);
HelpfulMatrix{9,2} = features(:,6);

HelpfulMatrix{10,1} = features(:,5);
HelpfulMatrix{10,2} = features(:,6);

%% Finding correlations between features

% Correlation between 2nd feature and all others
[R{1},P{1}] = corrcoef(features(:,2),features(:,3)); 
[R{2},P{2}] = corrcoef(features(:,2),features(:,4)); %significant
[R{3},P{3}] = corrcoef(features(:,2),features(:,5)); %significant
[R{4},P{4}] = corrcoef(features(:,2),features(:,6));


% Correlation between 3rd feature and all others
[R{5},P{5}] = corrcoef(features(:,3),features(:,4));
[R{6},P{6}] = corrcoef(features(:,3),features(:,5));
[R{7},P{7}] = corrcoef(features(:,3),features(:,6)); %significant

% Correlation between 4th feature and all others
[R{8},P{8}] = corrcoef(features(:,4),features(:,5)); %significant
[R{9},P{9}] = corrcoef(features(:,4),features(:,6)); %significant


% Correlation between 5th feature and all others
[R{10},P{10}] = corrcoef(features(:,5),features(:,6)); %significant

% R output is a symmetric matrix so only taking the most important value
% from each. Looks like (1,R;R,1)
Rval(1) = R{1}(1,2);
Rval(2) = R{2}(1,2);
Rval(3) = R{3}(1,2);
Rval(4) = R{3}(1,2);
Rval(5) = R{5}(1,2);
Rval(6) = R{6}(1,2);
Rval(7) = R{7}(1,2);
Rval(8) = R{8}(1,2);
Rval(9) = R{9}(1,2);
Rval(10) = R{10}(1,2);

% P is a symmetric matrix also, Looks like (1,P;P,1)
Pval(1) = P{1}(1,2);
Pval(2) = P{2}(1,2);
Pval(3) = P{3}(1,2);
Pval(4) = P{4}(1,2);
Pval(5) = P{5}(1,2);
Pval(6) = P{6}(1,2);
Pval(7) = P{7}(1,2);
Pval(8) = P{8}(1,2);
Pval(9) = P{9}(1,2);
Pval(10) = P{10}(1,2);

%% Indexing significant correlations
for i = 1: length(Pval)
    [idx1,num1] = find(Pval(:) < 0.05);
end

%% Plotting the correlated features
% for i = 1:length(idx1)
%  figure()
%        A = HelpfulMatrix{idx1(i),1}; % the columns 
%        B = HelpfulMatrix{idx1(i),2}; % the rows
%        [~,ax] = gplotmatrix(A,B,SRvsNoSR(:)); % categorizing them based on if they have SR or not
%        format short g
% %        str1 = sprintf('feature %.f',features(:,HelpfulMatrix{idx1(i),1}));
% %        str2 = sprintf('feature %.f',features(:,HelpfulMatrix{features(i),2}))
% % % title(str,'FontSize',12);
% %        ax(1,1).YLabel = str1;
% %        ax(1,1).XLabel = str2;
%        lsline(ax)
% end

%% Correlation between SR and Each Feature
s = string(YPredicted);
YPredict = double(s);
s = string(Ytest);
Ytest = double(s);
%if SRvsNoSR == 1
    for i = 1:5
        [R2{i},P2{i}] = corrcoef(Ytest(:),Xtest(:,i));
    end

    Pval2(1) = P2{1}(1,2);
    Pval2(2) = P2{2}(1,2);
    Pval2(3) = P2{3}(1,2);
    Pval2(4) = P2{4}(1,2);
    Pval2(5) = P2{5}(1,2);
    %Pval2(6) = P2{6}(1,2);

% Indexing significant correlations
    for i = 1: 5   
        [idx2,num2] = find(Pval2(:) < 0.05);
    end
end