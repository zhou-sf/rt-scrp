function minP = minPriori(B,col)

% This function gives the bay updated after the retrieval of a container
% using the MinMax policy at (tRetrieve,sRetrieve).
[T,S] = size(B);
height = sum(B~=-1);
if col==0
    minP=zeros(1,S);
    for s=1:S
%         if height(s)==T
%             minP(s) = -1;
        if height(s)==0
            minP(s)=T*S+1;
        else
            minP(s) = min(B(T-height(s)+1:T,s));
        end
    end
else
%     if height(col)==T
%         minP = -1;
    if height(col)==0
        minP=T*S+1;
    else
        minP = min(B(T-height(col)+1:T,col));
    end
end


% %% We initialize the size of the configuration
% [T,S] = size(B);
% height = sum(B~=-1);
% Z=sum(height);
% %% The vector of minimums (0 for full columns and the target column; Z+1 for
% % empty columns, where Z is the maximum time window)
% minVector = zeros(1,S);
% for s=1:S
%     stackConsidered = B(:,s);
%     if isempty(stackConsidered(stackConsidered~=-1))
%         minVector(s) = Z+1;
%     else
%         if height(s)==T
%             minVector(s) = -1;
%         else
%             minVector(s) = min(stackConsidered(stackConsidered~=-1));
%         end
%     end
% end
