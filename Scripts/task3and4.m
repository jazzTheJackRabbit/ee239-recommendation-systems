%===========================================================
% Task 3 and 4
%       NOTE: Run factorize.m first to generate populate
%       the dataset.
%       Contains a duplication of code form task 3 since
%       the calculation of U and V matrices for each training
%       set is expensive
%===========================================================
disp('BEGIN TASK 4');
numIter = 10;                   % Num of iterations
len = length(data) / numIter;   % Length of a the testing set
train_len = len*(numIter-1);    % Length of the training set

%train_set = zeros(train_len, 3);   % note: cannot prealloc
test_set = zeros(len, 3);

avg_error = zeros(1,numIter);   % avg prediction error for each training/testing set
%precision = zeros(1,numIter);
%recall = zeros(1,numIter);

thresholds = 1:0.2:5;
m=0;

precision = zeros(length(thresholds),numIter);
recall = zeros(length(thresholds),numIter);
 
for i=0:numIter-1
        
% Threshold for like/disliking a movie


    % Divide data into training and testing set
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
    [U,V,iters,tElps,finalResidual] = wnmfrule(R_mat,k,opts);


    R_pred = U*V;                   % R prediction matrix U*V
    p_error = zeros(len,1);


    % Precision = tp / (tp + fp
    % Recall = tp / (tp + fn)
    tp = 0;     % True positive count
    fp = 0;     % False positive count
    fn = 0;     % False negative count
    
    %============================================================
    t = 1;
    for thresh = thresholds   
      
        fprintf('Training set: %d, threshold=%f\n',i,thresh);
        
        % for each data point in the testing set
        for j=1:len                     % Analyze prediction error
            uid = test_set(j,1);
            mid = test_set(j,2);
            rating = test_set(j,3);
            if (R_pred(uid,mid) >= thresh)
                if (rating >= thresh)
                    tp = tp + 1;
                else
                    fp = fp + 1;
                end
            elseif (rating >= thresh)
                fn = fn + 1;
            end

            p_error(j) = abs(rating - R_pred(uid,mid)); 
        end
        
        %[precision/recall](threshold_value, iteration_number)
        precision(t,i+1) = tp/(tp+fp);
        recall(t,i+1) = tp/(tp+fn);
        
        
        fprintf('Precision=%f, Recall=%f', precision(t, i+1), recall(t, i+1));
        avg_error(t,i+1) = mean(p_error);
        
        t = t+1;
    end
end