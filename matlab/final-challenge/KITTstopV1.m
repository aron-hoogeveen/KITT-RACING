% EPO-4 Group B4
% 13-05-2019
% Calculating the brakePoint (in driven distance, NOT distance to the wall) 

% stopdistance: desired distance driven
% x_brake, v_brake, x_acc, v_acc: velocity-position curves
% brakeEnd: property of braking curve where v = 0;
% delay: optional added delay (in ms) which shifts the distance according to the speed

function [brakePoint, vPoint] = KITTstopV1(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, delay)

    xPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    vPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 0);
    
    % Compensate for delay (ms)
    x_comp = delay * vPoint/90;
 
    brakePoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1)-x_comp;
  
end%KITTstopV1

% End of code