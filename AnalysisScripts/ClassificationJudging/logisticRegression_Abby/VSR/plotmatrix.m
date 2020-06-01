function plotmatrix(features,SRvsNoSR)
     figure(2)
     A = features(:,[4 5]); % the columns 
     B = features(:,[6]); % the rows
     [~,ax] = gplotmatrix(A,B,SRvsNoSR(:)) % categorizing them based on if they have SR or not
     ax(1,1).YLabel.String = 'Standard Deviation of Thresholds';
     ax(1,1).XLabel.String = 'Ratio of Best to Sham';
     ax(1,2).XLabel.String = 'Avg of Best and Two Neighboring';
     title('100 Simulations with N=50')
end
