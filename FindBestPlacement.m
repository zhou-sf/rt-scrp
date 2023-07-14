function [stack,error] = FindBestPlacement(b,Bid,Bpriori)
if b==0
    throw(MException('MATLAB:customerError','current blocking container is 0.'));
end

[T,S]=size(Bid);
minVector=minPriori(Bpriori,0);
height = sum(Bid~=0);

[row,col]=find(Bid==b);
if isempty(row) || length(row)>1
    throw(MException('MATLAB:customerError','current blocking container not existing or existing more than one items'));
end
p = Bpriori(row,col);

errorMaxp=999; %%Õý²îÒì
errorMaxn=-999; %%¸º²îÒì
stackp=0;
stackn=0;
stackz=0;
minHeight1=999;
minHeight2=999;
minHeight3=0;

for i=1:S 
    if minVector(i)==-1 || i==col || height(i)==T
        continue;
    end
    
    if minVector(i)-p>0 && minVector(i)-p<errorMaxp
        errorMaxp = minVector(i)-p;
        stackp=i;
    elseif minVector(i)-p>0 && errorMaxp==minVector(i)-p
        if height(i)<minHeight1
            minHeight1=height(i);
            stackp=i;
        end
    elseif minVector(i)-p==0 && height(i)<minHeight2
        minHeight2 = height(i);
        stackz=i;
    elseif minVector(i)-p<0 && minVector(i)-p>errorMaxn
        errorMaxn = minVector(i)-p;
        stackn=i;
    elseif minVector(i)-p<0 && errorMaxn==minVector(i)-p
        if height(i)>minHeight3
            minHeight3=height(i);
            stackn=i;
        end
    end
end
if errorMaxp~=999
    stack = stackp;
    error = errorMaxp;
elseif minHeight2~=999
    stack = stackz;
    error = 0;
elseif errorMaxn~=-999
    stack=stackn;
    error = errorMaxn;
else
    stack = 0;
    error = -999;
end
    
%     
%     
% if b==0
%     stack=0;
%     error=-999;
% else
%     minVector = minPriori(Bpriori);
%     [row,col]=find(Bid==b);
%     p = Bpriori(row,col);
%     errorMaxp=999; %%Õý²îÒì
%     errorMaxn=-999; %%¸º²îÒì
%     stackp=0;
%     stackn=0;
%     stackz=0;
%     minHeight=999;
%     height = sum(Bid~=0);
% 
%     for i=1:S 
%         if minVector(i)==-1 || height(i)>=T
%             continue;
%         end
%         
%         if minVector(i)-p>0 && minVector(i)-p<errorMaxp
%             errorMaxp = minVector(i)-p;
%             stackp=i;
%         elseif minVector(i)-p==0 && height(i)<minHeight
%             minHeight = height(i);
%             stackz=i;
%         elseif minVector(i)-p<0 && minVector(i)-p>errorMaxn
%             errorMaxn = minVector(i)-p;
%             stackn=i;
%         end
%     end
%     if errorMaxp~=999
%         stack = stackp;
%         error = errorMaxp;
%     elseif minHeight~=999
%         stack = stackz;
%         error = 0;
%     elseif errorMaxn~=-999
%         stack=stackn;
%         error = errorMaxn;
%     else
%         stack = 0;
%         error = -999;
%     end
% end