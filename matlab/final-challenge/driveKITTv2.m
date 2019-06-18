function drivingDistance = driveKITTv2(offlineCom, handles, distToEnd, transmitDelay, curves, d_q, ang_q)

    % Determine time KITT drives (small distance, dependent on distToEnd);
    drivingDistance = distToEnd/5;
    [drivingTime, ~] = KITTstopV2(drivingDistance, curves.ydis_brake, curves.yspeed_brake, curves.ydis_acc, curves.yspeed_acc, curves.brakeEnd, 0); % Time the car must drive for step 2 in challenge A in ms (straight line)
    
    EPOCom(offlineCom, 'transmit', 'M160');
    pause(drivingTime-transmitDelay);
    EPOCom(offlineCom, 'transmit', 'M150');


end

