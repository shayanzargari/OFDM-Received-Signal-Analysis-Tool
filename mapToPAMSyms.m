function [pamSyms, pamSymSet] = mapToPAMSyms(dataSyms, modOrder)
% mapToPAMSyms - Maps data symbols to PAM levels or returns PAM symbol set.
%
% Description:
%   This function generates the Pulse Amplitude Modulation (PAM) symbol set 
%   based on the specified modulation order. If the input data symbols are 
%   provided, it maps the input data symbols to the corresponding PAM levels.
%   If the input data symbols are not provided, it returns only the PAM symbol set.
%
% Inputs:
%   dataSyms  - (Optional) Vector containing data symbols to be modulated [1xN].
%   modOrder  - Scalar representing the order of PAM modulation [1x1].
%
% Outputs:
%   pamSyms   - (Optional) Vector of PAM modulated symbols [1xN].
%   pamSymSet - Vector of possible PAM symbols [1xM], where M = modOrder.
%
% Example 1:
%   % When dataSyms is provided:
%   dataSyms = [0 1 2 3]; % Data symbols for 4-PAM
%   modOrder = 4;
%   [pamSyms, pamSymSet] = mapToPAMSyms(dataSyms, modOrder);
%   disp('PAM Symbols:'), disp(pamSyms);
%   disp('PAM Symbol Set:'), disp(pamSymSet);
%
% Example 2:
%   % When dataSyms is not provided:
%   modOrder = 4;
%   [~, pamSymSet] = mapToPAMSyms([], modOrder);
%   disp('PAM Symbol Set:'), disp(pamSymSet);
%
% Author: Shayan Zargari
% Date: 2024-08-15
% Version: 1.2

% Generate PAM symbol set
pamSymSet = -(modOrder-1):2:(modOrder-1);

% Map data symbols to PAM symbols if provided
if nargin > 0 && ~isempty(dataSyms)
    pamSyms = pamSymSet(dataSyms + 1);
else
    pamSyms = []; % Return empty if dataSyms is not provided
end

end
