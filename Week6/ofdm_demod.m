function [qam_seq,channel_est]=ofdm_demod(mod_seq,N,L,Lqam,frame,Lt,Ld)
 
mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:); % L is gone 

num=ceil(size(mod_seq,2)/(Lt+Ld));

for i= 1: num-1 
trainBlock =  mod_seq(:,1+(i-1)*(Lt+Ld):(i-1)*(Ld+Lt)+Lt); %Take each TrainBlock
Packet = mod_seq(:,(i-1)*(Ld+Lt)+1+Lt:(i-1)*(Ld+Lt)+Ld+Lt); % Take each packet
framec=conj(frame);
framec=flip(framec,1);
G = fft(trainBlock);
% B=G(1,:);
% h(1)=mean(B);
% B=G(N/2,:);
% h(N/2)=mean(B);


    for k=1:N/2-1
        A=repmat(frame(k),1,Lt);
        B=G(k+1,:);
        h(k)=B/A;
%         A2=repmat(framec(k),1,Lt);
%         B2=G(k+N/2+1,:);
%         h(k+N/2+1)=B2/A2;
    end
Hn=[0 h 0 fliplr(conj(h))];
channel_est(i,:)=Hn;
seq(:,(i-1)*Ld+1 :i*Ld) = fft(Packet)./Hn.'; %feeling seq mod_seq in seq
end

i=num;
trainBlock =  mod_seq(:,1+(i-1)*(Lt+Ld):(i-1)*(Ld+Lt)+Lt); %Take the last TrainBlock
CLeft= size(mod_seq,2) - (num-1)*(Ld+Lt)-Lt;
Packet = mod_seq(:,(i-1)*(Ld+Lt)+1+Lt:(i-1)*(Ld+Lt)+Lt+CLeft); % Take the last packet
framec=conj(frame);
framec=flip(framec,1);
G = fft(trainBlock);
% h(1)=G(1,1);
% h(N)=0;

    for k=1:N/2-1
        A=repmat(frame(k),1,Lt);
        B=G(k+1,:);
        h(k)=B/A;
%         A2=repmat(framec(k),1,Lt);
%         B2=G(k+N/2+1,:);
%         h(k+N/2+1)=B2/A2;
    end
Hn=[0 h 0 fliplr(conj(h))];
channel_est(i,:)=Hn;
seq(:,(i-1)*Ld+1 :(i-1)*Ld+CLeft) = fft(Packet)./Hn.'; %feeling mod_seq in seq



sig = seq(2:(N/2),:);
%sig = mod_seq(2:(N/2),1);
qam_seq = sig(:);
qam_seq=qam_seq(1:Lqam);

 end