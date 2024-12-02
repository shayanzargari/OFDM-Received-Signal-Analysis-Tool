function param = initializeParameters()
% initializeParameters - Initializes system parameters for signal processing.
%
% Outputs:
%   param - Structure containing all system parameters.

% General parameters
param.fs = 7e6; % Sampling rate in Hz
param.transformType = 'fft-double'; % Transform type for analysis
param.plotFlag = true; % Enable/disable plotting for debugging

% Bandwidth estimation
param.thresholdFactor = []; % Threshold factor for bandwidth calculation
param.bwType = '3dB'; % Bandwidth type (e.g., 3dB cutoff)

% Autocorrelation analysis
param.peakThreshold = 0.065; % Threshold for peak detection

% Detection parameters
param.softFlag = 'hard'; % Detection type: 'hard' or 'soft'
param.phaseOff = 0; % Phase offset for detection
param.symOrder = 'natural'; % Symbol order
end
