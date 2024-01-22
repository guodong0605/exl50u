function changedata(str, num)
% 选中figure中的曲线并对数据进行运算操作
% example：changedata('y*10')      选中figure中的曲线后，对曲线中的ydata*10
% example：changedata('smooth',10) 选中figure中的曲线后，对曲线中进行10个点的smooth操作
% 获取当前选中的对象
    line = findobj(gco, 'Type', 'Line');
    if isempty(line)
        disp('No line selected or found.');
        return;
    end
    line = line(1); % 取第一个找到的线对象

    % 获取线对象的数据
    x = line.XData;
    y = line.YData;

    % 计算新的y值
    if nargin < 2
        y2 = eval(str); % 直接计算新的y值
    else
        y2 = smooth(y, num); % 使用平滑函数
    end
    line.YData=y2;    %用计算后的数据替换原有的数据y坐标
end
