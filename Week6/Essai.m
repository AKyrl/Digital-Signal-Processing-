n = 0:15;
%x = 0.84.^n;
%y = circshift(x,5);
x=[ 0 1 1 1 1 1 1 0]
y=sin(n);
D=[0 0 0 0 0 0 0 0.5 0.6 0 0 0  x 0 0 0 0 0 0 0 0 0 0 y];
%y=reshape(y,45,[])
[c,lags] = xcorr(x,D);
figure
stem(lags,c);
figure
subplot(2,1,1);
plot(x);
subplot(2,1,2); 
plot(D);

[M,I]=max(c);
lags(I)


