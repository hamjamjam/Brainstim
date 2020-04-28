%% Tactile Task Analysis
clc;
clear;
close all;

%% Globals
mu_guess=0.1;
sigma_guess=0.1;

% What subjects are we looking at?
subjectsASR = [1, 2, 5, 7, 10];
subjectsVSR = [1, 2, 5, 7, 8];

subID = '5';
cd ../
cd SubjectData
cd(subID)
listing = dir('*Tactile*');
cd data
cd ../
cd ../
cd AnalysisScripts

for i = 1:length(listing)
    figure;
    % What file are we reading?
    %fid = ['BSRA1_VSR_',subID,'_Tactile_0mA_0dB.xls'];
    fid = listing(i).name;
    
    % What's the file path?
    filePath = ['../SubjectData/',subID,'/'];
    
    % Generate the full file name
    file2read = [filePath,fid];
    
    % Get the data
    data = xlsread(file2read);
    
    % Extract stimulus values
    stim = data(:,2);
    
    % Extract correct data
    cor = data(:,4);
    
    % Get the bin numbers
    bins = stim*256;
    
    % Fit the threshold
    X = fminsearch(@(X) two_int_fit_simp(X, stim, cor), [mu_guess, sigma_guess]);
    
    % Get lambda, mu, and sigma
    %lambda = X(1);
    mu = X(1);
    sigma = X(2);
    
    fprintf('Subject %d:\n   Mu =    %4.3f\n   Sigma = %4.3f\n\n',subID,mu,sigma);
    
    % Generate the psychometric curve
    x = linspace(0,1,400);
    y = 0.5 + 0.5*cdf('normal',x,mu, sigma);
    
    %% The staircase (S)
subplot(3,1,1); hold on;
for i = 1:length(stim)
    if cor(i)
        plot(i,stim(i),'ro');
    else
        plot(i,stim(i), 'rx');
    end
end
hold off;

%     plot((1:length(stim)),stim,'r.','MarkerSize',20);
titlestr = ['Tactile ', fid(7:9), ' at ', fid(end-12:end-4), ' Staircase, Subject ',subID];
title(titlestr);
xlabel('Trial');
ylabel('Stimulus');
grid minor;

%% Historgram of stim values
subplot(3,1,2);
hold on;
histogram(bins,16);
lowbins = sum(bins<=10);
titlestr = ['Histogram of Bin Values, Trials below bin 10 = ',num2str(lowbins)];
title(titlestr);
xlabel('Bin Value');
ylabel('Number of Trials');

lowbins = sum(bins <=10);
axis([0 256 0 50]);


%% The bubble (B)
subplot(3,1,3);
hold on;
plot(x,y,'b','LineWidth',1.25);
% Average the Y outcomes at each unique X value
[Xunique, ix, ixu] = unique(stim);
Punique = zeros(1,length(Xunique));
Lunique = zeros(1,length(Xunique));
for k = 1:length(Xunique)
    YatXunique = cor(ixu == k); % find the Y outcomes for the jth unique X value
    Lunique(k) = length(YatXunique);    % find the number of trials for the ith unique X value
    Punique(k) = mean(YatXunique);  % find the probability at the ith unique X value
end
for k = 1:length(Xunique)
    % find the marker size with a max of 12 and a min of 4
    if max(Lunique) == min(Lunique)
        msize = 8;
        
    else
        msize = (12-4)/(max(Lunique)-min(Lunique)) * (Lunique(k)-min(Lunique)) + 4;
    end
    plot(Xunique(k), Punique(k), 'ko', 'MarkerSize', msize);
end

mu = round(mu,4)
sigma = round(sigma, 4)
titlestr = ['Tactile ', fid(7:9), ' at ', fid(end-12:end-4), ' Curve Fit, Subject ',subID, ' mu:', num2str(mu), ' sig:', num2str(sigma)];
title(titlestr);
xlabel('Stimulus');
ylabel('Probability of Correct Response');
grid on;
axis([0 1 0.5 1]);
    
cd ../
cd SubjectData
cd(subID)
print(fid(1:end-4), '-dpdf');
close all;
cd ../
cd ../
cd AnalysisScripts

end

cd ../
cd SubjectData
cd(subID)
listing = dir('*.pdf');
cd ../
cd ../
cd AnalysisScripts

titlestr = ['All_Tactile_Curves_Subject_', subID, '.pdf'];
for i =1:length(listing)
    listing(i).name = [filePath,listing(i).name];
end

append_pdfs(titlestr, listing.name)

