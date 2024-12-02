function [qamSyms, qamSymSet] = mapToQAMSyms(dataSymbols, modOrder)
% mapToQAMSyms - Maps data symbols to QAM constellation points or returns QAM symbol set.
%
% Description:
%   This function generates the Quadrature Amplitude Modulation (QAM) symbol set based on 
%   the specified modulation order. If the input data symbols are provided, it maps the 
%   input data symbols to the corresponding QAM constellation points. If the input data 
%   symbols are not provided, it returns only the QAM symbol set.
%
% Inputs:
%   dataSymbols - (Optional) Vector containing data symbols to be modulated [1xN].
%   modOrder    - Scalar representing the order of QAM modulation [1x1].
%
% Outputs:
%   qamSyms     - (Optional) Vector of QAM modulated symbols [1xN].
%   qamSymSet   - Vector of possible QAM symbols [1xM], where M = modOrder.
%
% Example 1:
%   % When dataSymbols is provided:
%   dataSymbols = [0 1 2 3]; % Data symbols for 4-QAM
%   modOrder = 4;
%   [qamSyms, qamSymSet] = mapToQAMSyms(dataSymbols, modOrder);
%   disp('QAM Symbols:'), disp(qamSyms);
%   disp('QAM Symbol Set:'), disp(qamSymSet);
%
% Example 2:
%   % When dataSymbols is not provided:
%   modOrder = 4;
%   [~, qamSymSet] = mapToQAMSyms([], modOrder);
%   disp('QAM Symbol Set:'), disp(qamSymSet);
%
% Author: Shayan Zargari
% Date: 2024-08-15
% Version: 1.2

% Generate QAM symbol set
m = sqrt(modOrder);  % Assuming modOrder is a perfect square

if mod(m, 1) ~= 0
    error('modOrder must be a perfect square.');
end

% Generate in-phase and quadrature components
I = repmat((-m+1):2:(m-1), m, 1);
Q = repmat((-m+1):2:(m-1), m, 1).';

% Create symbol set
qamSymSet = I(:).' + 1i * Q(:).';

% Map data symbols to QAM symbols if provided
if nargin > 0 && ~isempty(dataSymbols)
    qamSyms = qamSymSet(dataSymbols + 1);
else
    qamSyms = []; % Return empty if dataSymbols is not provided
end

end
