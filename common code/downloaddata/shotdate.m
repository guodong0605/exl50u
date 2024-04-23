function myDate=shotdate(dateorshot)
% 检查输入是日期还是炮号
if length(num2str(dateorshot)) == 8
    % 输入是日期
    dateNum = dateorshot;
    myDate=processDateInput(dateNum);
elseif isnumeric(dateorshot) && dateorshot < 100000
    % 输入是炮号
    [~,~,~,~,myDate] = downloaddata(dateorshot, 'ip01', '0:1:0.01', 0, 0);
    dateObject = datetime(myDate, 'InputFormat', 'd-MMM-yyyy HH:mm:ss.SS', 'Locale', 'en_US');
    % 将datetime对象转换为指定格式的字符串
    myDate = datestr(dateObject, 'yyyymmdd');

    fprintf('炮号 %s 对应的日期: %s\n', num2str(dateorshot),num2str(myDate));
    fprintf('炮号 %s 对应的时间: %s\n', num2str(dateorshot),datestr(dateObject));

else
    error('输入格式不正确。');
end
end

function myDate = processDateInput(dateNum)
fullPath = mfilename('fullpath');
fileDir = fileparts(fileparts(fileparts(fullPath)));
dataFilePath = fullfile(fileDir, 'common code/downloaddata/data/shotinfo.mat');
if ~exist(dataFilePath, 'file')
    % 如果shotdate.mat文件不存在，创建文件并存储数据
    lastestshot = currentshot(); % 这个函数需要你自己实现，用来获取当前的最新炮号
    [shots, dates] = generateShotDatePairs(lastestshot,1);
    shotinfo=[shots,dates];
    save(dataFilePath, 'shotinfo');
else
    % 如果文件存在，加载数据
    temp = load(dataFilePath);
    shotinfo=temp.shotinfo;
    if ismember(dateNum, shotinfo(:,2))
        % 如果输入日期在文件中，找出所有对应的炮号
        idx = ismember(shotinfo(:,2), dateNum);
        shots=shotinfo(:,1);
        shotsForDate = shots(idx);
        fprintf('日期 %s 对应的炮号有: %s\n', num2str(dateNum), [num2str(shotsForDate(1)),'-:-',num2str(shotsForDate(end))]);
        myDate = [shotsForDate(1),shotsForDate(end)];
    else
        % 如果输入日期是最新的，更新文件
        lastestshot = currentshot(); % 同上，获取最新炮号
        lastShotInFile = max(shotinfo(:,1));
        if lastShotInFile < lastestshot
            [newShots, newDates] = generateShotDatePairs(lastestshot, lastShotInFile + 1);
            shotinfo=[shotinfo;[newShots,newDates]];
            save(dataFilePath, "shotinfo");
        end
        idx = ismember(shotinfo(:,2), max(shotinfo(:,2)));
        shots=shotinfo(:,1);
        shotsForDate = shots(idx);
        fprintf('日期 %s 对应的炮号有: %s\n', num2str(max(shotinfo(:,2))), [num2str(shotsForDate(1)),'-:-',num2str(shotsForDate(end))]);
        myDate = [shotsForDate(1),shotsForDate(end)];
    end
end
end

function [shots,dates] = generateShotDatePairs(currentshot, startShot)
if nargin < 2
    startShot = 1;
end
shots = (startShot:currentshot)';
dates=zeros(numel(shots),1);
k=1;
for shot=startShot:currentshot
    try
        [~,~,~,~,dateString] = downloaddata(shot, 'ip01', '0:1:0.01', 0, 0);
        dateObject = datetime(dateString, 'InputFormat', 'd-MMM-yyyy HH:mm:ss.SS', 'Locale', 'en_US');
        % 将datetime对象转换为指定格式的字符串
        formattedDateString = datestr(dateObject, 'yyyymmdd');
        % 将格式化的日期字符串转换为数字
        dates(k) = str2double(formattedDateString);
        k=k+1;
    catch
        dates(k)=0;  
        k=k+1;
    end
end

end



