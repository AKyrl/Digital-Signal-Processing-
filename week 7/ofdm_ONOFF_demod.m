function [qam_seq,channel_est]=ofdm_ONOFF_demod(mod_seq,N,L,Lqam,frame,Lt,index,M)

 

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

W=zeros(1,length(h));
X=zeros(length(h),size(Packet,2));
% PacketReal=fft(Packet)./FUN;
%%%% Finding W%%%%%%
PacketFFT=fft(Packet);
for m=1:length(index)
    i=index(m);
    sig= PacketFFT(i+1,1).';
    W(i,1)=1/conj(h(i)); 
    X(i,1)=conj(W(i,1))*sig;
    for j=2:size(Packet,2)
    mi= 0.5;
    alpha= 0.00001;
    sig= PacketFFT(i+1,j).';
    Yk=conj(W(i,j-1)).*sig;
    estimatedBit = qam_demod(Yk,M);
    estimatedQAM = qam_mod(estimatedBit,M);
    corr=  mi./(alpha + conj(sig).'*sig);
    A= sig.'*conj(estimatedQAM-Yk);
    W(i,j) = W(i,j-1) + corr.* A;
    X(i,j)=conj(W(i,j))*sig;
    end
end

seq1=X;
k=1;
frames=size(seq1,2);


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


