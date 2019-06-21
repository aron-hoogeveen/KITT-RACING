% EPO-4 Group B4
% 18-06-2019

function [x, y, callN] = KITTLocation(offline, recordArgs, callN)
%[] = KITTLocation(argin) returns an x and y
%    coordinate. When <offline>==true then the function will return sample
%    data. If <offline>==false than this function calls the function that
%    requests the real time location of the car.

% Define a persistent variable <input_values>
persistent input_values

% Input error checking
if (nargin < 2)
    error('Not enough input arguments!');
end

if (offline)
    if (callN == 1)
        % Ask the user how many value pairs he/she would like to input
        i_user = input('Enter number of locations: ');
                
        if i_user < 1
            warning('Input must be greater than zero. Setting input value to 1 for you...');
            i_user = 1;
        end
        
        % initialize the input matrix
        input_values = zeros(i_user, 2);
        i = 1;
        while (i < i_user + 1)
            new_input = input('New value pair (in the form of [x,y]): ');
            % Check if the input is a matrix of two elements 
            
            if(size(new_input,1) == 1 && size(new_input,2) == 2)
                % Add the new input
                input_values(i,:) = new_input;
            else
                % Incorrect input
                warning('You did not input a legal value. Try again');
                i = i - 1;
            end
            i = i + 1;
        end%while
        
        % Output the first inputted element and increment <callN>
        x = input_values(callN,1);
        y = input_values(callN,2);
        % Check if there are any pre-entered locations left. Otherwise
        % let the user enter new locations the next time.
        if (size(input_values,1) == callN)
            callN = 1;
            input_values = [];
        else
            callN = callN + 1;
        end
    else
        % Check if the <input_values> variable is not empty
        if (isempty(input_values))
            warning('<input_values> is empty! Did you forget to input locations? Because you are special, I will give you the oppurtunity to input 1 location pait anyway. However I will not check the input for any errors...');
            i = 1;
            while (i < 2)
                new_input = input('New value pair (in the form of [x,y]): ');
                % Check if the input is a matrix of two elements 
                if(size(new_input,1) == 1 && size(new_input,2) == 2)
                    % Add the new input
                    input_values(i,:) = new_input;
                else
                    % Incorrect input
                    warning('You did not input a legal value. Try again');
                    i = i - 1;
                end
                i = i + 1;
            end%while
            x = input_values(callN,1);
            y = input_values(callN,2);
            callN = 1; % Make <callN> 1 to ensure that the next time this function is called the user has to input some legit values
        else
            % Output the <callN> element of the previous inputted data
            x = input_values(callN,1);
            y = input_values(callN,2);
            
            % Check if there are any pre-entered locations left. Otherwise
            % let the user enter new locations the next time.
            if (size(input_values,1) == callN)
                callN = 1;
                input_values = [];
            else
                callN = callN + 1;
            end
        end%if(isempty(input_values))
    end
else
    % Online
%     warning("The real time location function has not been added yet!" + newline +...
%         "    The value of the returned <x> and <y> is NaN.");
%     x = NaN; y = NaN;
%     callN = callN + 1;
    % Retrieve the coordinates of the KITT car
    
    [coord, ~] = Record_TDOA(recordArgs.ref, recordArgs.peakperc, recordArgs.mic, recordArgs.d, recordArgs.peakn, recordArgs.Fs, recordArgs.Fbit, recordArgs.RepCount, recordArgs.RecTime, recordArgs.transmap);
    x = coord(1);
    y = coord(2);
    callN = callN;
end

end%KITTLocation