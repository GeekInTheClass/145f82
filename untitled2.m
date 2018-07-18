% Initialize system parameters
Fs = 10000;     % Sample rate
Rs = 100;       % Symbol rate
sps = Fs/Rs;    % Samples per symbol
rolloff = 0.5;  % Rolloff factor
M = 4;          % Modulation order (QPSK)

% Square root raised cosine filters.
filterSpan = 6;
filterGainTx = 9.9121;
transmitFilter = comm.RaisedCosineTransmitFilter('RolloffFactor', rolloff, ...
    'OutputSamplesPerSymbol', sps, ...
    'FilterSpanInSymbols', filterSpan, ...
    'Gain', filterGainTx);
receiveFilter = comm.RaisedCosineReceiveFilter('RolloffFactor', rolloff, ...
    'InputSamplesPerSymbol', sps, ...
    'FilterSpanInSymbols', filterSpan, ...
    'DecimationFactor', 1, ...
    'Gain', 1/filterGainTx);


% Generate modulated and pulse shaped signal
frameLen = 1000;
message = randi([0 M-1], frameLen, 1);
modulated = pskmod(message, M, pi/4);
filteredTx = transmitFilter(modulated);

t = 0:1/Fs:50/Rs-1/Fs; idx = round(t*Fs+1);
hFig = figure; plot(t, real(filteredTx(idx)));
title('Modulated, filtered in-phase signal');
xlabel('Time (sec)');
ylabel('Amplitude');
grid on;

% Manage the figures
hFig.Position = [50 400 hFig.Position(3:4)];