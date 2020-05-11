function [underlyingRatios] = underlyingMuDropsASRaud(levels, masking_slope)

%%input variables
lam = 4.2; %changes dip size
w=1.2; %changes dip size
%make curve
q1=linspace(-3,0);
A1 = zeros(1,length(q1));
q2=linspace(0.01,10);
A0 = 1; %needs to be 1 for % imp.
r2 = lam*exp(-lam./(2.*q2.^2)); %intermediate calc for linspace of A as per q2
A2 = -A0.*(1./q2.^2).*(r2./(sqrt(4*r2 + w))); %linspace of A as per q2
underlying_ratio = 10.5*[A1 A2];
SRNoise = [q1 q2]*10.5 - 6.8 + levels(4); 

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
% plot example curve
underlying_ratio = underlying_ratio+5;
figure();
plot(SRNoise,underlying_ratio, '-');
ylim([-5 15]);
xlim([-10 45]);
title('Threshold against SR noise level');
set(gca,'YTick',[]);

ind = interp1(SRNoise,1:length(SRNoise),levels,'nearest');
underlyingRatios = underlying_ratio(ind);

end
