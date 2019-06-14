function [coord,y, disdiff] = Record_TDOA(ref,peakperc,mic,d,peakn, Fs)
%RECORD_TDOA Summary of this function goes here
%   Detailed explanation goes here

N = 4*48000;                          % # samples (records 100ms)
maxChannel = 5;                     %# mics


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

