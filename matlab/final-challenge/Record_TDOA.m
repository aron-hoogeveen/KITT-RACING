function [coord,y, disdiff] = Record_TDOA(ref,peakperc,mic,d,peakn, devId)
%RECORD_TDOA Summary of this function goes here
%   Detailed explanation goes here

% if playrec('isInitialised')
%     playrec('reset');
% end
% 
% devs = playrec('getDevices');
% for id=1:size(devs,2)
%     if(strcmp('ASIO4ALL v2', devs(id).name))
%         break;
%     end
% end
% devId=devs(id).deviceID;

Fs = 48000;
N = 4*48000;                          % # samples (records 100ms)
maxChannel = 5;                     %# mics
% Fcarrier = 'F8000';                    %% default 15khz carrier frequency
% Fbit = 'B4000';                         %% default 5khz bit frequency
% RepCount = 'R4000';                       %% Default 64 bits
% BitCode  = 'C0xC33C3CC3';               %% Default 0x92340f0f
% Comport = '\\.\com15';
setpref('dsp','portaudioHostApi',3)

playrec('init', Fs, -1, devId);

if ~playrec('isInitialised')
    error ('Failed to initialise device at any sample rate');      %%Check if the connection is opened correctly
end

% result = EPOCommunications('open', Comport);
% 
% if result == 0 
%     disp('An error has occured, connection not possible');
%     EPOCommunications('close');
% else
%     EPOCommunications('transmit', Fcarrier);
%     EPOCommunications('transmit', Fbit);
%     EPOCommunications('transmit', RepCount);
%     EPOCommunications('transmit', BitCode);  

    EPOCommunications('transmit', 'A1');
    page=playrec('rec',N, 1 : maxChannel); % start recording in 
                                           % a new buffer page
    while(~playrec('isFinished')) % Wait till recording is done 
                             %(can also be done by turning on the block option)
    end
    EPOCommunications('transmit', 'A0');
    
    y = double(playrec('getRec',page)); % get the data

    playrec('delPage'); % delete the page (can be done every few cycle)
    
    B = 8000;
    R = 4000;
    
    %%Call TDOA and Localisation functions
    disdiff = tdoa(y,ref,peakperc,Fs,B,R,peakn);
    coord1 = loc(mic,disdiff,d); 
    coord  = coord1;

end

