function [NFFT, Noccupied, NominalBW] = calFFTSize(receivedSignal, signalBW, fs, scSpacing)
% calFFTSize Estimates the FFT size (NFFT), number of occupied subcarriers (Noccupied),
% and the nominal bandwidth (NominalBW).
%
% Inputs:
%   receivedSignal - Time-domain received signal (vector)
%   signalBW       - Computed signal bandwidth in Hz (scalar)
%   fs             - Sampling frequency in Hz (scalar)
%   scSpacing      - Subcarrier spacing in Hz (scalar)
%
% Outputs:
%   NFFT           - Estimated FFT size (integer, power of 2)
%   Noccupied      - Number of occupied subcarriers (integer)
%   NominalBW      - Nominal bandwidth in Hz (scalar)

%% Validate inputs
validateSignalInputs(receivedSignal, signalBW, fs, scSpacing);

%% Calculate the number of occupied subcarriers
Noccupied = ceil(signalBW / scSpacing); % Number of subcarriers actively used

%% Estimate FFT size (total subcarriers including guard bands)
NFFT = fs / scSpacing;            % Ideal FFT size based on sampling rate
NFFT = 2^nextpow2(NFFT);          % Round up to the nearest power of 2

%% Ensure NFFT is larger than Noccupied
if NFFT < Noccupied
    NFFT = 2^nextpow2(Noccupied); % Ensure sufficient FFT size for occupied subcarriers
end

%% Calculate the nominal bandwidth
NominalBW = NFFT * scSpacing; % Total bandwidth spanned by all FFT subcarriers

end

function validateSignalInputs(receivedSignal, signalBW, fs, scSpacing)
% Check number of inputs
if nargin < 4
    error('All inputs (receivedSignal, signalBW, fs, scSpacing) are required.');
end
% Validate receivedSignal
if ~isvector(receivedSignal)
    error('receivedSignal must be a vector.');
end
% Validate signalBW
if ~isscalar(signalBW) || signalBW <= 0
    error('Signal bandwidth (signalBW) must be a positive scalar.');
end
% Validate fs (Sampling Frequency)
if ~isscalar(fs) || fs <= 0
    error('Sampling frequency (fs) must be a positive scalar.');
end
% Validate scSpacing (Subcarrier Spacing)
if ~isscalar(scSpacing) || scSpacing <= 0
    error('Subcarrier spacing (scSpacing) must be a positive scalar.');
end
end

