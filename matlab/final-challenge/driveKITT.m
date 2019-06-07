function [] = driveKITT(offline,  maximumLocalizationTime, drivingTime, pointsAmount, endpoint, transmitDelay, v_rot, t_radius, v_rot_prime, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc, d_q, ang_q)
            % KITT is already driving when this function is called (with
            % straight wheels)

            doPause = true; % pause for drivingTime - time it takes for audio, will stay true if driving is not interrupted
            t_loc_start = tic; % Start timing the audio coordinates retrieval
            x_points = []; % empty array for the points
            y_points = []; % empty array for the points
            for i=1:pointsAmount
                [x, y] = retrieveAudioLocationFIXME_exlacmationmark(true);%FIXMEthe duration of this computation is variable
                plot(x, y, 'm+', 'MarkerSize', 10, 'linewidth',6); % plot the point on the map
                x_points = [x_points x]; %append the x coordinate to array
                y_points = [y_points y]; %append the y coordinate to array

                
                if(length(x_points) > floor(pointsAmount/2) && length(x_points) > 1) % If KITT has traveled at least half of the path to end
                    % Make a trend line through the audio location points and calculate the actual angle
                    
                    prms = polyfit(x_points,y_points,1);
                    rico = prms(1); % Richtingsco�fficient
                    b = prms(2); %intersection of y-axis (y = mx +b)
                    phi = atand(rico);
                    if (x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) < 0) %x decreasing, y decreasing
                        actual_orientation = phi - 180;
                    elseif(x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) > 0) %x decreasing, y increasing
                        actual_orientation = phi+180;
                    elseif(x_points(end)-x_points(1) > 0 && y_points(end)-y_points(1) < 0) %x increasing, y decreasing
                        actual_orientation = phi;
                    else % x increasing, y increasing
                        actual_orientation = phi;
                    end
                    
                    x_samp = [50:510];
                    % Extend the trend line with y = rico*x + b to calculate the endpoint difference
                    extended_trend = rico*x_samp  +b;
                    % The distance from a point (x_p,y_p) to a line m*x +b is |m*x_p - y_p + b|/sqrt(m^2 + 1)
                    end_dist_difference = abs(rico*endpoint(1) - endpoint(2) + b)/sqrt(rico^2+1); % distance between endpoint and trend

                    if (end_dist_difference > 10) %then: stop and make a corrective turn
                        EPOCom(offline, 'transmit', 'M150');% FIXME: brake or rollout? smoothstop?
                        pause(1) %Wait for KITT to have stopped
                        % Retrieve a new point for audio location
                        [x, y] = retrieveAudioLocationFIXME_exlacmationmark(true);%FIXMEthe duration of this computation is variable
                        plot(x, y, 'm+',  'MarkerSize', 10, 'linewidth',6); % plot the point on the map
                        x_points = [x_points x]; %append the x coordinate to array
                        y_points = [y_points y]; %append the y coordinate to array
                        

                    %   Calculate the actual orientation again with an extra point
                    %   Make a trend line through the audio location points and calculate the actual angle
                        prms = polyfit(x_points,y_points,1);
                        rico = prms(1); % Richtingsco�fficient
                        phi = atand(rico);
                        if (x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) < 0) %x decreasing, y decreasing
                            actual_orientation = phi - 180;
                        elseif(x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) > 0) %x decreasing, y increasing
                            actual_orientation = phi+180;
                        elseif(x_points(end)-x_points(1) > 0 && y_points(end)-y_points(1) < 0) %x increasing, y decreasing
                            actual_orientation = phi;
                        else % x increasing, y increasing
                            actual_orientation = phi;
                        end
                        % Plot the trend line
                        plot(x_samp, x_samp*rico+b, '--m');

                        % Calculate a new turn;
                        [turntime, direction, turnEndPos, new_orientation] = calculateTurn([x_points(end), y_points(end)],endpoint,actual_orientation, t_radius, v_rot_prime);
                        turnEndSpeed = v_rot(turntime); % Velocity of KITT at the end of the new turn
                        new_dist = sqrt((endpoint(2)-y_points(end))^2+(endpoint(1)-x_points(end))^2);
                        [drivingTime, ~] = KITTstopV2(new_dist, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc,186.5,turnEndSpeed); % FIXME, %Time the car must drive in ms (straight line)
                        disp('turning time (ms):');
                        disp( turntime);
                        disp('[direction (1:left, -1:right), new_orientation] = ');
                        disp([direction, new_orientation]);
                        disp('turnEndPos (x, y) = ');
                        disp( turnEndPos);

                        % Compute the amount of location points that can be retrieved in driving time
                        pointsAmount = floor((drivingTime-transmitDelay)/maximumLocalizationTime); %45 is transmit delay
                        
                        %   Perform STEP 1 of challenge A again (do a turn)
                        turnKITT(offline, direction, turntime, transmitDelay, d_q, ang_q);
                        % Recursive function call, drive to the end point again:
                        driveKITT(offline,  maximumLocalizationTime, drivingTime, pointsAmount, endpoint, transmitDelay, v_rot, t_radius, v_rot_prime, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc, d_q, ang_q);
                        
                        doPause = false; % the driving is interupted as KITT deviates from the cours
                    end
                end
            t_loc_elapsed = toc(t_loc_start); % Duration of audio location computing
            if (doPause)
                pause((drivingTime - 45)/1000 - t_loc_elapsed);
                %smoothstop(); %FIXME
            end
      end
end%driveKITT
