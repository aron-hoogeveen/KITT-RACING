function [distanceR, distanceL] = mainKITT(comPort, speed, stopDistance)
%mainKITT controls the KITT racing car.
%    speed is defined as: 	%    [distanceR, distanceL] = mainKITT(comPort, speed, stopDistance) opens
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

if (nargin < 3)
    error('Not enough input arguments.');
end

% Close the comport connection when an error is encountered.
try
    % Initialize the connection
    result = EPOCommunications('open', comPort);
    if (result == 0)
        disp('The connection could not be established');
        return;
    else
        disp('The connecton has been established');
    end
    
    distR = 999; % Initialize distance overload
    distL = 999; % Initialize distance overload
    
    % Matrices to store the sensor values in
    distanceR = [];
    distanceL = [];
    
    % Wait for user input to start
    input('Press enter to start...');
    
    % Start driving forward
    speedKITT = strcat('M', string(speed));
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
            break;
        end
        
        % Removed the wait statement that was here.
    end
    
    % Close the connection
    EPOCommunications('close');
    disp('Done with execution');
catch e
    % MAIDAY MAIDAY CLOSE THE CONNECTION
    EPOCommunications('close');
    disp(strcat('Error "', e.identifier, '"', ': "', e.message, '"'));
end
end