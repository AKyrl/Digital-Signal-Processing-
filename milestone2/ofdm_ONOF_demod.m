function qam_seq=ofdm_ONOF_demod(mod_seq,N,L,freq_resp)
start = 200;
stop = 395;
mod_seq = reshape(mod_seq,N+L,[]);
mod_seq = mod_seq(L+1:N+L,:);
mod_seq = fft(mod_seq);%./freq_resp.';

sig = mod_seq(2:((N/2)), :);

% sig = cat(1,sig(1:start,:),sig(stop+1:end,:));
k=1;
for j=1:N/2-1
for i=1:123
   if (k>38836)
   
   elseif (start<j)&&(j<stop)
       
   else
    qam_seq(k,1) = sig(j,i);
    k = k +1;
   end
end
end


 end