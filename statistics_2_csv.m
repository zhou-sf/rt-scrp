
%% This file helps to perform the experiments for PBFS using the dataset
% of Ku and Arthanari (2016) in the batch model

folderResults = 'Results/Experiments_2/';

%% We set the fillRate
fillRate = 0.5;

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
fprintf(fid1,'%s,%s,%s,%s,%s,%s','S','T', 'W', 'CW','maxTime','avgTime');
for i=1:30
    fprintf(fid1,',%s',strcat('InitBlocking',num2str(i)));
end
fprintf(fid1,',%s','AvgBlocking');
for i=1:30
    fprintf(fid1,',%s',strcat('instance',num2str(i)));
end
fprintf(fid1,',%s\n','AvgInstance');

fid2 = fopen(outputFileName2,'W');
fprintf(fid2,'%s,%s,%s,%s,%s,%s','S','T', 'W', 'CW','maxTime','avgTime');
for i=1:30
    fprintf(fid2,',%s',strcat('InitBlocking',num2str(i)));
end
fprintf(fid2,',%s','AvgBlocking');
for i=1:30
    fprintf(fid2,',%s',strcat('instance',num2str(i)));
end
fprintf(fid2,',%s\n','AvgInstance');

%% We loop of each Bay size (5 to 10 stacks and 3 to 6 tiers)
W=[8,10];
CW1=5:8;
CW2=4:7;
CW3=6:9;
CW4=5:7;
CW5=8:12;
CW6=8:11;
for T=8:10
    for S=10:12
        if (S==10 && T==10) || S==11 || (S==12 && T<10)
            continue;
        end
        
        for w=W
            if S==10 && T==8 && w==8
                CW=CW1;
            elseif S==10 && T==8 && w==10
                 CW=CW2;
             elseif S==10 && T==9 && w==8
                 CW=CW3;
             elseif S==10 && T==9 && w==10
                 CW=CW4;
             elseif S==12 && T==10 && w==8
                 CW=CW5;
             elseif S==12 && T==10 && w==10
                 CW=CW6;
            end
            
            if S==12 && (T==8 || T==9)
                continue;
            end
            for cw=CW
                OBJ1 = zeros(1,68);
                OBJ2 = zeros(1,68);
                
                OBJ1(1)=S;
                OBJ1(2)=T;
                OBJ1(3)=w;
                OBJ1(4)=cw;
                
                OBJ2(1)=S;
                OBJ2(2)=T;
                OBJ2(3)=w;
                OBJ2(4)=cw;      
                
                
                total_LL=0;
                total_SPFH=0;
                instancesCount_LL=0;
                instancesCount_SPFH=0;
                
                str1='';
                str2='';
                str3='';
                str4='';
                str5='';
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
                if w<10
                    str3=strcat('0',num2str(w),'W_');
                else
                    str3=strcat('',num2str(w),'W_');
                end
                if cw<10
                    str4=strcat('0',num2str(cw),'CW_');
                else
                    str4=strcat('',num2str(cw),'CW_');
                end
                str5='Utilization_';
                
                outputFileName3 = strcat(folderResults, str1, str2, str3, str4, str5, 'LL.csv');
                outputFileName4 = strcat(folderResults, str1, str2, str3, str4, str5, 'SPFH.csv');
                
                if exist(outputFileName3)
                    rawdata_LL = csvread(outputFileName3,1,0);
                    ib_LL=rawdata_LL(:,2);
                    t=rawdata_LL(:,3);
                    rawdata_LL(:,[1,2])=[];
                    relocs = sum(rawdata_LL,2);
                    
                    OBJ1(5)=max(t);
                    OBJ1(6)=sum(t)/30;
                    for i=1:30
                        OBJ1(i+6)=ib_LL(i);
                    end
                    OBJ1(37)=sum(ib_LL)/30;
                    for i=1:30
                        OBJ1(i+37)=relocs(i);
                    end
                    OBJ1(68)=sum(relocs)/30;
                end
                
                if exist(outputFileName4)
                    rawdata_SPFH = csvread(outputFileName4,1,0);
                    ib_SPFH=rawdata_SPFH(:,2);
                    t=rawdata_SPFH(:,3);
                    rawdata_SPFH(:,[1,2])=[];
                    relocs = sum(rawdata_SPFH,2);
                    
                    OBJ2(5)=max(t);                    
                    OBJ2(6)=sum(t)/30;
                    for i=1:30
                        OBJ2(i+6)=ib_SPFH(i);
                    end
                    OBJ2(37)=sum(ib_SPFH)/30;
                    for i=1:30
                        OBJ2(i+37)=relocs(i);
                    end
                    OBJ2(68)=sum(relocs)/30;
                end
                
                fprintf(fid1,'%d,%d,%d,%d,%d,%d',OBJ1(1),OBJ1(2),OBJ1(3),OBJ1(4),OBJ1(5),OBJ1(6));
                for i=1:30
                    fprintf(fid1,',%d',OBJ1(i+6));
                end
                fprintf(fid1,',%d',OBJ1(37));
                for i=1:30
                    fprintf(fid1,',%d',OBJ1(i+37));
                end
                fprintf(fid1,',%d\n',OBJ1(68));
                fprintf(fid2,'%d,%d,%d,%d,%d,%d',OBJ2(1),OBJ2(2),OBJ2(3),OBJ2(4),OBJ2(5),OBJ2(6));
                for i=1:30
                    fprintf(fid2,',%d',OBJ2(i+6));
                end
                fprintf(fid2,',%d',OBJ2(37));
                for i=1:30
                    fprintf(fid2,',%d',OBJ2(i+37));
                end
                fprintf(fid2,',%d\n',OBJ2(68));
            end
        end
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