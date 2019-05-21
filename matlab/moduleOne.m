function [] = moduleOne(comPort, startDistance, stopDistance, steeringOffset)
%[] = moduleOne(comPort, startDistance, stopDistance, [steeringOffset])
%    The comPort need only be the numberic part of the comport. The textual
%    part will be appended in this function.
%
%    EPO-4 Group B4
%    21-05-2019

if (nargin < 3)
    error('Not enough input arguments. Check the help for the function syntax');
end
if (nargin < 4)
    steeringOffset = 'D152'; % Default steering offset as used in the last EPO sessions
else
    steeringOffset = char(strcat('D', string(steeringOffset)));
end

% check if the stopDist is an integer.
if (mod(stopDistance,1) ~= 0)
    error('stopDist moet een integer zijn.');
end

% Check if the comPort is an integer and if so, append the comport text to
% it.
if (mod(comPort,1) ~= 0)
    error('The comPort has to be an integer');
end
comPort = char(strcat('.//COM', string(comPort)));
disp(strcat('the comport is "', comPort, '"'));

% EDIT: moved the opening of the connection outside the script since the time
% measurement of the midterm challenge will start after pressing {ENTER} and
% this wastes valuable time.

% Open up the connection to the KITT Racing car.
% if (EPOCommunications('open', comPort) ~= 1)
%     % TODO: Most likely the conenction failed due to an already open port.
%     %     Close the connection to the port. 
%     error('The connection could not be established.');
% end
% disp('Connection to KITT Racing car succesful.');

% Compensate the distance that the sensors are behind the bumper of the car
stopDistance = stopDistance + 8.5;

% Read out the current voltage of the car. This voltage will be used to
% adjust the projected distance accordingly.
voltageStr = EPOCommunications('transmit', 'Sv');
voltage = str2double(voltageStr(6:9)); % Extract the voltage


% Start driving towards the wall. 
% The speed setting is predefined and should be set here. If needed one
% could add an optional function input parameter that overwrites this
% predefined speedSetting value. 
speedSetting = 160;
KITTspeed = char(strcat('M', string(speedSetting)));

% Calculate the break point
% Load the brake & acceleration data to compute the stoppoint with
%load Acc160-185V.mat;
%load Brake140-185V.mat;
load acc_ploy.mat;
load brake_ploy_v2.mat;
% this loads ydis_brake, yspeed_brake, ydis_acc, yspeed_acc

yspeed_acc = [yspeed_acc 156];  % fixes for a too short acceleration for version 1
ydis_acc = [ydis_acc 500]; % fixes for a too short acceleration curve for version 1
driveDistance = startDistance - stopDistance;
[breakPoint, speed] = KITTstop(driveDistance, ydis_brake, yspeed_brake, ydis_acc, yspeed_acc, 186.5, 0);

% breakPoint is given as the distance that the car should drive, so convert
% it to the distance that the car will be from the wall
stopPoint = startDistance - breakPoint;
disp(strcat('stopPoint=', string(stopPoint)));

% Delay that is used to compute the projected distance
delay = (37e-3 + 0.5 * 35e-3 + 0.5 * 37e-3) * 5; % requestDistanceDelay + 0.5 * sensorUpdateDelay + matlabCalculationsDelay + sendStopDelay(=0.5*requestDistanceDelay)

% Voltage Correction
if (voltage > 19)
    voltageCorrection = 0.9;
elseif (voltage <= 19 && voltage > 18.5)
    voltageCorrection = 1.1;
elseif (voltage <= 18.5 && voltage > 18)
    voltageCorrection = 1.1; 
elseif (voltage <= 18 && voltage > 17.5)
    voltageCorrection = 1.3; % TODO: this voltageCorrection has not been verified for correctness
elseif (voltage <= 17.5 && voltage > 17)
    voltageCorrection = 1.4; % TODO: this voltageCorrection has not been verified for correctness
else
    % Voltage is lower than 17
    voltageCorrection = 1.6; % TODO: this voltageCorrection has not been verified for correctness
end

% Correct the steering offset
EPOCommunications('transmit', steeringOffset);
% Drive
EPOCommunications('transmit', KITTspeed);
while (1 == 1)
    % Read out sensor data and compare it to the breakPoint
    % Only compare sensor values that can be considered accurate
    status = EPOCommunications('transmit', 'Sd');
    distStr = strsplit(status);
    sensorL = str2double(distStr{1}(4:end));
    sensorR = str2double(distStr{2}(4:end));
    
    projectedDistanceL = sensorL - delay * speed * voltageCorrection;
    projectedDistanceR = sensorR - delay * speed * voltageCorrection;
    if ( abs(sensorL - sensorR) <= 40 ) && ( (projectedDistanceR < stopPoint) || (projectedDistanceL < stopPoint ))
        disp(strcat('Speed=', string(speed)));
        disp(strcat('delta=', string(delay * speed)));
        disp(strcat('SensorL=', string(sensorL), ', projectedDistanceL=', string(projectedDistanceL)));
        disp(strcat('SensorR=', string(sensorR), ', projectedDistanceR=', string(projectedDistanceR)));
        
        % Stop the car
        smoothStop(speedSetting);
        break;
    end
end%while
pause(1);
% read out the final measured distance at standstill
status = EPOCommunications('transmit', 'S');
disp(status);
disp(string(stopPoint));

% NOTE: to use our time efficiently the connection is not closed in this 
% function

% Close the connection to the car. 
% EPOCommunications('close');
% disp('Connection closed.');
end%moduleOne