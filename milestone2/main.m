% Exercise session 4: DMT-OFDM transmission scheme
clear all;
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% Get H(k) to do adaptive bit loading
order = 100;
% % % Gama = 10;
 N = 1024; 
 for i=1:order
   h(i) = randn/2; 
 end
 H = fft(h,N);
%load('U:\Documents\matlab\New Folder\week 4\freq_resp.mat');

% SNR = 10;
% noise =   (randn(1,N)+j*randn(1,N))/SNR ;
% [Pxx,F] = periodogram(noise,[],length(noise),N);

% % % P = 0.25; % find correct P_n(k)
% % % for k=1:N
% % %     b(k) = floor( log2( 1 + (abs((H(k))^2)/(Gama*P)) ) );%Pxx(k)
% % %     
% % % end
% plot( b)
% QAM modulation
Nq = 4; %<=6
M = 2^Nq;
qamStream = qam_mod(bitStream,M);
zeropaded = qamStream;
% OFDM modulation
N = 1024; 
numbZer = 0;
while rem(size(zeropaded,1),(N/2)-1 ) ~= 0 %zero pad signal to be divisible by n/2 -1
    zeropaded(end+1:end+1)=0;
    numbZer = numbZer + 1;
end
L=0;
%ofdmStream = ofdm_ONOF_mod(zeropaded,N,L);
ofdmStream=ofdm_mod(zeropaded,N,L);

% Channel
SNR = inf;
noise =   randn(size(ofdmStream))/SNR ;

rxOfdmStream = ofdmStream; %fftfilt(h,ofdmStream) + noise;

%PSD calculation
% % Fs = 16000;
% % [Pxx,F] = periodogram(rxOfdmStream);%,[],length(rxOfdmStream),Fs
% % plot(f,10*log10(Pxx))


% OFDM demodulation
% rxQamStream = ofdm_ONOF_demod(rxOfdmStream,N,L,fft(h',N));
rxQamStream = ofdm_demod(rxOfdmStream,N,L,H);
rxQamStream = rxQamStream(1:end-numbZer); % remove zero padding
% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
berTransmission = ber(bitStream,rxBitStream)

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
