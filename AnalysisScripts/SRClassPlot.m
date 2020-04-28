% Callable SR Analysis Function
% Created by Sage Sherman, modified by Jamie Voros
% Also commented by Sage Sherman, sorry lol
% Last edited 69/69

function SRClassPlot(A)
subID = A(1);
TestType = A(2);
SRType = A(3);
%% Housekeeping and defining

%% Assign Variables (change code to define levels) and extract information
switch TestType
    case 1 % define information for visual test
        if SRType == 1
            levels = [0 30:5:80];
            PlotTitle = ' ASR Visual Task'; xTitle = 'ASR Level, dB'; yTitle = 'Contrast Threshold';
        elseif SRType == 2
            levels = [0:.1:1];
            PlotTitle = ' VSR Visual Task'; xTitle = 'VSR Level, mA'; yTitle = 'Contrast Threshold';
        else
        end
    case 2 % define information for auditory task
        if SRType == 1
            levels = [0 -2:5:28 40];
            PlotTitle = ' ASR Auditory Task'; xTitle = 'ASR Level, dB'; yTitle = 'Auditory Threshold, dB';
        elseif SRType == 2
            levels = [0:.1:1];
            PlotTitle = ' VSR Auditory Task'; xTitle = 'VSR Level, mA'; yTitle = 'Auditory Threshold, dB';
        else
        end
    case 3 % define information for tactile task
        if SRType == 1
            levels = [0 30:5:80];
            PlotTitle = ' ASR Tactile Task'; xTitle = 'ASR Level, dB'; yTitle = 'Tactile Threshold, mm';
        elseif SRType == 2
            levels = [0:.1:1];
            PlotTitle = ' VSR Tactile Task'; xTitle = 'VSR Level, mA'; yTitle = 'Tactile Threshold, mm';
        else
        end
    case 4 % define information for vestibular task
        if SRType == 1
            levels = [0 30:5:80];
            PlotTitle = ' ASR Vestibular Task'; xTitle = 'ASR Level, dB'; yTitle = 'Vestibular Threshold, deg';
        elseif SRType == 2
            levels = [0:.1:1];
            PlotTitle = ' VSR Vestibular Task'; xTitle = 'VSR Level, mA'; yTitle = 'Vestibular Threshold, deg';
        else
        end
end

[AllData]=FindThresholds(subID,TestType,SRType,levels);

%% Plot Results
PlotDataClass(AllData,subID,TestType,SRType,levels,PlotTitle,xTitle,yTitle,0);
fname = ['SRPlots/' num2str(subID) PlotTitle ' Binary, Jack'];
print(fname, '-dpdf');

end
