function param = initializeParameters()
% initializeParameters - Initializes system parameters for signal processing.
%
% Outputs:
%   param - Structure containing all system parameters.

% General parameters
param.fs = 7e6;                         % Sampling rate in Hz
param.transformType = 'fft-double';     % Transform type for analysis
param.plotFlag = true;                  % Enable/disable plotting for debugging

% Bandwidth estimation
param.thresholdFactor = [];             % Threshold factor for threshold-based bandwidth
param.bwType = '3dB';                   % Options: '3dB', 'threshold', 'OBW'

% Subcarrier spacing estimation
param.scmethod = 'mean';                % Options: 'mean', 'kmeans'

% Autocorrelation analysis
param.peakThreshold = 0.065;            % Threshold for peak detection

% Detection parameters
param.softFlag = 'hard';                % Detection type: 'hard' or 'soft'
param.phaseOff = 0;                    % Phase offset for PSK detection
param.symOrder = 'natural';             % Options: 'natural', 'gray'
end
