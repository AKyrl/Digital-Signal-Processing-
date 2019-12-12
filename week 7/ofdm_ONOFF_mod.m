function [mod_seq,Dummy]=ofdm_mod(QAM_stream,N,L,train,Lt,index)

div= (N/2-1) -(length(index)-1);
frames = ceil(length(QAM_stream)/div);
P = zeros(N/2-1, frames);
k = 1;
train1=zeros(N/2-1,1);
for j=1:length(index) %stop:N/2-1
    for i=1:frames
        if k>length(QAM_stream)
           break;       
        else
          P(index(j),i) = QAM_stream(k);
          k=k+1;
        end 
    end
 train1(index(j))=train(index(j));
end

Pc= conj(P);
Pc= flip(Pc,1);
Packet=[zeros(1,size(P,2)); P; zeros(1,size(P,2)); Pc]; % Packet with Data

trainB=repmat(train1,Lt,1);
trainB=reshape(trainB,N/2-1,[]);
trainBc=conj(trainB);
trainBc=flip(trainBc,1);
trainBlock=[zeros(1,size(trainB,2)); trainB; zeros(1,size(trainBc,2)); trainBc]; % TrainingBlock

Packet2=[trainBlock Packet];

ifftP = ifft(Packet2); 
ifftP=[ifftP(N-L+1:N,:);ifftP];
mod_seq = ifftP(:);
 end