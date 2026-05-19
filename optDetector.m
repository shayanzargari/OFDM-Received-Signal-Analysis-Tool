function [receivedSyms, receivedBits, LLR] = optDetector(receivedSig, modOrder, modType, phaseOffset, softFlag, noiseVar, symOrder)
% optDetector - Performs hard or soft detection for PSK and QAM symbols.
%
% Inputs:
%   receivedSig - Vector of received signal values.
%   modOrder    - Modulation order.
%   modType     - Modulation type: 'PSK' or 'QAM'.
%   phaseOffset - Phase offset in radians for PSK.
%   softFlag    - Detection type: 'hard' or 'soft'.
%   noiseVar    - Noise variance for soft demodulation.
%   symOrder    - Symbol order: 'gray' or 'natural'.
%
% Outputs:
%   receivedSyms - Detected constellation symbols for hard detection.
%   receivedBits - Detected bits for hard detection.
%   LLR          - Log-likelihood ratios for soft detection.

validateInput(receivedSig, modOrder, modType, phaseOffset, softFlag, symOrder);

receivedSyms = zeros(size(receivedSig));
receivedBits = [];
LLR = [];

switch lower(modType)
    case 'psk'
        [~, symSet] = mapToPSKSyms([], modOrder, phaseOffset);

    case 'qam'
        [~, symSet] = mapToQAMSyms([], modOrder);

    otherwise
        error('Invalid modulation type. Supported options are ''PSK'' and ''QAM''.');
end

switch lower(softFlag)
    case 'hard'
        for i = 1:length(receivedSig)
            receivedSyms(i) = findMinDis(receivedSig(i), symSet);
        end
        receivedBits = symToBits(receivedSyms, modOrder, phaseOffset, symOrder, modType);

    case 'soft'
        if nargin < 6 || isempty(noiseVar) || noiseVar <= 0
            error('A positive noise variance is required for soft detection.');
        end
        LLR = softDemod(receivedSig, modOrder, symSet, noiseVar, symOrder);

    otherwise
        error('Invalid softFlag. Supported options are ''hard'' and ''soft''.');
end
end

function validateInput(receivedSig, modOrder, modType, phaseOffset, softFlag, symOrder)
validateattributes(receivedSig, {'numeric'}, {'vector', 'nonempty'}, mfilename, 'receivedSig');
validateattributes(modOrder, {'numeric'}, {'scalar', 'positive', 'integer'}, mfilename, 'modOrder');
validateattributes(modType, {'char', 'string'}, {'nonempty'}, mfilename, 'modType');
validateattributes(phaseOffset, {'numeric'}, {'scalar'}, mfilename, 'phaseOffset');
validatestring(char(softFlag), {'hard', 'soft'}, mfilename, 'softFlag');
validatestring(char(symOrder), {'gray', 'natural'}, mfilename, 'symOrder');
end
