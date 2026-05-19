function [cpLength, numOFDMSymbols] = calOFDMSymParams(param, RxSignal, NFFT, peakLags)
% calOFDMSymParams Estimates cyclic prefix length and OFDM symbol count.

validatePeakLagInputs(RxSignal, NFFT, peakLags);

positiveLags = peakLags(peakLags > 0);

if isempty(positiveLags)
    error('No valid positive autocorrelation lags were detected.');
end

numOFDMSymbols = max(length(positiveLags), 1);

estimatedSymbolLength = length(RxSignal) / numOFDMSymbols;
cpLength = round(estimatedSymbolLength - NFFT);

if cpLength < 0
    error('Estimated cyclic prefix length is negative.');
end

if cpLength >= NFFT
    error('Estimated cyclic prefix length is larger than or equal to NFFT.');
end
end

function validatePeakLagInputs(RxSignal, NFFT, peakLags)
if nargin < 3
    error('All inputs (RxSignal, NFFT, peakLags) are required.');
end

if ~isvector(RxSignal) || isempty(RxSignal)
    error('RxSignal must be a non-empty vector.');
end

if ~isvector(peakLags) || isempty(peakLags)
    error('peakLags must be a non-empty vector.');
end

if ~isscalar(NFFT) || ~isnumeric(NFFT) || NFFT <= 0
    error('NFFT must be a positive scalar.');
end
end
