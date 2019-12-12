%% Exercise session 6: OFDM over the acoustic channel: transmitting an image
clear all;
%% Convert BMP image to bitstream
% [bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

%% Create Train vector
Nq = 6; %<=6
M = 2^Nq;
N = 1024;
S = 1000*Nq;
bitStream = randi([0 1],S,1) ;

%% QAM modulation


qamStream = qam_mod(bitStream,M);

Lqam = length(qamStream);






%% OFDM modulation

% L=9;
% %  ofdmStream = ofdm_mod(qamStream,N,L,Train_qam,Lt,Ld);
%  ofdmStream = ofdm_ONOFF_mod(qamStream,N,L,Train_qam,Lt,Ld,index);

%% Channel
H = 2*( rand() + j*rand());
SNR = inf;
noise =   randn(size(qamStream)) ;
sig = conv(qamStream,H) + noise/SNR;
% [simin,nbsecs,fs]=initparams(ofdmStream_pulse,fs);
% sim('recplay')
% out=simout.signals.values;




%% OFDM demodulation

%  [rxQamStream,channel_est] = ofdm_demod(rxOfdmStream,N,L,Lqam,Train_qam,Lt,Ld);
  
% [rxQamStream,channel_est] = ofdm_ONOFF_demod(rxOfdmStream,N,L,Lqam,Train_qam,Lt,Ld,index);

%% QAM demodulation

W = 5/(conj(H)) + 3*(rand()+j*rand());

mi= 0.05;
alpha= 0.1;

Y= sig;
e=1;
i=1;
while abs(e) >0.001
    estimatedBit = qam_demod(Y,M);
    estimatedQAM = qam_mod(estimatedBit,M);
    Y=conj(W)*sig;
    corr=  mi./(alpha + conj(sig).'*sig);
    A= sig().'*conj(estimatedQAM-Y);
    W = W + corr.* A;
    e = mean(estimatedQAM - Y)
%     e = conj(W)-(1/H);
    e_plot(i) = e;
    i = i+1;
end

rxQamStream = conj(W)*sig;
rxBitStream = qam_demod(rxQamStream,M);


%% Compute BER
plot(e_plot,'.');
berTransmission = ber(bitStream,rxBitStream)


%% Construct image from bitstream
% imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

%% Plot image
% subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
% subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;

%plot the channel response and the estimated channel response
% subplot(2,1,1);
% plot(h);
% subplot(2,1,2); 
% plot(h);

