function tempSignal = removeCyclicPrefix(rxSignal, cpLength, NFFT, numOFDMSymbols)
% removeCyclicPrefix - Removes the cyclic prefix from the received signal.
%
% Inputs:
%   rxSignal       - Received OFDM signal (1D array).
%   cpLength       - Length of the cyclic prefix (in samples).
%   NFFT           - FFT size.
%   numOFDMSymbols - Number of OFDM symbols in the signal
%
% Outputs:
%   tempSignal     - OFDM symbols without the cyclic prefix.
%

% Validate inputs
validateOFDMSignalInputs(rxSignal, cpLength, NFFT, numOFDMSymbols);

% Initialize output (no CP considered)
tempSignal = zeros(NFFT, numOFDMSymbols);

% Remove cyclic prefix for each OFDM symbol
for k = 1:numOFDMSymbols
    % Starting index of the current symbol
    startIdx = (k-1) * (NFFT + cpLength) + cpLength + 1;

    % Ending index of the current symbol
    endIdx = startIdx + NFFT - 1;

    % Extract the symbol without CP
    tempSignal(:, k) = rxSignal(startIdx:endIdx);
end

end

function validateOFDMSignalInputs(rxSignal, cpLength, NFFT, numOFDMSymbols)
% Check the number of inputs
if nargin < 4
    error('All inputs (rxSignal, cpLength, NFFT, numOFDMSymbols) are required.');
end
% Validate rxSignal (must be a 1D array)
if ~isvector(rxSignal)
    error('rxSignal must be a 1D array.');
end
% Validate cpLength (non-negative scalar)
if ~isscalar(cpLength) || cpLength < 0
    error('cpLength must be a non-negative scalar.');
end
% Validate NFFT (positive scalar)
if ~isscalar(NFFT) || NFFT <= 0
    error('NFFT must be a positive scalar.');
end
% Validate numOFDMSymbols (positive scalar)
if ~isscalar(numOFDMSymbols) || numOFDMSymbols <= 0
    error('numOFDMSymbols must be a positive scalar.');
end
end

