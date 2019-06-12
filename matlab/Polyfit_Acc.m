% Polyfit_Acc
% Author: Rik van der Hoorn - 4571150
% Last modified: 16-05-19
% Polynomial approximation of the measured acceleration at PWM of 160

clear all
close all

load('def_acc_160.mat')
timeVector = timeVector(1:end); % remove 0 time, vector same length

% flip distance, start at 0 cm
Lmax = max(distanceL);
Rmax = max(distanceR);
distanceLflip = Lmax - distanceL;
distanceRflip = Rmax - distanceR;
distanceflip = (distanceLflip + distanceRflip)/2;   % average of both sensors

% approximate distance measurement with polynoom
n = 5;  % order of polynoom
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
ylim([0 400])
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
ylim([0 160])
grid on
legend('L poly','R poly','Avg poly','Location','northwest')
title('Speed curves')
xlabel('time [s]')
ylabel('speed [cm/s]')

figure()
hold on
plot(yLdis,yLspeed)
plot(yRdis,yRspeed)
plot(ydis,yspeed)
xlim([ydis(1) ydis(end)])
ylim([0 160])
grid on
legend('L poly','R poly','Avg poly','Location','northwest')
title('Distance - Speed curves')
xlabel('distance [cm]')
ylabel('speed [cm/s]')

%% save data
ydis_acc = ydis;
yspeed_acc = yspeed;
save('acc_ploy','ydis_acc','yspeed_acc')