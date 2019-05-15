function [] = moduleOne(comPort, startDistance, stopDistance, steeringOffset)
%moduleOne(argsIn) is the one and only midterm challenge function that will
%    get us our pass.
%    The comPort need only be the numberic part of the comport. The textual
%    part will be appended in this function. 

% Met behulp van eerdere break metingen gaat dit script het break point
% bepalen van de auto als deze een afstand tussen de 30-50 centimeter voor
% de muur moet stoppen.
% Er moeten genoeg break en accelaration metingen zijn voor verschillende
% voltages tussen de 17 en 20 [V]. 
%
% De auto heeft een start afstand van 3 tot 5 meter verwijderd van de muur.
% Op deze afstand is het gedrag van de distance sensors onvoorspelbaar dus
% daar moet rekening mee gehouden worden in de code. De auto moet op een
% gegeven afstand voor de muur stoppen. Deze afstand ligt tussen de 30 en
% 50 centimeter. 
% De spanning van de batterijen zal tussen de 17 en 20 [V] liggen.
% Het eindpunt moet binnen 3 seconde worden gehaald, en de auto mag geen
% overshoot hebben.
%
% The uitgelezen afstand van de linker sensor is kut en niet te vertrouwen.
% Die van de rechter sensor is betrouwbaarder, maar wel pas accuraat vanaf
% een meter of 2,5 tot 2. Daarom moeten we pas wat doen met de uitgelezen
% waardes vanaf die afstand. Anders kunnen we er niet op vertrouwen dat de
% uitgelezen waardes waarheidsgetrouw zijn.
% 
% Het is misschien een idee om in plaats van één keer de sensor waardes uit
% te lezen, het twee (of meer) keer te doen en dan alleen te stoppen
% wanneer twee (of meer) keer is waargenomen dat de auto de breakPoint
% heeft bereikt. Het kan zijn dat dit nodig is, als de sensors te vaak
% bullshit waardes geven (en daardoor het stop mechanisme triggeren).

% input argumenten: 
%   - de afstand waarop de auto moet stoppen. 
%
% Waardes die aan het begin van de functie opgeroepen moeten worden.
%   - Voltage van de auto (dit zou een input waarde kunnen/moeten zijn van
%     een functie die de stopafstand bepaald. 

% Aanpak:
% De auto kunnen we beter niet op z'n snelst laten rijden omdat het dan
% moeilijker wordt om 'm op tijd te laten stoppen (en zonder overshoot)


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Actual Program
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

if (nargin < 3)
    error('Not enough input arguments. Check the help for the function syntax');
end
if (nargin < 4)
    steeringOffset = 'D152'; % Default steering offset as used in the last EPO sessions
else
    steeringOffset = char(strcat('D', string(steeringOffset)));
end

% FIXME: I am not entirely sure that we will only get integers as input
%     values. If not, then this integer check should be removed.
% Validate the input argument(s)
% check if the stopDist is an integer.
if (mod(stopDistance,1) ~= 0)
    error('stopDist moet een integer zijn.');
end

% Check if the comPort is an integer and if so, append the comport text to
% it.
if (mod(comPort,1) ~= 0)
    error('The comPort has to be an integer');
end
comPort = char(strcat('.//COM', string(comPort)));
disp(strcat('the comport is "', comPort, '"'));

% Open up the connection to the KITT Racing car.
if (EPOCommunications('open', comPort) ~= 1)
    % TODO: Most likely the conenction failed due to an already open port.
    %     Close the connection to the port. 
    error('The connection could not be established.');
end
disp('Connection to KITT Racing car succesful.');

% Compensate the distance that the sensors are behind the bumper of the car
stopDistance = stopDistance + 8.5;

% Read out the current voltage of the car. This voltage will be used to
% adjust the projected distance accordingly.
voltageStr = EPOCommunications('transmit', 'Sv');
voltage = str2double(voltageStr(6:9)); % Extract the voltage


% Start driving towards the wall. 
% The starting speed is predefined and should be set here. If needed one
% could add an optional function input parameter that overwrites this
% predefined startSpeed value. 
speedSetting = 160;
KITTspeed = char(strcat('M', string(speedSetting)));

% Calculate the break point
% Load the brake & acceleration data to compute the stoppoint with
%load Acc160-185V.mat;
%load Brake140-185V.mat;
load acc_ploy.mat;
load brake_ploy_v2.mat;

yspeed_acc = [yspeed_acc 156];  % fixes for a too short acceleration for version 1
ydis_acc = [ydis_acc 500]; % fixes for a too short acceleration curve for version 1
driveDistance = startDistance - stopDistance;
[breakPoint, speed] = KITTstop(driveDistance, ydis_brake, yspeed_brake, ydis_acc, yspeed_acc, 186.5, 0);

% breakPoint is given as the distance that the car should drive, so convert
% it to the distance that the car will be from the wall
stopPoint = startDistance - breakPoint;
disp(strcat('stopPoint=', string(stopPoint)));
% Start driving until the breakPoint has been reached (or the value is
% close enough to the breakpoint, want vertragingen).
delay = (37e-3 + 0.5 * 35e-3 + 0.5 * 37e-3) * 5; % requestDistanceDelay + 0.5 * sensorUpdateDelay + matlabCalculationsDelay + sendStopDelay(=0.5*requestDistanceDelay)

% Voltage Correction
if (voltage > 19)
    voltageCorrection = 1;
elseif (voltage <= 19 && voltage > 18.5)
    voltageCorrection = 1.1;
elseif (voltage <= 18.5 && voltage > 18)
    voltageCorrection = 1.2; % The average undershoot was 10 centimeter at this voltage. So with a delay of 50 centimeter the voltage corrention should then be 1.2
elseif (voltage <= 18 && voltage > 17.5)
    voltageCorrection = 1.3; % This value is a guess based of the voltageCorrection for 18 < V <= 18.5
elseif (voltage <= 17.5 && voltage > 17)
    voltageCorrection = 1.4;
else
    % Voltage is lower than 17
    voltageCorrection = 1.6;
end

% Correct the steering offset
EPOCommunications('transmit', steeringOffset);
% Drive
EPOCommunications('transmit', KITTspeed);
while (1 == 1)
    % Read out sensor data and compare it to the breakPoint
    % Only compare sensor values that can be considered accurate
    status = EPOCommunications('transmit', 'Sd');
    distStr = strsplit(status);
    sensorL = str2double(distStr{1}(4:end));
    sensorR = str2double(distStr{2}(4:end));
    
    % The sensor values can be considered accurate when
    %   - THE FOLLOWING IS NOT TRUE. ~they are smaller than +/-250 cm;~
    %   - they are larger than +/-20 cm;
    %   - sensorL and sensorR are within 15 centimeter of eachother
    %     (assuming that the wall is orthogonal to the car, otherwise this 
    %     value could be higher)
    
    % differenceX resembles the current distance to the breakPoint
    
    projectedDistanceL = sensorL - delay * speed * voltageCorrection;
    projectedDistanceR = sensorR - delay * speed * voltageCorrection;
    if ( abs(sensorL - sensorR) <= 40 ) && ( (projectedDistanceR < stopPoint) || (projectedDistanceL < stopPoint ))
        % If the deviation between the two sensors is more than 20 cm, the 
        % sensor values (or at least one) should be considered worthless. 
        disp(strcat('Speed=', string(speed)));
        disp(strcat('delta=', string(delay * speed)));
        disp(strcat('SensorL=', string(sensorL), ', projectedDistanceL=', string(projectedDistanceL)));
        disp(strcat('SensorR=', string(sensorR), ', projectedDistanceR=', string(projectedDistanceR)));
        
        smoothStop(speedSetting); % actual stop function is written in another function to keep this function readable.
        break;
    end
end%while
pause(1);
% read out the final measured distance at standstill
status = EPOCommunications('transmit', 'S');
disp(status);
disp(string(stopPoint));

% Close the connection to the car. 
EPOCommunications('close');
disp('Connection closed.');
end%moduleOne