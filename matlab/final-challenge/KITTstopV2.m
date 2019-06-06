% EPO-4 Group B4
% 13-05-2019
% Calculating the brakePoint (in driven distance, NOT distance to the wall) 

% stopdistance: desired distance driven
% x_brake, v_brake, x_acc, v_acc: velocity-position curves
% brakeEnd: property of braking curve where v = 0;
% delay: optional added delay (in ms) which shifts the distance according to the speed

function [timeToDrive, vPoint] = KITTstopV2(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, turnEndSpeed)
    % Find the index of the turnEndSpeed and crop the v_acc and x_acc
    % accordingly
    iEndSpeed = find(v_acc>turnEndSpeed);
    v_acc = v_acc(iEndSpeed:end); % FIXME it is possible that the cropping causes the v_acc to be too short. If that is the case just trek het grafiekje door
    x_acc = x_acc(iEndSpeed:end);
    x_acc = x_acc - min(x_acc);
    figure;
%     plot(v_acc);title('vacc');
%     figure;
     plot(x_acc);title('xacc');
    plot(x_acc, v_acc);title('x - v - acc zoals kittstopv2');
    figure;
    % Get the distance that corresponds to iEndSpeed
%     x1 = x_acc(iEndSpeed);
%     iSpeedZero = find(x_acc>(x1+distance)); % find the index of the point where the car should stop
%     iSpeedZero = iSpeedZero - iEndSpeed; % Take the cropping of v_acc into account
    
    
    
    xPoint = CurvesIntersect(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    vPoint = CurvesIntersect(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 0);
 
    brakePoint = CurvesIntersect(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    timeToDrive = 2;
end%KITTstopV2