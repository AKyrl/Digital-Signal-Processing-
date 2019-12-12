function [qam_seq,channel_est]=ofdm_ONOFF_demod(mod_seq,N,L,Lqam,frame,Lt,index,M,FUN)

 

mod_seq = reshape(mod_seq,N+L,[]);

mod_seq = mod_seq(L+1:N+L,:); % L is gone 

train1=zeros(N/2-1,1);


%%%%%finding Hn %%%%%%%%

for j=1:length(index)
train1(index(j))=frame(index(j));
end

frame=train1;



trainBlock =  mod_seq(:,1:Lt); %Take each TrainBlock
Packet = mod_seq(:,1+Lt:end); % Take each packet
framec=conj(frame);
framec=flip(framec,1);
G = fft(trainBlock);

for k=1:N/2-1
     A=repmat(frame(k),1,Lt);
     B=G(k+1,:);
     h(k)=B/A;
end
Hn=[0 h 0 fliplr(conj(h))];
channel_est=Hn;


PacketReal=fft(Packet)./FUN;
%%%% Finding W%%%%%%
W=zeros(1,length(h));
for j=1:length(index)
i=index(j);
W(i)=1/conj(h(i));    
mi= 0.003;
alpha= 0.00001;
sig=fft(Packet(i+1,:).');
Y= fft(Packet(i+1,:).');
e=1;
    while abs(e) >0.15
       estimatedBit = qam_demod(Y,M);
        estimatedQAM = qam_mod(estimatedBit,M);
        Y=conj(W(i))*sig;
        corr=  mi./(alpha + conj(sig).'*sig);
        A= sig.'*conj(estimatedQAM-Y);
        W(i) = W(i) + corr.* A;
        e = mean( Y-estimatedQAM);
        %e = conj(W(i))-(1/HP(i+1));
    end
end

Hm=[0 W 0 fliplr(conj(W))];
Essai= 1./conj(Hm);
seq=fft(Packet).*conj(Hm).';

seq1=seq;
k=1;
frames=size(seq1,2);
seq1=seq1(2:N/2,:);

for j= 1:length(index)%stop:N/2
    for i=1:frames
      if k>Lqam
          break;
      else
        qam_seq(k) = seq1(index(j),i);
        k=k+1;
      end
    end
end
qam_seq=qam_seq.';
 end


