function dataBits = pamToBits(pamSymbols, modOrder, symOrder)
% pamToBits - Maps PAM symbols back to the corresponding bit sequences.
%
% Description:
%   This function demodulates PAM symbols by mapping each symbol back to the 
%   corresponding bit sequence based on the modulation order (modOrder) and
%   symbol mapping order (Gray or natural).
%
% Inputs:
%   pamSymbols - Vector of PAM modulated symbols [1xN].
%   modOrder   - Scalar representing the order of PAM modulation [1x1].
%   symOrder   - String specifying the symbol order ('gray' or 'natural').
%
% Outputs:
%   dataBits   - Vector containing the demodulated bits corresponding to the input PAM symbols [1xN*log2(modOrder)].
%
% Example:
%   modOrder = 4;
%   symOrder = 'gray';
%   pamSymbols = [-3, -1, 1, 3]; % Example 4-PAM symbols
%   dataBits = pamToBits(pamSymbols, modOrder, symOrder);
%   disp('Data Bits:'), disp(dataBits);
%
% Author: Shayan Zargari
% Date: 22-Sep-2024
% Version: 1.1

% Validate Inputs
validateInputs(pamSymbols, modOrder, symOrder);

% Generate PAM symbol set
pamSymSet = -(modOrder-1):2:(modOrder-1);

% Generate Gray mapping if needed
if strcmpi(symOrder, 'gray')
    grayMapping = binaryToGray(0:modOrder-1);
else
    grayMapping = 0:modOrder-1; % Natural order
end

% Find closest symbols and map them to bits
numBitsPerSymbol = log2(modOrder);
dataBits = zeros(1, length(pamSymbols) * numBitsPerSymbol);

for i = 1:length(pamSymbols)
    % Find the index of the closest PAM symbol
    [~, closestIdx] = min(abs(pamSymbols(i) - pamSymSet));

    % Map the index to the corresponding bit pattern (Gray or Natural)
    symbolIndex = grayMapping(closestIdx);
    
    % Convert the index to binary and map to bits
    binaryBits = de2bi(symbolIndex, numBitsPerSymbol, 'left-msb');
    
    % Store the resulting bits
    dataBits((i-1) * numBitsPerSymbol + 1:i * numBitsPerSymbol) = binaryBits;
end

end

% Input validation function
function validateInputs(pamSymbols, modOrder, symOrder)
% validateInputs - Validate the inputs to pamToBits function.
    if ~isvector(pamSymbols)
        error('pamSymbols must be a vector.');
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
