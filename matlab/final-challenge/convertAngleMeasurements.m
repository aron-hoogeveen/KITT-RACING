% 27-5-2019
% interpolates the measured points for angleToCommand
% Is run only once 

d = [100, 105, 110, 120, 125, 140, 150, 160, 175, 180, 190, 195, 200];
ang = [-25, -24, -19, -15, -14, -8, 0, 6, 10, 12, 19, 22, 25]; %left is positive

global d_q;
global ang_q;

d_q = 100:1:200;
ang_q = interp1(d,ang,d_q);
%stem(d_q, ang_q);

% End of code

