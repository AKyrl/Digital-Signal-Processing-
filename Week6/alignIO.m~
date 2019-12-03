function [out_aligned]= alignIO(out,pulse,L)

[r,lags]=xcorr(out,pulse); 
[M,I]=max(r);
lags(I);

out_aligned=out(abs(lags)+length(pulse)+L-20:end);
end
