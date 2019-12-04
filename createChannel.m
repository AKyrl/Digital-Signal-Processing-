function [h, H] = createChannel(filename, N)
h = importdata(filename);
h = extend(h, N); % zero padding
H = fft(h, N);
end
