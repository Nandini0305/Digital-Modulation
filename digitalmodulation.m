clc;
clear;
close all;

%% PARAMETERS
N = 10000;          % Number of bits
EbN0_dB = 0:2:12;   % Eb/N0 range in dB
BER = zeros(size(EbN0_dB));

%% TRANSMITTER
data = randi([0 1], 1, N);     % Random binary data

% BPSK Modulation (0 -> -1, 1 -> +1)
bpsk_signal = 2*data - 1;

%% CHANNEL + RECEIVER
for i = 1:length(EbN0_dB)
    
    EbN0 = 10^(EbN0_dB(i)/10);
    noise_variance = 1/(2*EbN0);
    
    % AWGN Noise
    noise = sqrt(noise_variance) * randn(1, N);
    
    % Received signal
    received_signal = bpsk_signal + noise;
    
    % BPSK Demodulation
    received_data = received_signal > 0;
    
    % BER Calculation
    BER(i) = sum(data ~= received_data) / N;
end

%% PLOTS

% Transmitted bits
figure;
stem(data(1:50), 'filled');
title('Transmitted Binary Data');
xlabel('Bit Index');
ylabel('Bit Value');
grid on;

% BPSK Signal
figure;
stem(bpsk_signal(1:50), 'filled');
title('BPSK Modulated Signal');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% Received Signal
figure;
plot(received_signal(1:200));
title('Received Signal with Noise');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% BER Curve
figure;
semilogy(EbN0_dB, BER, '-o');
title('BER vs Eb/N0 for BPSK');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate');
grid on;
