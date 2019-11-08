function [mod_seq]=ofdm_adapt_mod(bitstream,N,L,b)


for i=1:N
   
    qamseq(i)=qam_mod(bitstream(i*N-N:i*size(bitstream)/N),b(i));
%     zeropad = qamseq(end+1:end+)
end



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