function [a,b,H12] = fixed_transmitter_side_beamformer(H1,H2)
num1=conj(H1);
num2=conj(H2);
sum = H1.*conj(H1)+H2.*conj(H2);
den=sqrt(sum);
a=num1./den;
b=num2./den; 
H12=den; 

end