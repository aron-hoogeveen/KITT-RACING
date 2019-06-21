H = Final_GUI;
handles = guidata(H);
peakperc = 30;
load('datamicloc.mat', 'mic');
load('refsignal3.mat', 'refsignal3');
load('transmap.mat');
d = 2;
peakn = 2;
Fs = 48000;

% if playrec('isInitialised')
%    playrec('reset');
% end
% 
% devs = playrec('getDevices');
% for id=1:size(devs,2)
%    if(strcmp('ASIO4ALL v2', devs(id).name))
%        break;
%    end
% end
% devId=devs(id).deviceID;
% 
% setpref('dsp','portaudioHostApi',3)
% 
% playrec('init', Fs, -1, devId);
% 
% if ~playrec('isInitialised')
%     error ('Failed to initialise device at any sample rate');      %%Check if the connection is opened correctly
% end

% Argument struct for Record_TDOA(ref,peakperc,mic,d,peakn)
recordArgs.ref = refsignal3;
recordArgs.peakperc = peakperc;
recordArgs.mic = mic;
recordArgs.d = d;
recordArgs.peakn = peakn;
recordArgs.Fs = Fs;
recordArgs.transmap = transmap;

while(true)
    uiwait(handles.figure1);
    handles = guidata(H);
    orientation = str2double(string(handles.Out.Orientation));
    startpoint = [str2double(string(handles.Out.BeginX)) str2double(string(handles.Out.BeginY))];
    endpoint = [str2double(string(handles.Out.EndX)) str2double(string(handles.Out.EndY))];
    waypoint = [str2double(string(handles.Out.MidpointX)) str2double(string(handles.Out.MidpointY))];
    voltage = str2double(string(handles.Out.Voltage));
    obstacles = str2double(string(handles.Out.Obstacle));
    recordArgs.RepCount = str2double(string(handles.Out.RepCount));
    recordArgs.Fbit = str2double(string(handles.Out.Fbit));
    recordArgs.RecTime = str2double(string(handles.Out.RecTime));
    if (waypoint(1) == -1 || waypoint(2) == -1)
        KITTControl(handles, voltage,orientation, startpoint, endpoint, recordArgs);
    else
        KITTControl(handles, voltage,orientation, startpoint, endpoint, recordArgs, waypoint, obstacles);
    end
     EPOCommunications('transmit', 'A0');
end%while(true)
