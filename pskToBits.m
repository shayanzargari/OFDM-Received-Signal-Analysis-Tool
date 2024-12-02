function dataBits = pskToBits(pskSymbols, modOrder, phaseOffset, symOrder)
% pskToBits - Maps PSK symbols back to the corresponding bit sequences.
%
% Description:
%   This function demodulates PSK symbols by mapping each symbol back to the 
%   corresponding bit sequence based on the modulation order (modOrder), phase offset,
%   and symbol mapping order (Gray or natural).
%
% Inputs:
%   pskSymbols  - Vector of PSK modulated symbols [1xN].
%   modOrder    - Scalar representing the order of PSK modulation [1x1].
%   phaseOffset - Scalar specifying the phase offset in radians [1x1].
%   symOrder    - String specifying the symbol order ('gray' or 'natural').
%
% Outputs:
%   dataBits    - Vector containing the demodulated bits corresponding to the input PSK symbols [1xN*log2(modOrder)].
%
% Example:
%   modOrder = 4;
%   phaseOffset = 0;
%   symOrder = 'gray';
%   pskSymbols = exp(1i * (2 * pi * [0 1 2 3] / modOrder)); % Example 4-PSK symbols
%   dataBits = pskToBits(pskSymbols, modOrder, phaseOffset, symOrder);
%   disp('Data Bits:'), disp(dataBits);
%
% Author: Shayan Zargari
% Date: 22-Sep-2024
% Version: 1.1

% Validate Inputs
validateInputs(pskSymbols, modOrder, symOrder);

% Generate PSK symbol set
pskSymSet = generatePSKSymSet(modOrder, phaseOffset);

% Generate Gray mapping if needed
if strcmpi(symOrder, 'gray')
    grayMapping = binaryToGray(0:modOrder-1);
else
    grayMapping = 0:modOrder-1; % Natural order
end

% Find closest symbols and map them to bits
numBitsPerSymbol = log2(modOrder);
dataBits = zeros(1, length(pskSymbols) * numBitsPerSymbol);

for i = 1:length(pskSymbols)
    % Find the index of the closest PSK symbol
    [~, closestIdx] = min(abs(pskSymbols(i) - pskSymSet));
    
    % Map the index to the corresponding bit pattern (Gray or Natural)
    symbolIndex = grayMapping(closestIdx);
    
    % Convert the index to binary and map to bits
    binaryBits = de2bi(symbolIndex, numBitsPerSymbol, 'left-msb');
    
    % Store the resulting bits
    dataBits((i-1) * numBitsPerSymbol + 1:i * numBitsPerSymbol) = binaryBits;
end

end

% Generate PSK symbol set function
function pskSymSet = generatePSKSymSet(modOrder, phaseOffset)
% generatePSKSymSet - Generate the PSK constellation points based on the modulation order and phase offset.
    pskSymSet = exp(1i * (2 * pi * (0:modOrder-1) / modOrder + phaseOffset));
end

% Input validation function
function validateInputs(pskSymbols, modOrder, symOrder)
% validateInputs - Validate the inputs to pskToBits function.
    if ~isvector(pskSymbols)
        error('pskSymbols must be a vector.');
    end
    if mod(log2(modOrder), 1) ~= 0
        error('modOrder must be a power of 2.');
    end
    if ~ismember(lower(symOrder), {'gray', 'natural'})
        error('symOrder must be ''gray'' or ''natural''.');
    end
end

% Binary to Gray code conversion function
function grayCode = binaryToGray(binaryValues)
% binaryToGray - Convert binary numbers to Gray code.
    grayCode = bitxor(binaryValues, bitshift(binaryValues, -1));
end
