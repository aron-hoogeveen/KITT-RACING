angle = 25;
direction = 'left';

[d_q, ang_q] = convertAngleMeasurements();
steering =  sprintf('%s%d', 'D' ,angleToCommand(angle, direction, d_q, ang_q));


input('Press enter to start driving','s')
tic
EPOCommunications('transmit', steering);
pause(0.1);
EPOCommunications('transmit', 'M158');
input('Press enter to stop driving','s')
EPOCommunications('transmit', 'M150');
toc
pause(0.5);
EPOCommunications('transmit', 'D150');