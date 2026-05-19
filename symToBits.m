function bits = symToBits(detectedSyms, order, phaseOff, symOrd, modType)
% symToBits - Convert detected PSK/QAM symbols to bit sequences.

switch lower(modType)
    case 'psk'
        bits = pskToBits(detectedSyms, order, phaseOff, symOrd);

    case 'qam'
        bits = qamToBits(detectedSyms, order, symOrd);

    otherwise
        error('Unsupported modulation type: %s. Supported types are PSK and QAM.', modType);
end
end
