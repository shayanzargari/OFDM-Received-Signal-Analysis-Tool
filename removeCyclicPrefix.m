function tempSignal = removeCyclicPrefix(rxSignal, cpLength, NFFT, numOFDMSymbols)
% removeCyclicPrefix - Removes the cyclic prefix from the received signal.

validateOFDMSignalInputs(rxSignal, cpLength, NFFT, numOFDMSymbols);

cpLength = round(cpLength);

tempSignal = zeros(NFFT, numOFDMSymbols);

for k = 1:numOFDMSymbols
    startIdx = (k - 1) * (NFFT + cpLength) + cpLength + 1;
    endIdx = startIdx + NFFT - 1;

    if endIdx > length(rxSignal)
        error('Signal length is insufficient for the estimated OFDM parameters.');
    end

    tempSignal(:, k) = rxSignal(startIdx:endIdx);
end
end

function validateOFDMSignalInputs(rxSignal, cpLength, NFFT, numOFDMSymbols)
if nargin < 4
    error('All inputs (rxSignal, cpLength, NFFT, numOFDMSymbols) are required.');
end

if ~isvector(rxSignal)
    error('rxSignal must be a 1D array.');
end

if ~isscalar(cpLength) || cpLength < 0
    error('cpLength must be a non-negative scalar.');
end

if ~isscalar(NFFT) || NFFT <= 0
    error('NFFT must be a positive scalar.');
end

if ~isscalar(numOFDMSymbols) || numOFDMSymbols <= 0
    error('numOFDMSymbols must be a positive scalar.');
end
end
