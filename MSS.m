function [colConsidered] = MSS_new(Bid,Bpriori,col,bestStack)
%% We initialize the size of the configuration and maximum time window
[T,S] = size(Bid);
% The height vector
height = sum(Bid~=0);
if Bid(T-height(col)+1,col)==0
    throw(MException('MATLAB:customerError','the target container is 0!'));
end
colConsidered=0;
if T-height(bestStack)<2
    return;
end

[~, tops_P] = Tops(Bid,Bpriori);

minVector = minPriori(Bpriori,0);
min2Vector = minPrioriExceptTopmost(Bpriori,0);

%% Performing the MSS rule
stackMSS = 0;
errorP=999;
minHeight = 999;

for s=1:S
    if s==col || s==bestStack %|| height(s)<2
        continue;
    end
    
    if tops_P(s)>min2Vector(s) && tops_P(s)>tops_P(col)% && height(s)>1
        if minVector(bestStack)>tops_P(s) && errorP>minVector(bestStack)-tops_P(s)
            errorP=minVector(bestStack)-tops_P(s);
            stackMSS=s;
        elseif minVector(bestStack)>tops_P(s) && errorP==minVector(bestStack)-tops_P(s)
            if minHeight>height(s) %the same level, we select the higher stack
                minHeight = height(s);
                stackMSS=s;
            end
        end
    end
%     disp(strcat('tops_P(s)=',num2str(tops_P(s)),'    min2Vector(s)=',num2str(min2Vector(s)),'    height(s)=',num2str(height(s))));
end
colConsidered=stackMSS;
