function autoClim(inputData, cthreshold)
% Auto-adjusts the color limits of a plot based on data distribution.
% inputData: Data to analyze (2D matrix for image data).
% cthreshold: Threshold to define significant data range (default is 25).

% Validate and parse input arguments
if nargin < 1 || isempty(inputData) || ~isnumeric(inputData)
    axChildren = get(gca, 'Children');
    zData = get(axChildren, 'CData');
end
if nargin < 2 || isempty(cthreshold) 
    cthreshold = 25;
end

% Ensure inputData is a numeric matrix
zData = double(zData);

% Calculate histogram
nbins = 100;
[no, xo] = histcounts(zData(:), nbins);

% Determine significant data range based on cthreshold
significantDataRange = xo(no > max(no) / cthreshold);
clower = min(significantDataRange);
chigher = max(significantDataRange);

% Set color limits
clim([clower, chigher]);

% Enhance plot appearance
colormap('jet');
colorbar;
enhancePlotAppearance();

end

function enhancePlotAppearance()
% Sets the plot properties to enhance its appearance.
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 2, ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'TickLength', [0.02 0.02], ...
    'XGrid', 'on', 'YGrid', 'on', 'Box', 'on');
end
