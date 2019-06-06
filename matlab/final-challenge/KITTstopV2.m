% EPO-4 Group B4
% 13-05-2019
% Calculating the brakePoint (in driven distance, NOT distance to the wall) 

% stopdistance: desired distance driven
% x_brake, v_brake, x_acc, v_acc: velocity-position curves
% brakeEnd: property of braking curve where v = 0;
% delay: optional added delay (in ms) which shifts the distance according to the speed


% Output in milliseconds
function [timeToDrive, vPoint] = KITTstopV2(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, turnEndSpeed)
    % Find the index of the turnEndSpeed and crop the v_acc and x_acc
    % accordingly
    iEndSpeed = find(v_acc>turnEndSpeed);
    v_acc = v_acc(iEndSpeed:end); % FIXME it is possible that the cropping causes the v_acc to be too short. If that is the case just trek het grafiekje door
    x_acc = x_acc(iEndSpeed:end);
    x_acc = x_acc - min(x_acc);
    figure;
     plot(x_acc);title('xacc');
    plot(x_acc, v_acc);title('x - v - acc zoals kittstopv2');
    figure;
    
    xPoint = CurvesIntersect(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 1);
    vPoint = CurvesIntersect(distance, x_brake, v_brake, x_acc, v_acc, brakeEnd, 0);

    % Convert the xPoint to the time it takes to get to that point. 
    i = find(abs(x_acc-xPoint) < 0.1); % Get the index of x_acc where the distance is equal to the stop distance.
    disp("xPoint is " + string(xPoint));
%     disp("i is " + string(i));
%     disp("x_acc = ");
%     disp(x_acc);
    timeToDrive = i * 37; % 1 sample corresponds to 37 miliseconds. 
end%KITTstopV2