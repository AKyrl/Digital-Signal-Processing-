% Exercise session 4: DMT-OFDM transmission scheme

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
fs=16000;
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
Pulse=[wgn(fs,1,0);zeros(300,1)];
Pulse_norm=Pulse/max(Pulse)/10;
 ofdmStream_pulse = [Pulse_norm;ofdmStream1];

% SNR = inf;
% noise =   randn(size(ofdmStream1))/SNR ;
% order = 200;
% for i=1:order
%    h(i) =5*( randn+j*randn); 
% end
% rxOfdmStream = fftfilt(h,ofdmStream1) + noise;

[simin,nbsecs,fs]=initparams(ofdmStream_pulse,fs);
sim('recplay')
out=simout.signals.values;
[out_aligned]= alignIO(out,Pulse_norm);
rxOfdmStream=out_aligned(1:length(ofdmStream1));


% OFDM demodulation
[rxQamStream,H_est] = ofdm_demodC(rxOfdmStream,N,L,Lt,qamStream1);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
 berTransmission = ber(train,rxBitStream)


% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);


% channel estimation prcessing

h_est = ifft(H_est.').';

[sorted_h, index] = sort(H_est(2:N/2),'descend');

if BWusage<100
index = index(1:floor(((N/2))*BWusage/100));
else
index = index(1:floor((N/2)-1));
end

sys = tf(h_est.', [1 zeros(1,length(h_est.')-1)], 1/fs);

f_axis = ((-N/2):N/2-1)/N*2*fs;

%plot the channel response and the estimated channel response
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




