function qam_seq=ofdm_demod(mod_seq,N,L,freq_resp)
 
mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:);
mod_seq = fft(mod_seq)./freq_resp.';

sig = mod_seq(2:((N/2)), :);

qam_seq = sig(:);

 end