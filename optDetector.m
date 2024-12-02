function [receivedSyms, receivedBits, LLR] = optDetector(receivedSig, modOrder, modType, phaseOffset, softFlag, noiseVar, symOrder)
% optDetector - Maps downsampled signals to the nearest constellation points or performs soft demodulation.
%
% This function maps the downsampled signal to the nearest constellation points for 
% PAM, PSK, or QAM modulations. If softFlag is true, it performs soft demodulation
% using LLR calculations.
%
% Inputs:
%   receivedSig    - Vector of received signal values [1xN].
%   modOrder       - Scalar representing the order of modulation [1x1].
%   modType        - String specifying the modulation type ('PAM', 'PSK', 'QAM').
%   phaseOffset    - Scalar specifying the phase offset in radians [1x1] (only used for PSK).
%   softFlag       - Boolean flag to enable soft demodulation (true/false).
%   noiseVar       - Noise variance for LLR calculation (required for soft demodulation).
%   symOrder       - String specifying the symbol order ('gray' or 'natural').
%
% Outputs:
%   receivedSyms   - Vector of received symbols mapped to the nearest constellation points.
%   receivedBits   - Vector of received bits fro hard decision.
%   LLR            - Log-likelihood ratios for each bit (only if soft demodulation is enabled).
%
% Example:
%   % Example for QAM modulation (soft demodulation)
%   receivedSig = [1+1j, -1+1j, -1-1j, 1-1j];
%   modOrder = 16;
%   modType = 'QAM';
%   phaseOffset = 0; % Not used for QAM
%   softFlag = true;
%   noiseVar = 0.1; % Noise variance
%   [receivedSyms, LLR] = optDetector(receivedSig, modOrder, modType, phaseOffset, softFlag, noiseVar);
%   disp('Received QAM Symbols:'), disp(receivedSyms);
%
% Author: Shayan Zargari
% Date: 2024-10-07
% Version: 3.1

%% Input Validation
validateInput(receivedSig, modOrder, modType, phaseOffset);

%% Initialize the Received Symbols and LLR
receivedSyms = zeros(size(receivedSig));
LLR = [];

%% Generate Symbol Set Based on Modulation Type
switch lower(modType)
    case 'pam'
        [~, symSet] = mapToPAMSyms([], modOrder);
        
    case 'psk'
        [~, symSet] = mapToPSKSyms([], modOrder, phaseOffset);
        
    case 'qam'
        [~, symSet] = mapToQAMSyms([], modOrder);

    otherwise
        error('Invalid modulation type. Choose ''PAM'', ''PSK'', or ''QAM''.');
end

%% Perform Hard or Soft Demodulation
switch lower(softFlag)
    case 'hard'
        % Hard demodulation: Map received signal values to the nearest symbol
        for i = 1:length(receivedSig)
            receivedSyms(i) = findMinDis(receivedSig(i), symSet);
        end
        % Convert Received Symbols to Bits
        receivedBits = symToBits(receivedSyms, modOrder, phaseOffset, symOrder, modType);
    case 'soft'
        % Soft demodulation: Calculate the LLR based on noise variance
        LLR = softDemod(receivedSig, modOrder, symSet, noiseVar, symOrder);
        receivedBits = [];
end


end

%% Helper Functions
function validateInput(receivedSig, modOrder, modType, phaseOffset)
% validateInput Validates the inputs for optimal detector function.
validateattributes(receivedSig, {'numeric'}, {'vector', 'nonempty'}, mfilename, 'receivedSig');
validateattributes(modOrder, {'numeric'}, {'scalar', 'positive', 'integer'}, mfilename, 'modOrder');
validateattributes(modType, {'char'}, {'nonempty'}, mfilename, 'modType');
validateattributes(phaseOffset, {'numeric'}, {'scalar'}, mfilename, 'phaseOffset');
end
