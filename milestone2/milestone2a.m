clear all

% Set constellation size, data sequence length and SNR
len = factorial(6)*100; % factorial(6) = 720
normalize = true; % !if put to false to check difference in BER, also remove 'measured' some lines below  
SNR = linspace(-10, 15, 10);
M = 1:6;

% generate pseudo random binary sequence of length L
dataIn = randi([0 1], len,1);

b = zeros(5, 6);
for m = 1:length(M)
    for s = 1:length(SNR)
        % Tx: modulate signals
        dataMod = qam_mod(dataIn, 2.^m);
        dataModNoise = awgn(dataMod, SNR(s), 'measured');
        %avgPower = mean(abs(dataMod).^2)

        % Rx: demodulate QAM symbol sequence
        dataDemodNoise = qam_demod(dataModNoise, 2.^m);
        b(s, m) = ber(dataIn, dataDemodNoise);
    end
end
figure('NumberTitle', 'off', 'Name', 'Milestone2a');
semilogy(SNR,b, 'x-');
grid on
legend('2 QAM', '4 QAM', '8 QAM', '16 QAM', '32 QAM', '64 QAM', 'Interpreter', 'Latex', 'Location', 'best');
xlabel('SNR [dB]', 'Interpreter', 'Latex')
ylabel('Bit Error Rate', 'Interpreter', 'Latex')
title('BER vs SNR', 'Interpreter', 'Latex')