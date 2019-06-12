H = Final_GUI;
handles = guidata(H);
peakperc = 40;
%load datamicloc.mat;
%load refsignal.mat;
d = 2;


uiwait(handles.figure1);
handles = guidata(H);
orientation = handles.Orientation;
startpoint = [str2double(handles.BeginX) str2double(handles.BeginY)];
endpoint = [str2double(handles.EndX) str2double(handles.EndY)];
waypoint = [str2double(handles.MidpointX) str2double(handles.MidpointY)];
voltage = handles.Voltage;
obstacles = handles.Obstacle;
%KITTControl(voltage,orientation, startpoint, endpoint, waypoint, obstacles)

