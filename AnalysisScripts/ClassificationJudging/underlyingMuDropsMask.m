function [underlyingRatios] = underlyingMuDropsMask(levels, masking_slope)

%make curve
q1=linspace(-3,10);
A1 = zeros(1,length(q1));
underlying_ratio = 10.5*[A1];
SRNoise = [q1]*10.5 - 6.8 + levels(4); 

%%add masking 15 db above threshold
ind = interp1(SRNoise,1:length(SRNoise),levels(4)+15,'nearest');
for i = ind:length(SRNoise)
    
%% Piecewise continuous Linear
     underlying_ratio(i) = underlying_ratio(i) + (SRNoise(i) - SRNoise(ind))*masking_slope;

end

% plot(SRNoise,underlying_ratio)
% ylim([-5 0])
% xlim([0 1])
% 
% % plot example curve
% underlying_ratio = underlying_ratio+5;
% figure();
% plot(SRNoise,underlying_ratio, '-');
% ylim([-5 15]);
% xlim([-10 45]);
% title('Threshold against SR Noise Level');
% set(gca,'YTick',[]);

ind = interp1(SRNoise,1:length(SRNoise),levels,'nearest');
underlyingRatios = underlying_ratio(ind);

end
