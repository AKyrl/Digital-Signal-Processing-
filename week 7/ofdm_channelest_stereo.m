
% Exercise session 4: DMT-OFDM transmission scheme

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
fs=16000;
BWusage=100;
% Create Train vector
Nq = 2; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;
Lt=50;

% QAM modulation
qamStream1 = qam_mod(train,M);

% OFDM modulation
L=200;
ofdmStream1 = ofdm_modC(qamStream1,N,L);
ofdmStream1 = repmat(ofdmStream1,50,1);
% Channel
ofdmStream_L = [ofdmStream1 ; zeros(length(ofdmStream1),1)];
ofdmStream_R = [ zeros(length(ofdmStream1),1);ofdmStream1 ];
Pulse_L=[wgn(fs,1,0);zeros(300,1)];
Pulse_R=[wgn(fs,1,0);zeros(300,1)];
Pulse_norm_L=Pulse_L/max(Pulse_L)/10;
Pulse_norm_R=Pulse_R/max(Pulse_R)/10;
ofdmStream_pulse_L = [Pulse_norm_L;ofdmStream_L];
ofdmStream_pulse_R = [Pulse_norm_R;ofdmStream_R];

[simin,nbsecs,fs]=initparams_stereo(ofdmStream_pulse_L,ofdmStream_pulse_R,fs);
sim('recplay')
out=simout.signals.values;
[out_aligned_L]= alignIO(out,Pulse_norm_L);

rxOfdmStream_L=out_aligned_L(1:length(ofdmStream1));
rxOfdmStream_R=out_aligned_L(length(ofdmStream1)+1:2*length(ofdmStream1));


% OFDM demodulation
[rxQamStream_L,H1] = ofdm_demodC(rxOfdmStream_L,N,L,Lt,qamStream1);
[rxQamStream_R,H2] = ofdm_demodC(rxOfdmStream_R,N,L,Lt,qamStream1);
% QAM demodulation
rxBitStream_L = qam_demod(rxQamStream_L,M);
rxBitStream_R = qam_demod(rxQamStream_R,M);

% Compute BER
 berTransmission_L = ber(train,rxBitStream_L)
 berTransmission_R = ber(train,rxBitStream_R)


% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream_L, imageSize, bitsPerPixel);


% channel estimation prcessing

h_est1 = ifft(H1.').';
[sorted_h, index] = sort(H1(2:N/2),'descend');
% index = index(1:floor(((N/2))*BWusage/100));
sys = tf(h_est1.', [1 zeros(1,length(h_est1.')-1)], 1/fs);
f_axis = ((-N/2):N/2-1)/N*2*fs;

h_est2 = ifft(H2.').';
[sorted_h, index] = sort(H2(2:N/2),'descend');
% index = index(1:floor(((N/2))*BWusage/100));
sys2 = tf(h_est2.', [1 zeros(1,length(h_est2.')-1)], 1/fs);
f_axis = ((-N/2):N/2-1)/N*2*fs;

%plot the channel response and the estimated channel response
figure('NumberTitle', 'off', 'Name', 'OFDM_est');
subplot(2,1,1);
impulse(sys)
title('Estimated time domain impulse response H1', 'Interpreter', 'Latex');
xlabel('time', 'Interpreter', 'Latex');
ylabel('impulse response', 'Interpreter', 'Latex');
subplot(2,1,2);
plot(f_axis,20*log10(abs(fftshift(H1))))
title('Estimated frequency response', 'Interpreter', 'Latex');
xlabel('frequency[Hz]', 'Interpreter', 'Latex');
ylabel('magnitude (dB)', 'Interpreter', 'Latex');


figure('NumberTitle', 'off', 'Name', 'OFDM_est');
subplot(2,1,1);
impulse(sys2)
title('Estimated time domain impulse response H2', 'Interpreter', 'Latex');
xlabel('time', 'Interpreter', 'Latex');
ylabel('impulse response', 'Interpreter', 'Latex');
subplot(2,1,2);
plot(f_axis,20*log10(abs(fftshift(H2))))
title('Estimated frequency response', 'Interpreter', 'Latex');
xlabel('frequency[Hz]', 'Interpreter', 'Latex');
ylabel('magnitude (dB)', 'Interpreter', 'Latex');
