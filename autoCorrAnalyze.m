function [peakLags, peakValues, autoCorrNorm] = autoCorrAnalyze(RxSignal, peakThreshold, plotFlag)
% autoCorrAnalyze - Computes the autocorrelation of RxSignal,
% normalizes it, finds peaks, optionally plots the result, and estimates the number of OFDM symbols.
%
% Inputs:
%   RxSignal      - The received signal vector (1D array).
%   peakThreshold - The minimum normalized autocorrelation value to detect peaks (0 to 1).
%   plotFlag      - Boolean (true/false) to enable or disable plotting.
%
% Outputs:
%   peakLags       - Lags (samples) corresponding to detected peaks.
%   peakValues     - Normalized autocorrelation values at detected peaks.
%   autoCorrNorm   - Normalized autocorrelation.

%% Validate inputs
validateAutoCorrInputs(RxSignal, peakThreshold, plotFlag)

%% Compute autocorrelation
autoCorr = xcorr(RxSignal, RxSignal);

%% Normalize the autocorrelation
autoCorrNorm = abs(autoCorr) / max(abs(autoCorr)); % Normalize between 0 and 1

%% Create lag indices
lags = -(length(RxSignal)-1):(length(RxSignal)-1);

%% Find peaks above the threshold
[peakValues, peakIndices] = findpeaks(autoCorrNorm, 'MinPeakHeight', peakThreshold);

%% Convert indices to lags
peakLags = lags(peakIndices);

% Plot the autocorrelation with peaks marked (if enabled)
if plotFlag
    figure;
    plot(lags, autoCorrNorm, 'LineWidth', 2);
    hold on;
    plot(peakLags, peakValues, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Mark peaks
    xlabel('Lag (samples)');
    ylabel('Normalized Autocorrelation');
    title('Autocorrelation with Detected Peaks');
    grid on;
    legend('Autocorrelation', 'Detected Peaks');
    hold off;
end
end

function validateAutoCorrInputs(RxSignal, peakThreshold, plotFlag)
% Check number of inputs
if nargin < 3
    error('All inputs (RxSignal, peakThreshold, plotFlag) are required.');
end
% Validate RxSignal
if ~isvector(RxSignal) || isempty(RxSignal)
    error('RxSignal must be a non-empty 1D vector.');
end
% Validate peakThreshold
if ~isscalar(peakThreshold) || ~isnumeric(peakThreshold) || peakThreshold <= 0 || peakThreshold > 1
    error('peakThreshold must be a scalar numeric value in the range (0, 1].');
end
% Validate plotFlag
if ~islogical(plotFlag) && ~ismember(plotFlag, [0, 1])
    error('plotFlag must be a boolean (true/false).');
end
end
