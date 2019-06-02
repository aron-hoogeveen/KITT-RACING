angle = 20;
direction = 'right';

[d_q, ang_q] = convertAngleMeasurements();
steering =  sprintf('%s%d', 'D' ,angleToCommand(angle, direction, d_q, ang_q));


input('Press enter to start driving','s')
tic
EPOCommunications('transmit', steering);
EPOCommunications('transmit', 'M160');
input('Press enter to stop driving','s')
EPOCommunications('transmit', 'M150');
toc