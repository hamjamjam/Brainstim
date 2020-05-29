function subplotSR(thresholds,i,levels,withSR)
%this is the SR plot for the subject we just simulated!
         figure(1);
         hold on
         subplot(2, 5 ,(i)); % This needs to be changed depending on how many simulations are run
         plot(levels, thresholds(:,i),'*--');
         ylim([0 0.5]); %making it look nicer
         xticks(levels);
         xlabel('SR Noise Level (mA)');
         ylabel('Visual Contrast Threshold');
         if withSR == 1
             title('Simulated Subject with SR');
         else
             title('Simulated Subject without SR');
         end