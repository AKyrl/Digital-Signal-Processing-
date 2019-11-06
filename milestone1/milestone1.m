%% ---- initalise parameters ----
fs = 16000;
t=[0:1/fs:2]';
 % freq = 400;
 % freq = 1500;
 freq = [100,200, 500, 1000, 1500, 2000, 4000, 6000];
 DC = 0 ; 
 sig=0;
 for i=1:8
    sig =  sig + sin(freq(i)*2*pi*t) + DC;
 end
 sig= wgn(10000,1,1);
dftsize = 1000; 
fs = 16000;
window = dftsize;
%% ---- play and record ----
[simin,nbsecs,fs] = initparams(sig,fs);
 sim('recplay')
 out=simout.signals.values;
%% ---- make and plot spectrogram ----
[spec_out,f_out,t_out] = spectrogram(out,window,100,dftsize,fs);
[spec_in,f_in,t_in] = spectrogram(sig,window,100,dftsize,fs);
figure(1)
subplot(2,1,1)
% plot(sig)
imagesc(t_out,f_out,20*log(abs(spec_in)))
title('Spectrogram of input signal') 
subplot(2,1,2)
% plot(out)
title('Spectrogram of output signal') 
imagesc(t_in,f_in,20*log(abs(spec_out)))
title('Spectrogram of output signal') 
% hold 
%% ---- calculate and plot PSD ----
psd_out = zeros(501);

for i=1 : 1:size(spec_out,2)
    
    psd_out = psd_out + (abs( spec_out(:,i))).^2 ;
    
end

psd_out = psd_out/(length(spec_out));
figure(2)
% imagesc(t_out,f_out,10*log(abs(psd_out)))
title('PSD of output') 
plot(f_out,10*log(psd_out))

%% -------- Week 2 -------
%clear all;
%% Find IR by impulse


 %FIND IR using noise
% %  fs=16000;
% %  noise= wgn(500,1,1);
% %  t = (0:1/fs:2)';
% %  [simin,nbsecs,fs] = initparams(noise,fs);
% %  sim('recplay')
% %  out=simout.signals.values;
% soundsc(out,fs);
 [M,I]=max(out);
 %impulse=out(I-20:I+200);

T=toeplitz(out(I-10:I+5000),zeros([1 100]));
size(T,1);
length(out(2*fs:2*fs+size(T,1)-1))
h=T\out(2*fs-100:2*fs+size(T,1)-101);
figure(3)
subplot(2,1,1)
 plot(20*log(abs(fft(h))));
 title('FFT of signal ') 
subplot(2,1,2)
plot(20*log(abs(h)));
 title('Impulse responce by IR2') 

fs=16000;
 t = (0:1/fs:2)';
 impulse = t==0.5;
%  plot(t,impulse)
 [simin,nbsecs,fs] = initparams(impulse,fs);
 sim('recplay')
 out=simout.signals.values;
 x=[0:1/fs:nbsecs];
%  plot(simin);
%  soundsc(out,fs);
 [maximum,I]=max(out);
 sig = out(I-10:I+170);
 figure(4)
subplot(2,1,1)
 plot(20*log(abs(fft(sig))));
 title('FFT of signal ')
subplot(2,1,2)
plot(20*log(abs(sig)));
 title('Impulse responce by IR1') 

