function [] = operateKITT(comPort)
%OPERATEKITT(params) is a loop for controlling the KITT racing car.
%    <INSERT DETAILED FUNCTION DESCRIPTION>
debugValue = 0;
% available commands
helpStr = 'Available commands: s(tatus);f(orwards);b(ackwards);l(eft);r(ight);n(eutral)';

% Initialize the connection
result = EPOCommunications('open', comPort);
if (result == 0 && debugValue == 0)
    disp('The connection could not be established');
    return;
end

% Enter a loop that continuously waits for commands
% This loop does not have a 'stress' keypress option (press a specific key
% and immediatly send a specific command to the car)
while (1 == 1)
    clear userInput;
    
    % Ask the user for a command
    userInput = input('Command: ', 's');
    
    % Quit if an empty string is returned
    if (isempty(userInput)) 
        %try to send neutral to the car
        EPOCommunications('transmit', 'M150');
        return;
    end
    
    switch userInput(1)
        case 'h'%elp
            disp(helpStr);
        case 's'%tatus
            status = EPOCommunications('transmit', 'S');
            disp(status);
        case 'f'%orwards
            EPOCommunications('transmit', 'M160'); 
        case 'b'%ackwards
            EPOCommunications('transmit', 'M145');
        case 'l'%eft
            EPOCommunications('transmit', 'D100');
        case 'r'%ight
            EPOCommunications('transmit', 'D200');
        case 'n'%eutral
            EPOCommunications('transmit', 'M150');
    end
end
end