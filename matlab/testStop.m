function [distanceR, distanceL] = testStop(comPort, speed, stopDistance)
%mainKITT controls the KITT racing car.
%    [distanceR, distanceL] = mainKITT(comPort, speed, stopDistance) opens
%    up a serial bluetooth connection with the KITT racing car, with which
%    commands the car to drive forward with a predefined speed. It reads 
%    out sensor data from the car. Together with the stopDistance it 
%    determines wether to send the stop signal to the car or not.
%    
%    Notes: 
%    The speed of the car is of the format 'xxx', where xxx denotes a 
%    value between and including 156 and 160. 
%
%    This function uses Windows specific functions
%    (EPOCommunications.mexw64) so it can only be used in a Windows
%    environment.
%
%
%    (c) 2019 Epo-4 Group B.04 "KITT Racing"

% Error strings
strSpeedErr = '"speed" needs to be of the form "xxx" with xxx an integer value between 156 and 160.';

% Default values
cmdRefreshTime = 0.04; % [s] FIXME: fine tune this interval

% Check input arguments
if (nargin < 2)
    error('Not enough input arguments (minimum of two required). Type "help mainKITT" to check the syntax of this function.');
end
if (nargin < 3)
    stopDistance = 100; % Default stop distance.
end

% Check format of speed
% if (length(speed) ~= 3)
%     error(strSpeedErr);
% elseif (str2num(speed) < 156 || str2num(speed) > 160)
%     error('The speeds needs to be between 156 and 160.');
% end

% Check format of comPort
% if (comPort(1:3) ~= 'COM')
%     error('comPort needs to be of the form "COMx", with x the comport number');
% end

try
    % Initialize the connection
    result = EPOCommunications('open', comPort);
    if (result == 0)
        error('The connection could not be established');
%         return;
    else
        disp('The connecton has been established');
        EPOCommunications('transmit', 'D154');
    end
    
    % Global variables. These variables are used to comminucate between
    % functions. KITT_STOP signals that the smooth_stop function should be
    % activated. distL and distR contain the current read out sensor values
    % TODO: read out a couple of sensor values and take the average. This
    % can be done to filter out sensor errors. Consider the amount of time
    % it takes to take multiple measurements.
    global KITT_STOP;
    global distR;
    global distL;
    global distParR distParL
    global stopL stopR
    
    KITT_STOP = 0;  % At the start of this script we do not want the car to stop
    distR = 999; % Initialize distance overload
    distL = 999; % Initialize distance overload
    
    % Matrices to store the sensor values in
    distanceR = []; distParR = [];
    distanceL = []; distParL = [];
    
    % Wait for user input to start
    input('Press enter to start...');
    disp('READY');
    pause(0.5); % This is worth our valuable time
    disp('SET');
    pause(0.4);
    
    % Start driving forward
    speedKITT = strcat('M', speed);
    EPOCommunications('transmit', 'D154');  % Fix the steering offset of the car
    % TODO: save default values in a seperate file and read them out. This
    % way it is possible to change a specific value in one place only and
    % have the effect through all functions.
    EPOCommunications('transmit', speedKITT);
    
    disp('GO!');
    while (KITT_STOP ~= 1)
        % TODO: Request only the distance status 'Sd'
        
        status = EPOCommunications('transmit', 'Sd'); % Request only distance
        % Extract sensor values from the returned status
%         distIndex = strfind(status, 'Dist');
%         distEnd = strfind(status(distIndex:end), '*');
%         distStr = status(distIndex:distIndex+distEnd-3);
%         distStr = transpose(split(distStr));
%         distRtemp = distStr(3);
%         distR = str2num(distRtemp{1});
%         distLtemp = distStr(5);
%         distL = str2num(distLtemp{1});
        distStr = strsplit(status);
        distL = str2num(distStr{1}(4:end));
        distR = str2num(distStr{2}(4:end));
        
        
        % Save the distances
        distanceR = [distanceR, distR]; distParR = [distParR, distR];
        distanceL = [distanceL, distL]; distParL = [distParL, distL];
        
        % TODO: implement the stop curve in a way that makes the car stop
        % at exactly the stopDistance. At this moment the car starts
        % stopping at the stopDistance.
        if (distR < stopDistance || distL < stopDistance)
%             KITT_STOP = 1;
            EPOCommunications('transmit', 'M135');
            stopStat = [];
            stopL = []; stopR = [];
            for i=1:26
                status = EPOCommunications('transmit', 'Sd'); % Request only distance
                % Extract sensor values from the returned status
        %         distIndex = strfind(status, 'Dist');
        %         distEnd = strfind(status(distIndex:end), '*');
        %         distStr = status(distIndex:distIndex+distEnd-3);
        %         distStr = transpose(split(distStr));
        %         distRtemp = distStr(3);
        %         distR = str2num(distRtemp{1});
        %         distLtemp = distStr(5);
        %         distL = str2num(distLtemp{1});
                distStr = strsplit(status);
                distL = str2num(distStr{1}(4:end));
                distR = str2num(distStr{2}(4:end));
                
                % Save the distances
                stopR = [stopR, distR]; distParR = [distParR, distR];
                stopL = [stopL, distL]; distParL = [distParL, distL];
            end
            EPOCommunications('transmit', 'M150');
            break;
            % FIXME: consider using break instead of KITT_STOP. This will
            % only make sense when only this conditional statement
            % determines the moment to stop.
        end
        
        pause(cmdRefreshTime);
    end
    
    % Close the connection
    EPOCommunications('close');
    disp('Done with execution, we are.');
    
    clf;
    plot(distanceR);
    hold on;
    plot(distanceL);
    legend('JEMOEDER', 'JEMOEDEL');
    
    figure;
    plot(stopR);
    hold on;
    plot(stopL);
    legend('R', 'ziekeL');
catch e
    % MAIDAY MAIDAY CLOSE THE CONNECTION
    EPOCommunications('close');
    disp(strcat('Error "', e.identifier, '"', ': "', e.message, '"'));
end
end