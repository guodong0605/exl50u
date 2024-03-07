function M = MMutInductance(X1, Y1, X2, Y2, ATurnCoil, varargin)
%% Mutual Inductance Calculation
% 计算多个场点（field points）和多个源点（source points）之间的互感或磁通量
% 输入:
% - X1, Y1: 场点坐标数组
% - X2, Y2: 源点坐标数组
% - ATurnCoil: 安匝数数组
% - varargin: 可选参数，gapX
%
% 输出:
% - M: 互感矩阵

% 定义常量
Cmu = 2.0e-7 * pi; % =mu/2
numSource = numel(X2);
M = zeros(size(X1)); % 初始化互感矩阵

% 处理可选的gapX参数
if nargin > 5
    gapX = varargin{1};
else
    gapX = [];
end

% 计算互感
for i = 1:numSource
    % 计算R1，避免源点和场点重叠
    R1 = sqrt((X1 + X2(i)).^2 + (Y1 - Y2(i)).^2);
    m = 4 .* X2(i) .* X1 ./ R1.^2;
    
    % 寻找需要调整的索引
    index = find(abs(m - 1) < 1.0e-15);
    
    % 根据gapX参数调整重叠点
    if ~isempty(index)
        XX1 = X1;
        if isempty(gapX)
            XX1(index) = X1(index) + 0.0001; % 默认移动1mm
        elseif numel(gapX) == 1
            XX1(index) = X1(index) + gapX; % 使用单一值
        elseif numel(gapX) == numel(X2)
            XX1(index) = X1(index) + gapX(i); % 使用对应的gapX值
        end
        
        % 重新计算R1和m
        R1 = sqrt((XX1 + X2(i)).^2 + (Y1 - Y2(i)).^2);
        m = 4 .* X2(i) .* XX1 ./ R1.^2;
    end
    
    % 计算完全椭圆积分K和E
    [myK, myE] = ellipke(m);
    
    % 累加到互感矩阵
    M = M + ATurnCoil(i) .* Cmu .* R1 .* (2 .* (myK - myE) - m .* myK);
end
