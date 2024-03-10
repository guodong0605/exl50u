function colomnPlot(chnData, N)
% 参数检查
if ~iscell(chnData) || ~isnumeric(N) || N < 1
    error('Invalid input parameters.');
end

% 计算subplot的行数和列数
numSubplots = numel(chnData);
numRows = ceil(numSubplots / N);
colors=[0,0,0;1 0 0;0,1,0;0,0,1;1,0,0.761904761904762;0,0,0;0.0793650793650794,0.582677165354331,1;0,0.582677165354331,0.349206349206349;0.523809523809524,0.149606299212598,0;0,0,0.412698412698413;0.253968253968254,0.527559055118110,0.603174603174603;0,1,0.984126984126984;0.698412698412698,1,0.492063492063492;1,0.653543307086614,0.936507936507937;0.634920634920635,0.385826771653543,1;0.444444444444444,0,0.269841269841270;1,0.173228346456693,0.428571428571429;1,0.574803149606299,0.0476190476190476;0.746031746031746,0.669291338582677,0.380952380952381;0.190476190476190,0.212598425196850,0;0,0.0708661417322835,0.158730158730159];

% 创建figure
figure;
% 设置figure的顶部标题
sgtitle('EXL-50U discharge');

% 计算每两列之间的间距参数，这里可以根据需要调整
columnSpacing = 0.14; % 列间距
leftSpace=0.05;
rightSpace=0.1;
downSpace=0.10;
upSpace=0.05;
pic_width=(1-leftSpace-rightSpace-columnSpacing)/N;
pic_height=(1-downSpace-upSpace)/numRows;

% 绘制subplots
for i = 1:numSubplots
    % 获取当前子cell的数据
    dataLeft = chnData{i}{1}; % 左侧Y轴数据
    dataRight = chnData{i}{2}; % 右侧Y轴数据

    % 计算当前subplot的位置
    [row, col] = ind2sub([numRows, N], i);
    position=[(col-1)*pic_width+leftSpace+columnSpacing*(col-1) ,  (row-1)*pic_height+downSpace, pic_width, pic_height];

    % 调整subplot的位置和大小以适应列间距
    subplot('Position', position, 'XTickLabelMode', 'auto');
    yyaxis left
    for m=2:size(dataLeft,2)
        hold on;
        hg{i}=plot(dataLeft(:,1), dataLeft(:,m),'LineWidth', 1.5);
    end
    yyaxis right
    for m=2:size(dataRight,2)
        hold on;
        plot(dataRight(:,1), dataRight(:,m),'LineWidth', 1.5);
    end
    % 设置标题、标签和字体
        set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')

    if row==numRows
        set(gca, 'XTickLabel',[])
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
end
