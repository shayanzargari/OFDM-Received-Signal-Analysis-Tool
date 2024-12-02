function [signalBW, validIndices] = calSignalBW(psd, freqBins, thresholdFactor, bwType)
% calSignalBW Computes the signal bandwidth from the PSD.
%
% Inputs:
%   psd             - Power spectral density (vector)
%   freqBins        - Frequency bins corresponding to the PSD (vector)
%   thresholdFactor - Fraction of the maximum PSD to use as the threshold (scalar, e.g., 0.01)
%   bwType          - Type of bandwidth calculation ('threshold', '3dB', 'OBW')
%
% Outputs:
%   signalBW        - Computed signal bandwidth in Hz (scalar)
%   validIndices    - Indices of frequency bins where the PSD exceeds the threshold (vector)
%
% Example:
%   [signalBW, validIndices] = calSignalBW(psd, freqBins, 0.01, 'threshold');

%% Validate inputs
validateBWInputs(psd, freqBins, thresholdFactor, bwType);

%% Process PSD based on bwType
switch lower(bwType)
    case 'threshold'
        % Threshold-based calculation
        threshold = max(abs(psd)) * thresholdFactor;
        validIndices = find(abs(psd) > threshold);

    case '3db'
        % -3 dB bandwidth calculation
        psd_dB = 10 * log10(max(abs(psd), eps)); % Avoid log of zero
        maxPSD_dB = max(psd_dB);
        threshold_dB = maxPSD_dB - 3;
        validIndices = find(psd_dB > threshold_dB);

    case 'obw'
        % Occupied Bandwidth (OBW) calculation (e.g., 99% of total power)
        totalPower = trapz(freqBins, abs(psd)); % Total power using integration
        cumulativePower = cumtrapz(freqBins, abs(psd)); % Cumulative power
        lowerIdx = find(cumulativePower >= 0.1 * totalPower, 1, 'first'); % 1% lower
        upperIdx = find(cumulativePower >= 0.9  * totalPower, 1, 'first'); % 90% upper
        validIndices = lowerIdx:upperIdx;

    otherwise
        error("Invalid bwType. Use 'threshold', '3dB', or 'OBW'.");
end

%% Ensure significant signal exists
if isempty(validIndices)
    error('No significant signal detected in the PSD.');
end

%% Compute bandwidth
freqSubset = freqBins(validIndices); % Get valid frequencies
signalBW = max(freqSubset) - min(freqSubset);
end

function validateBWInputs(psd, freqBins, thresholdFactor, bwType)
% Check the number of inputs
if nargin < 4
    error('All inputs (psd, freqBins, thresholdFactor, bwType) are required.');
end
% Check if psd and freqBins are vectors
if ~isvector(psd) || ~isvector(freqBins)
    error('Inputs psd and freqBins must be vectors.');
end
% Check if psd and freqBins have the same length
if length(psd) ~= length(freqBins)
    error('psd and freqBins must have the same length.');
end
% Check thresholdFactor for threshold-based bandwidth calculation
if isempty(thresholdFactor) && strcmpi(bwType, 'threshold')
    error('thresholdFactor is required for threshold-based bandwidth calculation.');
end
% Validate thresholdFactor (if provided)
if ~isempty(thresholdFactor) && (~isnumeric(thresholdFactor) || thresholdFactor <= 0)
    error('thresholdFactor must be a positive scalar.');
end
% Validate bwType
if ~ischar(bwType) || ~ismember(lower(bwType), {'threshold', '3db', 'obw'})
    error("bwType must be one of 'threshold', '3dB', or 'OBW'.");
end
end
