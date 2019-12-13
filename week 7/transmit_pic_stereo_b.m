

%% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
BWusage=50;

%% Create Train vector
Nq = 1; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;

%% QAM modulation

ofdm_channelest_stereo();
[a,b,H12]=fixed_transmitter_side_beamformer(H1,H2);
% a=zeros(N,1);
Lt=10; %Lt training frames
Ld=10;
qamStream = qam_mod(bitStream,M);
Train_qam = qam_mod(train,M);
Lqam = length(qamStream);

%% OFDM modulation
N=1024;
L=50;

[ofdmStream_L,ofdmStream_R] = ofdm_mod_stereo(qamStream,a,b,N,L,Train_qam,Lt,Ld);


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
rxOfdmStream=out_aligned_L(1:length(ofdmStream_L));






%% OFDM demodulation
[rxQamStream,channel_est]=ofdm_demod_stereo(rxOfdmStream,N,L,Lt,Lqam,Ld,Train_qam);

%% QAM demodulation

rxBitStream = qam_demod(rxQamStream,M);

%% Compute BER

 berTransmission = ber(bitStream,rxBitStream)
 
 %% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

%% Plot image
figure;
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
                                                                                                           


                                                 







                                                                                              