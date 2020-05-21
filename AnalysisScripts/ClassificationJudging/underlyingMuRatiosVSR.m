function [underlyingRatios] = underlyingMuRatiosVSR(levels)

%%generate underlying SR curve

%input variables
lam = 4.2; %changes dip size
w=1.2; %changes dip size

%make curve
q1=linspace(-3,0);
A1 = ones(1,length(q1));
q2=linspace(0.01,10);
A0 = 1; %needs to be 1 for % imp.
r2 = lam*exp(-lam./(2.*q2.^2)); %intermediate calc for linspace of A as per q2
A2 = -A0.*(1./q2.^2).*(r2./(sqrt(4*r2 + w))); %linspace of A as per q2
A2 = 1.+A2;
underlying_ratio = [A1 A2];
SRNoise = [q1 q2]; 
SRNoise = SRNoise/3.75;
% plot(SRNoise,underlying_ratio)
% ylim([0 1])
% xlim([0 1])

%% plot example curve
% underlying_ratioplt = underlying_ratio*0.15;
% figure();
% plot(SRNoise,underlying_ratioplt, '-');
% ylim([0 0.5]);
% xlim([0 1]);
% title('Example');
% set(gca,'YTick',[]);

ind = interp1(SRNoise,1:length(SRNoise),levels,'nearest');
underlyingRatios = underlying_ratio(ind);
end
