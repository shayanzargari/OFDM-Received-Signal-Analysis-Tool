function [pskSyms, pskSymSet] = mapToPSKSyms(dataSymbols, modOrder, phaseOffset)
% mapToPSKSyms - Maps data symbols to PSK constellation points or returns PSK symbol set.
%
% Description:
%   This function generates the Phase Shift Keying (PSK) symbol set based on the specified 
%   modulation order and phase offset. If the input data symbols are provided, it maps 
%   the input data symbols to the corresponding PSK constellation points. If the input 
%   data symbols are not provided, it returns only the PSK symbol set.
%
% Inputs:
%   dataSymbols - (Optional) Vector containing data symbols to be modulated [1xN].
%   modOrder    - Scalar representing the order of PSK modulation [1x1].
%   phaseOffset - Scalar specifying the phase offset in radians [1x1].
%
% Outputs:
%   pskSyms     - (Optional) Vector of PSK modulated symbols [1xN].
%   pskSymSet   - Vector of possible PSK symbols [1xM], where M = modOrder.
%
% Example 1:
%   % When dataSymbols is provided:
%   dataSymbols = [0 1 2 3]; % Data symbols for 4-PSK
%   modOrder = 4;
%   phaseOffset = 0;
%   [pskSyms, pskSymSet] = mapToPSKSyms(dataSymbols, modOrder, phaseOffset);
%   disp('PSK Symbols:'), disp(pskSyms);
%   disp('PSK Symbol Set:'), disp(pskSymSet);
%
% Example 2:
%   % When dataSymbols is not provided:
%   modOrder = 4;
%   phaseOffset = 0;
%   [~, pskSymSet] = mapToPSKSyms([], modOrder, phaseOffset);
%   disp('PSK Symbol Set:'), disp(pskSymSet);
%
% Author: Shayan Zargari
% Date: 2024-08-15
% Version: 1.2

% Generate PSK symbol set
pskSymSet = exp(1i * (2 * pi * (0:modOrder-1) / modOrder + phaseOffset));

% Map data symbols to PSK symbols if provided
if nargin > 0 && ~isempty(dataSymbols)
    pskSyms = pskSymSet(dataSymbols + 1);
else
    pskSyms = []; % Return empty if dataSymbols is not provided
end

end
