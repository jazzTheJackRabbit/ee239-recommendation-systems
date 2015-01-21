%Part 1
for i = k
    [U,V,numIters,tElps,finalResidual] = wnmfrule(m_rmat,i,option_struct);
    uv_rmat = U * V;
    uv_rmat = m_weight.*uv_rmat;
    error = (m_rmat - uv_rmat);
    squared_error_mat = error.*error;
    squared_error_scalar = sum(sum(squared_error_mat))
end