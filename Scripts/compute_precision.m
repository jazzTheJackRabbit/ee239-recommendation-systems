function [precision] = compute_precision(LDL_p, LDL_a, rated_matrix)
    %Ignore all values that are not actually rated
    LDL_p = rated_matrix .* LDL_p;
    
    TP_mat = LDL_a .* LDL_p;
    FP_mat = LDL_p - TP_mat;
    
    TP = sum(sum(TP_mat));
    FP = sum(sum(FP_mat));
    
    precision = TP/(TP+FP);
end