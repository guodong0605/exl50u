function [XX,YY] = findNearestPoints(x0, y0, X, Y, N,flag)
% 在数据点 (X, Y) 中寻找距离点 (x0, y0) 最近的 N 个点

% 计算所有数据点到点 (x0, y0) 的距离

% flag=1  寻找最近的点，flag=0 寻找最远的点
distances = sqrt((X - x0).^2 + (Y - y0).^2);

% 对距离进行排序，得到排序后的下标
if flag==1
    [~, sortedIndices] = sort(distances);
else
    [~, sortedIndices] = sort(distances,'descend');
end

% 取前 N 个下标，即为距离最近的 N 个点
indices = sortedIndices(1:N);

XX=X(indices);  %输出距离最近的N个点的X坐标
YY=Y(indices);


end
