function [distanceR, distanceL] = mainKITT(comPort)
%MAINKITT control unit for challenge 1
try
    % Initialize the connection
    result = EPOCommunications('open', comPort);
    if (result == 0)
        disp('The connection could not be established');
        return;
    else
        disp('The connecton has been established');
    end
    
    % Global variables. These variables are used to comminucate between
    % functions. KITT_STOP signals that the smooth_stop function should be
    % activated. distL and distR contain the current read out sensor values
    % TODO: read out a couple of sensor values and take the average. This
    % can be done to filter out sensor errors. 
    global KITT_STOP;
    global distR;
    global distL;
    
    KITT_STOP = 0;  % At the start of this script we do not want the car to stop
    distR = 999; % Initialize distance overload
    distL = 999; % Initialize distance overload
    
    % Matrices to store the sensor values in
    distanceR = [];
    distanceL = [];
    
    % Wait for user input to start
    input('Press enter to start...');
    
    % Start driving forward
    EPOCommunications('transmit', 'D154');
    EPOCommunications('transmit', 'M156');
    
    disp('Process started.');
    while (KITT_STOP ~= 1)
        % Main control loop
        % Start met rechtdoor rijden
        % Status continue opslaan
        %   Extract distance
        % Check for stop signal
        %   Stop the car + status
        
        status = EPOCommunications('transmit', 'S');
        % Extract sensor values from the returned status
        distIndex = strfind(status, 'Dist');
        distEnd = strfind(status(distIndex:end), '*');
        distStr = status(distIndex:distIndex+distEnd-3);
        distStr = transpose(split(distStr));
        distRtemp = distStr(3);
        distR = str2num(distRtemp{1});
        distLtemp = distStr(5);
        distL = str2num(distLtemp{1});
        
        % Save the distances
        distanceR = [distanceR, distR];
        distanceL = [distanceL, distL];
        
        
        
        % STOP THE CAR YEET
        if (distR < 200 || distL < 200)
            KITT_STOP = 1;
        end
        
        pause(0.09);
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