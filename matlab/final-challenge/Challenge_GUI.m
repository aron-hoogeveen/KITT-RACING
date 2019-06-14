H = Final_GUI;
handles = guidata(H);
peakperc = 40;
load('datamicloc.mat', 'mic');
load('refsignal.mat', 'refsignal');
d = 2;
peakn = 2;
% Argument struct for Record_TDOA(ref,peakperc,mic,d,peakn)
recordArgs.ref = refsignal;
recordArgs.peakperc = peakperc;
recordArgs.mic = mic;
recordArgs.d = d;
recordArgs.peakn = peakn;

while(true)
    uiwait(handles.figure1);
    handles = guidata(H);
    orientation = handles.Orientation;
    startpoint = [str2double(handles.BeginX) str2double(handles.BeginY)];
    endpoint = [str2double(handles.EndX) str2double(handles.EndY)];
    waypoint = [str2double(handles.MidpointX) str2double(handles.MidpointY)];
    voltage = handles.Voltage;
    obstacles = handles.Obstacle;
    if (waypoint(1) == -1 || waypoint(2) == -1)
        KITTControl(handles, voltage,orientation, startpoint, endpoint, recordArgs);
    else
        KITTControl(handles, voltage,orientation, startpoint, endpoint, recordArgs, waypoint, obstacles);
    end
end%while(true)
