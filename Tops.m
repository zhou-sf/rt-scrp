function [topIds,topPrioris] = Tops(Bid,Bpriori)

% This function gives the bay updated after the retrieval of a container
% using the MinMax policy at (tRetrieve,sRetrieve).

%% We initialize the size of the configuration and maximum time window
[T,S] = size(Bid);
topIds = zeros(1,S);
topPrioris = zeros(1,S)-1;

%% The height vector
height = sum(Bid~=0);

for s=1:S
    if height(s)~=0
        topIds(s)=Bid(T-height(s)+1,s);
        topPrioris(s)=Bpriori(T-height(s)+1,s);
    else
        topIds(s)=0;%Bid(T-height(s)+1,s);
        topPrioris(s)=-1;%Bpriori(T-height(s)+1,s);
    end
end
