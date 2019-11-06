fs = 16000;
t=[0:1/fs:2]';
freq = 1000;
sig = sin(freq*2*pi*t);

dftsize = 1000; 
window = dftsize;


[simin,nbsecs,fs] = initparams(sig,fs);
 sim('recplay')
 out=simout.signals.values;

[spec_out,f_out,t_out] = spectrogram(out,window,100,dftsize,fs);
[spec_in,f_in,t_in] = spectrogram(sig,window,100,dftsize,fs);

%subplot(2,1,1)
%imagesc(t_out,f_out,20*log(abs(spec_out)))
%plot(sig)
%subplot(2,1,2)
%plot(out)
%imagesc(t_in,f_in,20*log(abs(spec_in)))

psd_out = zeros(501);

for i=1 : 1:size(spec_out,2)
    
    psd_out = psd_out + (abs( spec_out(:,i))).^2 ;
    
end

psd_out = psd_out/(length(spec_out));
plot(10*log(psd_out))
