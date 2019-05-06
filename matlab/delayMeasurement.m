function [timeAverage] = delayMeasurement(comPort)
%USEFUL COMMENT

% Open connection
status = EPOCommunications('open', comPort);

if (status == 0)
    disp('Connection not established');
else
    disp('Connection established');
end

% Enter execution loop
n = 100;
% Start time measurement
tic
    for i=1:n
%         EPOCommunications('transmit', 'M150');
        status = EPOCommunications('transmit', 'Sd');
    end
toc
elapsedTime = toc;

disp(elapsedTime/n);

timeAverage = elapsedTime/n;

% Close the connection
EPOCommunications('close');
end