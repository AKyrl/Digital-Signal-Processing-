function [qam_seq,channel_est]=ofdm_ONOFF_demod(mod_seq,N,L,Lqam,frame,Lt,Ld,index)

 

mod_seq = reshape(mod_seq,N+L,[]);

mod_seq = mod_seq(L+1:N+L,:); % L is gone 



num=ceil(size(mod_seq,2)/(Lt+Ld));



train1=zeros(N/2-1,1);

for j=1:length(index)

train1(index(j))=frame(index(j));

end

% for j=stop:N/2-1
% 
% train1(j)=frame(j);
% 
% end



frame=train1;



for i= 1: num-1 

trainBlock =  mod_seq(:,1+(i-1)*(Lt+Ld):(i-1)*(Ld+Lt)+Lt); %Take each TrainBlock

Packet = mod_seq(:,(i-1)*(Ld+Lt)+1+Lt:(i-1)*(Ld+Lt)+Ld+Lt); % Take each packet

framec=conj(frame);

framec=flip(framec,1);

G = fft(trainBlock);

B=G(1,:);

h(1)=G(1,1);

h(N/2)=G(N/2,1);



    for k=1:N/2-1

        A=repmat(frame(k),1,Lt);

        B=G(k+1,:);

        h(k+1)=B/A;

        A2=repmat(framec(k),1,Lt);

        B2=G(k+N/2+1,:);

        h(k+N/2+1)=B2/A2;

    end

channel_est(i,:)=h;

seq(:,(i-1)*Ld+1 :i*Ld) = fft(Packet)./h.'; %feeling seq mod_seq in seq

end



i=num;

trainBlock =  mod_seq(:,1+(i-1)*(Lt+Ld):(i-1)*(Ld+Lt)+Lt); %Take the last TrainBlock

CLeft= size(mod_seq,2) - (num-1)*(Ld+Lt)-Lt;

Packet = mod_seq(:,(i-1)*(Ld+Lt)+1+Lt:(i-1)*(Ld+Lt)+Lt+CLeft); % Take the last packet

framec=conj(frame);

framec=flip(framec,1);

G = fft(trainBlock);

h(1)=G(1,1);

h(N/2)=G(N/2,1);



    for k=1:N/2-1

        A=repmat(frame(k),1,Lt);

        B=G(k+1,:);

        h(k+1)=B/A;

        A2=repmat(framec(k),1,Lt);

        B2=G(k+N/2+1,:);

        h(k+N/2+1)=B2/A2;

    end

channel_est(i,:)=h;

seq(:,(i-1)*Ld+1 :(i-1)*Ld+CLeft) = fft(Packet)./h.'; %feeling mod_seq in seq



seq1=seq;



k=1;

frames=size(seq1,2);



% for j=2:start
% 
% for i=1:frames
% 
%     qam_seq(k) = seq1(j,i);
% 
%     k = k +1;
% 
% end
% 
% end


seq1=seq1(2:N/2,:)
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





% sig = qam_seq(2:(N/2),:);

% %sig = mod_seq(2:(N/2),1);

% qam_seq = sig(:);

% qam_seq=qam_seq(1:Lqam);



 end






  


