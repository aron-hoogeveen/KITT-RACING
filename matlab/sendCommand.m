function [status] = sendCommand(command, value)
%SENDCOMMAND sends a command to the KITT remote controlled car
%    insert detailed function description

switch command
    case "initialize"
        % Connect to KITT. Check the connection and return the result
        result = EPOCommunications('open', string(value));
        if (result == 1)
            disp('COM port opended succesfully');
        else
            warning(strcat('Could not open the connection to ', string(value)));
        end
    case "forward"
        
    case "reverse"
        
    case "status"
        
    case "neutral"
end