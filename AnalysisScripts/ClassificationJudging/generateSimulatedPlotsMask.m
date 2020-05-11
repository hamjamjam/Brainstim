%% inputs
N = 100; %number of trials
Nsubs = 99; %total number of plots

masking_slope = 0.6;

mu = 5.600273127; %mu aud
muSD = 2.807327826; %muSD aud
sigma = 2.656874132; %sigma aud
sigmaSD = 1.679326588; %sigmaSD aud
sigmu = 0.47; %sigma mu ratio (not always used)
initial_stim = 0.5; %initial stimulus for the visual task
groundTruth = zeros(1,Nsubs);


%% simulate
for i = 1:Nsubs
    
    close all;
    % get simulated thresholds
    withSR = round(rand());
    groundTruth(i) = withSR;
    mutemp = round(normrnd(mu,muSD),1);
    sigmatemp = normrnd(sigma, sigmaSD);
    levels = [mutemp-15:5:mutemp+20 40];
    threshtemp = simulateSubjectMask(mutemp, sigmatemp, levels, withSR, N, initial_stim, masking_slope);
    
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