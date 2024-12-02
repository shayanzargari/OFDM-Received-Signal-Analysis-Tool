function scSpacing = estSubSpc(psd, freqBins, method)
% estSubSpc Estimates subcarrier spacing from PSD.
%
% Inputs:
%   psd       - Power spectral density (vector)
%   freqBins  - Frequency bins corresponding to the PSD (vector)
%   method    - Method for spacing estimation ('mean' or 'kmeans')
%
% Outputs:
%   scSpacing - Estimated subcarrier spacing (Hz)

% Validate inputs
validateSCInputs(psd, freqBins, method);

% Normalize PSD for peak detection
psdNormalized = abs(psd) / max(abs(psd));

% Detect peaks in the PSD
[~, locs] = findpeaks(psdNormalized, 'MinPeakHeight', 0.1, 'MinPeakDistance', 10);

% Extract frequencies corresponding to the peaks
peakFreqs = freqBins(locs);

% Calculate pairwise frequency differences
peakDiffs = abs(diff(sort(peakFreqs)));

% Estimate subcarrier spacing based on the selected method
switch lower(method)
    case 'kmeans'
        % Use k-means clustering to find dominant frequency spacing
        [~, clusterCenters] = kmeans(peakDiffs(:), 2, 'Replicates', 5);
        scSpacing = min(clusterCenters); % Choose the smaller cluster center

    case 'mean'
        % Use the mean of pairwise frequency differences
        scSpacing = mean(peakDiffs);

    otherwise
        error("Unsupported method. Use 'mean' or 'kmeans'.");
end

% Ensure the spacing is positive and reasonable
if isempty(scSpacing) || scSpacing <= 0
    error('Failed to estimate subcarrier spacing.');
end
end

function validateSCInputs(psd, freqBins, method)
% Check the number of inputs
if nargin < 3
    error('All inputs (psd, freqBins, method) are required.');
end
% Check if psd and freqBins are vectors
if ~isvector(psd) || ~isvector(freqBins)
    error('Inputs psd and freqBins must be vectors.');
end
% Check if psd and freqBins have the same length
if length(psd) ~= length(freqBins)
    error('Inputs psd and freqBins must have the same length.');
end
% Validate method
if ~ischar(method) || ~ismember(lower(method), {'mean', 'kmeans'})
    error("Method must be 'mean' or 'kmeans'.");
end
end
