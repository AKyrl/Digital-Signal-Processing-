 fs=16000;
 freq=1500;
 t=[0:1/fs:2]';
 sinewave=sin(freq*2*pi*t);
 [simin,nbsecs,fs] = initparams(sinewave,fs);
 sim('recplay')
 out=simout.signals.values;
 x=[0:1/fs:nbsecs];
 plot(out);
 %plot(simin);
 soundsc(out,fs);