clear all;
%% make Packet
N = 10;
L=4;
Nq = 4; % <=6 size of qam
M = 2^Nq; 

n= 10;
s = (2^n)*Nq;
SNR = 8;

seq = randi([0 1],s*Nq,1);
 
[qam_stream] = qam_mod(seq,M);
    
mod_seq=ofdm_mod(qam_stream,N,L);

noise =   randn(size(mod_seq)) ;
sig = mod_seq + noise/SNR;

qam_stream_r = ofdm_demod(sig,N,L);
 
[seq_r] = qam_demod(qam_stream_r,M);
 
 ber(seq,seq_r)
 
 fs = 1000;
 R = M*((n/2)-1)*fs/N ;
%%

