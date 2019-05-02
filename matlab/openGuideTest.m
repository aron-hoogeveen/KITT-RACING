function [] = openGuideTest()
%openGuideTest opens the GUI guide_test and adds extra functionality to it.
    
    % Global variables. There must be a more efficient way to do this. But
    % this is the easiest way :)
    global currentSpeed;
    global guiFig;
    currentSpeed = 150;
    
    guiFig = guide_test;
    
    % Set static text elements
%     guiFig.figure1.text2.String = 'test123';
    guiFig.Children(4).String = string(currentSpeed); % txtSpeed
%     guiFig.txtStatus.String = 'Press <ENTER> to get a status update...';
    guiFig.Children(2).String = 'Press <ENTER> to get a status update...'; % txtStatus
    
    % Set keyPress handle
    set(guiFig, 'KeyPressFcn', @keyPressHandle);
end

function keyPressHandle(hObject, event)
    % asdw 
    % space
    % enter
%     if (event.Key == 'space')
%         disp('Space bar has been pressed');
%     elseif (event.Key == 'enter')
%         disp('Enter has been pressed');
%     end
    
    % Variables
    global currentSpeed;
    speedIncrease = 2; % Set the step size of speed increase
    currentDirection = 0;

    if (strcmpi(event.Key, 'escape'))
        % panick button + close connection
        
    elseif (strcmpi(event.Key, 'space'))
        % panick button - only neutral
        currentSpeed = 150;
        
        % Send new speed to car
%         EPOCommunications('transmit', strcat('M', string(currentSpeed)));
%         status = EPOCommunications('transmit', 'S');
        
        % Update fields
        hObject.Children(2).String = 'Press <ENTER> to get a status update...'; % txtStatus
        hObject.Children(4).String = string(currentSpeed); % txtSpeed
        
    elseif (strcmpi(event.Key, 'enter'))
        % Request status
        
    elseif (strcmpi(event.Key, 'a'))
        % Left
        if (currentDirection == -1) % left
            % Already left. Do nothing
        elseif (currentDirection == 0) % straight
            % Turn Left
            currentDirection = -1;
            EPOCommunications('transmit', 'D200');
            status = EPOCommunications('transmit', 'S');
            
            % Update fields
            hObject.Children(2).String = status; % txtStatus
        elseif (currentDirection == 1) % right
            currentDirection = 0;
            EPOCommunications('transmit', 'D150');
            status = EPOCommunications('transmit', 'S');
            
            % Update fields
            hObject.Children(2).String = status; % txtStatus
        end
        
    elseif (strcmpi(event.Key, 's'))
        % Reverse
        if (currentSpeed <= 135)
            % Speed cannot be smaller than 135
            currentSpeed = 135;
        else
            % Decrease current speed
            currentSpeed = currentSpeed - speedIncrease;
            
            if (currentSpeed < 135)
                % Oops...
                currentSpeed = 135;
            end
        end
        % Send new speed to car
        EPOCommunications('transmit', strcat('M', string(currentSpeed)));
        status = EPOCommunications('transmit', 'S');

        % Update fields
        hObject.Children(2).String = 'Press <ENTER> to get a status update...'; % txtStatus
        hObject.Children(4).String = string(currentSpeed); % txtSpeed
        
    elseif (strcmpi(event.Key, 'd'))
        % Right
        if (currentDirection == -1) % left
            currentDirection = 0;
            EPOCommunications('transmit', 'D150');
            status = EPOCommunications('transmit', 'S');
        elseif (currentDirection == 0) % straight
            % Turn Left
           
            
            % Update fields
            hObject.Children(2).String = status; % txtStatus
        elseif (currentDirection == 1) % right
            currentDirection = 0;
            EPOCommunications('transmit', 'D200');
            status = EPOCommunications('transmit', 'S');
            
            % Update fields
            hObject.Children(2).String = status; % txtStatus
        end
        
    elseif (strcmpi(event.Key, 'w'))
        % Forward
        if (currentSpeed >= 160)
            % Speed cannot be smaller than 135
            currentSpeed = 160;
        else
            % Increase current speed
            currentSpeed = currentSpeed + speedIncrease;
            if (currentSpeed > 160)
                % Oops...
                currentSpeed = 160;
            end
        end
        % Send new speed to car
%         EPOCommunications('transmit', strcat('M', string(currentSpeed)));
%         status = EPOCommunications('transmit', 'S');

        % Update fields
        hObject.Children(2).String = 'Press <ENTER> to get a status update...'; % txtStatus
        hObject.Children(4).String = string(currentSpeed); % txtSpeed
    end
end