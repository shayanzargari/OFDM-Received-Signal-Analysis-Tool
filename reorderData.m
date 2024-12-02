function outputSignal = reorderData(fftOutput, NFFT, numActiveSC, numOFDMSymbols)
% reorderData - Packs data, removes virtual subcarriers, and reorders FFT output.
%
% Inputs:
%   fftOutput        - FFT output signal (NFFT x numOFDMSymbols matrix or 3D array).
%   NFFT             - FFT size (total number of subcarriers).
%   numActiveSC      - Number of occupied subcarriers (active data subcarriers).
%   numOFDMSymbols   - Number of OFDM symbols in the input.
%
% Outputs:
%   outputSignal     - Reordered and packed signal with only occupied subcarriers.
%
% Example:
%   outputSignal = reorderData(fftOutput, 256, 200, numOFDMSymbols);

% Validate inputs
validateReorderDataInputs(fftOutput, NFFT, numActiveSC, numOFDMSymbols);

% Preallocate output signal
outputSignal = zeros(numActiveSC, numOFDMSymbols);

% Extract lower half of occupied subcarriers
lowerHalfStart = NFFT / 2 - ceil(numActiveSC / 2) + 1;
lowerHalfEnd = NFFT / 2;
outputSignal(1:ceil(numActiveSC / 2), :, :) = fftOutput(lowerHalfStart:lowerHalfEnd, :, :);

% Extract upper half of occupied subcarriers
upperHalfStart = NFFT / 2 + 2;
upperHalfEnd = NFFT / 2 + 1 + floor(numActiveSC / 2) ;
outputSignal((ceil(numActiveSC / 2) + 1):numActiveSC, :, :) = fftOutput(upperHalfStart:upperHalfEnd, :, :);
end

function validateReorderDataInputs(fftOutput, NFFT, numActiveSC, numOFDMSymbols)
% Validate number of inputs
if nargin < 4
    error('All inputs (fftOutput, NFFT, numActiveSC, numOFDMSymbols) are required.');
end
% Validate fftOutput dimensions
if ~ismatrix(fftOutput) && ndims(fftOutput) ~= 3
    error('fftOutput must be a 2D or 3D array.');
end
if size(fftOutput, 1) ~= NFFT
    error('fftOutput must have NFFT rows.');
end
% Validate NFFT (positive scalar)
if ~isscalar(NFFT) || NFFT <= 0
    error('NFFT must be a positive scalar.');
end
% Validate numActiveSC (positive scalar less than or equal to NFFT)
if ~isscalar(numActiveSC) || numActiveSC <= 0 || numActiveSC > NFFT
    error('numActiveSC must be a positive scalar and less than or equal to NFFT.');
end
% Validate numOFDMSymbols (positive scalar matching fftOutput dimensions)
if ~isscalar(numOFDMSymbols) || numOFDMSymbols <= 0
    error('numOFDMSymbols must be a positive scalar.');
end
end

