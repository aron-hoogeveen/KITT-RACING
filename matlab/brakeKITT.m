function [distanceR, distanceL, timeVector] = brakeKITT(comPort)
%[distanceR, distanceL] = brakeKITT(comPort, speed, stopDistance) is used
%    to let the car drive up to 1 meter distance from the wall and then
%    stop the car. (It is assumed that the car will be stopped in time
%    before it reaches the wall)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: DO NOT FORGET TO VALIDATE ALL CAR SETTINGS (like speed, brake
% speed, etc) AND INCLUDE IT IN THE FILENAME, OR BETTER AS SEPERATE
% VARIABLES THAT WILL BE SAVED ALONGSIDE THE SENSORDATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if (nargin < 1)
%     error('Not enough input arguments.');
% end
% if (nargin < 2)
%     speed = 160;
% end
% if (nargin < 3)
%     stopDistance = 100;
% end
speed = 160;
stopDistance = 200;
if (stopDistance < 20)
    error('stopDistance needs to be greater than 20.');
end

% Close the comport connection when an error is encountered.
try
    % Initialize the connection
    result = EPOCommunications('open', char(comPort));
    if (result == 0)
        error('The connection could not be established');
    end
    disp('The connecton has been established');

    
    distR = 999; % Initialize distance overload
    distL = 999; % Initialize distance overload
    
    % Matrices to store the sensor values in
    distanceR = [];
    distanceL = [];
    timeVector = [0];
    
    % Wait for user input to start
    input('Press enter to start...');
    
    % Start driving forward
    speedKITT = char(strcat('M', string(speed)));
    EPOCommunications('transmit', 'D152');  % Fix the steering offset of the car
    EPOCommunications('transmit', speedKITT);
    
    disp('Process started.');
    startTime = tic;
    
    while (1 == 1)
        % Request the data from the KITT distance sensors.
        % There will be duplicate data in the received data, as the time it
        % takes to request the distance is only about 40 milliseconds while
        % the time it takes the sensors to refresh their measurement is
        % about 70 milliseconds.
        status = EPOCommunications('transmit', 'Sd');
        newTime = toc(startTime);
        distStr = strsplit(status);
        distL = str2num(distStr{1}(4:end));
        distR = str2num(distStr{2}(4:end));
        
        % Append the distance to the previous measured distances.
        distanceR = [distanceR, distR];
        distanceL = [distanceL, distL];
        timeVector = [timeVector, newTime];
        
        % If the car is at the given 'stop' distance, start stopping
        if (((distR < stopDistance && distR > 20) || (distL < stopDistance && distL > 20)) && (abs(distR - distL) <= 40))
            % The above conditional statement should filter out most of the
            % random errors that the distance sensors will give sometimes. 
            
            if (speed == 165)
                EPOCommunications('transmit', 'M135');
            else
                EPOCommunications('transmit', 'M138');
            end
            % Stop the car
            breakTimer = tic;
            for i=1:10 % Tweak this value when the car does not stop in time
                status = EPOCommunications('transmit', 'Sd');
                newTime = toc(startTime);
                distStr = strsplit(status);
                distL = str2num(distStr{1}(4:end));
                distR = str2num(distStr{2}(4:end));

                % Append the distance to the previous measured distances.
                distanceR = [distanceR, distR];
                distanceL = [distanceL, distL];
                timeVector = [timeVector, newTime];
            end
%             pause(0.4);
            toc(breakTimer);
%             pause(0.4)
            EPOCommunications('transmit', 'M150');
            
            break;%while
        end%if
        
        % Removed the wait statement that was here.
    end%while
    
    % Add a few extra measurements to the breaking data
    for i=1:15 
        status = EPOCommunications('transmit', 'Sd');
        newTime = toc(startTime);
        distStr = strsplit(status);
        distL = str2num(distStr{1}(4:end));
        distR = str2num(distStr{2}(4:end));
        
        % Append the distance to the previous measured distances.
        distanceR = [distanceR, distR];
        distanceL = [distanceL, distL];
        timeVector = [timeVector, newTime];
    end
    
    % Close the connection
    EPOCommunications('close');
    disp('Done with execution');
catch e
    % MAIDAY MAIDAY CLOSE THE CONNECTION
    EPOCommunications('close');
    disp(strcat('Error "', e.identifier, '"', ': "', e.message, '"'));
end%try
end%accKITT