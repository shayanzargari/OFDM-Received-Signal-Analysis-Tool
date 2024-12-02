function dataBits = qamToBits(qamSymbols, modOrder, symOrder)
% qamToBits - Maps QAM symbols back to the corresponding bit sequences.
%
% Description:
%   This function demodulates QAM symbols by mapping each symbol back to the 
%   corresponding bit sequence based on the modulation order (modOrder) and
%   symbol mapping order (Gray or natural).
%
% Inputs:
%   qamSymbols - Vector of QAM modulated symbols [1xN].
%   modOrder   - Scalar representing the order of QAM modulation [1x1].
%   symOrder   - String specifying the symbol order ('gray' or 'natural').
%
% Outputs:
%   dataBits   - Vector containing the demodulated bits corresponding to the input QAM symbols [1xN*log2(modOrder)].
%
% Example:
%   modOrder = 4;
%   symOrder = 'gray';
%   qamSymbols = [1+1i, -1+1i, -1-1i, 1-1i]; % Example 4-QAM symbols
%   dataBits = qamToBits(qamSymbols, modOrder, symOrder);
%   disp('Data Bits:'), disp(dataBits);
%
% Author: Shayan Zargari
% Date: 22-Sep-2024
% Version: 1.1

% Validate Inputs
validateInputs(qamSymbols, modOrder, symOrder);

% Generate QAM symbol set
qamSymSet = generateQAMSymSet(modOrder);

% Generate Gray mapping if needed
if strcmpi(symOrder, 'gray')
    grayMapping = binaryToGray(0:modOrder-1);
else
    grayMapping = 0:modOrder-1; % Natural order
end

% Find closest symbols and map them to bits
numBitsPerSymbol = log2(modOrder);
dataBits = zeros(1, length(qamSymbols) * numBitsPerSymbol);

for i = 1:length(qamSymbols)
    % Find the index of the closest QAM symbol
    [~, closestIdx] = min(abs(qamSymbols(i) - qamSymSet));

    % Map the index to the corresponding bit pattern (Gray or Natural)
    symbolIndex = grayMapping(closestIdx);
    
    % Convert the index to binary and map to bits
    binaryBits = de2bi(symbolIndex, numBitsPerSymbol, 'left-msb');
    
    % Store the resulting bits
    dataBits((i-1) * numBitsPerSymbol + 1:i * numBitsPerSymbol) = binaryBits;
end

end

% Generate QAM symbol set function
function qamSymSet = generateQAMSymSet(modOrder)
% generateQAMSymSet - Generate the QAM constellation points based on the modulation order.
    m = sqrt(modOrder); % Assuming modOrder is a perfect square
    I = repmat((-m+1):2:(m-1), m, 1); % In-phase components
    Q = repmat((-m+1):2:(m-1), m, 1).'; % Quadrature components
    qamSymSet = I(:).' + 1i * Q(:).'; % Create QAM symbol set
end

% Input validation function
function validateInputs(qamSymbols, modOrder, symOrder)
% validateInputs - Validate the inputs to qamToBits function.
    if ~isvector(qamSymbols)
        error('qamSymbols must be a vector.');
    end
    if mod(sqrt(modOrder), 1) ~= 0
        error('modOrder must be a perfect square.');
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
