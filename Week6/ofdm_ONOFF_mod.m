function [mod_seq,Dummy]=ofdm_ONOFF_mod(QAM_stream,N,L,train,Lt,Ld,index)

if length(index) == 511
    
    frames = ceil(length(QAM_stream)/((N/2)-1 ));
else
    frames = ceil(length(QAM_stream)/(((N/2)-1 ) -(length(index)-1)));
end
    



P = zeros(N/2-1, frames);

k = 1;

train1=zeros(N/2-1,1);

% for j=1:start
% 
% for i=1:frames
% 
%      P(j,i) = QAM_stream(k);
% 
%      k=k+1;
% 
% end
% 
% train1(j)=train(j);
% 
% end



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

Packet=[zeros(1,size(P,2)); P; zeros(1,size(P,2)); Pc];





Dummy=Packet; 





trainB=repmat(train1,Lt,1);

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







ifftP = ifft(Packet2); 

ifftP=[ifftP(N-L+1:N,:);ifftP];



mod_seq = ifftP(:);







 end