function posixTime = chineseDateToPosixTime(dateStr)
    % 中文月份到数字月份的映射
    months = {'一月', '二月', '三月', '四月', '五月', '六月', ...
              '七月', '八月', '九月', '十月', '十一月', '十二月'};
    numMonths = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'};
    
    % 拆分输入的日期字符串
    parts = strsplit(dateStr, '-');
    
    % 年
    year = parts{1};
    
    % 月（中文转数字）
    monthIndex = find(strcmp(months, parts{2}));
    if isempty(monthIndex)
        error('Invalid month');
    end
    month = numMonths{monthIndex};
    
    % 日
    day = parts{3};
    
    % 构建标准日期格式字符串
    standardDateStr = [year, '-', month, '-', day];
    
    % 创建 datetime 对象
    dateObj = datetime(standardDateStr, 'InputFormat', 'yyyy-MM-dd');
    
    % 转换为 POSIX 时间
    posixTime = posixtime(dateObj);
end
