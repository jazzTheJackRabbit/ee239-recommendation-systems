%===========================================================
% Task 5
%       NOTE: 
%===========================================================
load('C:\Users\Brandon\Documents\GitHub\recommendationSystems\Dataset\ml-100k\u.data');

uid = u(:,1);
mid = u(:,2);
rating = u(:,3);
data = [uid,mid,rating];

R = zeros(max(uid), max(mid));
for i=1:length(data)
	R(uid(i),mid(i)) = rating(i);
end
W = ~iszero(R);


option_struct = struct('iter',200,'dis',0);
clusters = [10,50,100];
lambda = [0.01,0.1,1];

sqerr = inf(3,3);
for k = clusters
    for l = lambda
        [U,V,~,~,~] = wnmf2(R,W,l,k,option_struct);
        Rpred = U * V;

        R(isnan(R)) = 0;    % should non entries be NaN?

        error = R - (W.*R_pred);
        squared_error_mat = error.*error;
        sqerr(k,l) = sum(sum(squared_error_mat));
    end
end