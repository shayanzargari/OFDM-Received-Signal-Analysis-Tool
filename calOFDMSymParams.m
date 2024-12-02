function [cpLength, numOFDMSymbols] = calOFDMSymParams(param, RxSignal, NFFT, peakLags)
% calOFDMSymParams Estimates the cyclic prefix length and number of OFDM symbols.
%
% Inputs:
%   RxSignal      - Received OFDM signal (vector)
%   NFFT          - FFT size (scalar, number of subcarriers)
%   peakLags      - Lags corresponding to detected peaks (vector)
%
% Outputs:
%   cpLength      - Estimated cyclic prefix length (scalar)
%   numOFDMSymbols - Estimated number of OFDM symbols (scalar)

%% Validate inputs
validatePeakLagInputs(RxSignal, NFFT, peakLags);

%% Estimate the number of OFDM symbols
numOFDMSymbols = length(peakLags) - 1;

% % Calculate samples per symbol (useful part only, no CP)
% NSamplesSym = param.fs / param.scSpacing;
%
% % Estimate the number of symbols
% numOFDMSymbols = floor(length(RxSignal) / NSamplesSym)-1;

%% Calculate the cyclic prefix length
if numOFDMSymbols > 0
    cpLength = (length(RxSignal) / numOFDMSymbols) - NFFT;
else
    error('Number of OFDM symbols must be greater than zero.');
end

%% Ensure cpLength is non-negative
if cpLength < 0
    error('Estimated cyclic prefix length is negative!');
end

end

function validatePeakLagInputs(RxSignal, NFFT, peakLags)
% Check the number of inputs
if nargin < 3
    error('All inputs (RxSignal, NFFT, peakLags) are required.');
end
% Validate RxSignal and peakLags
if ~isvector(RxSignal) || isempty(RxSignal)
    error('RxSignal must be a non-empty vector.');
end
if ~isvector(peakLags) || isempty(peakLags)
    error('peakLags must be a non-empty vector.');
end
% Validate NFFT
if ~isscalar(NFFT) || ~isnumeric(NFFT) || NFFT <= 0
    error('NFFT must be a positive scalar.');
end
end

