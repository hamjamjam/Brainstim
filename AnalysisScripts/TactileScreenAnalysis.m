%% Tactile Task Analysis
clc;
clear;
close all;

% What subjects are we looking at?
subjects = [12];
% levels = [0:0.1:1];
levels = [0:0.1:1];
SRType =2;
for i = 1:length(subjects)
        % What subject are we looking at?
    subID = num2str(subjects(i));
    for j = 1:length(levels)
        
    figure;

    
    level = levels(j);
    
    % What file are we reading?
    if SRType == 2
    if level == 0
    fid = ['BSRA1_VSR_',subID,'_Tactile_0mA_0dB.xls'];
    elseif level == 1
       fid = ['BSRA1_VSR_',subID,'_Tactile_0mA_0dB.xls']; 
    else
        fid = ['BSRA1_VSR_',subID,'_Tactile_0p',num2str(floor(level*10)),'mA_0dB.xls'];
    end
    else
        fid = ['BSRA1_ASR_',subID','_Tactile_0mA_',num2str(level),'dB.xls'];
    end
    
    
    % What's the file path?
    filePath = ['RA1Data/',subID,'/'];
    
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
    X = fminsearch(@(X) two_int_fit_lapse(X, stim, cor, 0.06), [0 0.2 0.03]);
    
    % Get lambda, mu, and sigma
    lambda = X(1);
    mu = X(2);
    sigma = X(3);
    
    fprintf('Mu =    %4.3f\n   Sigma = %4.3f\n\n',mu,sigma);
    
    % Generate the psychometric curve
    x = linspace(0,1,400);
    y = 0.5 + (1 + 0.5 - 1 - lambda)*normcdf(x,mu,sigma);
    
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
titlestr = ['Tactile VSR Staircase, Subject ',subID,' ', num2str(level),' mA'];
title(titlestr);
xlabel('Trial');
ylabel('Stimulus');
grid minor;

%% Historgram of stim values
subplot(3,1,2);
hold on;
histogram(bins,16);
lowbins = sum(bins<=10);
hibins = sum(bins == 256);
titlestr = ['Histogram of Bin Values, bin<10 = ',num2str(lowbins),', bin 256 = ',num2str(hibins)];
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
titlestr = ['Tactile VSR Curve Fit, Subject ',subID,' ', num2str(level),' mA'];
title(titlestr);
xlabel('Stimulus');
ylabel('Probability of Correct Response');
grid on;
axis([0 1 0 1]);
    end
end