% Exercise session 4: DMT-OFDM transmission scheme
clear all;
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');


Lresp = 10;          % order of the impulse response of the channel
equalize=true;
N=1024;
Num = exp(1)*exp(-1:-1:-(Lresp+1));
%Num = [1 zeros(1,Lresp)];
Den = [1 zeros(1,Lresp)];
sys = tf(Num, Den, -1);

% FEQ: frequency domain 
Hn = [];
if (equalize)
    Hn = fft([Num zeros(1,2*N+2-length(Num))]);
    Hn = Hn(2:N+1);
end


 
 % QAM modulation
Nq = 4; %<=6
M = 2^Nq;
qamStream = qam_mod(bitStream,M);
zeropaded = qamStream;


% OFDM modulation
N = 1024; 
numbZer = 0;
while rem(size(zeropaded,1),(N/2)-1 ) ~= 0 %zero pad signal to be divisible by n/2 -1
    zeropaded(end+1:end+1)=0;
    numbZer = numbZer + 1;
end
L=0;


%ofdmStream = ofdm_ONOF_mod(zeropaded,N,L);
ofdmStream=ofdm_mod(zeropaded,N,L);

% Channel
SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
% rxOfdmStream = ofdmStream;
rxOfdmStream =lsim(sys,ofdmStream);

% Channel noise
rxOfdmStream = awgn(rxOfdmStream,SNR, 'measured');


% OFDM demodulation

% rxQamStream = ofdm_ONOF_demod(rxOfdmStream,N,L,fft(h',N));
rxQamStream = ofdm_demod(rxOfdmStream,N,L,Hn);
rxQamStream = rxQamStream(1:end-numbZer); % remove zero padding


% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
berTransmission = ber(bitStream,rxBitStream)

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
