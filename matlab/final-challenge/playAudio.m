function [] = playAudio(choice, blocking, language)
%[] = playAudio(choice, blocking, language) plays an audio file that is 
%    selected with choice. 'blocking' specifies if the function should 
%    return control immediatly or that it should wait for the audio to 
%    finish playing. It defaults to true. The user could set the language 
%    with language, which defaults to 'nl'. Available languages are 'nl',
%    'de'.
%
%    Example: playAudio('start', false, 'de');
%
%    Sounds generated with https://soundoftext.com/
%
% Version 1.0
% Date: 26-05-2019
% Group: B.04

if (nargin < 2)
    blocking = true; % Default behaviour of the function
end
if (nargin < 3)
    language = 'nl';
end

switch choice
    case 'destination_reached'
        % load audio file
        if (strcmp(language, 'de'))
            [y,Fs] = audioread('audio/Ziel-erreicht.mp3');
        else
            % Defaults to Dutch
            [y,Fs] = audioread('audio/bestemming-bereikt.mp3');
        end
        % Play the audio
        player = audioplayer(y,Fs);
        if (blocking == true)
            playblocking(player);
        else
            soundsc(y,Fs);
        end
        
    case 'start'
        % load audio file
        if (strcmp(language, 'de'))
            [y,Fs] = audioread('audio/schnall-dich-an.mp3');
        else
            % Defaults to Dutch
            [y,Fs] = audioread('audio/gordels-om.mp3');
        end
        % Play the audio
        player = audioplayer(y,Fs);
        if (blocking == true)
            playblocking(player);
        else
            soundsc(y,Fs);
        end
        
    otherwise
        disp('Unknown option for argsIn in playAudio.');
        return;
end%switch
end%playAudio