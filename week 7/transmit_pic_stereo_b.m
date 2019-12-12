
%% Create Train vector


Lt=10;
Nq = 4; %<=6
M = 2^Nq;
N = 1024;
S = (N/2-1)*Nq;
train = randi([0 1],S,1) ;
fs=16000;
Train_qam = qam_mod(train,M);

Train_qam_B = repmat(Train_qam,Lt,1);
toplayL = [Train_qam_B;zeros(length(Train_qam_B),1)];
toplayR = [zeros(length(Train_qam_B),1);Train_qam_B];

pulse = [wgn(fs,1,0);zeros(300, 1)];
pulse = pulse/max(pulse)/10;
Tx_pulseL = [pulse; toplayL ];
Tx_pulseR = [pulse; toplayR ];



simin=initparams_stereo(Tx_pulseL,Tx_pulseR,fs);