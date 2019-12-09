%% Exercise session 6: OFDM over the acoustic channel: transmitting an image
clear all;
%% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

Lt=4; %Lt training frames
%% Create Train vector
Nq = 4; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;

%% QAM modulation


qamStream = qam_mod(bitStream,M);
Train_qam = qam_mod(train,M);
Lqam = length(qamStream);






%% OFDM modulation

L=9;
  ofdmStream = ofdm_mod(qamStream,N,L,Train_qam,Lt);
%  ofdmStream = ofdm_ONOFF_mod(qamStream,N,L,Train_qam,Lt);

%% Channel
% fs = 16000;
SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
order = 3;
for i=1:order
   h(i) = randn/2; 
end
rxOfdmStream = fftfilt(h,ofdmStream) + noise;


% Pulse=[wgn(fs,1,0);zeros(300,1)];
% Pulse_norm=Pulse/max(Pulse)/10;
% ofdmStream_pulse = [Pulse_norm;ofdmStream];
% 
% [simin,nbsecs,fs]=initparams(ofdmStream_pulse,fs);
% sim('recplay')
% out=simout.signals.values;
% [out_aligned]= alignIO(out,Pulse_norm);
% rxOfdmStream=out_aligned(1:length(ofdmStream));


%% OFDM demodulation

 [rxQamStream,channel_est] = ofdm_demod(rxOfdmStream,N,L,Lqam,Train_qam,Lt,M,fft(h,N),qamStream);
%   [rxQamStream,channel_est] = ofdm_ONOFF_demod(rxOfdmStream,N,L,Lqam,Train_qam,Lt,Ld,index);

%% QAM demodulation

rxBitStream = qam_demod(rxQamStream,M);

%% Compute BER

 berTransmission = ber(bitStream,rxBitStream)


%% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

%% Plot image
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;

%plot the channel response and the estimated channel response
% subplot(2,1,1);
% plot(h);
% subplot(2,1,2); 
% plot(h);

