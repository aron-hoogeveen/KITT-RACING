% This script is used for testing the smoothStop function. 
clear currentVoltage;
try
    EPOCommunications('open', comPort);

    currentVoltage = EPOCommunications('transmit', 'Sv');

    EPOCommunications('transmit', 'D154');
    EPOCommunications('transmit', 'M160');
    pause(2.8);
    smoothStop(160);
    EPOCommunications('close');
catch
    EPOCommunications('close');
end