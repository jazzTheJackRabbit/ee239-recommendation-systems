function [hit, miss, LR] = recommend(R, U, V, L, threshold)
    
len=length(R(:,1));
R_pred = U*V;
W = ~iszero(R);

hit=0;      % Num of correctly recommended titles
miss=0;     % Num of incorrectly recommended
LR = zeros(len,L);
for i=1:len
    recs = kmax(R_pred(i,:), L);    % recs = array of indices (movie ids)
    LR(i,:) = recs;
    for j=recs   % For each recommended title
        rating = R(i,j);
        if (rating == 0)
            % Do nothing, user has not rated the movie
        elseif (rating > threshold)
            hit = hit + 1;
        else  
            miss = miss + 1;
        end
    end
end

