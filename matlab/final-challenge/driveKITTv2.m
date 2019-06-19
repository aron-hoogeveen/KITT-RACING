function drivingDistance = driveKITTv2(offlineCom, handles, distToEnd, transmitDelay, curves, d_q, ang_q)
% driveKITTv2 Drive KITT for a certain distance (small distance, dependent 
%    on <distToEnd>)
%
%    drivingDistance = driveKITTv2(offlineCom, distToEnd, transmitDelay,
%    curves) lets KITT drive a distance <drivingDistance>.
%
%    EPO-4 Group B4
%    <insert date of last modification>
    drivingDistance = distToEnd/4;
    if (drivingDistance < 20 && drivingDistance > 10)
        drivingDistance = 20;
    elseif (drivingDistance < 10)
        drivingDistance = 10;
    end
    [drivingTime, ~] = KITTstopV2(drivingDistance, curves.ydis_brake, curves.yspeed_brake, curves.ydis_acc, curves.yspeed_acc, curves.brakeEnd, 0); % Time the car must drive for step 2 in challenge A in ms (straight line)
    ticdrive = tic;
    EPOCom(offlineCom, 'transmit', 'M160');
    pause((drivingTime-transmitDelay)/1000);
    smoothStop(offlineCom, 160);
    toc(ticdrive)
end

