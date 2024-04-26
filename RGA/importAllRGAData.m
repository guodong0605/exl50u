function [combinedData,info] = importAllRGAData(folderPath,fig)
% 获取指定路径及其所有子目录中的所有.txt文件
files = dir(fullfile(folderPath, '**', '*.txt')); % 注意'**'用于递归搜索

% 初始化空矩阵以存储合并后的数据
combinedData = [];

% 循环遍历所有文件
for i = 1:length(files)
    % 构建完整的文件路径
    try
        filePath = fullfile(files(i).folder, files(i).name);
        % 调用importRGAfile函数加载数据
        [data, info] = importRGAfile(filePath,0);
        % 合并数据
        combinedData = [combinedData; data];
    end
end

% 检查是否有数据加载
if isempty(combinedData)
    warning('No data loaded. Check the file contents or path.');
    return;
end
% 按时间（第一列）排序数据
[~, idx] = sort(combinedData(:,1));  % 获取排序索引
combinedData = combinedData(idx, :);  % 重新排列数据
% 返回排序后的数据
if fig==1
    filepath=mfilename("fullpath");
    filepath2=fileparts(fileparts(filepath));
    colorpath=fullfile(filepath2,"common code/plotFunction/mycolors.mat");
    load(colorpath);
    figure('Color',[1 1 1])

    posixTimes = combinedData(:, 1);  % 第一列是时间戳数据
    time = datetime(posixTimes, 'ConvertFrom', 'posixtime');
    for i=1:size(combinedData,2)-1
        hold on; plot(time,combinedData(:,i+1),'LineWidth',2,'Color',colors(i,:))
    end
    set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
    title('RGA')
    ax = gca;  % 获取当前坐标轴句柄
    ax.XAxis.TickLabelFormat = 'yyyy-MM-dd HH:mm:ss';  % 使用\n换行符分隔日期和时间
    ax.XAxis.TickLabelRotation = 10;
    legend(info.elementName)
    set(ax,'yscale','log')
end
end
