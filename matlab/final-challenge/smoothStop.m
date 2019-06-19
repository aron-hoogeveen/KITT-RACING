function [] = smoothStop(offline, speed)
%smoothStop(speed) stops the KITT Racing car that is driving at a constant
%    speed with speed setting 'speed'.
%    If the speed setting is not valid the car will brake (of reverse) for
%    a short time, and the connection to the car will be closed to prevent
%    damage to the car.

switch speed
    case 158
        stopSpeed = 'M145';
        stopTime = 0.2;
        EPOCom(offline,'transmit', stopSpeed);
        pause(stopTime);
        EPOCom(offline,'transmit', 'M150');
    case 160
        % Testcase 18.9[V]
        disp('smooth 160 stop');
        stopSpeed = 'M138';
        stopTime = 0.2;
        EPOCom(offline,'transmit', stopSpeed);
        pause(stopTime);
        EPOCom(offline,'transmit', 'M150');
        
    case 163
        stopSpeed = 'M138';
        stopTime = 0.3;
        EPOCom(offline,'transmit', stopSpeed);
        pause(stopTime);
        EPOCom(offline,'transmit', 'M150');
    case 165
        % Testcase 18.9[V]
        stopSpeed = 'M135';
        stopTime = 0.4;
        EPOCom(offline,'transmit', stopSpeed);
        pause(stopTime);
        EPOCom(offline,'transmit', 'M150');
    case 666
        stopSpeed = 'M135';
        stopTime = 0.2;
        EPOCom(offline,'transmit', stopSpeed);
        pause(stopTime);
        EPOCom(offline,'transmit', 'M150');
    otherwise
        warning('smoothStop: the provided speed setting could not be processed. Trying to slow down the car now...');
        % Brake for a short time to avoid major crashes.
        EPOCom(offline,'transmit', 'M140');
        pause(0.3);
        EPOCom(offline,'transmit', 'M150');
        disp('Closing the connection te the car...');
        EPOCom(offline,'close');
        disp('Connection closed.');
end%switch

end%smoothStop