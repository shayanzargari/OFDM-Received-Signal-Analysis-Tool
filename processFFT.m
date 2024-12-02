function fftOutput = processFFT(inputSignal, NFFT, numActiveSC)
% processFFT - Applies FFT processing, normalization, and FFT shift to the input signal.
%
% Inputs:
%   inputSignal - Input signal (e.g., OFDM symbols without cyclic prefix).
%   NFFT        - FFT size (number of samples per OFDM symbol).
%   numActiveSC - Number of occupied subcarriers in the OFDM signal.
%
% Outputs:
%   fftOutput   - Processed FFT output with normalization and reordering.

%% Validate inputs
validateProcessFFTInputs(inputSignal, NFFT, numActiveSC);

%% Apply FFT along the first dimension
fftOutput = fft(inputSignal, NFFT, 1);

%% Normalize the FFT output
fftOutput = fftOutput ./ (NFFT / sqrt(numActiveSC));

%% Apply FFT shift for proper subcarrier ordering
fftOutput = [fftOutput(NFFT/2 + 1:NFFT, :, :); fftOutput(1:NFFT/2, :, :)];
end

function validateProcessFFTInputs(inputSignal, NFFT, numActiveSC)
% Check the number of inputs
if nargin < 3
    error('All inputs (inputSignal, NFFT, numActiveSC) are required.');
end
% Validate inputSignal (must be 2D or 3D array)
if ~ismatrix(inputSignal) && ~ndims(inputSignal) == 3
    error('inputSignal must be a 2D or 3D array.');
end
% Validate NFFT (positive scalar, divisible by 2)
if ~isscalar(NFFT) || NFFT <= 0 || mod(NFFT, 2) ~= 0
    error('NFFT must be a positive scalar and divisible by 2.');
end
% Validate numActiveSC (positive scalar, less than or equal to NFFT)
if ~isscalar(numActiveSC) || numActiveSC <= 0 || numActiveSC > NFFT
    error('numActiveSC must be a positive scalar less than or equal to NFFT.');
end
% Validate inputSignal size (first dimension should match NFFT)
if size(inputSignal, 1) ~= NFFT
    error('The first dimension of inputSignal must match NFFT.');
end
end
