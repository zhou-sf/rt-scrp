function sequences = GenerateSequences(P,Bid)
% 首先生成目标箱的全排列
count = sum(P~=0);
Q=zeros(1,count);
k=1;
for i=1:length(P)
    [row1,~]=find(Bid==P(i));
    if isempty(row1)
        Q(:,length(Q))=[];
        continue;
    end
    if P(i)~=0
        Q(k)=P(i);
        k=k+1;
    end
end
b=perms(Q);

% P,Q,Bid
%% 然后排除不符合提取顺序的提箱顺序

[T,~]=size(b);
del=zeros(1,T);
for i=1:length(Q)-1
    [row1,col1]=find(Bid==Q(i));
%     disp(['Q(i)=',num2str(Q(i))]);
    for j=i+1:length(Q)
        [row2,col2]=find(Bid==Q(j));
%         disp(['Q(j)=',num2str(Q(j))]);
        if col1~=col2
            continue;
        else
            for k=1:T
                [~,col3]=find(b(k,:)==Q(i));
                [~,col4]=find(b(k,:)==Q(j));

                if ~((row1<row2 && col3<col4) || (row1>row2 && col3>col4))
                    del(k)=1;
                end
            end
        end
    end
end
% del
for k=T:-1:1
    if del(k)==1
        b(k,:)=[];
    end
end
% length(b)
sequences=b;