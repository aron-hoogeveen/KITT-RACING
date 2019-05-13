function [distanceR, distanceL] = brakeKITT(comPort, speed, stopDistance)
%[distanceR, distanceL] = brakeKITT(comPort, speed, stopDistance) is used
%    to let the car drive up to 1 meter distance from the wall and then
%    stop the car. (It is assumed that the car will be stopped in time
%    before it reaches the wall)
if (nargin < 1)
    error('Not enough input arguments.');
end
if (nargin < 2)
    speed = 160;
end
if (nargin < 3)
    stopDistance = 100;
end
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
    
    % Wait for user input to start
    input('Press enter to start...');
    
    % Start driving forward
    speedKITT = char(strcat('M', string(speed)));
    EPOCommunications('transmit', 'D154');  % Fix the steering offset of the car
    EPOCommunications('transmit', speedKITT);
    
    disp('Process started.');
    while (1 == 1)
        % Request the data from the KITT distance sensors.
        % There will be duplicate data in the received data, as the time it
        % takes to request the distance is only about 40 milliseconds while
        % the time it takes the sensors to refresh their measurement is
        % about 70 milliseconds.
        status = EPOCommunications('transmit', 'Sd');
        distStr = strsplit(status);
        distL = str2num(distStr{1}(4:end));
        distR = str2num(distStr{2}(4:end));
        
        % Append the distance to the previous measured distances.
        distanceR = [distanceR, distR];
        distanceL = [distanceL, distL];
        
        % If the car is at the given 'stop' distance, start stopping
        if (((distR < stopDistance && distR > 20) || (distL < stopDistance && distL > 20)) && (abs(distR - distL) <= 10))
            % The above conditional statement should filter out most of the
            % random errors that the distance sensors will give sometimes. 
            
            % Stop the car
            for i=1:10 % Tweak this value when the car does not stop in time
                status = EPOCommunications('transmit', 'Sd');
                distStr = strsplit(status);
                distL = str2num(distStr{1}(4:end));
                distR = str2num(distStr{2}(4:end));

                % Append the distance to the previous measured distances.
                distanceR = [distanceR, distR];
                distanceL = [distanceL, distL];
            end
            
            break;%while
        end%if
        
        % Removed the wait statement that was here.
    end%while
    
    % Add a few extra measurements to the breaking data
    for i=1:4 
        status = EPOCommunications('transmit', 'Sd');
        distStr = strsplit(status);
        distL = str2num(distStr{1}(4:end));
        distR = str2num(distStr{2}(4:end));
        
        % Append the distance to the previous measured distances.
        distanceR = [distanceR, distR];
        distanceL = [distanceL, distL];
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