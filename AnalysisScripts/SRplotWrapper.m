B = [9 2 2];

for i = 1:length(B(:,1))
    close all;
    SRClassPlot(B(i,:))
end

listing = dir('SRPlots/*.pdf');
filePath = 'SRPlots/';
for i =1:length(listing)
    listing(i).name = [filePath,listing(i).name];
end

titlestr = 'allSRCurves.pdf';
append_pdfs(titlestr, listing.name)

