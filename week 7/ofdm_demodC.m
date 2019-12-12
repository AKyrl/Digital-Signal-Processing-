function [qam_seq,H_est]=ofdm_demodC(mod_seq,N,L,Lt,frame)

 
xk=reshape(mod_seq,[N+L,Lt]);
xk=xk(L+1:end,:);
xk=fft(xk,N);
xk=xk(2:N/2,1:Lt);
Hn=zeros(1,N/2-1);
for j=1:(N/2-1)
    A=repmat(frame(j),[Lt,1]);
    B=xk(j,:).';
    Hn(j)=A\B;
end

Xk=diag(1./Hn)*xk;
qam_seq=reshape(Xk,[Lt*(N/2-1),1]);
qam_seq=qam_seq(1:(N/2-1));
H_est= [0 Hn 0 fliplr(conj(Hn))].';


 end