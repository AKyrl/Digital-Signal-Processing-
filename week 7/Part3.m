 
clear all;
%% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
BWusage=50;
Lt=4; %Lt training frames
%% Create Train vector
Nq = 2; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;

%% QAM modulation

N=1024;

order=3;
for i=1:order
    h1(i) = randn/2; 
    h2(i) = rand/4;
 end
H1=fft(h1,N);
H2=fft(h2,N);
[a,b,H12]=fixed_transmitter_side_beamformer(H1,H2);


qamStream = qam_mod(bitStream,M);
Train_qam = qam_mod(train,M);
Lqam = length(qamStream);

%% OFDM modulation

L=9;
 ofdmStream = ofdm_mod(qamStream,N,L,Train_qam,Lt); 
[ofdmStream1,ofdmStream2] = ofdm_mod_stereo(qamStream,a,b,N,L,Train_qam,Lt);
 

SNR = 100;
noise =   randn(size(ofdmStream))/SNR ;
rxOfdmStream = fftfilt(h1,ofdmStream1) + fftfilt(h2,ofdmStream2)+ noise;
 
%% OFDM demodulation
rxQamStream=ofdm_demod_stereo(rxOfdmStream,N,L,Lt,H12,Lqam);

%% QAM demodulation

rxBitStream = qam_demod(rxQamStream,M);

%% Compute BER

 berTransmission = ber(bitStream,rxBitStream)
 
 %% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

%% Plot image
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;

