function bits = symToBits(detectedSyms, order, phaseOff, symOrd, modType)
% symToBits - Convert detected symbols to bits based on modulation type.
%
% Inputs:
%   detectedSyms - The detected symbols from the modulation scheme.
%   order        - The modulation order.
%   phaseOff     - Phase offset for PSK.
%   symOrd       - String specifying the symbol order ('gray' or 'natural').
%   modType      - The modulation type ('psk', 'qam', 'pam').
%
% Outputs:
%   bits         - The corresponding demodulated bits.
%
% Author: Shayan Zargari
% Date: 22-Sep-2024
% Version: 1.3

switch lower(modType)
    case 'psk'
        bits = pskToBits(detectedSyms, order, phaseOff, symOrd);

    case 'qam'
        bits = qamToBits(detectedSyms, order, symOrd);

    case 'pam'
        bits = pamToBits(detectedSyms, order, symOrd);

    otherwise
        error('Unsupported modulation type: %s', modType);
end

end
