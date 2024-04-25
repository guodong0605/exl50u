function autoYLim(figureHandle)
% example autoYLim(gcf) 对当前figure进行y坐标标签自适应
axesHandles = findobj(figureHandle, 'Type', 'axes');
for i = 1:length(axesHandles)
    currentAxes = axesHandles(i);
    yTicks = get(currentAxes, 'YTick');
    if length(yTicks) < 2
        continue;
    end
    yLabelInterval = yTicks(2) - yTicks(1);
    currentYLim = get(currentAxes, 'YLim');
    allLines = findobj(currentAxes, 'Type', 'line');
    for j = 1:length(allLines)
        yData = get(allLines(j), 'YData');
        ymin = min(currentYLim(1), min(yData));
        ymax = max(currentYLim(2), max(yData));
    end

    % 调整ymax和ymin到最近的yLabelInterval倍数
    newUpperLim = ceil(ymax / yLabelInterval) * yLabelInterval-0.1*yLabelInterval;
    newLowerLim = floor(ymin / yLabelInterval) * yLabelInterval+0.1*yLabelInterval;

    set(currentAxes, 'YLim', [newLowerLim, newUpperLim]);
end
end
