%Part 3

kFolds = 10;
fullData = data;
fullDataWithSerial = zeros(length(fullData),4);
randomizedFullDataWithSerial = zeros(length(fullData),4);

fullDataWithSerial(1:length(fullData),1:3) = fullData(1:length(fullData),:);
fullDataWithSerial(1:length(fullData),4) = (1:length(fullData));

%Randomize the dataset
randomizedFullDataWithSerial = fullDataWithSerial(randperm(size(fullDataWithSerial,1)),:);

offset = length(fullData)/kFolds;

absolute_error_vector = zeros(offset,kFolds);    
avg_abs_error_for_each_threshold = zeros(kFolds,1);
option_struct = struct('iter',200,'dis',1);

for i=0:kFolds-1        
    start_idx = offset*i + 1;
    end_idx = start_idx + offset - 1;  
    
    trainData = randomizedFullDataWithSerial; % will be 100K set but the testData part will be 0s
    
    %Separate the train Data
    testData = trainData(start_idx:end_idx,:);                  
    
    %Create the R and W matrix
    [r_mat,w_mat] = create_R_and_W(trainData);
    
    %For all the uid,mid pairs in the training data, change all the weight
    %values.
    for j=1:length(testData)
%         sprintf('Iteration:%d | Weight zeroed for:%d,%d',j,testData(j,1),testData(j,2))
        w_mat(testData(j,1),testData(j,2)) = 0;
    end

    sprintf('Fold#:%d',i)
%     square_error(i+1) = compute_squared_error([100],r_mat,w_mat)   
    
    [U,V,numIters,tElps,finalResidual] = wnmfrule(r_mat,[100],option_struct); %Returns
    uv_rmat = U * V;
%     uv_rmat = w_mat.*uv_rmat;
    
%     
    for idx=1:length(testData)
        rating = testData(idx,3);
        predicted_rating = uv_rmat(testData(idx,1),testData(idx,2));
        absolute_error_vector(idx,i+1) = abs(rating - predicted_rating);
    end
    
    avg_abs_error_for_each_threshold(i+1) = mean(absolute_error_vector(:,i+1));
    
end

average_for_k_folds = mean(avg_abs_error_for_each_threshold);
 