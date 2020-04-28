%% inputs
N = 50; %number of trials
Nsubs = 99; %total number of plots
mu = 0.152853799; %visual task baseline mu across all subs
muSD = 0.041867006; %visual task mu SD
sigma = 0.051212612; %visual task sigma
sigmaSD = 0.040692789; %visual task sigma SD
% mu = 5.600273127; %mu aud
% muSD = 2.807327826; %muSD aud
% sigma = 2.656874132; %sigma aud
% sigmaSD = 1.679326588; %sigmaSD aud
sigmu = 0.47; %sigma mu ratio (not always used)
initial_stim = 0.5; %initial stimulus for the visual task
levels = [25:5:80];
groundTruth = zeros(1,Nsubs);

%% get real subject data
cd ../
cd AllData
listing = dir('*_ASR_1.mat');
y = datasample(1:Nsubs,length(listing),'Replace',false);
inds = [1:3:36];
z = randperm(length(listing));
for i = 1:length(listing)
    groundTruth(y(i)) = 2;
    clear AllData;
    close all;
    load(listing(z(i)).name);
    nums = [AllData{:,3}];
    threshtemp = nums(inds);
    
    %%plot
    figure();
    plot(levels(2:end),threshtemp(2:end),'*--', 'Color', [0, 0.4470, 0.7410]); hold on;
    plot(levels(1), threshtemp(1), '*', 'Color', [0, 0.4470, 0.7410]);
    ylim([0 0.5]);
    xticks(levels);
    xticklabels({'sham','30','35','40','45','50','55','60','65','70','75','80'});
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
    mutemp = normrnd(mu,muSD);
    sigmatemp = normrnd(sigma, sigmaSD);
    threshtemp = simulateSubject(mutemp, sigmatemp, levels, withSR, N, initial_stim);
    
    %%plot
    figure();
    plot(levels(2:end),threshtemp(2:end),'*--', 'Color', [0, 0.4470, 0.7410]); hold on;
    plot(levels(1), threshtemp(1), '*','Color', [0, 0.4470, 0.7410]);
    ylim([0 0.5]);
    xticks(levels);
    xticklabels({'sham','30','35','40','45','50','55','60','65','70','75','80'});
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