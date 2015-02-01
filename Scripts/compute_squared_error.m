function [squared_error_scalar] = compute_squared_error(thresholds,r_mat,w_mat)

% thresholds=[10,50,100] - more like number of features to learn, not thresholds!;

option_struct = struct('iter',200,'dis',0);

for k = thresholds
    [U,V,numIters,tElps,finalResidual] = wnmfrule(r_mat,k,option_struct); %Returns
    uv_rmat = U * V;
    uv_rmat = w_mat.*uv_rmat;
    
    r_mat(isnan(r_mat)) = 0;  % should non entries be NaN?
    
    error = (r_mat - uv_rmat);
    squared_error_mat = error.*error;
    squared_error_scalar = sum(sum(squared_error_mat));
    sprintf('Squared error for %d features/thresholds:%d',k,squared_error_scalar)
end