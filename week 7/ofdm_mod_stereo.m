function [mod_seq1,mod_seq2]=ofdm_mod_stereo(QAM_stream,a,b,N,L,train,Lt)

frames = ceil(length(QAM_stream)/(N/2-1));
P = zeros(N/2-1, frames);

k = 1;
for j=1:frames
for i=1:N/2-1
    if k>length(QAM_stream)
       break;
       
   else
     P(i,j) = QAM_stream(k);
     k=k+1;
   end
end
end
Pc= conj(P);
Pc= flip(Pc,1);

Packet=[zeros(1,size(P,2)); P; zeros(1,size(P,2)); Pc];

trainB=repmat(train,Lt,1);
trainB=reshape(trainB,N/2-1,[]);
trainBc=conj(trainB);
trainBc=flip(trainBc,1);

trainBlock=[zeros(1,size(trainB,2)); trainB; zeros(1,size(trainBc,2)); trainBc];

Packet2=[trainBlock Packet];


ifftP = ifft(Packet2.*a.'); 
ifftP=[ifftP(N-L+1:N,:);ifftP];
ifftP2 = ifft(Packet2.*b.'); 
ifftP2=[ifftP2(N-L+1:N,:);ifftP2];
mod_seq1 = ifftP(:);
mod_seq2 = ifftP2(:);

 end