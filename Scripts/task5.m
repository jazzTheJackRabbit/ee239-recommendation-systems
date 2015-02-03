%===========================================================
% Task 5
%       NOTE: 
%===========================================================
% load('C:\Users\Brandon\Documents\GitHub\recommendationSystems\Dataset\ml-100k\u.data');
load('/Dataset/ml-100k/u.data');

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


sqerr = inf(3,3);
i=1;
for k = [10,50,100]
    l=1;
    for lambda = [0.01,0.1,1]
        fprintf('k=%d, lambda=%f\n', k,lambda);
        [U,V,~,~,~] = wnmf2(R,W,lambda,k,option_struct);
        R_pred = U*V;

        %R(isnan(R)) = 0;    % should non entries be NaN?
        
        error = R - (W.*R_pred);
        squared_error_mat = error.*error;
        sqerr(i,l) = sum(sum(squared_error_mat));
        l=l+1;
    end
    i=i+1;
end