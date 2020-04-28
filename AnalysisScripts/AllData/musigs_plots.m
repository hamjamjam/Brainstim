SRtype = 'ASR';
task = 'both';

name = ['*_' SRtype '_' task '.mat'];
%name = ['*_' task '.mat'];
%name = ['*' SRtype '*.mat'];
listing = dir(name);

allmus = [];
allsigs = [];
avgmus = zeros(length(listing),1);
avgsigs = zeros(length(listing),1);
shammus = zeros(length(listing),1);
shamsigs = zeros(length(listing),1);

bstSRlv = zeros(length(listing),1);
scndbstSRlv = zeros(length(listing),1);
for i = 1:length(listing)
    clear AllData;
    close all;
    load(listing(i).name);
    nums = [AllData{:,3}];
    indsMU = [1:3:length(nums)];
    indsSD = [2:3:length(nums)];
    indsSR = [3:3:length(nums)];
    mus = nums(indsMU);
    sigs = nums(indsSD);
    sigs =  log(sigs);
    SRs = nums(indsSR);
    avgmus(i) = mean(mus);
    avgsigs(i) = mean(sigs);
    shammus(i) = mus(1);
    shamsigs(i) = sigs(1);
    allmus = [allmus mus];
    allsigs = [allsigs sigs];
    [B,I] = sort(mus,'ascend');
    bstSRlv(i) = SRs(I(1));
    scndbstSRlv(i) = SRs(I(2));
end

titlestr = [SRtype ' on task ' task ' Best SR Levels'];

figure();
subplot(2,1,1);
hist(bstSRlv,11);
xlabel('best SR Level');
ylabel('Frequency');
title(titlestr);

subplot(2,1,2);
hist([bstSRlv; scndbstSRlv],11);
xlabel('best and 2nd best SR Levels');
ylabel('Frequency');
title('Best and 2nd Best SR Levels');

print(titlestr, '-dpdf')


titlestr = [SRtype ' on task ' task ' , averaged per subject'];
figure()
subplot(3,1,1);
plot(avgmus,avgsigs, '*');
title(titlestr)
xlabel('average mus')
ylabel('average ln(sigmas)')

subplot(3,1,2);
hist(avgmus);
xlabel('mu');
ylabel('frequency');
title('histogram of mu, averaged per subject');

subplot(3,1,3);
hist(avgsigs);
xlabel('ln(sigma)');
ylabel('frequency');
title('histogram of ln(sigma), averaged per subject');

print(titlestr, '-dpdf')

titlestr = [SRtype ' on task ' task ' , shams'];

figure();
subplot(3,1,1);
plot(shammus, shamsigs, '*');
title(titlestr)
xlabel('sham mus')
ylabel('sham ln(sigmas)')

subplot(3,1,2);
hist(shammus);
xlabel('mu');
ylabel('frequency');
title('histogram of mu, shams');

subplot(3,1,3);
hist(shamsigs);
xlabel('ln(sigma)');
ylabel('frequency');
title('histogram of ln(sigma), sham');

print(titlestr, '-dpdf')

titlestr = [SRtype ' on task ' task ' , all'];

figure();
subplot(3,1,1);
plot(allmus, allsigs, '*');
title(titlestr)
xlabel('all mus')
ylabel('all ln(sigmas)')

subplot(3,1,2);
hist(allmus);
xlabel('mu');
ylabel('frequency');
title('histogram of mu, all');

subplot(3,1,3);
hist(allsigs);
xlabel('ln(sigma)');
ylabel('frequency');
title('histogram of ln(sigma), all');

print(titlestr, '-dpdf')

cd ../
listing = dir('AllData\*all.pdf');
for i = 1:length(listing)
    listing(i).name = ['AllData\' listing(i).name];
end
append_pdfs('AllMuLnSigAnalysis.pdf', listing.name)