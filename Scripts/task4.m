%===========================================================
% Task 4
%       NOTE: This script runs the precision and recall
%       measurements based on generating training set from
%       the COMPLETE data set. So run task1 or task2 first
%===========================================================

threshold = 1:0.01:5;
prec = zeros(1,length(threshold));  % Precision data points
rec = zeros(1,length(threshold));   % Recall data points

it=1;
for t = threshold
    % Precision = tp / (tp + fp
    % Recall = tp / (tp + fn)
    tp = 0;     % True positive count
    fp = 0;     % False positive count
    fn = 0;     % False negative count
    
    for i=1:length(data)
        uid = data(i,1);
        mid = data(i,2);
        rating = data(i,3);
        
        if (uv_rmat(uid,mid) >= t)
            if (rating >= t)
                tp = tp + 1;
            else
                fp = fp + 1;
            end
        elseif (rating >= t)
            fn = fn + 1;
        end
    end
    prec(it) = tp/(tp+fp);
    rec(it) = tp/(tp+fn);
   it = it + 1;
end
