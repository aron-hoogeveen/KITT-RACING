% chanest
% Author: Rik van der Hoorn - 4571150
% Last modified: 01-06-19
%
% This function takes x and y as inputs to estimate the channel
% using deconvolution in frequency domain

function hhat = chanest(x,y,e)
x = x(:);                   % ensure column vectors
y = y(:);                   % ensure column vectors
Ny = length(y);             % define lengths
Nx = length(x);             % define lengths
L = Ny - Nx + 1;            % define lengths
Y = fft(y);
X = fft([x; zeros(Ny - Nx, 1)]);    % zero padding to length Ny
epsilon = e/100*max(abs(X));            % create treshold for weak frequencies
H = Y ./ X;                         % frequency domain deconvolution
for n = 1:Ny
    if (abs(X(n))>epsilon)          % use the treshold
        G(n) = 1;
    else
        G(n) = 0;
    end
end
G = G(:);
Hhat = H.*G;                        % pointwise multiplication to remove weak frequencies
hhat = ifft(Hhat);
%hhat = hhat(1:L);                  % truncate h to length L
hhat = real(hhat);

% figure
% plot(hhat)
% title('Channel estimation of microphone recording and reference signal')
% xlabel('Sample number')
% ylabel('Amplitude')
end