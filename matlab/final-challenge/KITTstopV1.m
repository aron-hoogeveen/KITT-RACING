% EPO-4 Group B4
% 13-05-2019
% Calculating the brakePoint (in driven distance, NOT distance to the wall) 

% stopdistance: desired distance driven
% x_brake, v_brake, x_acc, v_acc: velocity-position curves
% brakeEnd: property of braking curve where v = 0;
% delay: optional added delay (in ms) which shifts the distance according to the speed

function [timeToDrive, vPoint] = KITTstopV1(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd)

    xPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    vPoint = CurvesIntersect(stopdistance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 0);

    % Convert the xPoint to the time it takes to get to that point. 
    i = find(x_acc==xPoint); % Get the index of x_acc where the distance is equal to the stop distance.
    timeToDrive = i * 37e-3; % 1 sample corresponds to 37 miliseconds. 
  
end%KITTstopV1

% End of code