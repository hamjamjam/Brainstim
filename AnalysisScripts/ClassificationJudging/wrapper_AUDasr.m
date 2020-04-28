%% inputs
N = 100; %number of trials
Nsubs = 99; %total number of plots

mu = 5.600273127; %mu aud
muSD = 2.807327826; %muSD aud
sigma = 2.656874132; %sigma aud
sigmaSD = 1.679326588; %sigmaSD aud
sigmu = 0.47; %sigma mu ratio (not always used)
initial_stim = 0.5; %initial stimulus for the visual task
levels = [25:5:80];
groundTruth = zeros(1,Nsubs);

%% get real subject data
cd ../
cd AllData
listing = dir('*_ASR_2.mat');
y = datasample(1:Nsubs,length(listing),'Replace',false);

z = randperm(length(listing));
for i = 1:length(listing)
    groundTruth(y(i)) = 2;
    clear AllData;
    close all;
    load(listing(z(i)).name);
    nums = [AllData{:,3}];
    inds = [1:3:length(nums)];
    indslev = [6:3:length(nums)];
    threshtemp = nums(inds);
    levels = nums(indslev);
    levels = [levels(1)-5 levels];
    
    for k = 1:length(levels)
        if k == 1
            ticklabs(k) = {'sham'};
        else
            ticklabs(k) = {num2str(levels(k))};
        end
    end
    
    %%plot
    figure();
    plot(levels(2:end),threshtemp(2:end),'*--', 'Color', [0, 0.4470, 0.7410]); hold on;
    plot(levels(1), threshtemp(1), '*', 'Color', [0, 0.4470, 0.7410]);
    ylim([-5 20]);
    xlim([-15 40]);
    xticks(levels);
    xticklabels(ticklabs);
    title(num2str(y(i)));
    set(gca,'YTick',[]);
    
    %save as PDF
    if y(i) < 10
        filename = ['0' num2str(y(i))];
    else
        filename = num2str(y(i));
    end
    cd ../
    cd ClassificationJudging
    cd classPDFs
    print(filename, '-dpdf');
    cd ../
    cd ../
    cd AllData
end
cd ../
cd ClassificationJudging

%% simulate
for i = 1:Nsubs
    if ismember(i,y)
        continue
    end
    
    close all;
    % get simulated thresholds
    withSR = round(rand());
    groundTruth(i) = withSR;
    mutemp = round(normrnd(mu,muSD),1);
    sigmatemp = normrnd(sigma, sigmaSD);
    levels = [mutemp-15:5:mutemp+20 40];
    threshtemp = simulateSubjectMask(mutemp, sigmatemp, levels, withSR, N, initial_stim);
    
    %%plot
    for k = 1:length(levels)
        if k == 1
            ticklabs(k) = {'sham'};
        else
            ticklabs(k) = {num2str(levels(k))};
        end
    end
    
    figure();
    plot(levels(2:end),threshtemp(2:end),'*--', 'Color', [0, 0.4470, 0.7410]); hold on;
    plot(levels(1), threshtemp(1), '*', 'Color', [0, 0.4470, 0.7410]);
    ylim([-5 20]);
    xlim([-15 40]);
    xticks(levels);
    xticklabels(ticklabs);
    title(num2str(i));
    set(gca,'YTick',[]);
    
    %save as PDF
    if i < 10
        filename = ['0' num2str(i)];
    else
        filename = num2str(i);
    end
    cd classPDFs
    print(filename, '-dpdf');
    cd ../
    
end



%% compile book
titlestr = ['ClassificationBook.pdf'];
cd classPDFs
listing = dir('*.pdf');
append_pdfs(titlestr, listing.name)

%% save Ground Truths
plotNo = [1:Nsubs];
output = [plotNo;groundTruth]';
xlswrite('groundTruth.xls',output,'groundTruth');
cd ../