function varargout = Final_GUI(varargin)
% FINAL_GUI MATLAB code for Final_GUI.fig
%      FINAL_GUI, by itself, creates a new FINAL_GUI or raises the existing
%      singleton*.
%
%      H = FINAL_GUI returns the handle to a new FINAL_GUI or the handle to
%      the existing singleton*.
%
%      FINAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_GUI.M with the given input arguments.
%
%      FINAL_GUI('Property','Value',...) creates a new FINAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Final_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Final_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Final_GUI

% Last Modified by GUIDE v2.5 12-Jun-2019 18:03:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Final_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Final_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Final_GUI is made visible.
function Final_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Final_GUI (see VARARGIN)
handles.ComPort = 0;
handles.Fcarrier = 0;
handles.Fbit = 0;
handles.RepCount = 0;
handles.Bitcode = 0;
handles.BeginX = 0;
handles.BeginY = 0;
handles.EndX = 0;
handles.EndY = 0;
handles.MidpointX = 0;
handles.MidpointY = 0;
handles.RealXData = [];
handles.RealYData = [];
handles.Stop = 0;
handles.Start = 0;
handles.Orientation = 0;
handles.Obstacle = 0;
handles.Voltage = 0;
rectangle(handles.LocationPlot, 'Position', [0,0,50,560], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
hold on;
rectangle('Position', [510,0,50,560], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
rectangle(handles.LocationPlot,'Position', [0,510,560,50], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
rectangle(handles.LocationPlot,'Position', [0,0,560,50], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
pbaspect(handles.LocationPlot,[1 1 1]); %fixed square map
xlim(handles.LocationPlot, [0,560]);
ylim(handles.LocationPlot, [0,560]);
title(handles.LocationPlot, "Field Map");
grid on;

% Choose default command line output for Final_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Final_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Final_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Connect.
function Connect_Callback(hObject, eventdata, handles)
% hObject    handle to Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(handles.ComPort);
result = EPOCommunications('open',convertStringsToChars(handles.ComPort));
if result == 0
    error('No connection established');
else
    disp('Connection established');
end
guidata(hObject,handles);


function Com_Port_Callback(hObject, eventdata, handles)
% hObject    handle to Com_Port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Com_Port as text
%        str2double(get(hObject,'String')) returns contents of Com_Port as a double
ComPort = get(hObject,'String');
handles.ComPort = strcat('\\.\com',string(ComPort));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Com_Port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Com_Port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fcarrier_Callback(hObject, eventdata, handles)
% hObject    handle to Fcarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fcarrier as text
%        str2double(get(hObject,'String')) returns contents of Fcarrier as a double
handles.Fcarrier = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Fcarrier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fcarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fbit_Callback(hObject, eventdata, handles)
% hObject    handle to Fbit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fbit as text
%        str2double(get(hObject,'String')) returns contents of Fbit as a double
handles.Fbit = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Fbit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fbit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepCount_Callback(hObject, eventdata, handles)
% hObject    handle to RepCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RepCount as text
%        str2double(get(hObject,'String')) returns contents of RepCount as a double
handles.RepCount = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function RepCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bitcode_Callback(hObject, eventdata, handles)
% hObject    handle to Bitcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bitcode as text
%        str2double(get(hObject,'String')) returns contents of Bitcode as a double
handles.Bitcode = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Bitcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bitcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UpdateBeacon.
function UpdateBeacon_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateBeacon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPOCommunications('transmit',convertStringsToChars((strcat('F', string(handles.Fcarrier)))));
EPOCommunications('transmit',convertStringsToChars((strcat('B', string(handles.Fbit)))));
EPOCommunications('transmit',convertStringsToChars((strcat('R', string(handles.RepCount)))));
EPOCommunications('transmit',convertStringsToChars((strcat('C0x', string(handles.Bitcode)))));
disp('Beacon updated');



function BeginLocX_Callback(hObject, eventdata, handles)
% hObject    handle to BeginLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BeginLocX as text
%        str2double(get(hObject,'String')) returns contents of BeginLocX as a double
handles.BeginX = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function BeginLocX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BeginLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BeginLocY_Callback(hObject, eventdata, handles)
% hObject    handle to BeginLocY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BeginLocY as text
%        str2double(get(hObject,'String')) returns contents of BeginLocY as a double
handles.BeginY = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function BeginLocY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BeginLocY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndLocX_Callback(hObject, eventdata, handles)
% hObject    handle to EndLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndLocX as text
%        str2double(get(hObject,'String')) returns contents of EndLocX as a double
handles.EndX = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function EndLocX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndLocY_Callback(hObject, eventdata, handles)
% hObject    handle to EndLocY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndLocY as text
%        str2double(get(hObject,'String')) returns contents of EndLocY as a double
handles.EndY = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function EndLocY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndLocY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MidpointLocX_Callback(hObject, eventdata, handles)
% hObject    handle to MidpointLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MidpointLocX as text
%        str2double(get(hObject,'String')) returns contents of MidpointLocX as a double
handles.MidpointX = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MidpointLocX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MidpointLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MidpointLocY_Callback(hObject, eventdata, handles)
% hObject    handle to MidpointLocY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MidpointLocY as text
%        str2double(get(hObject,'String')) returns contents of MidpointLocY as a double
handles.MidpointY = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MidpointLocY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MidpointLocY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BeginEndUpdate.
function BeginEndUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to BeginEndUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(str2num(handles.BeginX),str2num(handles.BeginY),'b*', 'MarkerSize', 10);
hold on;
plot(str2num(handles.EndX),str2num(handles.EndY),'r*', 'MarkerSize', 10);
axis manual;


% --- Executes on button press in BeginMidEndUpdate.
function BeginMidEndUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to BeginMidEndUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(str2num(handles.BeginX),str2num(handles.BeginY),'b*', 'MarkerSize', 10);
plot(str2num(handles.EndX),str2num(handles.EndY),'r*', 'MarkerSize', 10);
plot(str2num(handles.MidpointX),str2num(handles.MidpointY),'g*', 'MarkerSize', 10);


% --- Executes during object creation, after setting all properties.
function LocationPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LocationPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate LocationPlot


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);





% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 EPOCommunications('close');
 disp('Connection closed');



function orientation_Callback(hObject, eventdata, handles)
% hObject    handle to orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of orientation as text
%        str2double(get(hObject,'String')) returns contents of orientation as a double
handles.Orientation = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function orientation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Voltage_Callback(hObject, eventdata, handles)
% hObject    handle to Voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Voltage as text
%        str2double(get(hObject,'String')) returns contents of Voltage as a double
handles.Voltage = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Voltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Obstacles.
function Obstacles_Callback(hObject, eventdata, handles)
% hObject    handle to Obstacles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Obstacles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Obstacles
contents = cellstr(get(hObject,'String'));
Obstacle = contents{get(hObject,'Value')};
handles.Obstacle = strcmp(Obstacle,'Obstacles');
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Obstacles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Obstacles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%saveState() saves the inputs of the gui to "state.mat"
function saveState_Callback(hObject, eventdata, handles)


state.Voltage = get(handles.Voltage, 'value');


get(handles.Voltage, 'value')
save ('state.mat', 'state');

%loadState() is used to load previous instances of the gui inputs
function loadState_Callback(hObject, eventdata, handles) 
fileName = 'state.mat';

if exist(fileName)
    load(fileName)
    set(handles.Voltage, 'value', state.Voltage);
    delete(fileName)
end
