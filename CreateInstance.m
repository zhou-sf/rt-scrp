function [B]=CreateInstance(S,T,W,CW)

% This function creates a bay of S stacks and T tiers with W
% batches, each with CW containers. We consider that the number of
% containers is C = W*CW, where the containers are distributed randomly in 
% the bay.
C = W*CW;
%% Start generating a random permutation of T*S
X=randperm(T*S);
Df=zeros(T,S);
for p=1:T*S
% We only display the number such that they are less than N
    if X(p) <= C
        Df(p)=X(p);
    end
end

%% We create the configuration where the gravity applies
D=zeros(T,S);
for s=1:S
    col=Df(:,s);
    col=col(col~=0);
    for k=1:size(col,1)
        D(T-k+1,s)=col(size(col,1)-k+1);
    end
end

%% We ``hide'' information and create the W batches of containers
B = zeros(T,S);
for s=1:S
    for t=1:T
        B(t,s) = ceil(D(t,s)/CW);
    end
end