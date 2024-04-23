function manysubplots(shotnum,channelnames, timeRange,plotLayout)

    % Preallocate dataset cell array
    dataset = cell(length(channelnames), 1);

    for idx = 1:length(channelnames)
        % Parse current channel set
        currentChannels = strsplit(channelnames{idx}, ',');
        % Download data for the current set of channels
        [y, t, ~,unit] = downloaddata(shotnum, currentChannels, timeRange, 0);        
        % Create data pair with time and data values, and labels
        dataset{idx} = {[t, y], unit};
    end

    % Call the plotting function
    colomnPlot(dataset, plotLayout);
end
