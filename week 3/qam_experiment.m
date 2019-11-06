clear all;
Nq = 1; %<=6
M = 2^Nq;

N= 10;
size = (2^N)*Nq;

seq = randi([0 1],size,1) ;

noise= (0.1) * ( randn(size/Nq, 1) + 1j*randn(size/Nq,1));

sig= qam_mod(seq,M) + noise ;

scatterplot(sig)
% text(real(sig)+0.1, imag(sig), dec2bin(seq))
title('M-QAM, Binary Symbol Mapping')
%axis([-4 4 -4 4])


demod_seq=qam_demod(sig,M);

% scatterplot(demod_seq)

beri = ber(seq,demod_seq);

