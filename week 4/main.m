% Exercise session 4: DMT-OFDM transmission scheme
clear all;
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
Nq = 4; %<=6
M = 2^Nq;
qamStream = qam_mod(bitStream,M);

% OFDM modulation
N = 10; %zero pad signal to be divisible by n/2 -1
L=9;
ofdmStream = ofdm_mod(qamStream,N,L);

% Channel
SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
order = 3;
for i=1:order
   h(i) = randn/2; 
end
rxOfdmStream = fftfilt(h,ofdmStream) + noise;

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream,N,L,fft(h,N));

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
 berTransmission = ber(bitStream,rxBitStream)

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
