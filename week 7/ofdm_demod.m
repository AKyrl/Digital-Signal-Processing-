function [qam_seq,channel_est]=ofdm_demod(mod_seq,N,L,Lqam,frame,Lt,M,HP,qamStream)
 
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

for i=1:length(h)
W(i)=1/conj(h(i));    
mi= 0.01;
alpha= 0.5;
sig=fft(Packet(i+1,:).');
Y= fft(Packet(i+1,:).');
e=1;
while abs(e) >0.1
    estimatedBit = qam_demod(Y,M);
    estimatedQAM = qam_mod(estimatedBit,M);
    Y=conj(W(i))*sig;
    corr=  mi./(alpha + conj(sig).'*sig);
    A= sig.'*conj(estimatedQAM-Y);
    W(i) = W(i) + corr.* A;
%     e = mean(estimatedQAM - Y)
%     e = mean( Y-estimatedQAM);
% e=e+1;
    e = conj(W(i))-(1/HP(i+1));
end
% Packet(i+1,:)=conj(W(i))*Packet(i+1,:);
end


Hm=[0 W 0 fliplr(conj(W))];
seq=fft(Packet).*conj(Hm).';
sig = seq(2:(N/2),:);
%sig = mod_seq(2:(N/2),1);
qam_seq = sig(:);
qam_seq=qam_seq(1:Lqam);

 end