%===========================================================
% Task 6
%       NOTE: Run factorize.m first to generate populate
%       the dataset.
%       Contains a duplication of code form task 3 since
%       the calculation of U and V matrices for each training
%       set is expensive
%===========================================================
fprintf('BEGIN TASK 6\n');
factorize;
R = m_weight;
W = m_rmat;

k=100;
L=5; 
threshold=3;

[U,V,~,~,~] = wnmf(R,W,k,option_struct);
[hit,miss,LR] = recommend(W,U,V,L,threshold);





