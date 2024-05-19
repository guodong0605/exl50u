function [rgadata2,info] = importRGAfile(filename,fig)
%IMPORTFILE 从文本文件中导入数据
%  RGA12023APR232024071416AM = IMPORTFILE(FILENAME)读取文本文件 FILENAME
%  中默认选定范围的数据。  以表形式返回数据。
%
%  RGA12023APR232024071416AM = IMPORTFILE(FILE, DATALINES)按指定行间隔读取文本文件
%  FILENAME 中的数据。对于不连续的行间隔，请将 DATALINES 指定为正整数标量或 N×2 正整数标量数组。

%% 输入处理
fileId = fopen(filename, 'r');
for i = 1:29
    line = fgetl(fileId);
    if ~ischar(line)  % 如果到达文件末尾，提前退出循环
        break;
    end
    infoSet{i,1} = line;
end
fclose(fileId);

dateStr = datetime(infoSet{1}, 'InputFormat', 'MMM dd, yyyy  hh:mm:ss a', 'Locale', 'en_US');
% 将datetime对象转换为POSIX时间
dateNum = posixtime(dateStr);
info.date=dateStr;
for i=1:10
    temp=infoSet{19+i};
    data = textscan(temp, '%d%f%s%f%d%s');
    % 提取质量数和元素名称
    massNumber(i,:) = data{2};
    elementName(i,:) = data{3};
end
info.massNumber=massNumber;
info.elementName=elementName;
info.name=infoSet{2};
info.unit=infoSet{8};
info.energy=infoSet{12};

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 11);
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.DataLines = [34, Inf];
opts.Delimiter = ",";
rgadata=readtable(filename, opts);
if isnan(table2array(rgadata(1,2)))
    opts.Delimiter = " ";
    % 指定文件级属性
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";
    opts.VariableNames = ["Times", "Channel1", "Channel2", "Channel3", "Channel4", "Channel5", "Channel6", "Channel7", "Channel8", "Channel9", "Channel10"];
    opts = setvaropts(opts, "Times", "TrimNonNumeric", true);
    opts = setvaropts(opts, "Times", "ThousandsSeparator", ",");
    rgadata=readtable(filename, opts);
end
%%

rgadata2=table2array(rgadata);
rgadata2(:,1)=rgadata2(:,1)+dateNum;
if fig
    warning off;
    filepath=mfilename("fullpath");
    filepath2=fileparts(fileparts(filepath));
    colorpath=fullfile(filepath2,"common code/plotFunction/mycolors.mat");
    load(colorpath);
    figure('Color',[1 1 1],'Units','normalized','Position',[0,0,0.8,0.8])
    posixTimes = rgadata2(:, 1);  % 第一列是时间戳数据
    time = datetime(posixTimes, 'ConvertFrom', 'posixtime');
    for i=1:size(rgadata2,2)-1
        hold on; plot(time,rgadata2(:,i+1),'LineWidth',2,'Color',colors(i,:))
    end
    set(gca, 'FontWeight', 'bold', 'FontSize', 12, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
    title('RGA')
    ax = gca;  % 获取当前坐标轴句柄
    ylabel('Pa')
    xlabel('Time')
    ax.XAxis.TickLabelFormat = 'yyyy-MM-dd HH:mm:ss';  % 使用\n换行符分隔日期和时间
    ax.XAxis.TickLabelRotation = 10;
    set(ax,"YScale",'log')
    t=legend(info.elementName);
    set(t,"Location","best")
end

end