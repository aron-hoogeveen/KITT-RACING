H = Final_GUI;
handles = guidata(H);
peakperc = 80;
load datamicloc.mat;
load refsignal2.mat;
d = 2;
peakn = 2;
Fs = 48000;

if playrec('isInitialised')
   playrec('reset');
end

devs = playrec('getDevices');
for id=1:size(devs,2)
   if(strcmp('Jack Mic (Realtek Audio)', devs(id).name))
       break;
   end
end
devId=devs(id).deviceID;

playrec('init', Fs, -1, devId);

if ~playrec('isInitialised')
    error ('Failed to initialise device at any sample rate');      %%Check if the connection is opened correctly
end
while 1
uiwait(handles.figure1);
    disp('Starting challenge');
    handles = guidata(H);
    RepCount = str2double(string(handles.Out.RepCount));
    Fbit = str2double(string(handles.Out.Fbit));
    RecTime = str2double(string(handles.Out.RecTime));

    N = (RecTime*RepCount*Fs)/Fbit;                          % # samples (records 100ms)
    maxChannel = 1;                     %# mics


        page=playrec('rec',N, 1 : maxChannel); % start recording in 
                                               % a new buffer page
        while(~playrec('isFinished')) % Wait till recording is done 
                                 %(can also be done by turning on the block option)
        end

        y = double(playrec('getRec',page)); % get the data
        plot(y);
        playrec('delPage'); % delete the page (can be done every few cycle)
end
        
    
           