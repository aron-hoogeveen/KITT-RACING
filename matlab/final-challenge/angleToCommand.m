function command = angleToCommand(angle, direction, d_q, ang_q)
% angleToCommand Converts angles to commands for the control function
% 
%    command = angleToCommand(angle, direction) converts <angle> to a valid
%    <direction> command that can be send to KITT.
%
%    EPO-4 Group B4
%    <insert date of last modification>

    if (abs(angle) > 25)
        error('Angle is out of range (>25)');
    end

    if (strcmp(direction,'right'))
        command = interp1(ang_q,d_q,-1*angle, 'nearest'); %right is negative in measurements, so angle*-1
    else if (strcmp(direction,'left'))
        command = interp1(ang_q,d_q,angle, 'nearest');
    else
        msg = 'No valid direction argument ("left" or "right")';
        error(msg)
    end
end%angleToCommand