clc;
clear;
close all;

%% PARAMETERS
N = 10000;              % Number of bits (must be even)
EbN0_dB = 0:2:12;       % Eb/N0 range
BER = zeros(size(EbN0_dB));

%% TRANSMITTER
data = randi([0 1], 1, N);     % Random binary data

% Serial to Parallel (2 bits per symbol)
data_I = data(1:2:end);
data_Q = data(2:2:end);

% QPSK Mapping
I = 2*data_I - 1;
Q = 2*data_Q - 1;

% QPSK Signal (complex baseband)
qpsk_signal = (I + 1j*Q) / sqrt(2);

%% CHANNEL + RECEIVER
for i = 1:length(EbN0_dB)

    EbN0 = 10^(EbN0_dB(i)/10);
    noise_variance = 1/(2*EbN0);

    % AWGN Noise
    noise = sqrt(noise_variance) * ...
            (randn(1,length(qpsk_signal)) + ...
             1j*randn(1,length(qpsk_signal)));

    % Received Signal
    received_signal = qpsk_signal + noise;

    % Demodulation
    received_I = real(received_signal) > 0;
    received_Q = imag(received_signal) > 0;

    % Parallel to Serial
    received_data = zeros(1,N);
    received_data(1:2:end) = received_I;
    received_data(2:2:end) = received_Q;

    % BER Calculation
    BER(i) = sum(data ~= received_data) / N;
end

%% PLOTS

% Constellation Diagram
figure;
plot(real(qpsk_signal), imag(qpsk_signal), 'o');
title('QPSK Constellation Diagram');
xlabel('In-phase');
ylabel('Quadrature');
grid on;

% Received Constellation
figure;
plot(real(received_signal), imag(received_signal), '.');
title('Received QPSK Signal (with Noise)');
xlabel('In-phase');
ylabel('Quadrature');
grid on;

% BER Curve
figure;
semilogy(EbN0_dB, BER, '-o');
title('BER vs Eb/N0 for QPSK');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate');
grid on;
