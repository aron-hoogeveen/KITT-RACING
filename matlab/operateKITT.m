function [] = operateKITT(comPort)
%OPERATEKITT(params) is a loop for controlling the KITT racing car.
%    <INSERT DETAILED FUNCTION DESCRIPTION>
try
    debugValue = 1;
    % available commands
    helpStr = 'Available commands: s(tatus);f(orwards);b(ackwards);l(eft);r(ight);n(eutral);m(iddle)';

    % Initialize the connection
    result = EPOCommunications('open', comPort);
    if (result == 0 && debugValue == 0)
        disp('The connection could not be established');
        return;
    else
        disp('The connecton has been established');
    end

    % Enter a loop that continuously waits for commands
    % This loop does not have a 'stress' keypress option (press a specific key
    % and immediatly send a specific command to the car)
    while (1 == 1)
        clear userInput;
        status = '';

        % Ask the user for a command
        userInput = input('Command: ', 's');

        % Quit if an empty string is returned
        if (isempty(userInput)) 
            %try to send neutral to the car
            EPOCommunications('transmit', 'M150'); % Neutral
            EPOCommunications('close');
            return;
        end

        switch userInput(1)
            case 'h'%elp
                disp(helpStr);
            case 's'%tatus
                status = EPOCommunications('transmit', 'S');
            case 'f'%orwards
%                 EPOCommunications('transmit', 'D154');
                EPOCommunications('transmit', 'M165'); 
                status = EPOCommunications('transmit', 'S');
            case 'b'%ackwards
                EPOCommunications('transmit', 'M135');
                status = EPOCommunications('transmit', 'S');
            case 'l'%eft
                EPOCommunications('transmit', 'D200');
                status = EPOCommunications('transmit', 'S');
            case 'r'%ight
                EPOCommunications('transmit', 'D100');
                status = EPOCommunications('transmit', 'S');
            case 'n'%eutral
                EPOCommunications('transmit', 'M150');
                status = EPOCommunications('transmit', 'S');
            case 'm'%iddle
                EPOCommunications('transmit', 'D154');
                status = EPOCommunications('transmit', 'S');
        end

        if (isempty(status))
            % Do nothing
        else
            disp(status);
        end
    end
catch
    % Encountered an error. Close the connection
    EPOCommunications('close');
    disp('Encountered error. Closed connection. Exiting...');
    return
end
end