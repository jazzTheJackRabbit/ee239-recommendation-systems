%Part 2
temp = m_rmat;
m_rmat = m_weight;
m_weight = temp;

for i = k
    [U,V,numIters,tElps,finalResidual] = wnmfrule(m_rmat,i,option_struct);
    uv_rmat_no_weight = U * V;
    uv_rmat = m_weight.*uv_rmat_no_weight;
    error = (m_rmat - uv_rmat);
    squared_error_mat = error.*error;
    squared_error_scalar = sum(sum(squared_error_mat))
end
