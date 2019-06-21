% chanest
% Author: Rik van der Hoorn - 4571150
% Last modified: 20-06-19
% Status: complete, commented and tested
%
% Channel estimation using deconvolution in the frequency domain, with
% threshold for weak frequencies.
%
% function  hhat = chanest(x,y,e,check)
% Inputs:	x = reference signal
%           y = microphone recording
%           e = threshold for weak frequencies [%]
%           check = if check is nonzero, plots figures to debug
% Output:   hhat = estimated channel

function hhat = chanest(x,y,e,check)
x = x(:);                   % ensure column vector
y = y(:);                   % ensure column vector
Ny = length(y);             % length microphone recording
Nx = length(x);             % length reference signal
Y = fft(y);
X = fft([x; zeros(Ny - Nx, 1)]);	% zero padding to length Ny
epsilon = e/100*max(abs(X));        % create treshold for weak frequencies
H = Y ./ X;                         % frequency domain deconvolution
for n = 1:Ny
    if (abs(X(n))>epsilon)          % create vector to remove weak frequencies
        G(n) = 1;
    else
        G(n) = 0;
    end
end
G = G(:);
Hhat = H.*G;                        % remove weak frequencies
hhat = real(ifft(Hhat));            % estimated channel

if check                            % figure for debuging
    figure
    plot(hhat)
    title('Channel estimation')
    xlabel('Sample number')
    ylabel('Amplitude')
end
end