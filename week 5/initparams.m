function [simin,nbsecs,fs]=initparams(toplay,fs,Pulse,L)
 
simin = [zeros(2*fs,1) zeros(2*fs,1); Pulse Pulse ; zeros(L,1) zeros(L,1) ; toplay toplay; zeros(fs,1) zeros(fs,1)];
nbsecs = size(simin,1)*1/fs ;
     
 end