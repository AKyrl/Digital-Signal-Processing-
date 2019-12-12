
function [H1,H2] = ofdm_channelest_stereo(Lt)




% QAM modulation
qamStream = qam_mod(train,M);

% OFDM modulation
L=9;
ofdmStream = ofdm_modC(qamStream,N,L);
ofdmStream = repmat(ofdmStream,Lt,1);
% Channel

SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;
% order = 3;
% for i=1:order
%    h(i) = randn/2; 
% end
% rxOfdmStream = fftfilt(h,ofdmStream) + noise;


% pulse = [wgn(fs,1,0);zeros(300, 1)];
% pulse = pulse/max(pulse)/10;
% Tx_pulse = [pulse; ofdmStream];

% [h, H] = createChannel('matlab.mat', N+L);
% record =  conv(Tx_pulse, h);
% Rx = alignIO(record,pulse,0);
% rxOfdmStream=Rx(20:length(ofdmStream)+19)+noise;

Pulse=[wgn(fs,1,0);zeros(300,1)];
Pulse_norm_L=Pulse/max(Pulse)/10;
Pulse_norm_R=Pulse/max(Pulse)/20;
ofdmStream_L=[ofdmStream ; zeros(length(ofdmStream,1)];
ofdmStream_R=[zeros(length(ofdmStream,1) ;ofdmStream]
ofdmStream_pulse_L = [Pulse_norm_L;ofdmStream_L];
ofdmStream_pulse_R = [Pulse_norm_R;ofdmStream_R]


[simin,nbsecs,fs]=initparams_stereo(ofdmStream_pulse_L,ofdmStream_pulse_R,fs);
sim('recplay')
out=simout.signals.values;
[out_aligned]= alignIO(out,Pulse_norm);
rxOfdmStream=out_aligned(1:length(ofdmStream));

% 
% OFDM demodulation
[rxQamStream,H_est] = ofdm_demodC(rxOfdmStream,N,L,Lt,qamStream);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
 berTransmission = ber(train,rxBitStream)

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% channel estimation prcessing
h_est = ifft(H_est.').';
[sorted_h, index] = sort(H_est(2:N/2),'ascend');
index = index(1:floor((N/2)*BWusage/100));
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
ylabel('magnitude (dB)', 'Interpreter', 'Latex')

end

