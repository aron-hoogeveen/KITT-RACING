% Polyfit_Brake
% Author: Rik van der Hoorn - 4571150
% Last modified: 16-05-19
% Polynomial approximation of the measured deacceleration at PWM of 138

clear all
close all

load('def_brk_138.mat')

% triming the data to the breaking part
cutbegin = 120;
cutend = 153;
distanceL = distanceL(cutbegin+1:cutend);
distanceR = distanceR(cutbegin+1:cutend);
timeVector = timeVector(cutbegin+2:cutend+1);

% flip distance, start at 0 cm
Lmax = max(distanceL);
Rmax = max(distanceR);
distanceLflip = Lmax - distanceL;
distanceRflip = Rmax - distanceR;
distanceflip = (distanceLflip + distanceRflip)/2;

% approximate distance measurement with polynoom
n = 4;  % order of polynoom
pLdis = polyfit(timeVector,distanceLflip,n);
pRdis = polyfit(timeVector,distanceRflip,n);
pdis = polyfit(timeVector,distanceflip,n);
yLdis = polyval(pLdis,timeVector);
yRdis = polyval(pRdis,timeVector);
ydis = polyval(pdis,timeVector);

% differentiate the polynoom for the approximate speed
pLspeed = polyder(pLdis);
pRspeed = polyder(pRdis);
pspeed = polyder(pdis);
yLspeed = polyval(pLspeed,timeVector);
yRspeed = polyval(pRspeed,timeVector);
yspeed = polyval(pspeed,timeVector);

% speed polynoom trimming
yspeedtrim = yspeed;
yspeedtrim(1:18) = yspeed(19);
yspeedtrim(end) = 0;

%% plots
figure()
hold on
plot(timeVector,distanceLflip)
plot(timeVector,distanceRflip)
plot(timeVector,distanceflip)
plot(timeVector,yLdis)
plot(timeVector,yRdis)
plot(timeVector,ydis)
xlim([timeVector(1) timeVector(end)])
ylim([0 200])
grid on
legend('L measurement','R measurement','Avg measurement','L poly','R poly','Avg poly','Location','northwest')
title('Distance curves')
xlabel('time [s]')
ylabel('distance [cm]')

figure()
hold on
plot(timeVector,yLspeed)
plot(timeVector,yRspeed)
plot(timeVector,yspeed)
xlim([timeVector(1) timeVector(end)])
ylim([0 200])
grid on
legend('L poly','R poly','Avg poly','Location','southwest')
title('Speed curves')
xlabel('time [s]')
ylabel('speed [cm/s]')

figure()
hold on
plot(yLdis,yLspeed)
plot(yRdis,yRspeed)
plot(ydis,yspeed)
plot(ydis,yspeedtrim)
xlim([0 200])
ylim([0 200])
grid on
legend('L poly','R poly','Avg poly','Avg poly trim','Location','southwest')
title('Distance - Speed curves')
xlabel('distance [cm]')
ylabel('speed [cm/s]')

%% save data
ydis_brake = ydis;
yspeed_brake = yspeedtrim;
save('brake_ploy','ydis_brake','yspeed_brake')