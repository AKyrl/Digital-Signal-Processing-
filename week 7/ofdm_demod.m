function [qam_seq,channel_est]=ofdm_demod(mod_seq,N,L,Lqam,frame,Lt,M,qamStream)
 
mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:); % L is gone 

% num=ceil(size(mod_seq,2)/(Lt+Ld));


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

% PacketReal=fft(Packet)./HP.';
% W = 1/conj(h);
PacketFFT=fft(Packet);
for i=1:length(h)
    sig= PacketFFT(i+1,1).';
    W(i,1)=1/conj(h(i)); 
    X(i,1)=conj(W(i,1))*sig;
    for j=2:size(Packet,2)
    mi= 0.15;
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

qam_seq = X(:);
qam_seq=qam_seq(1:Lqam);

 end