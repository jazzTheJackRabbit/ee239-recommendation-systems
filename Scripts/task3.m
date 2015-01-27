%===========================================================
% Task 3
%       NOTE: Run factorize.m first to generate populate
%       the dataset.
%===========================================================
disp('BEGIN TASK 3');
numIter = 10;                   % Num of iterations
len = length(data) / numIter;   % Length of a the testing set
train_len = len*(numIter-1);    % Length of the training set

%train_set = zeros(train_len, 3);   % note: cannot prealloc
test_set = zeros(len, 3);

avg_error = zeros(1,numIter);

for i=0:numIter-1
    % Divide data into training and testing set
    i
    start = i*len+1;
    fin = start+len-1;
    test_set = data(start:fin, :);          % The testing set
    train_set = [];
    if(i > 0)
        train_set = data(1:start-1,:);      % The training set = {data - testing_set}
    end
    if(i < numIter-1)
        train_set = [train_set;data(fin+1:length(data),:)];
    end
   
    % Build R, W matrix for the training set
    disp('creating R and W matrix')
    W_mat = zeros(max(uid), max(mid));
    R_mat = zeros(max(uid), max(mid));
    
    for j=1:train_len                       % Populate R with training data
        uid = train_set(j,1);
        mid = train_set(j,2);
        rating = train_set(j,3);
        
        R_mat(uid,mid) = rating;
        W_mat(uid,mid) = 1;
    end
    
    k = 100;                                % Num of iterations
    opts = struct('iter',200,'dis',0);      % Option struct
    [U_mat,V_mat,iters,tElps,finalResidual] = wnmfrule(R_mat,k,opts);
    
    
    R_pred = U*V;                   % R prediction matrix U*V
    p_error = zeros(len,1);
    for j=1:len                     % Analyze prediction error
        uid = test_set(j,1);
        mid = test_set(j,2);
        rating = test_set(j,3);
        p_error(j) = abs(rating - R_pred(uid,mid));
    end
    
    avg_error(i+1) = mean(p_error);
end
