function [qam_seq]=ofdm_demod(mod_seq,N,L,Lt,H12,Lqam)
 

mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:);
Packet = mod_seq(:,1+Lt:end); % Take each packet
mod_seq = fft(Packet)./H12.';

sig = mod_seq(2:(N/2), :);

qam_seq = sig(:);
qam_seq=sig(1:Lqam).';


 end