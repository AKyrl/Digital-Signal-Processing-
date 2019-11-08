 fs=16000;
 noise= wgn(2*fs,1,1);
 t = (0:1/fs:2)';
 [simin,nbsecs,fs] = initparams(noise,fs);
 sim('recplay')
 out=simout.signals.values;
 k = 2*fs;
 L=300;
%  soundsc(out,fs);
% [M,I]=max(out);
 %impulse=out(I-20:I+200);

T=toeplitz(simin(2*fs:2*fs+k-1),fliplr(simin(2*fs-L+1:2*fs)));

% length(out(2*fs:2*fs+size(T,1)-1))
h=T\out(2*fs-100:2*fs+k-101);
plot(20*log(abs(h)));
