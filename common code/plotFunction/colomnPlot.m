function colomnPlot(chnData, N)
% 参数检查
if ~iscell(chnData) || ~isnumeric(N) || N < 1
    error('Invalid input parameters.');
end

% 计算subplot的行数和列数
numSubplots = numel(chnData);
numRows = ceil(numSubplots / N);
fontsize=12;
% 创建figure

% 设置figure的顶部标题

% 计算每两列之间的间距参数，这里可以根据需要调整
columnSpacing = 0.03; % 列间距
leftSpace=0.05;
rightSpace=0.1;
downSpace=0.10;
upSpace=0.05;
pic_width=(1-leftSpace-rightSpace-columnSpacing)/N;
pic_height=(1-downSpace-upSpace)/numRows;

% 绘制subplots
for i = 1:numSubplots
    % 获取当前子cell的数据
    dataLeft = chnData{i}{1}; % 第一个矩阵总是左侧Y轴数据

    % 初始化图例字符串数组
    legendsLeft = {};
    legendsRight = {};

    % 检查是否存在第二个矩阵以及它的类型
    if numel(chnData{i}) >= 2
        if isnumeric(chnData{i}{2})
            dataRight = chnData{i}{2}; % 第二个矩阵是右侧Y轴数据
            yyaxisUsed = 'both';
        else
            legendInfo = chnData{i}{2}; % 第二个矩阵是图例信息
            yyaxisUsed = 'left';
            % 解析图例信息
            try
                legendsLeft = strsplit(legendInfo, ',');
            catch
                legendsLeft =legendInfo;
            end
        end
    else
        yyaxisUsed = 'left';
    end

    % 如果存在第三个矩阵，则它包含图例信息
    if numel(chnData{i}) == 3 && ischar(chnData{i}{3})
        legendInfo = chnData{i}{3};
        % 分割左右图例
        legendParts = strsplit(legendInfo, ';');
        legendsLeft = strsplit(legendParts{1}, ',');
        if numel(legendParts) > 1
            legendsRight = strsplit(legendParts{2}, ',');
        end
    end
    [row, col] = ind2sub([numRows, N], i);
    position=[(col-1)*pic_width+leftSpace+columnSpacing*(col-1) ,  (row-1)*pic_height+downSpace, pic_width, pic_height];

    % 调整subplot的位置和大小以适应列间距
    subplot('Position', position, 'XTickLabelMode', 'auto');

    % 绘制左侧Y轴数据
    % yyaxis left
    hold on;
    for m = 2:size(dataLeft,2)
        hg{i}=plot(dataLeft(:,1), dataLeft(:,m), 'LineWidth', 2.5);
    end
    hold off;
    
    % 如果需要，绘制右侧Y轴数据
    if strcmp(yyaxisUsed, 'both')
        yyaxis right
        hold on;
        for m = 2:size(dataRight,2)
            plot(dataRight(:,1), dataRight(:,m), 'LineWidth', 1.5);
        end
        hold off;
    end
set(gca, 'FontWeight', 'bold', 'FontSize', fontsize, 'LineWidth', 1.1, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on')

    % 添加图例
    if ~isempty(legendsLeft) || ~isempty(legendsRight)
        % yyaxis left;
        legend([legendsLeft, legendsRight], 'Location', 'northwest','FontSize',8,'Box','off','Interpreter','none');
        warning off
    end
        % 设置标题、标签和字体

    if row>1
        set(gca, 'XTickLabel',[])
    else
        xlabel('Time(s)','FontSize',15,'FontWeight','bold')
    end

end
nn = 1;
for ii = 1:length(hg)
    for jj = length(hg{ii})
        all_axes(nn) = get(hg{ii}(jj), 'parent');
        nn = nn + 1;
    end
end
if length(all_axes)>1
    linkaxes(all_axes, 'x');    % link all x-axes
end
autoYLim(all_axes)
% 假定其余代码未改变
