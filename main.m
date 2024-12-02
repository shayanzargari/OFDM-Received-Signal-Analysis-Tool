function [results, param] = main(RxSignal, param)
% main - Performs OFDM signal analysis and processing.
%
% Inputs:
%   RxSignal - The received OFDM signal (complex samples).
%   param    - Structure containing simulation parameters.
%
% Outputs:
%   results  - Structure containing simulation results (SNR, modulation type, order, etc.).
%   param    - Structure containing updated simulation parameters.

%% Step 1: Signal Analysis and Parameter Estimation
disp('------------------------------------------------------------');
disp('      Step 1: Signal Analysis and Parameter Estimation');
disp('------------------------------------------------------------');
disp('Performing signal analysis...');

% Estimate PSD, phase, and frequency bins
[psd, ~, freqBins] = freqAnalyzer(RxSignal, param.fs, param.transformType, length(RxSignal), param.plotFlag);

% Calculate signal bandwidth and valid frequency indices
param.signalBW = calSignalBW(psd, freqBins, param.thresholdFactor, param.bwType);

% Estimate subcarrier spacing
param.scSpacing = estSubSpc(psd, freqBins, param.scmethod);

% Determine FFT size and number of active subcarriers
[param.NFFT, param.numActiveSC, param.NominalBW] = calFFTSize(RxSignal, param.signalBW, param.fs, param.scSpacing);

% Perform autocorrelation analysis and normalize
[peakLags, ~, autoCorrNorm] = autoCorrAnalyze(RxSignal, param.peakThreshold, param.plotFlag);

% Calculate cyclic prefix length and number of OFDM symbols
[param.cpLength, param.numOFDMSymbols] = calOFDMSymParams(param, RxSignal, param.NFFT, peakLags);

disp('✔ Signal analysis and parameter estimation complete.');

%% Step 2: Cyclic Prefix Removal and FFT Processing
disp('------------------------------------------------------------');
disp('      Step 2: Cyclic Prefix Removal and FFT Processing');
disp('------------------------------------------------------------');
disp('Processing received signal...');

% Remove cyclic prefix
tempSignal = removeCyclicPrefix(RxSignal, param.cpLength, param.NFFT, param.numOFDMSymbols);

% Perform FFT on the signal
fftOutput = processFFT(tempSignal, param.NFFT, param.numActiveSC);

% Reorder data for processing
inputSignal = reorderData(fftOutput, param.NFFT, param.numActiveSC, param.numOFDMSymbols);

disp('✔ Signal processing complete.');

%% Step 3: SNR and Modulation Estimation
disp('------------------------------------------------------------');
disp('      Step 3: SNR and Modulation Estimation');
disp('------------------------------------------------------------');
disp('Estimating SNR and modulation parameters...');

% Estimate SNR and modulation parameters
[snrdB, modType, modOrder] = estSNRandModulation(inputSignal, autoCorrNorm, param.plotFlag);

disp('✔ SNR and modulation parameters estimated.');

%% Step 4: Symbol Detection
disp('------------------------------------------------------------');
disp('      Step 4: Symbol Detection');
disp('------------------------------------------------------------');
disp('Performing symbol detection...');

% Calculate noise variance for detection
varNoiseSoftDetection = 10 ^ (-snrdB / 10);

% Perform detection based on the chosen detection type (soft or hard)
if strcmp(param.softFlag, 'soft')
    % Perform soft detection to obtain Log-Likelihood Ratios (LLRs)
    [~, ~, LLR] = optDetector(inputSignal(:), modOrder, modType, ...
                               param.phaseOff, param.softFlag, ...
                               varNoiseSoftDetection, param.symOrder);
    disp('✔ Soft detection complete.');
else
    % Perform hard detection to recover symbols and bits
    [receivedSyms, receivedBits, ~] = optDetector(inputSignal(:), modOrder, modType, ...
                                                  param.phaseOff, param.softFlag, ...
                                                  varNoiseSoftDetection, param.symOrder);
    disp('✔ Hard detection complete.');
end

disp('✔ Symbol detection process completed successfully.');

%% Step 5: Display Results
disp('============================================================');
disp('                    OFDM Signal Analysis Results');
disp('============================================================');
fprintf('Estimated SNR:              %.2f dB\n', snrdB);
fprintf('Estimated Modulation Type:  %s\n', modType);
fprintf('Estimated Modulation Order: %d\n', modOrder);

if exist('receivedBits', 'var') && ~isempty(receivedBits)
    fprintf('Number of Received Bits:    %d\n', length(receivedBits));
end
if exist('LLR', 'var') && ~isempty(LLR)
    fprintf('Number of LLR Values:       %d\n', length(LLR));
end

%% Step 6: Prepare Results
results = struct();
results.snrdB = snrdB;
results.modType = modType;
results.modOrder = modOrder;

% Include detected symbols or LLR in results based on detection type
if strcmp(param.softFlag, 'soft')
    results.LLR = LLR;
else
    results.receivedSyms = receivedSyms;
    results.receivedBits = receivedBits;
end

disp('✔ Results preparation complete.');
disp('============================================================');

