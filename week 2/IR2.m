 fs=16000;
 noise= wgn(500,1,1);
 t = (0:1/fs:2)';
 [simin,nbsecs,fs] = initparams(noise,fs);
 sim('recplay')
 out=simout.signals.values;
%  soundsc(out,fs);
% [M,I]=max(out);
 %impulse=out(I-20:I+200);

T=toeplitz(noise,zeros([1 100]));
size(T,1)
length(out(2*fs:2*fs+size(T,1)-1))
h=T\out(2*fs-100:2*fs+size(T,1)-101);
plot(20*log(abs(h)));
