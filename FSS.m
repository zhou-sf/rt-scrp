function [colConsidered,bestStack,error] = FSS_new(Bid,Bpriori,p,col)
    % This function gives the bay updated after the retrieval of a container
    % using the MinMax policy at (tRetrieve,sRetrieve).
    if p==0
        throw(MException('MATLAB:customerError','current blocking container is 0!'));
    end

    %% We initialize the size of the configuration and maximum time window
    [T,S] = size(Bid);

    %% The height vector
%     height = sum(Bid~=0);

    % [~,col]=find(Bid==p);
    % if isempty(col) || length(col)>1
    %     throw(MException('MATLAB:customerError','current target container not existing or existing more than one items'));
    % end
    [tops, tops_P] = Tops(Bid, Bpriori);
    minVector = minPriori(Bpriori,0);
    min2Vector = minPrioriExceptTopmost(Bpriori,0);

    error=999;
    colConsidered=0;
    bestStack=0;

    curB=Bid;
    curP=Bpriori;
    curB(:,col)=zeros(1,T)*999;
    curP(:,col)=zeros(1,T);
    
    
    for s=1:S
        if s==col
            continue;
        end
%         disp(strcat('p=',num2str(p),'  col=',num2str(col),'  s=',num2str(s),'  minVector(s)=',num2str(minVector(s)),'  min2Vector(s)=',num2str(min2Vector(s)),'  tops_P(col)=',num2str(tops_P(col))));
        if minVector(s)<min2Vector(s) && tops_P(col)<min2Vector(s)
            [best,err] = FindBestPlacement(tops(s),curB,curP);
            if best>0 && err>0
                if error> min2Vector(s)-tops_P(col)
                    error=min2Vector(s)-tops_P(col);
                    bestStack=best;
                    colConsidered=s;
                end
            end
        end

        %     if tops_P(col)<min2Vector(s) && tops_P(col)>tops_P(s) && errorP>min2Vector(s)-tops_P(col)
        %         [best,error] = FindBestPlacement(tops(s),Bid,Bpriori);
        %         if ~(best==col || best==0 || error<0)
        % %             stackFSS_P=s;
        %             colConsidered=s;
        %             bestStack=best;
        %             errorP=min2Vector(s)-tops_P(col);
        %         end
        %
        %     elseif tops_P(col)<min2Vector(s) && tops_P(col)>tops_P(s) && errorP==min2Vector(s)-tops_P(col)
        %         [best,error] = FindBestPlacement(tops(s),Bid,Bpriori);
        %         if ~(best==col || best==0 || error<0)
        %             if heightP>height(s) %the same level, we select the higher stack
        %                 heightP = height(s);
        %                 colConsidered=s;
        %                 bestStack=best;
        % %                 stackFSS_P=s;
        %             end
        %         end
        % %     elseif tops_P(col)==min2Vector(s) && tops_P(col)>tops_P(s) && heightZ>height(s)
        % %         [best,error] = FindBestPlacement(tops(s),Bid,Bpriori);
        % %         if ~(best==col || best==0 || error<0)
        % % %             stackFSS_Z=s;
        % %             colConsidered=s;
        % %             bestStack=best;
        % %             heightZ=height(s);
        % %         end
    end
end
% 
% if stackFSS_P~=0
%     colConsidered=stackFSS_P;
%     bestStack=best;
%     err=errorP;
% elseif stackFSS_Z~=0
%     colConsidered=stackFSS_Z;
%     bestStack=best;
%     err=errorZ;
% else
%     colConsidered=0;
%     bestStack=0;
%     err=0;
% end
