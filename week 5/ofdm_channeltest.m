% Exercise session 4: DMT-OFDM transmission scheme
clear all;
load('matlab.mat')
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% Create Train vector
Nq = 4; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;


% QAM modulation
qamStream = qam_mod(train,M);



% OFDM modulation
L=9;
ofdmStream = ofdm_mod(qamStream,N,L);
ofdmStream = repmat(ofdmStream,100,1);
% Channel
SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
% order = 3;
% for i=1:order
%    h(i) = randn/2; 
% end
h= h_lse;
rxOfdmStream = fftfilt(h,ofdmStream) + noise;

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream,N,L,fft(h,N),qamStream);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
 berTransmission = ber(train,rxBitStream)


% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot image


%plot the channel response and the estimated channel response
subplot(2,1,1);
plot(h);
subplot(2,1,2); 
plot(h);




