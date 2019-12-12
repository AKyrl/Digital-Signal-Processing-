function [mod_seq]=ofdm_modC(QAM_stream,N,L)
Packet = zeros(N, size(QAM_stream,1)/((N/2)-1) );
P=reshape(QAM_stream,N/2-1,[]);
Pc= conj(P);
Pc= flip(Pc,1);
for i=2:N/2
Packet(i,:) = P(i-1,:);
Packet(i+N/2,:) = Pc(i-1,:);
end
ifftP = ifft(Packet); 
ifftP=[ifftP(N-L+1:N,:);ifftP];
mod_seq = ifftP(:);
 end