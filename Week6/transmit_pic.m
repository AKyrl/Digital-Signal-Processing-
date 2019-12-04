% Exercise session 6: OFDM over the acoustic channel: transmitting an image
clear all;
load('matlab.mat')
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

Lt=40; %Lt training frames
Ld=10; %Ld data Frames
BWusage=70; % tones sent in the transmission
fs=16000;

% Create Train vector
Nq = 4; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;

% QAM modulation

qamStream = qam_mod(bitStream,M);
Train_qam = qam_mod(train,M);
Lqam = length(qamStream);


% OFDM modulation

L=9;
ofdmStream = ofdm_mod(qamStream,N,L,Train_qam,Lt,Ld);


% Channel


% %order = 10;
% a = ones(1, order);
% Num = a;
% Lresp = length(Num) -1;
% Den = [1 zeros(1,Lresp)];
% sys = tf(Num, Den, -1);

SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
order = 3;
% for i=1:order
%    h(i) = randn/2; 
% end
%  h= h_lse;

pulse = [wgn(fs,1,0);zeros(300, 1)];
pulse = pulse/max(pulse)/10;
Tx_pulse = [pulse; ofdmStream];

[h, H] = createChannel('matlab.mat', N);
record =  conv(Tx_pulse, h);
Rx = alignIO(record,pulse,0);
rxOfdmStream=Rx(20:length(ofdmStream)+19);



% rxOfdmStream = fftfilt(h,ofdmStream)+ noise;
%rxOfdmStream =lsim(sys,ofdmStream);

% OFDM demodulation

% rxQamStream = ofdm_demod(rxOfdmStream,N,L,fft(h,N),Train_qam,Lt,Ld);
 [rxQamStream,channel_est] = ofdm_demod(rxOfdmStream,N,L,Lqam,Train_qam,Lt,Ld,fft(h,N));

% QAM demodulation

rxBitStream = qam_demod(rxQamStream,M);

% Compute BER

 berTransmission = ber(bitStream,rxBitStream)


% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot image
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;

%plot the channel response and the estimated channel response
% subplot(2,1,1);
% plot(h);
% subplot(2,1,2); 
% plot(h);

