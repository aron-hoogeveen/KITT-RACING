function [] = smoothStop(speed)
%smoothStop(startSpeed) aims to stop the KITT Racing car without overshoot
%    when the car has a constant speed of startSpeed.
%
%    TODO: Test if it is needed to use the realtime speed as input instead
%    of startSpeed, since maybe the car is not yet at full speed.
switch speed
    case 157
        stopSpeed = 'M145';
        stopTime = 0.2;
        EPOCommunications('transmit', stopSpeed);
        pause(stopTime);
        EPOCommunications('transmit', 'M150');
    case 160
        % Testcase 18.9[V]
        stopSpeed = 'M138';
        stopTime = 0.4;
        EPOCommunications('transmit', stopSpeed);
        pause(stopTime);
        EPOCommunications('transmit', 'M150');
        
    case 163
        stopSpeed = 'M138';
        stopTime = 0.3;
        EPOCommunications('transmit', stopSpeed);
        pause(stopTime);
        EPOCommunications('transmit', 'M150');
    case 165
        % Testcase 18.9[V]
        stopSpeed = 'M135';
        stopTime = 0.4;
        EPOCommunications('transmit', stopSpeed);
        pause(stopTime);
        EPOCommunications('transmit', 'M150');
    otherwise
        disp('The provided speed for the smoothStop function could not be found in the switch statement.');
        disp('Closing the connection te the car...');
        EPOCommunications('close');
end%switch

end%smoothStop