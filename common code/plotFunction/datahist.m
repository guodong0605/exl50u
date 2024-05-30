function ratio = datahist(data, threshold, isfig)
    % 数据预处理：确保数据是行向量
    data = data(:)';

    % 定义区间边界，每隔0.5V
    edges = min(data):0.1:max(data); % 根据数据范围设置区间

    % 计算每个区间的数量
    counts = histcounts(data, edges);

    % 计算每个区间的中心点，用于绘制柱状图
    binCenters = edges(1:end-1) + diff(edges)/2;

    % 绘制柱状图
    if isfig == 1
        figure('Color',[1 1 1]);
        bar(binCenters, counts);
        xlabel('幅值 (V)');
        ylabel('数量');
        title('数值在不同区间的统计');
    end

    % 统计绝对值大于阈值的数据量的占比
    data_above_threshold = abs(data) > threshold;
    ratio = sum(data_above_threshold) / numel(data) * 100;

    % 在图中显示占比信息
    if isfig == 1
        text(mean(binCenters), max(counts), ...
            ['绝对值大于 ', num2str(threshold), 'V 的数据占比: ', num2str(ratio, '%.2f'), '%'], ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','FontSize',18);
      set(gca, 'FontWeight', 'normal', 'FontSize', 15, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')

    end
end
