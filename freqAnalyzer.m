function [result, phase, bins] = freqAnalyzer(signal, Fs, transformType, NFFT, plotFlag)
% freqAnalyzer - Compute and visualize the FFT or IFFT of a signal.
%
% Description:
%   Computes either the Fast Fourier Transform (FFT) or the Inverse Fast Fourier Transform (IFFT) of a given signal.
%   Supports both single-sided and double-sided transforms with optional visualization.
%
% Usage:
%   [result, phase, bins] = freqAnalyzer(signal, Fs, transformType, NFFT, plotFlag)
%
% Inputs:
%   signal        - (vector) Input signal in the time or frequency domain.
%   Fs            - (scalar) Sampling frequency in Hz.
%   transformType - (string) Type of transform: 'fft-single', 'fft-double', 'ifft-single', or 'ifft-double'.
%   NFFT          - (scalar) [Optional] Number of FFT points. Defaults to the next power of 2 of the signal length.
%   plotFlag      - (boolean) [Optional] If true, plots the magnitude and phase spectra (default: false).
%
% Outputs:
%   result - (vector) The computed FFT or IFFT of the signal.
%   phase  - (vector) Phase spectrum in degrees (for FFT only).
%   bins   - (vector) Frequency or time bins corresponding to the FFT/IFFT values.
%
% Example:
%   % Time-domain to frequency-domain example:
%   Fs = 1000; t = 0:1/Fs:1-1/Fs; NFFT = 1024;
%   signal = sin(2*pi*50*t) + sin(2*pi*120*t);
%   [freqSignal, phase, bins] = freqAnalyzer(signal, Fs, 'fft-double', NFFT, true);
%
%   % Frequency-domain to time-domain example:
%   [timeSignal, ~, bins] = freqAnalyzer(freqSignal, Fs, 'ifft-double', NFFT, true);
%
% Author: Shayan Zargari
% Date: 2024-07-15
% Version: 1.0

% Validate and set default input arguments
if nargin < 4 || isempty(NFFT)
    NFFT = 2^nextpow2(length(signal)); % Default to next power of 2
end
if nargin < 5
    plotFlag = false; % Default plotFlag to false
end

% Initialize phase to empty for non-FFT cases
phase = [];

% Define tolerance for phase computation
tolerance = 1e-6;

% Perform the appropriate transform
switch lower(transformType)
    case 'ifft-single'
        % Single-sided IFFT
        fullSignal = [signal, conj(flip(signal(2:end-1)))]; % Reconstruct full spectrum
        result = real(ifft(fullSignal, NFFT) * NFFT);       % Compute and scale IFFT
        result = result(1:NFFT/2+1);                        % Return real part of the reconstructed signal
        bins = (0:length(result)-1) / Fs;                   % Time bins

    case 'ifft-double'
        % Double-sided IFFT
        result = ifft(ifftshift(signal), NFFT) * NFFT; % Compute and scale IFFT
        bins = (0:length(result)-1) / Fs;              % Time bins

    case 'fft-single'
        % Single-sided FFT
        result = fft(signal, NFFT) / NFFT;
        result = result(1:NFFT/2+1);         % Extract single-sided FFT
        bins = (0:(NFFT/2)) * (Fs / NFFT);   % Frequency bins

    case 'fft-double'
        % Double-sided FFT
        result = fftshift(fft(signal, NFFT)) / NFFT;
        bins = (-NFFT/2:(NFFT/2-1)) * (Fs / NFFT);   % Frequency bins

    otherwise
        error('Invalid transformType. Valid options are: ''fft-single'', ''fft-double'', ''ifft-single'', or ''ifft-double''.');
end

% Compute phase spectrum if performing FFT
if contains(transformType, 'fft')
    result(abs(result) < tolerance) = 0;        % Mask noise
    phase = atan2d(imag(result), real(result)); % Compute phase in degrees
end

% Plot magnitude (and phase) spectra if plotFlag is true
if plotFlag
    figure;
    if strcmpi(transformType, 'ifft-single') || strcmpi(transformType, 'ifft-double')
        % Plot only magnitude for ifft-single
        plot(bins, result);
        title('Magnitude Spectrum');
        xlabel('Time (s)');
        ylabel('Magnitude');
        grid on;
    else
        % Plot magnitude and phase for other transform types
        semilogy(bins, abs(result));
        title('Magnitude Spectrum (dB)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        grid on;
        axis tight
    end
end

end