function fftOutput = processFFT(inputSignal, NFFT, numActiveSC)
% processFFT - Applies FFT processing, normalization, and FFT shift.

validateProcessFFTInputs(inputSignal, NFFT, numActiveSC);

fftOutput = fft(inputSignal, NFFT, 1);
fftOutput = fftOutput ./ (NFFT / sqrt(numActiveSC));

halfFFT = NFFT / 2;
fftOutput = [fftOutput(halfFFT + 1:end, :, :); fftOutput(1:halfFFT, :, :)];
end

function validateProcessFFTInputs(inputSignal, NFFT, numActiveSC)
if nargin < 3
    error('All inputs (inputSignal, NFFT, numActiveSC) are required.');
end

if ~(ismatrix(inputSignal) || ndims(inputSignal) == 3)
    error('inputSignal must be a 2D or 3D array.');
end

if ~isscalar(NFFT) || NFFT <= 0 || mod(NFFT, 2) ~= 0
    error('NFFT must be a positive even scalar.');
end

if ~isscalar(numActiveSC) || numActiveSC <= 0 || numActiveSC > NFFT
    error('numActiveSC must be a positive scalar less than or equal to NFFT.');
end

if size(inputSignal, 1) ~= NFFT
    error('The first dimension of inputSignal must match NFFT.');
end
end
