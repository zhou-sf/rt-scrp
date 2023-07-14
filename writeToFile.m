function success = writeToFile(S,T,instance,fillRate)

% This function outputs the configuration in the usual format from the data
% set of Ku et Arthanari (2016) for a given stack, tier size, the number of
% the instance and the fillrate (0.5 or 0.67)

%% First we find the folder and the file that we want to import
if S < 10
    foldername = strcat('crptw_instance/0',num2str(S), '0', num2str(T),'/');
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
    foldername = strcat('crptw_instance/',num2str(S), '0', num2str(T),'/');
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

%% We import all the information from the file, including the height of
% columns
RawConfiguration = dlmread(filename,'',1,0);
height = RawConfiguration(:,3);

%% We construct the actual configuration from the raw text file.
initialBay = zeros(T,S);
for s=1:S
    for t=1:height(s)
        initialBay(T-t+1,s) = RawConfiguration(s,2*(t+1));
    end
end

%% output the data file
[inputPath, fname, fext]= fileparts(filename);

folderOutput = strcat('Output',inputPath(length('crptw_instance')+1:end));

if ~exist(folderOutput, 'dir')
    mkdir(folderOutput);
end
outputFileName = strcat(folderOutput, '/', fname, fext);
outputFileName2 = strcat(folderOutput, '/', fname, '_batch', fext);
outputFileName3 = strcat(folderOutput, '/', fname, '_id', fext);
%% We save the file in a csv file with columns for methods and lines for instances
fid = fopen(outputFileName,'W');
fprintf(fid,'%s,%d,%d,%d,%d\n',fname,S,T,length(initialBay(initialBay>0)),max(max(initialBay)));
for s=1:S
    fprintf(fid,'%d %d',s,height(s));
    for t=1:height(s)
        fprintf(fid,' %d',initialBay(T-t+1,s)); %%initialBay(T-t+1,s) = RawConfiguration(s,2*(t+1));
    end
    fprintf(fid,'\n');
end
fclose(fid);

initialBatch=zeros(size(initialBay));
maxPriori = max(max(initialBay));
miniPriori=min(min(initialBay(initialBay>0)));

for i=1:maxPriori
    [col,row] = find(initialBay==i);
    if size(col,1)==0
        continue;
    end
    count = length(col);    
    batchCount = randi([1 count]);
    locI1=-1;
    for j=1:count
        locI2 = j;
        if locI2==locI1
            continue;
        else
            if j<=batchCount
                initialBatch(col(locI2),row(locI2))=miniPriori;
            else
                initialBatch(col(locI2),row(locI2))=miniPriori + 1;
            end
        end
    end
    miniPriori=max(max(initialBatch(initialBatch>0)));
    miniPriori=miniPriori+1;
end

fid2 = fopen(outputFileName2,'W');
fprintf(fid2,'%s,%d,%d,%d,%d\n',strcat(fname,'_batch'),S,T,length(initialBatch(initialBatch>0)),max(max(initialBatch)));
for s=1:S
    fprintf(fid2,'%d %d',s,height(s));
    for t=1:height(s)
        fprintf(fid2,' %d',initialBatch(T-t+1,s)); %%initialBay(T-t+1,s) = RawConfiguration(s,2*(t+1));
    end
    fprintf(fid2,'\n');
end
fclose(fid2);
success = 1;