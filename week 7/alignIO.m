function [out_aligned]= alignIO(out,pulse,L)
fs=16000;
[r,lags]=xcorr(out,pulse); 
[~,I]=max(r);
D=lags(I);

out_aligned=out(lags(I)+length(pulse)-20:end);
end
