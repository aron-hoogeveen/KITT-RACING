close all;
H = Final_GUI;
handles = guidata(H);
peakperc = 80;
load datamicloc.mat;
load refsignal2.mat;
d = 2;
peakn = 2;

uiwait(handles.figure1);
disp('Starting challenge');
            handles = guidata(H);
            [Coord, y, disdiff] = Record_TDOA(refsignal2,peakperc,mic,d,peakn);
            Xloc = Coord(1);
            Yloc = Coord(2);
            plot(handles.LocationPlot, Xloc, Yloc, '-.r*');
EPOCommunications('close');
           