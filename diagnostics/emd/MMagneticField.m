function [DX,DY]=MMagneticField(X1,Y1,X2,Y2,ATurnCoil,varargin)
% 计算多个场点由多个源点产生的磁场
% 输入:
% X1, Y1 - 场点的坐标数组
% X2, Y2 - 源点的坐标数组
% ATurnCoil - 每个源点的安匝数
% varargin - 可选参数，用于当场点和源点过于接近时的调整值
%
% 输出:
% DX, DY - 在每个场点处的磁场分量

% 处理可选参数gapX
if nargin > 5
    gapX = varargin{1};
else
    gapX = [];
end

Cmu = 2.0e-7; % 磁场常数，等于μ0 / (2π)

numSource = numel(X2); % 源点数量
DX = zeros(size(X1)); % 初始化DX
DY = zeros(size(X1)); % 初始化DY

% 遍历每个源点计算对所有场点的磁场贡献
for i = 1:numSource
    % 计算场点到当前源点的距离
    R1 = sqrt((X1 + X2(i)).^2 + (Y1 - Y2(i)).^2);
    m = 4 .* X2(i) .* X1 ./ R1.^2;
    
    % 检查和处理源点与场点重合的情况
    index = find(abs(m - 1) < 1.0e-10); % 查找几乎重合的点
    XX1 = X1; % 可能会修改的X1副本
    if ~isempty(index)
        if isempty(gapX)
            XX1(index) = X1(index) + 0.0001; % 默认偏移
        elseif numel(gapX) == 1
            XX1(index) = X1(index) + gapX; % 使用指定的单一偏移
        elseif numel(gapX) == numel(X2)
            XX1(index) = X1(index) + gapX(i); % 使用与源点相对应的偏移
        end
        
        % 重新计算调整后的R1和m
        R1 = sqrt((XX1 + X2(i)).^2 + (Y1 - Y2(i)).^2);
        m = 4 .* X2(i) .* XX1 ./ R1.^2;
    end
    
    % 计算椭圆积分
    R2 = sqrt((XX1 - X2(i)).^2 + (Y1 - Y2(i)).^2);
    [myK, myE] = ellipke(m);
    
    % 计算DX和DY分量
    DX = DX - ATurnCoil(i) .* Cmu .* (Y1 - Y2(i)) .* (myK - myE - 2 .* X2(i) .* XX1 .* myE ./ R2.^2) ./ R1 ./ XX1;
    DY = DY + ATurnCoil(i) .* Cmu .* (myK - myE + 2 .* X2(i) .* (X2(i) - XX1) .* myE ./ R2.^2) ./ R1;
end
