function llrValues = softDemod(receivedSymbols, modulationOrder, constellationSet, noiseVariance, symbolOrder)
% softDemodulate Performs soft demodulation on the received symbols.
%
% This function calculates the log-likelihood ratios (LLRs) for each bit
% based on the received symbols, modulation order, and symbol mapping 
% (Gray or natural coding).
%
% Inputs:
%   receivedSymbols - Vector of received symbols to be demodulated [1xN].
%   modulationOrder - Modulation order (e.g., 4 for 4-PAM, 4-PSK, 16-QAM).
%   constellationSet - Set of possible modulated symbols [1xM].
%   noiseVariance   - Noise variance for LLR calculation [1x1].
%   symbolOrder     - String specifying symbol mapping ('gray' or 'natural').
%
% Outputs:
%   llrValues       - Log-likelihood ratio (LLR) vector for each bit [1x(N * bitsPerSym)].
%
% Example:
%   receivedSymbols = [1+1i, -1-1i]; % Example received symbols
%   modulationOrder = 4; % 4-QAM
%   constellationSet = [-1-1i, -1+1i, 1-1i, 1+1i]; % Example symbol set for QAM
%   noiseVariance = 0.1; % Noise variance
%   symbolOrder = 'gray'; % Use Gray coding
%   llrValues = softDemodulate(receivedSymbols, modulationOrder, constellationSet, noiseVariance, symbolOrder);
%   disp('LLR Values:'); disp(llrValues);
%
% Author: Shayan Zargari
% Date: 2024-09-28
% Version: 2.0

%% Input Validation
validateSoftDemodInputs(receivedSymbols, modulationOrder, constellationSet, noiseVariance, symbolOrder);

%% Calculate Number of Bits per Symbol
bitsPerSymbol = log2(modulationOrder);

%% Initialize LLR Vector
llrValues = [];

%% Apply Gray Mapping if Required
if strcmpi(symbolOrder, 'gray')
    grayMapping = bin2gray(0:modulationOrder-1);
    constellationSet = constellationSet(grayMapping + 1); % Reorder based on Gray code
end

%% Compute LLRs for Each Received Symbol
for idx = 1:length(receivedSymbols)
    % Compute Euclidean distances from the received symbol to each constellation point
    distances = abs(receivedSymbols(idx) - constellationSet).^2;
    
    % Compute LLRs for each bit position
    for bitPosition = 1:bitsPerSymbol
        % Get indices for symbols with bit 0 and bit 1 at the current bit position
        bit0Idx = find(mod(floor((0:modulationOrder-1)/2^(bitsPerSymbol-bitPosition)), 2) == 0);
        bit1Idx = find(mod(floor((0:modulationOrder-1)/2^(bitsPerSymbol-bitPosition)), 2) == 1);
        
        % Calculate LLR for the current bit position
        llr = log(sum(exp(-distances(bit0Idx) / (2 * noiseVariance))) / sum(exp(-distances(bit1Idx) / (2 * noiseVariance))));
        
        % Append the LLR value for this bit
        llrValues = [llrValues, llr];
    end
end

end

%% Helper Functions
function validateSoftDemodInputs(receivedSymbols, modulationOrder, constellationSet, noiseVariance, symbolOrder)
% validateSoftDemodInputs Validates inputs for the soft demodulation function.
validateattributes(receivedSymbols, {'numeric'}, {'vector', 'nonempty'}, mfilename, 'receivedSymbols');
validateattributes(modulationOrder, {'numeric'}, {'scalar', 'positive', 'integer'}, mfilename, 'modulationOrder');
validateattributes(constellationSet, {'numeric'}, {'vector', 'nonempty'}, mfilename, 'constellationSet');
validateattributes(noiseVariance, {'numeric'}, {'scalar', 'positive'}, mfilename, 'noiseVariance');
validatestring(symbolOrder, {'gray', 'natural'}, mfilename, 'symbolOrder');
end