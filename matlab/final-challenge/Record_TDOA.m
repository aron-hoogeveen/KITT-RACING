function [coord,y, disdiff] = Record_TDOA(ref,peakperc,mic,d,peakn, Fs, Fbit, RepCount, RecTime, transmap)
%RECORD_TDOA Summary of this function goes here
%   Detailed explanation goes here
debugPlots = 0; % plot a lot of data in tdoa and loc for debugging
N = (RecTime*RepCount*Fs)/Fbit;                          % # samples (records 100ms)
maxChannel = 5;                     %# mics


    page=playrec('rec',N, 1 : maxChannel); % start recording in 
                                           % a new buffer page
    while(~playrec('isFinished')) % Wait till recording is done 
                             %(can also be done by turning on the block option)
    end
    
    y = double(playrec('getRec',page)); % get the data

    playrec('delPage'); % delete the page (can be done every few cycle)
    

    
    %%Call TDOA and Localisation functions
%     disdiff = tdoa(y,ref,peakperc,Fs,Fbit,RepCount,peakn); % old version
    disdiff = tdoa(y,ref,Fs,Fbit,RepCount,peakperc,debugPlots); % new version
    coord1 = loc(mic,disdiff,d, transmap, debugPlots); 
    coord  = coord1;

end

