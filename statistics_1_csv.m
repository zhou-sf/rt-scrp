
%% This file helps to perform the experiments for PBFS using the dataset
% of Ku and Arthanari (2016) in the batch model

folderResults = 'Results/Experiments_1/';

%% We set the fillRate
fillRate = 0.67;

%% Time Limit 1 hour
timeLimit = 600;

%% The number of samples for evaluating the heuristics
nSamples = 5000;

disp(strcat('Experiment 1 with fillRate=',num2str(fillRate)));

Total_OBJ = zeros(24,13);
setOfInstances = 0;

outputFileName1=strcat(folderResults,'E_total_LL',num2str(fillRate*100),'.csv');
outputFileName2=strcat(folderResults,'E_total_SPFH',num2str(fillRate*100),'.csv');

fid1 = fopen(outputFileName1,'W');
fprintf(fid1,'%s,%s,%s,%s','S','T', 'fillRate', 'time');
for i=1:30
    fprintf(fid1,',%s',strcat('InitBlocking',num2str(i)));
end
fprintf(fid1,',%s','AvgBlocking');
for i=1:30
    fprintf(fid1,',%s',strcat('instance',num2str(i)));
end
fprintf(fid1,',%s\n','AvgInstance');

fid2 = fopen(outputFileName2,'W');
fprintf(fid2,'%s,%s,%s,%s','S','T', 'fillRate', 'time');
for i=1:30
    fprintf(fid2,',%s',strcat('InitBlocking',num2str(i)));
end
fprintf(fid2,',%s','AvgBlocking');
for i=1:30
    fprintf(fid2,',%s',strcat('instance',num2str(i)));
end
fprintf(fid2,',%s\n','AvgInstance');

%% We loop of each Bay size (5 to 10 stacks and 3 to 6 tiers)

for T=3:6
    for S=5:10
        
        OBJ1 = zeros(1,66);
        OBJ2 = zeros(1,66);
        
        OBJ1(1)=S;
        OBJ1(2)=T;
        OBJ1(3)=fillRate;
        
        OBJ2(1)=S;
        OBJ2(2)=T;
        OBJ2(3)=fillRate;
        
        total_LL=0;
        total_SPFH=0;
        instancesCount_LL=0;
        instancesCount_SPFH=0;
        
        str1='';
        str2='';
        str3='';
        %                     str6='';
        if S<10
            str1=strcat('0',num2str(S),'S_');
        else
            str1=strcat('',num2str(S),'S_');
        end
        if T<10
            str2=strcat('0',num2str(T),'T_');
        else
            str2=strcat('',num2str(T),'T_');
        end
        str3=strcat(num2str(fillRate*100),'Utilization_');
        
        outputFileName3 = strcat(folderResults, str1, str2, str3, 'LL.csv');
        outputFileName4 = strcat(folderResults, str1, str2, str3, 'SPFH.csv');
        %             if exist(outputFileName3)
        rawdata_LL = csvread(outputFileName3,1,0);
        t=rawdata_LL(:,3);        
        ibs_LL=rawdata_LL(:,2);
        rawdata_LL(:,[1,2,3])=[];
        relocs = sum(rawdata_LL,2);
        OBJ1(4)=max(t);
        for i=1:30
            OBJ1(i+4)=ibs_LL(i);
        end
        OBJ1(35)=sum(ibs_LL)/30;
        for i=1:30
            OBJ1(i+35)=relocs(i);
        end
        OBJ1(66)=sum(relocs)/30;
        %             end
        
        %             if exist(outputFileName4)
        rawdata_SPFH = csvread(outputFileName4,1,0);
        t=rawdata_SPFH(:,3);
        ibs_SPFH=rawdata_SPFH(:,2);
        rawdata_SPFH(:,[1,2,3])=[];
        relocs = sum(rawdata_SPFH,2);
        OBJ2(4)=max(t);
        for i=1:30
            OBJ2(i+4)=ibs_SPFH(i);
        end
        OBJ2(35)=sum(ibs_SPFH)/30;
        for i=1:30
            OBJ2(i+35)=relocs(i);
        end
        OBJ2(66)=sum(relocs)/30;
        %             end
        
        fprintf(fid1,'%d,%d,%d,%d',OBJ1(1),OBJ1(2),OBJ1(3),OBJ1(4));
        for i=1:30
            fprintf(fid1,',%d',OBJ1(i+4));
        end
        fprintf(fid1,',%d',OBJ1(35));
        for i=1:30
            fprintf(fid1,',%d',OBJ1(i+35));
        end
        fprintf(fid1,',%d\n',OBJ1(66));
        fprintf(fid2,'%d,%d,%d,%d',OBJ2(1),OBJ2(2),OBJ2(3),OBJ2(4));
        for i=1:30
            fprintf(fid2,',%d',OBJ2(i+4));
        end
        fprintf(fid2,',%d',OBJ2(35));
        for i=1:30
            fprintf(fid2,',%d',OBJ2(i+35));
        end
        fprintf(fid2,',%d\n',OBJ2(66));
    end
end
fclose(fid1);
fclose(fid2);


% outputFileName = strcat(folderResults, num2str(100*fillRate), 'Utilization_FinalResults.csv');
% fid = fopen(outputFileName,'W');
% fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','S','T','C','LL','SPFH');
% for r=1:24
%     fprintf(fid,'%g,%g,%g,%g,%g,%g\n',Total_OBJ(r,1),Total_OBJ(r,2),Total_OBJ(r,3),Total_OBJ(r,4),Total_OBJ(r,5),Total_OBJ(r,6));
% end
% fclose(fid);