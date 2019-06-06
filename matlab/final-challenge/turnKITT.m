% Sends the drive commands for KITT to turn
function [] = turnKITT(direction, turntime, transmitDelay, d_q, ang_q)
        if (direction == 1)
            steering =  sprintf('%s%d', 'D' ,angleToCommand(25, 'left', d_q, ang_q));
        else
            steering =  sprintf('%s%d', 'D' ,angleToCommand(25, 'right', d_q, ang_q));
        end
        KITTspeed = 'M160';

        EPOCom(offline, 'transmit', steering);
        tic
        EPOCom(offline, 'transmit', KITTspeed);
        toc
        pause(turntime/1000 - transmitDelay/1000);  %let the car drive for calculated time
end 