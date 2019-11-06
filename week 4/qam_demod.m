function demod_seq=qam_demod(mod_seq,M)
 
k = log2(M);

mod_seq = mod_seq*sqrt((2/3)*(M-1));

dataSymbolsOut = qamdemod(mod_seq,M,'bin');
dataOutMatrix = de2bi(dataSymbolsOut,k);
demod_seq = dataOutMatrix(:);
           

 end