function [mod_seq1,mod_seq2]=ofdm_mod_stereo(QAM_stream,a,b,N,L,train,Lt,Ld)

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
num = ceil(size(Packet,2)/Ld); % number /Ld
for i=1:num-1
    Packet2(:,1+(i-1)*(Lt+Ld):(i-1)*(Ld+Lt)+Lt) =  trainBlock;
    Packet2(:,(i-1)*(Ld+Lt)+1+Lt:(i-1)*(Ld+Lt)+Ld+Lt) = Packet(:,(i-1)*(Ld)+1:(i)*(Ld));
end
i=num;
Packet2(:,1+(i-1)*(Lt+Ld):(i-1)*(Ld+Lt)+Lt) =  trainBlock;
CLeft= size(Packet,2) - (num-1)*(Ld);
Packet2(:,(i-1)*(Ld+Lt)+1+Lt:(i-1)*(Ld+Lt)+Lt+CLeft) = Packet(:,(i-1)*(Ld)+1:end);

a(1)=a(2);
a(N/2+1)=a(N/2+2);
b(1)=b(2);
b(N/2+1)=b(N/2+2);
IF=ifft(Packet2);
ifftP = ifft(Packet2.*a); 
ifftP=[ifftP(N-L+1:N,:);ifftP];
ifftP2 = ifft(Packet2.*b); 
ifftP2=[ifftP2(N-L+1:N,:);ifftP2];
mod_seq1 = ifftP(:);
mod_seq2 = ifftP2(:);

 end