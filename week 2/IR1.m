fs=16000;
 t = (0:1/fs:2)';
 impulse = t==0.5;
 %plot(t,impulse)
 [simin,nbsecs,fs] = initparams(impulse,fs);
 sim('recplay')
 out=simout.signals.values;
 x=[0:1/fs:nbsecs];
 plot(out);
 plot(simin);
%  soundsc(out,fs);
 [maximum,I]=max(out);
 sig = out(I-10:I+100);
 fiure(3)
subplot(2,1,1)
 plot(abs(sig));
subplot(2,1,2)
plot(20*log(abs(sig)));
