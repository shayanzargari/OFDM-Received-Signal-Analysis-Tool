function [snr, modulation, modOrder] = estSNRandModulation(inputSignal, autocorrelationNorm, plotFlag)
% estSNRandModulation - Estimates SNR and infers the modulation scheme and order.
%
% Inputs:
%   inputSignal       - Received OFDM signal (complex, multi-dimensional).
%   autocorrelationNorm - Normalized autocorrelation of the input signal.
%   plotFlag          - Boolean (true/false) to enable or disable plotting.
%
% Outputs:
%   snr               - Estimated Signal-to-Noise Ratio (in dB).
%   modulation        - Modulation type ('PSK' or 'QAM').
%   modOrder          - Modulation order (e.g., 2 for BPSK, 4 for QPSK, etc.).

%% Validate Inputs
validateEstSNRandModulationInputs(inputSignal, autocorrelationNorm, plotFlag)

%% SNR Estimation
% Estimate the noise floor and signal peak from autocorrelation
noiseFloor = mean(autocorrelationNorm(autocorrelationNorm < 0.1)); % Noise floor
signalPeak = max(autocorrelationNorm); % Peak of the autocorrelation
snr = 10 * log10(signalPeak / noiseFloor); % Signal-to-noise ratio in dB

%% Flatten and Normalize Received Symbols
% Flatten the signal to 1D and normalize by the maximum amplitude
flattenedSignal = inputSignal(:);
normalizedSymbols = flattenedSignal / max(abs(flattenedSignal)); % Normalize amplitude

%% Filter Out Noise Contributions
% Remove low-amplitude symbols likely caused by noise
noiseThreshold = 0.05;
filteredSymbols = normalizedSymbols(abs(normalizedSymbols) > noiseThreshold);

%% Cluster Estimation
% Determine the number of distinct amplitude clusters
clusterPrecision = 1; % Adjust precision for rounding
numClusters = length(unique(round(abs(filteredSymbols), clusterPrecision))); % Count unique clusters

% Map the number of clusters to valid modulation types
validClusters = [1, 2, 4, 6]; % Standard modulation cluster counts
[~, idx] = min(abs(validClusters - numClusters)); % Find closest match
numClusters = validClusters(idx);

%% Determine Modulation Scheme and Order
% Use a switch-case statement for cluster mapping
switch numClusters
    case 1
        modulation = 'PSK'; modOrder = 2; % BPSK
    case 2
        modulation = 'PSK'; modOrder = 4; % QPSK
    case 4
        modulation = 'QAM'; modOrder = 16; % 16-QAM
    case 6
        modulation = 'QAM'; modOrder = 64; % 64-QAM
    otherwise
        modulation = 'Unknown'; modOrder = NaN; % Unknown modulation
end

%% Plot Constellation Diagram
if plotFlag
    figure;
    scatter(real(filteredSymbols), imag(filteredSymbols), 'filled');
    xlabel('In-Phase');
    ylabel('Quadrature');
    title(['Constellation Diagram (' modulation ', Order: ' num2str(modOrder) ')']);
    grid on;
end
end

function validateEstSNRandModulationInputs(inputSignal, autocorrelationNorm, plotFlag)
% Validate inputSignal (must be numeric and non-empty)
if ~isnumeric(inputSignal) || isempty(inputSignal)
    error('inputSignal must be a non-empty numeric array.');
end
% Validate autocorrelationNorm (must be numeric and non-empty)
if ~isnumeric(autocorrelationNorm) || isempty(autocorrelationNorm)
    error('autocorrelationNorm must be a non-empty numeric array.');
end
% Validate autocorrelationNorm as a vector
if ~isvector(autocorrelationNorm)
    error('autocorrelationNorm must be a 1D vector.');
end
% Validate inputSignal and autocorrelationNorm lengths
if numel(inputSignal) < numel(autocorrelationNorm)
    error('autocorrelationNorm must not exceed the length of inputSignal.');
end
% Validate plotFlag (must be logical)
if ~islogical(plotFlag)
    error('plotFlag must be a logical value (true or false).');
end
end
