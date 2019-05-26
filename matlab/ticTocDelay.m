function [argsout] = ticTocDelay()
%ticTocDelay measures the time needed for execution of Matlab commands and
%    time needed for sending and/or receiving data from the KITT Racing
%    car.
    argsout = d_strplit();
end

function [executionTime] = d_strplit()
    % Testign variables
    status = '* Dist. L 500 R 500'; % theoretical status string
    delay = 0.35; % Not the extual delay. Only 
    speed = 140; % [cm/s]
    stopPoint = 20; % Should not trigger the if statement
    
    n = 100;

    tic
    for i=1:n
        distStr = strsplit(status);
        sensorL = str2double(distStr{1}(4:end));
        sensorR = str2double(distStr{2}(4:end));

        % The sensor values can be considered accurate when
        %   - THE FOLLOWING IS NOT TRUE. ~they are smaller than +/-250 cm;~
        %   - they are larger than +/-20 cm;
        %   - sensorL and sensorR are within 15 centimeter of eachother
        %     (assuming that the wall is orthogonal to the car, otherwise this 
        %     value could be higher)

        % differenceX resembles the current distance to the breakPoint

        projectedDistanceL = sensorL + delay * speed;
        projectedDistanceR = sensorR + delay * speed;
        if ( abs(sensorL - sensorR) <= 10 ) && ( (projectedDistanceR < stopPoint) || (projectedDistanceL < stopPoint ))
            % If the deviation between the two sensors is more than 10 cm, the 
            % sensor values (or at least one) should be considered worthless. 
            disp(strcat('SensorL=', sensorL, ', projectedDistanceL=', projectedDistanceL));
            disp(strcat('SensorR=', sensorR, ', projectedDistanceR=', projectedDistanceR));

            %smoothStop(speedSetting); % actual stop function is written in another function to keep this function readable.
            break;
        end
    end%for
    executionTime = toc / n;
end