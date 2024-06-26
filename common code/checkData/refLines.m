function refLines(figHandle)
if nargin < 1 || isempty(figHandle)
    figHandle = gcf; % 使用当前图形
end
axHandles = findall(figHandle, 'Type', 'axes');

if isempty(axHandles)
    error('没有找到子图。');
end

% 初始化全局变量以存储参考线和dx文本的句柄
global refLines dxText

refLines = gobjects(length(axHandles)*2, 1); % 存储所有参考线句柄
dxText = gobjects(length(axHandles), 1); % 存储所有dx文本句柄

xlimsGlobal = [inf, -inf]; % 初始化全局x轴限制

% 遍历所有子图
for i = 1:length(axHandles)
    ax = axHandles(i);
    hold(ax, 'on');

    xlims = get(ax, 'XLim');
    xlimsGlobal(1) = min(xlimsGlobal(1), xlims(1));
    xlimsGlobal(2) = max(xlimsGlobal(2), xlims(2));

    % 插入两条参考线
    refLines(i*2-1) = line(ax, [xlims(1)+((xlims(2)-xlims(1))/4), xlims(1)+((xlims(2)-xlims(1))/4)], get(ax, 'YLim'), 'Color', 'red', 'LineStyle', '--', 'Tag', 'RefLine1','LineWidth',2);
    refLines(i*2) = line(ax, [xlims(2)-((xlims(2)-xlims(1))/4), xlims(2)-((xlims(2)-xlims(1))/4)], get(ax, 'YLim'), 'Color', 'blue', 'LineStyle', '--', 'Tag', 'RefLine2','LineWidth',2);

    % 添加dx文本
    if i==length(axHandles)
        dxText(i) = text(ax, xlims(2)*1.1, mean(get(ax, 'YLim')*0.8), sprintf('x1: %.2f\nx2: %.2f\ndx: %.2f', xlims(1), xlims(2), diff(xlims)), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom','BackgroundColor','w');
        hold(ax, 'off');
    end
end

% 设置参考线的ButtonDownFcn回调
set(refLines, 'ButtonDownFcn', @(src, event) beginDrag(src, axHandles, xlimsGlobal));

% 确保参考线不出现在图例中
set(refLines, 'HandleVisibility', 'off');
end

function beginDrag(lineHandle, axHandles, xlimsGlobal)
global refLines
set(gcf, 'WindowButtonMotionFcn', @(src, event) dragging(lineHandle, axHandles, xlimsGlobal));
set(gcf, 'WindowButtonUpFcn', @endDrag);
end

function dragging(lineHandle, axHandles, xlimsGlobal)
global refLines dxText

cp = get(gca, 'CurrentPoint');
x = cp(1,1);
x = max(xlimsGlobal(1), min(x, xlimsGlobal(2))); % 限制x在全局x轴范围内

% 更新所有子图中相应参考线的位置
tag = get(lineHandle, 'Tag');
for i = 1:length(refLines)
    if strcmp(get(refLines(i), 'Tag'), tag)
        set(refLines(i), 'XData', [x x]);
    end
end

% 同时更新dx值
for i = 1:length(dxText)
    if isgraphics(dxText(i)) % 确保dxText(i)是有效的图形句柄
        x1 = get(refLines(i*2-1), 'XData');
        x2 = get(refLines(i*2), 'XData');
        dx = abs(x2(1) - x1(1));
        position = get(dxText(i), 'Position');clc
        set(dxText(i), 'String', sprintf('x1: %.2f\nx2: %.2f\n dx: %.2f',x1(1), x2(1), dx), 'Position', [x2(1), position(2)]);
    end
end

end

function endDrag(~, ~)
set(gcf, 'WindowButtonMotionFcn', '');
set(gcf, 'WindowButtonUpFcn', '');
end
