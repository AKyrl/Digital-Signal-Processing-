function [out_aligned]= alignIO(out,pulse,L)

[r,lags]=xcorr(out,pulse); 
[~,I]=max(r);
D=lags(I);

out_aligned=out(abs(D)+length(pulse)+L-20:end);
end
