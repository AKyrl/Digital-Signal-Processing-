function [simin,nbsecs,fs]=initparams_stereo(toplayL,toplayR,fs)
 
simin = [zeros(2*fs,1) zeros(2*fs,1); toplayL toplayR; zeros(fs,1) zeros(fs,1)];
nbsecs = size(simin,1)*1/fs ;     
 end