
%% This file helps to perform the experiments for PBFS using the dataset
% of Ku and Arthanari (2016) in the batch model

folderResults = 'Results/Experiments_2/';

%% We set the fillRate
fillRate = 0.67;

%% Time Limit 1 hour
timeLimit = 600;

%% The number of samples for evaluating the heuristics
nSamples = 5000;

disp(strcat('Experiment 1 with fillRate=',num2str(fillRate)));

Total_OBJ = zeros(24,13);
setOfInstances = 0;

outputFileName1=strcat(folderResults,'total_LL',num2str(fillRate*100),'.csv');
outputFileName2=strcat(folderResults,'total_SPFH',num2str(fillRate*100),'.csv');

fid1 = fopen(outputFileName1,'W');
fprintf(fid1,'%s,%s,%s,%s','S','T', 'W', 'CW');
for i=1:30
    fprintf(fid1,',%s',strcat('instance',num2str(i)));
end
fprintf(fid1,',%s\n','Avg');

fid2 = fopen(outputFileName2,'W');
fprintf(fid2,'%s,%s,%s,%s','S','T', 'W', 'CW');
for i=1:30
    fprintf(fid2,',%s',strcat('instance',num2str(i)));
end
fprintf(fid2,',%s\n','Avg');

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
            
%             if S==12 && (T==8 || T==9)
%                 continue;
%             end
            for cw=CW
                OBJ1 = zeros(1,35);
                OBJ2 = zeros(1,35);
                
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
                instance = 1;
                while instance <= 30
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
                    if instance<10
                        str5=strcat('0',num2str(instance),'I_');
                    else
                        str5=strcat('',num2str(instance),'I_');
                    end
                    
                    outputFileName3 = strcat(folderResults, str1, str2, str3, str4, str5, 'Actions_LL.txt');
                    outputFileName4 = strcat(folderResults, str1, str2, str3, str4, str5, 'Actions_SPFH.txt');
                    
                    if exist(outputFileName3)
                        outputFileName3
                        actions_LL = importdata(outputFileName3);
                        [rowll,~]=size(actions_LL);
                        relocLL=0;
                        for i=1:rowll
                            act=actions_LL{i};
                            act=act(2:end-1);
                            cols=split(act,',');
                            if (str2num(cols{3}))~=0
                                relocLL=relocLL+1;
                            end
                        end
                        OBJ1(instance+4)=relocLL;
                        total_LL=total_LL+relocLL;
                        instancesCount_LL=instancesCount_LL+1;
                    end
                    
                    if exist(outputFileName4)
                        outputFileName4
                        actions_SPFH = importdata(outputFileName4);
                        [rowspfh,~]=size(actions_SPFH);
                        relocSPFH=0;
                        for i=1:rowspfh
                            act=actions_SPFH{i};
                            act=act(2:end-1);
                            cols=split(act,',');
                            if (str2num(cols{3}))~=0
                                relocSPFH=relocSPFH+1;
                            end
                        end
                        OBJ2(instance+4)=relocSPFH;
                        total_SPFH=total_SPFH+relocSPFH;
                        instancesCount_SPFH=instancesCount_SPFH+1;
                    end
                    instance = instance + 1;
                end
                OBJ1(35)=total_LL/instancesCount_LL;
                OBJ2(35)=total_SPFH/instancesCount_SPFH;
                
                fprintf(fid1,'%d,%d,%d,%d',OBJ1(1),OBJ1(2),OBJ1(3),OBJ1(4));
                for i=1:30
                    fprintf(fid1,',%d',OBJ1(i+4));
                end
                fprintf(fid1,',%d\n',OBJ1(35));
                fprintf(fid2,'%d,%d,%d,%d',OBJ2(1),OBJ2(2),OBJ2(3),OBJ2(4));
                for i=1:30
                    fprintf(fid2,',%d',OBJ2(i+4));
                end
                fprintf(fid2,',%d\n',OBJ2(35));
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