function mod_seq=qam_mod(seq,M)
 
k = log2(M);
dataInMatrix = reshape(seq,length(seq)/k,k);  
dataSymbolsIn = bi2de(dataInMatrix);               

mod_seq = (qammod(dataSymbolsIn,M,'bin'))/(sqrt((2/3)*(M-1)));


 end