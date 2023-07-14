function [initialBayPriori,initialBayId,initialBatch] = readInputFile(S,T,instance,fillRate)

% This function outputs the configuration in the usual format from the data
% set of Ku et Arthanari (2016) for a given stack, tier size, the number of
% the instance and the fillrate (0.5 or 0.67)

%% First we find the folder and the file that we want to import
if S < 10
    foldername = strcat('Instances/0',num2str(S), '0', num2str(T),'/');
    if fillRate == 0.5
        if instance < 10
            filename = strcat(foldername,'T271014_0', num2str(S), '0', num2str(T), '_00', num2str(instance), '.txt');
        else
            filename = strcat(foldername,'T271014_0', num2str(S), '0', num2str(T), '_0', num2str(instance), '.txt');
        end
    elseif fillRate == 0.67
        if instance < 10
            filename = strcat(foldername,'T281014_0', num2str(S), '0', num2str(T), '_00', num2str(instance), '.txt');
        else
            filename = strcat(foldername,'T281014_0', num2str(S), '0', num2str(T), '_0', num2str(instance), '.txt');
        end
    end  
else
    foldername = strcat('Instances/',num2str(S), '0', num2str(T),'/');
    if fillRate == 0.5
        if instance < 10
            filename = strcat(foldername,'T271014_', num2str(S), '0', num2str(T), '_00', num2str(instance), '.txt');
        else
            filename = strcat(foldername,'T271014_', num2str(S), '0', num2str(T), '_0', num2str(instance), '.txt');
        end
    elseif fillRate == 0.67
        if instance < 10
            filename = strcat(foldername,'T281014_', num2str(S), '0', num2str(T), '_00', num2str(instance), '.txt');
        else
            filename = strcat(foldername,'T281014_', num2str(S), '0', num2str(T), '_0', num2str(instance), '.txt');
        end
    end  
end

%% We import all the information of Priori, including the height of
% columns
RawPriori = dlmread(filename,'',1,0);
height = RawPriori(:,2);

initialBayPriori = zeros(T,S)-1;
for s=1:S
    for t=1:height(s)
%         disp(strcat('s:',num2str(s),',t:',num2str(t),',T-t+1:',num2str(T-t+1),',instance:',num2str(instance),',height(s):',num2str(height(s))));
        initialBayPriori(T-t+1,s) = RawPriori(s,t+2);
    end
end

%% the information of Container Ids.
idfilename = strcat(filename(1:length(filename)-4),'_id.txt');
RawId = dlmread(idfilename,'',1,0);
height = RawId(:,2);

initialBayId = zeros(T,S);
for s=1:S
    for t=1:height(s)
        initialBayId(T-t+1,s) = RawId(s,t+2);
    end
end

%% the information of Pickup batches.
batchfilename = strcat(filename(1:length(filename)-4),'_batch.txt');

RawBatch = dlmread(batchfilename,'',1,0);

count = RawBatch(:,2);
[rows,cols] = size(RawBatch);

initialBatch = zeros(rows,cols-1);
for s=1:rows
    initialBatch(s,1)=count(s);
    for t=1:count(s)
        initialBatch(s,t+1) = RawBatch(s,t+2);
    end
end

