% x_brake, v_brake, x_acc, v_acc consist of 8 vectors each (every
% speedsetting)
function brakePoint = KITTstop(batt_level, speedsetting, stopdistance, x_brake, v_brake, x_acc, v_acc)
    

    % Select the curves at speedsetting and compensate for battery level
    % 8 speedlevels (8 is fastest)
    brakePoint = CurvesIntersect(stopdistance, x_brake(speedsetting), v_brake(speedsetting), x_acc(speedsetting), v_acc(speedsetting), brakeEndings(speedsetting));
    
end