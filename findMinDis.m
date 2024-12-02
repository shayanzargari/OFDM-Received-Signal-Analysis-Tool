function nearestSym = findMinDis(receivedValue, symSet)
% findMinDis - Finds the nearest symbol in the constellation set.
%
% This function calculates the nearest symbol in the given constellation
% set for a provided received signal value using the minimum distance
% criterion to find the closest symbol.
%
% Inputs:
%   receivedValue - Scalar representing the received signal value.
%   symSet        - Vector of possible constellation symbols [1xM].
%
% Outputs:
%   nearestSym    - Scalar representing the nearest symbol in the constellation.
%
% Example:
%   receivedValue = 1.2 + 0.3j;
%   symSet = [-1-1j, -1+1j, 1-1j, 1+1j];
%   nearestSym = findMinDis(receivedValue, symSet);
%   disp('Nearest Symbol:'), disp(nearestSym);
%
% Author: Shayan Zargari
% Date: 2024-09-28
% Version: 2.0

%% Input Validation
validateInput(receivedValue, symSet);

%% Find the Index of the Nearest Symbol
[~, idx] = min(abs(receivedValue - symSet));

%% Retrieve the Nearest Symbol
nearestSym = symSet(idx);

end

%% Helper Functions
function validateInput(receivedValue, symSet)
% validateInput Validates the inputs for finding the nearest symbol.
validateattributes(receivedValue, {'numeric'}, {'scalar'}, mfilename, 'receivedValue');
validateattributes(symSet, {'numeric'}, {'vector', 'nonempty'}, mfilename, 'symSet');
end
