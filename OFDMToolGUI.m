function OFDMToolGUI()
    % OFDMToolGUI - A graphical user interface for OFDM Received Signal Analysis Tool.

    % Close any existing figures with the same name
    existingFig = findall(0, 'Type', 'figure', 'Name', 'OFDM Received Signal Analysis Tool');
    if ~isempty(existingFig)
        close(existingFig);
    end

    % Create the main UI figure
    fig = uifigure('Name', 'OFDM Received Signal Analysis Tool', ...
        'Position', [100, 100, 600, 600]);

    % Add title
    uilabel(fig, 'Text', 'OFDM Received Signal Analysis Tool', ...
        'Position', [150, 550, 300, 40], ...
        'FontSize', 16, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');

    %% File Path Section
    uilabel(fig, 'Text', 'Signal File Path:', ...
        'Position', [50, 500, 150, 22], ...
        'FontSize', 12);
    filePath = uieditfield(fig, 'text', ...
        'Position', [260, 500, 260, 22]);
    uibutton(fig, 'Text', 'Browse', ...
        'Position', [460, 500, 100, 22], ...
        'ButtonPushedFcn', @(btn, event) browseFile(filePath));

    %% General Parameters Section
    % Sampling Rate
    uilabel(fig, 'Text', 'Sampling Rate (Hz):', ...
        'Position', [50, 450, 150, 22], ...
        'FontSize', 12);
    fsInput = uieditfield(fig, 'numeric', ...
        'Position', [260, 450, 100, 22], ...
        'Value', 7e6);

    % Transform Type
    uilabel(fig, 'Text', 'Transform Type:', ...
        'Position', [50, 410, 150, 22], ...
        'FontSize', 12);
    transformTypeInput = uidropdown(fig, ...
        'Items', {'fft-double', 'fft-single'}, ...
        'Position', [260, 410, 150, 22], ...
        'Value', 'fft-double');

    % Enable Plotting
    uilabel(fig, 'Text', 'Enable Plotting:', ...
        'Position', [50, 370, 150, 22], ...
        'FontSize', 12);
    plotFlagInput = uicheckbox(fig, ...
        'Text', '', ...
        'Position', [260, 370, 22, 22], ...
        'Value', true);

    % Subcarrier Estimation Method
    uilabel(fig, 'Text', 'Subcarrier Estimation Method:', ...
        'Position', [50, 330, 200, 22], ... % Adjusted position
        'FontSize', 12);
    scparamInput = uidropdown(fig, ...
        'Items', {'mean', 'kmeans'}, ... % Added dropdown for method selection
        'Position', [260, 330, 150, 22], ... % Adjusted position
        'Value', 'mean');

%% Bandwidth Estimation Section
% Bandwidth Type
uilabel(fig, 'Text', 'Bandwidth Type:', ...
    'Position', [50, 290, 150, 22], ...
    'FontSize', 12);
bwTypeInput = uidropdown(fig, ...
    'Items', {'3dB', 'threshBW', 'obw'}, ...
    'Position', [260, 290, 150, 22], ...
    'Value', '3dB');

% Threshold Factor
uilabel(fig, 'Text', 'Threshold Factor (For threshBW):', ...
    'Position', [50, 250, 200, 22], ...
    'FontSize', 12);
thresholdFactorInput = uieditfield(fig, 'text', ...
    'Position', [260, 250, 100, 22], ...
    'Value', '', ...
    'Tooltip', 'Leave blank for default behavior ([])');

%% Autocorrelation Analysis Section
% Peak Threshold for Autocorrelation
uilabel(fig, 'Text', 'Peak Threshold (AutoCorr):', ...
    'Position', [50, 210, 200, 22], ...
    'FontSize', 12);
peakThresholdInput = uieditfield(fig, 'numeric', ...
    'Position', [260, 210, 100, 22], ...
    'Value', 0.065);

%% Detection Parameters Section
uilabel(fig, 'Text', 'Detection Type:', ...
    'Position', [50, 170, 150, 22], ...
    'FontSize', 12);
detectionTypeInput = uidropdown(fig, ...
    'Items', {'hard', 'soft'}, ...
    'Position', [260, 170, 150, 22], ...
    'Value', 'hard');

    uilabel(fig, 'Text', 'Phase Offset:', ...
        'Position', [50, 130, 150, 22], ...
        'FontSize', 12);
    phaseOffsetInput = uieditfield(fig, 'numeric', ...
        'Position', [260, 130, 100, 22], ...
        'Value', 0);

    uilabel(fig, 'Text', 'Symbol Order for:', ...
        'Position', [50, 90, 150, 22], ... % Adjusted position
        'FontSize', 12);
    symOrderInput = uidropdown(fig, ...
        'Items', {'natural', 'gray'}, ...
        'Position', [260, 90, 150, 22], ...
        'Value', 'natural');

    %% Start Simulation Button
    uibutton(fig, 'Text', 'Start Simulation', ...
        'Position', [260, 30, 150, 40], ...
        'ButtonPushedFcn', @(btn, event) startSimulation());

    %% Callback Functions
    % Browse File Function
    function browseFile(fileField)
        [file, path] = uigetfile('*.mat', 'Select the Received Signal File');
        if isequal(file, 0)
            return;
        end
        fileField.Value = fullfile(path, file);
    end

    % Start Simulation Function
    function startSimulation()
        % Validate file path
        if isempty(filePath.Value) || exist(filePath.Value, 'file') ~= 2
            uialert(fig, 'Invalid file path. Please provide a valid file.', 'File Error');
            return;
        end

        % Load the signal
        try
            load(filePath.Value, 'RxSignal');
        catch
            uialert(fig, 'Error loading file. Ensure the file contains "RxSignal".', 'File Error');
            return;
        end

        % Collect parameter values
        param.fs = fsInput.Value;
        param.transformType = transformTypeInput.Value;
        param.plotFlag = plotFlagInput.Value;
        param.scmethod = scparamInput.Value;
        param.bwType = bwTypeInput.Value;

        % Parse thresholdFactor
        if isempty(thresholdFactorInput.Value)
            param.thresholdFactor = []; % Default behavior
        else
            param.thresholdFactor = str2double(thresholdFactorInput.Value);
            if isnan(param.thresholdFactor)
                uialert(fig, 'Invalid Threshold Factor. Please enter a numeric value.', 'Input Error');
                return;
            end
        end

        param.peakThreshold = peakThresholdInput.Value;
        param.softFlag = detectionTypeInput.Value;
        param.phaseOff = phaseOffsetInput.Value;
        param.symOrder = symOrderInput.Value;

        % Call main with parameters
        try
            [results, param] = main(RxSignal, param); % Assume this function returns results
            resultMessage = sprintf('Simulation completed successfully!\n\nSNR: %.2f dB\nModulation Type: %s\nModulation Order: %d', ...
                                    results.snrdB, results.modType, results.modOrder);
            uialert(fig, resultMessage, 'Simulation Results');
            % Save the results to a MAT file
            save('results.mat', 'results');
            save('param.mat', 'param');
            disp('✔ Results have been saved to results.mat.');
        catch ME
            uialert(fig, sprintf('Error during simulation:\n%s', ME.message), 'Simulation Error');
        end
    end
end
