function [Bid_new,Bpriori_new,Batch_new,oprs_new] = AutoRetrieval(Bid,Bpriori,Batch,k,oprs)

% This function tries to find the targets which can be retrieved directly and 
% return the retrieval operations.

%% We initialize the size of the configuration and get current round targets
curBid=Bid;
curBpriori = Bpriori;
curBatch = Batch;
curOprs = oprs;

hasTopTarget=true;
[T,S]=size(curBid);
targets = curBatch(k,2:end);
while hasTopTarget
    height = sum(curBid~=0);
    [topIds, ~] = Tops(curBid, curBpriori);
    hasTopTarget=false;
    
    for i=1:S %length(topIds)
        if topIds(i)==0
            continue;
        end
        [li,loc]=ismember(topIds(i),targets);
        if li %Existing topmost target containers
            if isempty(curOprs)
                curOprs = strcat('<',int2str(topIds(i)),',',int2str(i),',0>');
            else
                curOprs = strcat(curOprs,';<',int2str(topIds(i)),',',int2str(i),',0>');
            end

%             curBatch(k,1)=curBatch(k,1)-1;
            curBid(T-height(i)+1,i)=0;
            curBpriori(T-height(i)+1,i)=-1;
            targets(:,loc)=[];
            hasTopTarget=true;
        end
    end    
end

count=curBatch(k,1);
if ~isempty(targets)
   for i=1:count
       if i<=length(targets)
           curBatch(k,i+1)=targets(i);
       else
           curBatch(k,i+1)=0;
       end
   end
else
    for i=1:count
        curBatch(k,i+1)=0;
    end   
end
curBatch(k,1)=length(targets);

Bid_new=curBid;
Bpriori_new=curBpriori;
Batch_new=curBatch;
oprs_new=curOprs;



%     
%     targets = curBatch(k,2:end);
%     count = curBatch(k,1);
% 
%     for i=1:count
%         if targets(i)==0
%             continue;
%         end
%        [li,~] = ismember(targets(i),topIds);
%        if li
%            hasTopTarget=true;
%            [row,col]=find(curBid==targets(i));
%            if isempty(curOprs)
%                 curOprs = strcat('<',int2str(targets(i)),',',int2str(col),',0>');
%             else
%                 curOprs = strcat(curOprs,';<',int2str(targets(i)),',',int2str(col),',0>');
%            end
%            curBid(row,col)=0;
%            curBpriori(row,col)=-1;
% 
%            curBatch(k,i+1)=0;
%            curBatch(k,1)=curBatch(k,1)-1;       
%            height(col)=height(col)-1;
% 
%            if height(col)==0
%                topIds(col)=0;
% %                topPerioris(col)=-1;
%            else
%                topIds(col)=curBid(row+1,col);
% %                topPerioris(col)=curBpriori(row+1,col);
%            end
%        end
%     end
% end
% 
% Bid_new=curBid;
% Bpriori_new=curBpriori;
% Batch_new=curBatch;
% oprs_new=curOprs;

% 
% [T,~] = size(curBid);
% % targetRow=Batch(k);
% % target = targetRow(targetRow~=0);
% 
% %% To find the topmost targets and generate the retrieval operations
% hasTopTarget = true;
% 
% while (curBatch(k,1)>0 && hasTopTarget) %for j=1:Batch(k,1)%counBatch
%     hasTopTarget = false;
%     count = curBatch(k,1);
%     for j=2:count+1
%         target=curBatch(k,j);
% %         if target==0
% %             continue;
% %         end
%         % The height vector
%         height = sum(curBid~=0);
% 
%         [row,col]=find(curBid==target);
%         
%         if height(col)==T-row+1
%             if isempty(curOprs)
%                 curOprs = strcat('<',int2str(target),',',int2str(col),',0>');
%             else
%                 curOprs = strcat(curOprs,';<',int2str(target),',',int2str(col),',0>');
%             end
%             % Update the configuration B
%             curBid(row,col) = 0;
%             curBpriori(row,col) = -1;
%             curBatch(k,1) = curBatch(k,1) - 1;
%             hasTopTarget = true;
%             
%             if j<count+1
%                 for x=1:count-j+1
%                     curBatch(k,j+x-1)=curBatch(k,j+x);
%                 end
%                 curBatch(k,count+1) = 0;
%             else
%                 curBatch(k,j) = 0;
%             end            
%         end
%     end
% end
% Bid_new=curBid;
% Bpriori_new=curBpriori;
% Batch_new=curBatch;
% oprs_new=curOprs;
