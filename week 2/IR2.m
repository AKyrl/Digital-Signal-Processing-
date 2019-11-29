clear all

%input signal : white noise
%----- here user can define:
dftsize = 10000;        % size of the DFT
fs = 16000;             % sampling frequency
newSim = false;          % if true plays and record white noise    
storeData = false;          % if true stores the played/recorded signals    
duration = 2;           % duration of white noise signal (+ 1s before, 2s after of silence)
%-----

if newSim
    t = linspace(0, duration, duration*fs);
    sig =  wgn(length(t),1,0);

    % play and record the audio signal in sig at sampling frequency fs
    [simin,nbsecs,fs]=initparams(sig,fs);
    sim('recplay');
    record=simout.signals.values;
else
    simin = importdata('signalTx.mat');
    record = importdata('signalRx.mat');
end

% synchronizing played and recorded signal
d = 0;
M = max(abs(record));
w = length(simin(:,1));
record = record(1:w);
for i = 1:w
    if abs(record(i))>M/4
        if sum(abs(record(i:i+99)))>100*M/10
            d = i - 50;
            break
        end
    end
end



% Channel transfer function estimation
% L is the impulse response length, and K the amount of samples ze use in
% our LSE
L = 300;
K = duration*fs;
c = simin(2*fs:2*fs+K-1, 1);
r = fliplr(simin(2*fs-L+1:2*fs));
A_lse = toeplitz(c,r);
b_lse = record(d:d+K-1);
h_lse = A_lse\b_lse;

%Create the transfer function
sys = tf(h_lse', [1 zeros(1,L-1)], 1/fs);

%Plot impulse response in the time and frequency domain
figure('NumberTitle', 'off', 'Name', 'IR2');
subplot(2,1,1);
impulse(sys)
title('Time domain impulse response with LSE method', 'Interpreter', 'Latex');
xlabel('time', 'Interpreter', 'Latex');
ylabel('impulse response', 'Interpreter', 'Latex');
subplot(2,1,2);
[h,w] = freqz(h_lse', [1 zeros(1,L-1)],dftsize, fs);
plot(w,20*log10(abs(h)))
title('Frequency response with LSE method', 'Interpreter', 'Latex');
xlabel('frequency[Hz]', 'Interpreter', 'Latex');
ylabel('magnitude (dB)', 'Interpreter', 'Latex');

if storeData
    save('signalIR2Tx', 'simin');  
    save('signalIR2Rx', 'record');
end