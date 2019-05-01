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
    
    % Check if appropriate (global) variables are declared
    global KITT_STOP;
    global distR;
    global distL;
    
    KITT_STOP = 0;
    distR = 999; % Initialize distance overload
    distL = 999; % Initialize distance overload
    
    distanceR = [];
    distanceL = [];
    
    % Wait for user input to start
    input('press enter to start...');
    
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
        % Extract distance from status
        distIndex = strfind(status, 'Dist');
        distEnd = strfind(status(distIndex:end), '*');
        distStr = status(distIndex:distIndex+distEnd-3); % Very beun, much wow
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