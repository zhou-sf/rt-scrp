clear all;
clc;
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
        
        OBJ1 = zeros(31,63);
        OBJ2 = zeros(31,63);   
        
%% Each bay-size/fillRate has 30 instances. For each of them we use our new
% optimal Algorithm and a similar algorithm than Ku et Arthanaris with the
% projection method
% We solve until both methods do not work
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
                instance = 1;
                while instance <= 30
                    [initialPriori,initialId,initialBatch] = readInputFile2(S,T,instance,w,cw); 
                    
                    disp(strcat('Solving Problem  ', num2str(instance), ', of size T=',num2str(T),', S=',num2str(S),', W=',num2str(w),', and CW=',num2str(cw)));
                    disp(strcat('LL'));

                    tic
                    curB = initialId;
                    curPriori = initialPriori;
                    curBatch = initialBatch;

                    initBlocking = lb(curB,curPriori);
                    
                    actions_ll = '';
                    [K,C]=size(curBatch);
                    OBJ1(instance+1,1)=K;
                    OBJ1(instance+1,2)=initBlocking;
                    
                    for k=1:K
                        oprs_ll = '';
                        [Bid_new,Bpriori_new,Batch_new,OBJ1(instance+1,k+3),curOprs1] = LL(curB,curPriori,curBatch,k);%,oprs_ll);

                        curB=Bid_new;
                        curPriori=Bpriori_new;
                        curBatch = Batch_new;
                        if isempty(actions_ll)
                            actions_ll = curOprs1;
                        else
                            actions_ll = strcat(actions_ll, ';', curOprs1);
                        end
                    end
                    endTime1 = toc;
                    OBJ1(instance+1,3)=endTime1;

                    tic
                    curB = initialId;
                    curPriori = initialPriori;
                    curBatch = initialBatch;
                    [K,C]=size(curBatch);

                    disp(strcat('SPFH'));            

                    OBJ2(instance+1,1)=K;
                    OBJ2(instance+1,2)=initBlocking;
                    actions_spfh = '';
                    for k=1:K
                        oprs_spfh = '';
                        [Bid_new,Bpriori_new,Batch_new,OBJ2(instance+1,k+3),curOprs2] = SPFH_new(curB,curPriori,curBatch,k);%,oprs_spfh);
                        curB=Bid_new;
                        curPriori=Bpriori_new;                
                        curBatch = Batch_new;
                        if isempty(actions_spfh)
                            actions_spfh = curOprs2;
                        else
                            actions_spfh = strcat(actions_spfh, ';', curOprs2);
                        end
                    end
                    endTime2 = toc;                    
                    OBJ2(instance+1,3)=endTime2;

                    if S < 10
                        if T<10
                            if w<10
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            else
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            end
                        else
                            if w<10
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            else
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            end
                        end
                    else
                        if T<10
                            if w<10
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            else
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            end
                        else
                            if w<10
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            else
                                if cw<10
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                else
                                    if instance<10
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_0', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    else
                                        outputFileName3 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_LL.txt');
                                        outputFileName4 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', num2str(instance),'I_', 'Actions_SPFH.txt');
                                    end
                                end
                            end
                        end
                    end

                    [pathstr,~,~] = fileparts(outputFileName3);
                    if ~exist(pathstr,'dir')
                        mkdir(pathstr);
                    end

                    fid = fopen(outputFileName3,'W');
                    acts_ll = strsplit(actions_ll,';');
                    for i=1:length(acts_ll)
                        fprintf(fid,'%s\n',acts_ll{1,i});
                    end
                    fclose(fid);

                    fid = fopen(outputFileName4,'W');
                    acts_spfh = strsplit(actions_spfh,';');
                    for i=1:length(acts_spfh)
                        fprintf(fid,'%s\n',acts_spfh{1,i});
                    end
                    fclose(fid);

                    instance = instance + 1;
                end


                % We create a outputFileName (for optimal)
               
                if S < 10
                    if T<10
                        if w<10
                            if cw<10
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        else
                            if cw<10
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        end
                    else
                        if w<10
                            if cw<10
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        else
                            if cw<10
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults,'0',num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        end
                    end
                else
                    if T<10
                        if w<10
                            if cw<10
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        else
                            if cw<10
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_0', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        end
                    else
                        if w<10
                            if cw<10
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_0', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        else
                            if cw<10
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_0', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            else
                                outputFileName1 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_LL.csv');
                                outputFileName2 = strcat(folderResults ,num2str(S), 'S_', num2str(T),'T_', num2str(w), 'W_', num2str(cw), 'CW_', 'Utilization_SPFH.csv');
                            end
                        end
                    end
                end

                [pathstr,name,ext] = fileparts(outputFileName1);
                if ~exist(pathstr,'dir')
                    mkdir(pathstr);
                end
        %% We save the file in a csv file with columns for methods and lines for instances
                fid = fopen(outputFileName1,'W');
                fprintf(fid,'%s,%s,%s','Batches','InitBlocking','Runtime');
                for i=1:60
                    fprintf(fid,',%s',strcat('batch',num2str(i)));
                end
                fprintf(fid,'\n');

                for r=1:30
                    fprintf(fid,'%d,%d,%d',OBJ1(r+1,1),OBJ1(r+1,2),OBJ1(r+1,3));
                    for i=1:60
                        fprintf(fid,',%g',OBJ1(r+1,i+3));
                    end
                    fprintf(fid,'\n');
                end
                fclose(fid);

                fid = fopen(outputFileName2,'W');
                fprintf(fid,'%s,%s,%s','Batches','InitBlocking','Runtime');
                for i=1:60
                    fprintf(fid,',%s',strcat('batch',num2str(i)));
                end
                fprintf(fid,'\n');

                for r=1:30
                    fprintf(fid,'%d,%d,%d',OBJ2(r+1,1),OBJ2(r+1,2),OBJ2(r+1,3));
                    for i=1:60
                        fprintf(fid,',%g',OBJ2(r+1,i+3));
                    end
                    fprintf(fid,'\n');
                end
                fclose(fid);
            end
        end
    end
end

% outputFileName = strcat(folderResults, num2str(100*fillRate), 'Utilization_FinalResults.csv');
% fid = fopen(outputFileName,'W');
% fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','S','T','C','LL','SPFH');
% for r=1:24
%     fprintf(fid,'%g,%g,%g,%g,%g,%g\n',Total_OBJ(r,1),Total_OBJ(r,2),Total_OBJ(r,3),Total_OBJ(r,4),Total_OBJ(r,5),Total_OBJ(r,6));
% end
% fclose(fid);