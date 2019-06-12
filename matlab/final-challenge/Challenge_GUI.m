H = Final_GUI;
handles = guidata(H);
peakperc = 40;
%load datamicloc.mat;
%load refsignal.mat;
d = 2;
voltage = 18;
orientation = 90;
obstacles = 0;


uiwait(handles.figure1);
handles = guidata(H);
startpoint = [str2double(handles.BeginX) str2double(handles.BeginY)];
endpoint = [str2double(handles.EndX) str2double(handles.EndY)];
waypoint = [str2double(handles.MidpointX) str2double(handles.MidpointY)];
if (waypoint(1) == -1 || waypoint(2) == -1)
    KITTControl(handles, voltage,orientation, startpoint, endpoint);
else
    KITTControl(handles, voltage,orientation, startpoint, endpoint, waypoint, obstacles);
end

% disp('Starting challenge');
%         while 1
% %             handles = guidata(H);
% %             Coord = Record_TDOA(refsignal,peakperc,mic,d)
% %             plot(handles.LocationPlot, Coord, '-.r*');
% %             axis([0 500 0 500]);
%             disp('working');
%             pause(1);
%         end







% while i <5
%     RealXData = [RealXData i];
%     RealYData = [RealYData i];
%     plot(handles.LocationPlot, RealXData, RealYData, '-.r*')
%     axis(handles.LocationPlot, [0 5 0 5]);
%     i = i + 1;
%     pause(2);
% end
% 
