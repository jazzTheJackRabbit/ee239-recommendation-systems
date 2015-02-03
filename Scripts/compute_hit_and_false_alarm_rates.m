function [hit_rate,false_alarm_rate] = compute_hit_and_false_alarm_rates(LDL_p, LDL_a, rated_matrix)
    LDL_p = LDL_p .* rated_matrix;
    TP_mat = LDL_a .* LDL_p;
    FP_mat = LDL_p - TP_mat;
    
    TP = sum(sum(TP_mat));
    FP = sum(sum(FP_mat));
    
    likes_actuals = sum(sum(LDL_a));
    dislikes_actuals = sum(sum(~LDL_a));
    
    hit_rate = TP/likes_actuals;
    false_alarm_rate = FP/dislikes_actuals;
end