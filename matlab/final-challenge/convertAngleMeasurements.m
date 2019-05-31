% EPO-4 Group B4
% 27-05-2019
% Interpolates the measured points for angleToCommand()
% Is run only once 
function [d_q, ang_q] = convertAngleMeasurements()
    d = [100, 105, 110, 120, 125, 140, 150, 160, 175, 180, 190, 195, 200];
    ang = [-25, -24, -19, -15, -14, -8, 0, 6, 10, 12, 19, 22, 25]; %left is positive

    d_q = 100:1:200;
    ang_q = interp1(d,ang,d_q);
end

