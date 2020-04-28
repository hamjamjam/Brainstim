%subnum
%testype
%1 = vis 2 = aud 3 = tac
%SR type
%1 = ASR 2 = VSR

%x 2 1 to be done later (ASR aud)


A = [
    2 2 1
    ];


for i = 1
    subID = A(i,1);
    TestType = A(i,2);
    SRType = A(i,3);
    if SRType == 1
        SRName = 'ASR';
        levels = [0 3:5:33 40];
    else
        SRName = 'VSR';
        levels = [0:0.1:1];
    end
    
    levels = [0 3:5:33 40];
    
    [AllData]=FindThresholds(subID,TestType,SRType,levels);
    
    if subID < 10
        filename = ['0' num2str(subID) '_' SRName '_' num2str(TestType) '.mat'];
    else
        filename = [num2str(subID) '_' SRName '_' num2str(TestType) '.mat'];
    end
    
    save(filename, 'AllData');
end
