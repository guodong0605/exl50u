function [nearestPoint,index] = findNearestPoint(dataArray, point)
% 查找数组中距离给定点最近的点的值
% 输入:
%   dataArray - 一维或二维数组
%                对于一维情况，为一个包含x坐标的向量
%                对于二维情况，为Nx2的矩阵，每行是一个点的(x, y)坐标
%   point - 要寻找的点的位置，可以是x或者[x,y]
% 输出:
%   nearestPoint - dataArray中距离给定点最近的点的值
%                  对于一维情况，返回最近的x值
%                  对于二维情况，返回最近的(x, y)坐标

if size(dataArray,2)>size(dataArray,1)
    dataArray=dataArray';
end
if numel(point) == 1
    % 处理一维情况
    x = point;
    distances = abs(dataArray - x);
    [~, index] = min(distances);
    nearestPoint = dataArray(index); % 返回最近的x值
elseif numel(point) == 2
    % 处理二维情况
    x = point(1);
    y = point(2);
    distances = sqrt((dataArray(:, 1) - x).^2 + (dataArray(:, 2) - y).^2);
    [~, index] = min(distances);
    nearestPoint = dataArray(index, :); % 返回最近的(x, y)坐标
else
    error('点的位置参数必须是一个数值（一维）或包含两个元素的向量（二维）');
end
end
