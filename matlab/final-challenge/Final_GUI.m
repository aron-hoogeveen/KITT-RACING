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

% Last Modified by GUIDE v2.5 16-Jun-2019 22:39:11

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
Out.ComPort = 0;
Out.Fcarrier = 0;
Out.Fbit = 0;
Out.RepCount = 0;
Out.Bitcode = 0;
Out.BeginX = 0;
Out.BeginY = 0;
Out.EndX = 0;
Out.EndY = 0;
Out.MidpointX = 0;
Out.MidpointY = 0;
Out.Orientation = 0;
Out.Voltage = 0;
Out.Obstacle = 0;
handles.Out = Out;
% rectangle(handles.LocationPlot, 'Position', [0,0,50,560], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
% hold on;
% rectangle('Position', [510,0,50,560], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
% rectangle(handles.LocationPlot,'Position', [0,510,560,50], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
% rectangle(handles.LocationPlot,'Position', [0,0,560,50], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
pbaspect(handles.LocationPlot,[1 1 1]); %fixed square map
xlim(handles.LocationPlot, [0,460]);
hold on;
ylim(handles.LocationPlot, [0,460]);
xticks(handles.LocationPlot, [50 100 150 200 250 300 350 400 450]);
yticks(handles.LocationPlot, [50 100 150 200 250 300 350 400 450]);
title(handles.LocationPlot, "Field Map");
grid on;
box on;

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
disp(strcat('\\.\com',string(handles.Out.ComPort)));
result = EPOCommunications('open',convertStringsToChars(handles.Out.ComPort));
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
Out = handles.Out;
Out.ComPort = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.Fcarrier = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.Fbit = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.RepCount = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.Bitcode = get(hObject,'String');
handles.Out = Out;
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
EPOCommunications('transmit',convertStringsToChars((strcat('F', string(handles.Out.Fcarrier)))));
EPOCommunications('transmit',convertStringsToChars((strcat('B', string(handles.Out.Fbit)))));
EPOCommunications('transmit',convertStringsToChars((strcat('R', string(handles.Out.RepCount)))));
EPOCommunications('transmit',convertStringsToChars((strcat('C0x', string(handles.Out.Bitcode)))));
disp('Beacon updated');



function BeginLocX_Callback(hObject, eventdata, handles)
% hObject    handle to BeginLocX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BeginLocX as text
%        str2double(get(hObject,'String')) returns contents of BeginLocX as a double
Out = handles.Out;
Out.BeginX = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.BeginY = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.EndX = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.EndY = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.MidpointX = get(hObject,'String');
handles.Out = Out;
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
Out = handles.Out;
Out.MidpointY = get(hObject,'String');
handles.Out = Out;
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

% Convert the input argument of str2double first to a string, because there
% are cases where the input argument is already a number and str2double will
% give an error.
plot(str2double(string(handles.Out.BeginX)),str2double(string(handles.Out.BeginY)),'b*', 'MarkerSize', 10);
hold on;
plot(str2double(string(handles.Out.EndX)),str2double(string(handles.Out.EndY)),'r*', 'MarkerSize', 10);
axis manual;


% --- Executes on button press in BeginMidEndUpdate.
function BeginMidEndUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to BeginMidEndUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(str2double(string(handles.Out.BeginX)),str2double(string(handles.Out.BeginY)),'b*', 'MarkerSize', 10);
plot(str2double(string(handles.Out.EndX)),str2double(string(handles.Out.EndY)),'r*', 'MarkerSize', 10);
plot(str2double(string(handles.Out.MidpointX)),str2double(string(handles.Out.MidpointY)),'g*', 'MarkerSize', 10);


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
Out = handles.Out;
Out.Orientation = str2double(get(hObject,'String'));
handles.Out = Out;
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



function Voltage = Voltage_Callback(hObject, eventdata, handles)
% hObject    handle to Voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Voltage as text
%        str2double(get(hObject,'String')) returns contents of Voltage as a double
Out = handles.Out;
Out.Voltage = str2double(get(hObject,'String'));
handles.Out = Out;
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
Out = handles.Out;
contents = cellstr(get(hObject,'String'));
Obstacle = contents{get(hObject,'Value')};
Out.Obstacle = strcmp(Obstacle,'Obstacles');
handles.Out = Out;
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



% --- Executes on button press in Savestate.
function Savestate_Callback(hObject, eventdata, handles)
% hObject    handle to Savestate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUI = findobj('Tag', 'figure1');
handles = guidata(GUI);
state.Voltage = get(handles.Voltage, 'String');
state.Com_Port = get(handles.Com_Port, 'String');
state.Fcarrier = get(handles.Fcarrier, 'String');
state.Fbit = get(handles.Fbit, 'String');
state.RepCount = get(handles.RepCount, 'String');
state.Bitcode = get(handles.Bitcode, 'String');
state.BeginLocX = get(handles.BeginLocX, 'String');
state.BeginLocY = get(handles.BeginLocY, 'String');
state.EndLocX = get(handles.EndLocX, 'String');
state.EndLocY = get(handles.EndLocY, 'String');
state.MidpointLocX = get(handles.MidpointLocX, 'String');
state.MidpointLocY = get(handles.MidpointLocY, 'String');
state.orientation = get(handles.orientation, 'String');
save ('state.mat', 'state');


% --- Executes on button press in LoadState.
function LoadState_Callback(hObject, eventdata, handles)
% hObject    handle to LoadState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileName = 'state.mat';
GUI = findobj('Tag', 'figure1');
handles = guidata(GUI);
Out = handles.Out;
if exist(fileName)
    load(fileName)
    set(handles.Voltage, 'String', state.Voltage);
    set(handles.Com_Port, 'String', state.Com_Port);
    set(handles.Fcarrier, 'String', state.Fcarrier);
    set(handles.Fbit, 'String', state.Fbit);
    set(handles.RepCount, 'String', state.RepCount);
    set(handles.Bitcode, 'String', state.Bitcode);
    set(handles.BeginLocX, 'String', state.BeginLocX);
    set(handles.BeginLocY, 'String', state.BeginLocY);
    set(handles.EndLocX, 'String', state.EndLocX);
    set(handles.EndLocY, 'String', state.EndLocY);
    set(handles.MidpointLocX, 'String', state.MidpointLocX);
    set(handles.MidpointLocY, 'String', state.MidpointLocY);
    set(handles.orientation, 'String', state.orientation);
   
    Out.ComPort = state.Com_Port;
    Out.Fcarrier = state.Fcarrier;
    Out.Fbit = state.Fbit;
    Out.RepCount = state.RepCount;
    Out.Bitcode = state.Bitcode;
    Out.BeginX = state.BeginLocX;
    Out.BeginY = state.BeginLocY;
    Out.EndX = state.EndLocX;
    Out.EndY = state.EndLocY;
    Out.MidpointX = state.MidpointLocX;
    Out.MidpointY = state.MidpointLocY;
    Out.Orientation = state.orientation;
    Out.Voltage = state.Voltage;
    handles.Out = Out;
  
end
guidata(hObject,handles);
