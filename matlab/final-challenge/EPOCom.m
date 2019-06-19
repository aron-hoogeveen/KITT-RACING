function [result] = EPOCom(offline, cmd, arg1)
% EPOCom Simulates sending commands to KITT when KITT is not connected
%
%    [result] = EPOCom(offline, cmd, arg1) sends the <cmd> with <arg1> to
%    KITT when <offline> is false. When <offline> is true this function
%    will pass the <cmd> and <arg1> to the EPOCommunications function that
%    sends the corresponding data to KITT.
%
%    EPO-4 Group B4
%    <insert date of last modification>

if (nargin < 2)
    error('EPOCom requires at minimum two arguments.');
elseif (nargin < 3)
    if (~strcmp(cmd, 'close'))
        error('Missing required argument <arg1> for option <cmd>.');
    end
end

if (offline == true)
    switch cmd
        case 'open'
            disp(strcat('<offline mode> Connection opened succesfull on port "', arg1, '".'));
            result = 1;
        case 'close'
            disp('<offline mode> Connection closed.');
            result = 1;
        case 'transmit'
            switch arg1(1)
                case 'A'
                    if (length(arg1) ~= 2)
                        error('Faulty markup for <arg1>');
                    else
                        if (strcmp(arg1(2), '0'))
                            disp('<offline mode> Audio OFF');
                        elseif(strcmp(arg1(2), '1'))
                            disp('<offline mode> Audio ON');
                        else
                            error('Faulty markup for <arg1>');
                        end
                        result = 1;
                    end
                case 'B'
                    num = str2double(arg1(2:end));
                    if (num < 0 || num > 65535)
                        error('Error in <arg1> option for argument B out of range');
                    else
                        disp(strcat('<offline mode> Bit frequency set to "', string(num), '".'));
                    end
                    result = 1;
                case 'C'
                    if (length(arg1) ~= 11)
                        error('Error in <arg1> too short for switch C');
                    else
                        disp(strcat('<offline mode> 32 bit code word set to "', arg1(2:end)));
                    end
                    result = 1;
                case 'D'
                    num = str2double(arg1(2:end));
                    if (num < 100 || num > 200)
                        error('Error in <arg1> argument out of range');
                    else
                        disp(strcat('<offline mode> Steering direction is "', string(num), '".'));
                    end
                case 'F'
                    num = str2double(arg1(2:end));
                    if (num < 0 || num > 65535)
                        error('Error in <arg1> carrier frequency out of range.');
                    else
                        disp(strcat('<offline mode> Carrier frequency set to "', string(num), '".'));
                    end
                case 'M'
                    num = str2double(arg1(2:end));
                    if (num < 135 || num > 165)
                        error('Error in <arg1> argument out of range');
                    else
                        disp(strcat('<offline mode> Motor PWM is "', string(num), '".'));
                    end
                case 'R'
                    num = str2double(arg1(2:end));
                    if (num < 32 || num > 65535)
                        error('Error in <arg1> repetition counter out of range.');
                    else
                        disp(strcat('<offline mode> Repetition counter set to "', string(num), '".'));
                    end
                case 'S'
                    if (length(arg1) == 1)
                        result = "***********************" + newline +...
                            "* Audio Beacon: off" + newline +...
                            "* c: 0x       0" + newline +...
                            "* f_c: 15000" + newline +...
                            "* f_b: 5000" + newline +...
                            "* c_r: 2500" + newline +...
                            "***********************" + newline +...
                            "* PWM:" + newline +...
                            "* Dir. 154" + newline +...
                            "* Mot. 150" + newline +...
                            "***********************" + newline +...
                            "* Sensors:" + newline +...
                            "* Dist. L 198 R 127" + newline +...
                            "* V_batt 18.2 " + newline +...
                            "***********************";
                        result = char(result);
                    elseif(length(arg1) == 2)
                        if (strcmp(arg1(2),'d'))
                            result = "* Dist. L 198 R 127"; % TODO fix actual string
                        elseif (strcmp(arg1(2), 'v'))
                            result = 'VBATT18.1V';
                        else
                            error('Error in <arg1> unknows status option');
                        end
                    else
                        error('Error in <arg1> faulty status request.');
                    end
                case 'V'
                    result = '<offline mode> Version: 0.0.1';
                otherwise
                    error('Unknown option for <arg1>');
            end%switch
        otherwise
            error('Unknown cmd');
    end%switch
else
    % Online mode
    result = 0;
    if ((nargin) < 3)
        % Only possible command is 'close'
        result = EPOCommunications(char(cmd));
         if (isempty(result))
            result = 1;
        end
    else
        switch arg1(1)
                case 'A'
                    if (length(arg1) ~= 2)
                        error('Faulty markup for <arg1>');
                    else
                        if (strcmp(arg1(2), '0'))
                            EPOCommunications(char(cmd), char(arg1));
                        elseif(strcmp(arg1(2), '1'))
                            EPOCommunications(char(cmd), char(arg1));
                            error('Faulty markup for <arg1>');
                        end
                        result = 1;
                    end
                case 'B'
                    num = str2double(arg1(2:end));
                    if (num < 0 || num > 65535)
                        error('Error in <arg1> option for argument B out of range');
                    else
                        disp(strcat('<offline mode> Bit frequency set to "', string(num), '".'));
                    end
                    result = 1;
                case 'C'
                    if (length(arg1) ~= 11)
                        error('Error in <arg1> too short for switch C');
                    else
                        EPOCommunications(char(cmd), char(arg1));
                    end
                    result = 1;
                case 'D'
                    num = str2double(arg1(2:end));
                    if (num < 100 || num > 200)
                        error('Error in <arg1> argument out of range');
                    else
                       EPOCommunications(char(cmd), char(arg1));
                    end
                    
                    result = 1;
                case 'F'
                    num = str2double(arg1(2:end));
                    if (num < 0 || num > 65535)
                        error('Error in <arg1> carrier frequency out of range.');
                    else
                        EPOCommunications(char(cmd), char(arg1));
                    end
                    
                    result = 1;
                case 'M'
                    num = str2double(arg1(2:end));
                    if (num < 135 || num > 165)
                        error('Error in <arg1> argument out of range');
                    else
                        EPOCommunications(char(cmd), char(arg1));
                    end
                    
                    result = 1;
                case 'R'
                    num = str2double(arg1(2:end));
                    if (num < 32 || num > 65535)
                        error('Error in <arg1> repetition counter out of range.');
                    else
                        EPOCommunications(char(cmd), char(arg1));
                    end
                    
                    result = 1;
                case 'S'
                    if (length(arg1) == 1)
                        result = EPOCommunications(char(cmd), char(arg1));
                    elseif(length(arg1) == 2)
                        if (strcmp(arg1(2),'d'))
                            result = EPOCommunications(char(cmd), char(arg1));
                        elseif (strcmp(arg1(2), 'v'))
                            result = EPOCommunications(char(cmd), char(arg1));
                        else
                            error('Error in <arg1> unknows status option');
                        end
                    else
                        error('Error in <arg1> faulty status request.');
                    end
                case 'V'
                    result = EPOCommunications(char(cmd), char(arg1));
                otherwise
                    error('Unknown option for <arg1>');
            end%switch
%         result = 1;
        if (isempty(result))
            result = 1;
        end
    end
end%if(offline)

end%EPOCom