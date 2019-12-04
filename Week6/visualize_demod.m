clear all
transmit_pic();

% ** Visualization
Lb = length(rxBitStream);
LbPerPacket = Ld*(N/2-1)*log2(M);
Ncycles = length(rxOfdmStream)/(N+L)/(Ld+Lt);
h_est = ifft(channel_est.').';
f_axis = ((-N/2):N/2-1)/N*2*fs;
t_axis = (1:length(h_est))/fs;
Hmax = 20*log10(max(max(abs(channel_est))));
Hmin = 20*log10(min(min(abs(channel_est))));
hmax = max(max(h_est));
hmin = min(min(h_est));

figure;
subplot(2,2,1); plot(t_axis, h_est(1, :)); 
    axis([0, t_axis(end),hmin, hmax]); 
    title('Estimated impulse response', 'Interpreter', 'Latex');
    xlabel('time $$[s] $$ ', 'Interpreter', 'Latex');
    ylabel('amplitude', 'Interpreter', 'Latex');
    drawnow;
subplot(2,2,2); colormap(colorMap); 
    image(imageData); 
    axis image; 
    title('Original image'); 
    drawnow;

subplot(2,2,3);
    plot(f_axis,20*log10(abs(channel_est(1, :))));
    axis([-fs, fs, Hmin, Hmax]); 
    title('Estimated channel frequency response', 'Interpreter', 'Latex');
    xlabel('frequency $$[Hz] $$ ', 'Interpreter', 'Latex');
    ylabel('magnitude (dB)', 'Interpreter', 'Latex');
    drawnow;
subplot(2,2,4); colormap(colorMap); 
    image(bitstreamtoimage([rxBitStream(1:min(LbPerPacket, Lb)); zeros( Lb -LbPerPacket, 1);] , imageSize, bitsPerPixel)); 
    axis image; 
    title('Processed image'); 
    drawnow;
    pause(LbPerPacket/fs)
    %pause(5)

for t = 1:Ncycles    
    subplot(2,2,4); 
        colormap(colorMap); 
        image(bitstreamtoimage([rxBitStream(1:min(LbPerPacket*t, Lb)); zeros( Lb -LbPerPacket*t, 1);] , imageSize, bitsPerPixel)); 
            axis image; 
        drawnow;
    subplot(2,2,1); 
        plot(t_axis, h_est(t, :));
            axis([0, t_axis(end),hmin, hmax]); 

        drawnow;
    subplot(2,2,3);
        plot(f_axis,20*log10(abs(channel_est(t, :))));
       axis([-fs, fs, Hmin, Hmax]); 

        drawnow;
    pause(LbPerPacket/fs)
        %pause(5)

end
