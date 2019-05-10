function [brakePoint, vPoint] = KITTstop(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, delay)

    xPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    vPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 0);
    
    % Compensate for delay (ms)
    x_comp = delay * vPoint/90; %cm/ms
 
    brakePoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1)-x_comp;
  
end