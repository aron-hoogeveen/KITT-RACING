function command = angleToCommand(angle, direction)
%command = angleToCommand(angle, direction) converts angle to command for
%the control
% run convertAngleMeasurements beforehand for the vectors
% 27-05-2019
% Group: B.04

    global d_q;
    global ang_q;

    if (abs(angle) > 25)
        error('Angle is out of range (>25)');
    end

    if (strcmp(direction,'right'))
        command = interp1(ang_q,d_q,-1*angle, 'nearest'); %right is negative in measurements, son angle*-1
    else if (strcmp(direction,'left'))
        command = interp1(ang_q,d_q,angle, 'nearest');
    else
        msg = 'No valid direction argument ("left" or "right")';
        error(msg)
    end
end%angleToCommand