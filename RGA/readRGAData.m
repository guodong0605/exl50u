function [channelData, posixTimes, info] = readRGAData(filePath, plotData)
    % 读取整个文件
    fid = fopen(filePath, 'r');
    rawData = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    rawData = rawData{1};

    % 初始化数据存储
    channelData = [];
    posixTimes = [];
    info = struct();

    % 解析文件信息
    for i = 1:length(rawData)
        line = rawData{i};
        if contains(line, 'Active channels in Scan')
            info.channels = str2double(extractAfter(line, ','));
        elseif contains(line, 'Units')
            info.units = strtrim(extractAfter(line, ','));
        elseif contains(line, 'Sample Period')
            info.samplePeriod = str2double(extractAfter(line, ','));
        elseif contains(line, 'Focus Voltage')
            info.focusVoltage = str2double(extractAfter(line, ','));
        % 添加更多的信息解析逻辑
        end

        % 假设时间数据开始的标记
        if contains(line, 'Data Start Here')
            dataStartIndex = i + 1;
            break;
        end
    end

    % 解析数据部分
    for j = dataStartIndex:length(rawData)
        dataLine = strsplit(rawData{j}, ',');
        % 假设第一个是时间戳
        datetimeVal = datetime(dataLine{1}, 'InputFormat', 'MMM dd, yyyy  HH:mm:ss a');
        posixTimes(end+1) = posixtime(datetimeVal);
        % 假设后续是数据
        channelData(end+1, :) = str2double(dataLine(2:end));
    end

    % 绘制图表
    if plotData
        figure;
        plot(posixTimes, channelData);
        title('RGA Channel Data Over Time');
        xlabel('Time (POSIX)');
        ylabel('RGA Value');
        legend(arrayfun(@(x) ['Channel ', num2str(x)], 1:size(channelData, 2), 'UniformOutput', false));
    end
end
