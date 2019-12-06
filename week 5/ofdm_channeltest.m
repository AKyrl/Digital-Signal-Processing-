% Exercise session 4: DMT-OFDM transmission scheme
clear all;
load('matlab.mat')
%% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

%% Create Train vector
Nq = 4; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;


%% QAM modulation
qamStream = qam_mod(train,M);



%% OFDM modulation
L=9;
ofdmStream = ofdm_mod(qamStream,N,L);
ofdmStream = repmat(ofdmStream,100,1);
fs = 16000;

t=[0:1/fs:0.2]';
Pulse =  rectangularPulse(0.05,0.15,t);



%% Channel

SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
% order = 3;
% for i=1:order
%    h(i) = randn/2; 
% end
h= h_lse;
rxOfdmStream = fftfilt(h,ofdmStream) + noise;

% [simin,nbsecs,fs]=initparams(ofdmStream,fs,Pulse,L);
% sim('recplay')
% out=simout.signals.values;
% [out_aligned]= alignIO(out,Pulse,L);

%% OFDM demodulation

rxQamStream = ofdm_demod(rxOfdmStream,N,L,qamStream);

%% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

%% Compute BER
 berTransmission = ber(train,rxBitStream)


%% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% channel estimation prcessing
h_est = ifft(H_est.').';
sys = tf(h_est.', [1 zeros(1,length(h_est.')-1)], 1/fs);
f_axis = ((-N/2):N/2-1)/N*2*fs;
%% Plot image


%plot the channel response and the estimated channel response
% subplot(2,1,1);
% plot(h);
% subplot(2,1,2); 
% plot(h);


figure('NumberTitle', 'off', 'Name', 'OFDM_est');
subplot(2,1,1);
impulse(sys)
title('Estimated time domain impulse response', 'Interpreter', 'Latex');
xlabel('time', 'Interpreter', 'Latex');
ylabel('impulse response', 'Interpreter', 'Latex');
subplot(2,1,2);
plot(f_axis,20*log10(abs(fftshift(H_est))))
title('Estimated frequency response', 'Interpreter', 'Latex');
xlabel('frequency[Hz]', 'Interpreter', 'Latex');
ylabel('magnitude (dB)', 'Interpreter', 'Latex');

