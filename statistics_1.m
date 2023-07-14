
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

outputFileName1=strcat(folderResults,'total_LL',num2str(fillRate*100),'.csv');
outputFileName2=strcat(folderResults,'total_SPFH',num2str(fillRate*100),'.csv');

fid1 = fopen(outputFileName1,'W');
fprintf(fid1,'%s,%s,%s','S','T', 'fillRate');
for i=1:30
    fprintf(fid1,',%s',strcat('instance',num2str(i)));
end
fprintf(fid1,',%s\n','Avg');

fid2 = fopen(outputFileName2,'W');
fprintf(fid2,'%s,%s,%s','S','T', 'fillRate');
for i=1:30
    fprintf(fid2,',%s',strcat('instance',num2str(i)));
end
fprintf(fid2,',%s\n','Avg');

%% We loop of each Bay size (5 to 10 stacks and 3 to 6 tiers)
for T=3:6
    for S=5:10
        OBJ1 = zeros(1,34);
        OBJ2 = zeros(1,34);    
        
        OBJ1(1)=S;
        OBJ1(2)=T;
        OBJ1(3)=fillRate;
        
        OBJ2(1)=S;
        OBJ2(2)=T;
        OBJ2(3)=fillRate;
        
        total_LL=0;
        total_SPFH=0;
%% Each bay-size/fillRate has 30 instances. For each of them we use our new
% optimal Algorithm and a similar algorithm than Ku et Arthanaris with the
% projection method
% We solve until both methods do not work
        instance = 1;
        while instance <= 30
            
            if S < 10
                if instance<10
                    outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(instance),'I_',num2str(100*fillRate), 'Actions_LL.txt');
                    outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(instance),'I_',num2str(100*fillRate), 'Actions_SPFH.txt');
                else
                    outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(instance),'I_',num2str(100*fillRate), 'Actions_LL.txt');
                    outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(instance),'I_',num2str(100*fillRate), 'Actions_SPFH.txt');
                end
            else
                if instance<10
                    outputFileName3 = strcat(folderResults,num2str(S), 'S_0', num2str(T),'T_0', num2str(instance),'I_',num2str(100*fillRate), 'Actions_LL.txt');
                    outputFileName4 = strcat(folderResults,num2str(S), 'S_0', num2str(T),'T_0', num2str(instance),'I_',num2str(100*fillRate), 'Actions_SPFH.txt');
                else
                    outputFileName3 = strcat(folderResults,num2str(S), 'S_0', num2str(T),'T_', num2str(instance),'I_',num2str(100*fillRate), 'Actions_LL.txt');
                    outputFileName4 = strcat(folderResults,num2str(S), 'S_0', num2str(T),'T_', num2str(instance),'I_',num2str(100*fillRate), 'Actions_SPFH.txt');
                end
            end
                        
            actions_LL = importdata(outputFileName3);
            actions_SPFH = importdata(outputFileName4);
            [rowll,~]=size(actions_LL);
            [rowspfh,~]=size(actions_SPFH);
            
            relocLL=0;
            relocSPFH=0;
            for i=1:rowll
                act=actions_LL{i};
                act=act(2:end-1);
                cols=split(act,',');
                if (str2num(cols{3}))~=0
                    relocLL=relocLL+1;
                end
            end
            OBJ1(instance+3)=relocLL;
            
            for i=1:rowspfh
                act=actions_SPFH{i};
                act=act(2:end-1);
                cols=split(act,',');
                if (str2num(cols{3}))~=0
                    relocSPFH=relocSPFH+1;
                end
            end
            OBJ2(instance+3)=relocSPFH;
            
            total_LL=total_LL+relocLL;
            total_SPFH=total_SPFH+relocSPFH;
            
            instance = instance + 1;
        end
        OBJ1(34)=total_LL/30;
        OBJ2(34)=total_SPFH/30;
        
        fprintf(fid1,'%d,%d,%d',OBJ1(1),OBJ1(2),OBJ1(3));
        for i=1:30
            fprintf(fid1,',%d',OBJ1(i+3));
        end
        fprintf(fid1,',%d\n',OBJ1(34));
        fprintf(fid2,'%d,%d,%d',OBJ2(1),OBJ2(2),OBJ2(3));
        for i=1:30
            fprintf(fid2,',%d',OBJ2(i+3));
        end
        fprintf(fid2,',%d\n',OBJ2(34));        
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