% Sends the drive commands for KITT to turn
function [] = turnKITT(offline, direction, turntime, transmitDelay, d_q, ang_q)
        if (direction == 1)
            steering =  sprintf('%s%d', 'D' ,angleToCommand(25, 'left', d_q, ang_q));
        else
            steering =  sprintf('%s%d', 'D' ,angleToCommand(25, 'right', d_q, ang_q));
        end
        KITTspeed = 'M160';

        EPOCom(offline, 'transmit', steering);
        EPOCom(offline, 'transmit', KITTspeed);
        pause(turntime/1000 - transmitDelay/1000);  %let the car drive for calculated time
        EPOCom(offline, 'transmit', 'D152'); % wheels straight, KITt is still driving
end 