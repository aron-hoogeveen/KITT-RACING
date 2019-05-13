function [] = moduleOne(comPort, startDistance, stopDistance)
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
% The code could contain some pseudo code (non working code that only
% resembles the function that should be implemented).
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

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
    error('The connection could not be established.');
end
disp('Connection to KITT Racing car succesful.');

% Compensate the distance that the sensors are behind the bumper.
stopDistance = stopDistance + 8.5;


% Start driving towards the wall. 
% The starting speed is predefined and should be set here. If needed one
% could add an optional function input parameter that overwrites this
% predefined startSpeed value. 
startSpeed = 160;
KITTspeed = char(strcat('M', string(startSpeed)));

% Calculate the break point
% Load curves
%load Acc160-185V.mat;
%load Brake140-185V.mat;
load LAATSTEVANVRIJDAG3.mat;
delay = 0; %[ms]
driveDistance = startDistance - stopDistance;
[breakPoint, speed] = KITTstop(driveDistance, x_brake135, v_brake135, x_acc185, v_acc185, x_brake135_end, delay);

stopPoint = startDistance - breakPoint;
disp(stopPoint);
% Start driving until the breakPoint has been reached (or the value is
% close enough to the breakpoint, want vertragingen).
speed = speed / 0.04; % [cm / s]
delta = speed * 0.160; % TODO: calculate the maximum distance difference between the read out distance and the real time distance

% Correct the steering offset
EPOCommunications('transmit', 'D154');
EPOCommunications('transmit', KITTspeed);
while (1 == 1)
    % Read out sensor data and compare it to the breakPoint
    % Only compare sensor values that can be considered accurate
    status = EPOCommunications('transmit', 'Sd');
    distStr = strsplit(status);
    sensorL = str2num(distStr{1}(4:end)); % TODO:
    sensorR = str2num(distStr{2}(4:end));
    
    % The sensor values can be considered accurate when
    %   - THE FOLLOWING IS NOT TRUE. ~they are smaller than +/-250 cm;~
    %   - they are larger than +/-20 cm;
    %   - sensorL and sensorR are within 15 centimeter of eachother
    %     (assuming that the wall is orthogonal to the car, otherwise this 
    %     value could be higher)
    
    % differenceX resembles the current distance to the breakPoint
    differenceL = sensorL - stopPoint; % FIXME: maybe include this statement in a abs() since the case could arise that the car is already a bit further than the breakPoint
    differenceR = sensorR - stopPoint;
    if ( abs(sensorL - sensorR) < 40 ) && ( (differenceL < delta) || (differenceR < delta ))
        % IT'S TIME TO STOP!
        disp(sensorL);
        disp(sensorR);
        disp(delta);
        smoothStop(startSpeed); % actual stop function is written in another function to keep this function readable.
        break;
    end%
    
    % FIXME: should we include a pause statement here? Most likely not.
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