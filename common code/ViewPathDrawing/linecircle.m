function [x1, y1, x2, y2] = linecircle(x0, y0, k, x1, y1, r)
% 求解过点（x0, y0）的斜率为 k 的直线和过点（x1, y1）半径为 r 的圆的交点

a = 1 + k^2;
b = 2*k*(y0 - k*x0 - y1) - 2*x1;
c = x1^2 + (y0 - k*x0 - y1)^2 - r^2;

delta = b^2 - 4*a*c;

if delta < 0
    % 无实数解
    x1 = NaN;
    y1 = NaN;
    x2 = NaN;
    y2 = NaN;
elseif delta == 0
    % 只有一个交点
    x1 = -b / (2*a);
    y1 = k*x1 + (y0 - k*x0);
    x2 = x1;
    y2 = y1;
else
    % 有两个交点
    x1 = (-b + sqrt(delta)) / (2*a);
    y1 = k*x1 + (y0 - k*x0);
    x2 = (-b - sqrt(delta)) / (2*a);
    y2 = k*x2 + (y0 - k*x0);
end

end
