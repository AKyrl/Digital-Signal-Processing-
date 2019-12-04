function [sig_pad, P] = extend(sig, m)

L = length(sig);
P = ceil(L/m); % Number of packets
sig_pad = [sig; zeros(m*P - L, 1)];
end