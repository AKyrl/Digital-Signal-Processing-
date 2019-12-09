function [simin,nbsecs,fs]=initparams(toplay,fs)
 
simin = [zeros(2*fs,1) zeros(2*fs,1); toplay toplay; zeros(fs,1) zeros(fs,1)];
nbsecs = size(simin,1)*1/fs ;
     
 end