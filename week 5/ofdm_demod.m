function qam_seq=ofdm_demod(mod_seq,N,L,freq_resp,frame)
 
mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:); % L is gone 
framec=conj(frame);
framec=flip(framec,1);
%h=zeros(1,N);
h(1)=0;
h(N)=0;
G=fft(mod_seq);
for k=1:N/2-1
    A=repmat(frame(k),1,100);
    D=mod_seq(k+1,:);
    B=G(k+1,:);
    C=B/A;
    h(k+1)=C;
end
for k=1:N/2-1
    A=repmat(framec(k),1,100);
    B=G(k+N/2+1,:);
    C=B/A;
    h(k+N/2+1)=C;
end

mod_seq = fft(mod_seq)./h.';
sig = mod_seq(2:(N/2),1);
qam_seq = sig(:);

 end