function chineseDateStr = posixTimeToChineseDate(posixTime)
    % 中文月份数组
    monthsChinese = {'一月', '二月', '三月', '四月', '五月', '六月', ...
                     '七月', '八月', '九月', '十月', '十一月', '十二月'};
    
    % 从 POSIX 时间戳创建 datetime 对象
    dateObj = datetime(posixTime, 'ConvertFrom', 'posix');
    
    % 使用 datevec 获取年、月、日
    dateVector = datevec(dateObj);
    year = dateVector(1);
    month = dateVector(2);
    day = dateVector(3);
    
    % 构建中文日期字符串
    chineseDateStr = sprintf('%d-%s-%d', year, monthsChinese{month}, day);
end
