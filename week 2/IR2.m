 fs=16000;
 noise= wgn(500,1,1);
 t = (0:1/fs:2)';
 [simin,nbsecs,fs] = initparams(noise,fs);
 sim('recplay')
 out=simout.signals.values;
%  soundsc(out,fs);
% [M,I]=max(out);
 %impulse=out(I-20:I+200);
K = duration*fs;
c=simin(2*fs:2*fs+K-1, 1);
r = fliplr(simin(2*fs-L+1:2*fs));
T=toeplitz(c,r);
O=out(2*fs-100:2*fs+size(T,1)-101);
h=T\O;


plot(20*log(abs(h)));
