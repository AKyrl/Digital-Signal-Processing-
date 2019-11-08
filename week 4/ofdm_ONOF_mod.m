function [mod_seq]=ofdm_ONOF_mod(QAM_stream,N,L)
start = 200;
stop = 395;
frames = ceil(length(QAM_stream)/((N/2-1 ) - (stop-start)));

% Packet = zeros(N, ceil(size(QAM_stream,1)/frames) );
k = 1;
for j=1:start-1
for i=1:frames
     P(j,i) = QAM_stream(k);
     k=k+1;
end
end
k=stop;
for j=stop:N/2-1
for i=1:frames
   if k>size(QAM_stream)
       break;
       
   else
     P(j,i) = QAM_stream(k);
     k=k+1;
   end
    
end
end
% P=reshape(QAM_stream,N/2-1,[]);

Pc= conj(P);
Pc= flip(Pc,1);
 
for i=2:N/2
Packet(i,:) = P(i-1,:);
Packet(i+N/2,:) = Pc(i-1,:);
end


ifftP = ifft(Packet); 
ifftP=[ifftP(N-L+1:N,:);ifftP];

mod_seq = ifftP(:);

 end