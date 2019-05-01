% x_acc, v_acc consist of 8 vectors each (every
% speedsetting)
function brakePoint = KITTstop(batt_level, speedsetting, stopdistance, x_rollout, v_rollout, x_acc, v_acc, brakeEnd)
    % Compensating for battery level
    batt_comp = batt_level/18.4;

    % Select the curves at speedsetting and compensate for battery level
    % 8 speedlevels (8 is fastest)
    brakePoint = CurvesIntersect(stopdistance, x_rollout, v_rollout, x_acc(speedsetting, :), batt_comp*v_acc(speedsetting, :), brakeEnd);
    
end