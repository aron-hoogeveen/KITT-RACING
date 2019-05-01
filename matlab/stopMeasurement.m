function [] = stopMeasurement(comPort, speed, reverseDelay)
%MAINKITT control unit for challenge 1
%    speed is defined as: 
if (nargin < 3)
    error('Not enough input arguments (two required).');
end

try
    % Initialize the connection
    result = EPOCommunications('open', comPort);
    if (result == 0)
        disp('The connection could not be established');
        return;
    else
        disp('The connecton has been established');
    end
    
    % Wait for user input to start
    input('Press enter to start...');
    
    % Start driving forward
    speedKITT = strcat('M', speed);
    EPOCommunications('transmit', 'D154');  % Fix the steering offset of the car
    EPOCommunications('transmit', speedKITT);
    
    disp('Driving started.');
    
    % Wait for the car to get to maximum velocity
    pause(1.5); % Tweak this setting by trial and error
    
    % Start braking
    EPOCommunications('transmit', 'M135'); % Maximum breaking power (check if no skidding occurs)
    pause(reverseDelay);
    % Stop the breaking
    EPOCommunications('transmit', 'M150'); % Neutral
    
    % Close the connection
    EPOCommunications('close');
    disp('Done with execution');
catch e
    % MAIDAY MAIDAY CLOSE THE CONNECTION
    EPOCommunications('close');
    disp(strcat('Error "', e.identifier, '"', ': "', e.message, '"'));
end
end