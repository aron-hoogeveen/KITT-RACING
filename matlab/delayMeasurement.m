function [timeAverage] = delayMeasurement(comPort)
%[timeAverage] = delayMeasurement(comPort) returns the average time it 
%    takes requesting the distance sensor values from the KITT Racing car. 

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
timeAverage = elapsedTime/n;

disp(timeAverage);

% Close the connection
EPOCommunications('close');
end