kFolds = 10;
fullData = data;
fullDataWithSerial = zeros(length(fullData),4);
randomizedFullDataWithSerial = zeros(length(fullData),4);

fullDataWithSerial(1:length(fullData),1:3) = fullData(1:length(fullData),:);
fullDataWithSerial(1:length(fullData),4) = (1:length(fullData));

%Randomize the dataset
randomizedFullDataWithSerial = fullDataWithSerial(randperm(size(fullDataWithSerial,1)),:);

offset = length(fullData)/kFolds;

option_struct = struct('iter',200,'dis',1);

precision_kFold_matrix = zeros(size(1:0.2:5,2),kFolds);

for iFold=0:kFolds-1        
    start_idx = offset*iFold + 1;
    end_idx = start_idx + offset - 1;  
    
    trainData = randomizedFullDataWithSerial; % will be 100K set but the testData part will be 0s
    
    %Separate the train Data
    testData = trainData(start_idx:end_idx,:);                  
    
    %Create the R and W matrix
    %TODO: w_mat and r_mat SHOULD BE interchanged here because the questions says so!
    [r_mat,w_mat] = create_R_and_W(trainData);
       
    
    %For all the uid,mid pairs in the training data, change all the weight
    %values.
    for j=1:length(testData)
        %Set's the testing set's data to unknown for r_mat
        w_mat(testData(j,1),testData(j,2)) = 0;    
    end
    
    %rated_mat consists of whether the user has rated the movie or not.        
    %TODO: if r_mat and w_mat are interchanged, this should also be
    %interchanged
    rated_mat = w_mat;
    
    sprintf('Fold#:%d',iFold+1)
    
    %TODO: Check which lambda has best value and use that.
    lambda = 1;
    
    [U,V,~,~,~] = wnmf2(r_mat,w_mat,lambda,100,option_struct);    
    uv_rmat = U * V;
        
    %TODO: Change this to 5?
    L = size(uv_rmat,2);
    
    sorted_r_mat = zeros(size(r_mat));
    
    sorted_uv_rmat = zeros(size(uv_rmat,1),L);
    sorted_uv_rmat_original_indices = zeros(size(uv_rmat,1),L);

    for indx = 1:size(uv_rmat,1)
        [ratings,indices] = sort(uv_rmat(indx,:),'descend');
        sorted_uv_rmat(indx,:) = ratings(1:L);
        sorted_uv_rmat_original_indices(indx,:) = indices(1:L);    
    end

    sorted_r_mat = r_mat;
    %Sort the original r_mat to be in the same sorted order as uv_rmat
    for indx = 1:size(sorted_uv_rmat,1)
       %TODO: Check if this actually rearranges R correctly
       sorted_r_mat(indx,:) = sorted_r_mat(indx,sorted_uv_rmat_original_indices(indx,:));
       rated_mat(indx,:) = rated_mat(indx,sorted_uv_rmat_original_indices(indx,:));
    end

    %Run classification for each threshold   
    iteration = 1;
    for threshold = [1:0.2:5]        
        %Like v/s Dislike matrix of actuals    
        LDL_a = classify(sorted_r_mat,threshold);
        %Like v/s Dislike matrix of predicted
        LDL_p = classify(sorted_uv_rmat,threshold);
        
        precision_kFold_matrix(iteration,iFold+1) = compute_precision(LDL_p,LDL_a,rated_mat);
        fprintf('The precision for fold# %d and threshold=%f is %f \n',iFold+1,threshold,precision_kFold_matrix(iteration,iFold+1))
        iteration = iteration + 1;
        for L = [1:5]
            LDL_a = classify(sorted_r_mat(:,1:L),threshold);
            LDL_p = classify(sorted_uv_rmat(:,1:L),threshold);        
            [hits,misses] = compute_hit_and_false_alarm_rates(LDL_p,LDL_a,rated_mat(:,1:L));
            fprintf('L=%d fold=%d threshold=%f hitRate=%f falseAlarmRate=%f \n',L,iFold+1,threshold,hits,misses)
            plot(misses,hits);hold on;
        end
    end
    
%     threshold = 3
    
figure(1);   
end






%EXCLUSIVE PART 6

% %Recommend L = 5 movies
% L = 5;
% sorted_uv_rmat = zeros(size(uv_rmat,1),L);
% sorted_uv_rmat_original_indices = zeros(size(uv_rmat,1),L);
% 
% for i = 1:size(uv_rmat,1)
%     [ratings,indices] = sort(uv_rmat(i,:),'descend');
%     sorted_uv_rmat(i,:) = ratings(1:L);
%     sorted_uv_rmat_original_indices(i,:) = indices(1:L);    
% end
% 
% %Sort the original R matrix to be in the same sorted order as R-pred
% for r = 1:size(Rpred,1)
%    R(r,:) = R(r,ind(r,:));
% end

%Choose top L=5
%Run classification
%multiply the predicted classification with rated matrix
%find precision