function colomnPlot(chnData, N)
    % 参数检查
    if ~iscell(chnData) || ~isnumeric(N) || N < 1
        error('Invalid input parameters.');
    end

    % 计算subplot的行数和列数
    numSubplots = numel(chnData);
    numRows = ceil(numSubplots / N);

    % 创建figure
    figure;
    % 设置figure的顶部标题
    sgtitle('EXL-50U discharge');

    % 计算每两列之间的间距参数，这里可以根据需要调整
    columnSpacing = 0.01; % 列间距

    % 绘制subplots
    for i = 1:numSubplots
        % 获取当前子cell的X和Y数据
        X = chnData{i}{1};
        Y = chnData{i}{2};
        
        % 计算当前subplot的位置
        [row, col] = ind2sub([numRows, N], i);
        
        % 调整subplot的位置和大小以适应列间距
        subplot('Position', [(col-1)/N + columnSpacing/2, 1 - row/numRows, 1/N - columnSpacing, 1/numRows - 0.01], 'XTickLabelMode', 'auto');

        % 使用X和Y数据进行绘图
        plot(X, Y);
        title(sprintf('Plot %d', i)); % 为每个subplot设置标题
        xlabel('X label', 'FontName', 'Helvetica'); % 设置X轴标签
        ylabel('Y label', 'FontName', 'Helvetica'); % 设置Y轴标签

        % 如果不是第一行，则隐藏x轴标签
        if row > 1
            set(gca, 'XTickLabel', []);
        end
    end

    % 链接所有subplot的X轴
    linkaxes(findall(gcf,'Type','Axes'), 'x');
end

