%Part 2
temp = m_rmat;
m_rmat = m_weight;
m_weight = temp;

for i = k
    [U,V,numIters,tElps,finalResidual] = wnmf(m_rmat,m_weight, i,option_struct);
    uv_rmat_no_weight = U * V;
    uv_rmat = m_weight.*uv_rmat_no_weight;
   
   % m_rmat(isnan(m_rmat)) = 0;  % should non entries be NaN?

    error = (m_rmat - uv_rmat);
    squared_error_mat = error.*error;
    squared_error_scalar = sum(sum(squared_error_mat))
end
