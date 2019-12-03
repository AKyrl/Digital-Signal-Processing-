function qam_seq=ofdm_demod(mod_seq,N,L,frame,fre)
 
num=ceil(length(mod_seq)/(N+L));
O=N+L- (length(mod_seq)-num*(N+L));
mod_seq=[mod_seq; zeros(O,1)];
mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:); % L is gone 
framec=conj(frame);
framec=flip(framec,1);
%h=zeros(1,N);
G=fft(mod_seq);
B=G(1,:);
h(1)=mean(B);
B=G(N/2,:);
h(N/2)=mean(B);

for k=1:N/2-1
    A=repmat(frame(k),1,size(G,2));
    B=G(k+1,:);
    C=B/A;
    h(k+1)=C;
    A2=repmat(framec(k),1,size(G,2));
    B2=G(k+N/2+1,:);
    C=B2/A2;
    h(k+N/2+1)=C;
end


mod_seq = fft(mod_seq)./h.';
sig = mod_seq(2:(N/2),1);
qam_seq = sig(:);

 end