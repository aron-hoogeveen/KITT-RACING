% EPO-4 Group B4
% 13-05-2019
% Calculates the time needed to drive preStopDist (cm) from the endpoint

% distance: desired distance driven
% v_brake, v_acc: velocity-time curves
% brakeEnd: property of braking curve where v = 0;
% preStopDist: distance KITT needs to stop before the end point

function [brakePoint, vPoint] = KITTstopV2(distance, v_acc, v_brake, brakeEnd, preStopDist)

    xPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    vPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 0);
 
    brakePoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
  
end

% End of code