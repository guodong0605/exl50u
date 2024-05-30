function [outputArray,time,unitStr,info]=downloaddata(shotnum,chns,datatime,showfig,dshift,dshiftTime)
% Example [xx,time]=downloaddata(17103,{'div004-06','div011-16'},'0:5:1e-3',1)
% Example [xx,time]=downloaddata(17103,'div004-06','div011-16','0:5:1e-3',1)
% This function is used to download data from EXl50U server, you can download multiple channels in one command,
% outputArray: the output oclf data of m*n  m is the number of data series and  n is the number of chnnels;
% time： the time series of data
% outputData: struct with  channel name and channel data;
% shotnum: just name the shot you want to download data;
% chns: Can be a cell ,like 'chn1,chn3-4'， then you can download chn1,chn3,chn4
% datatime,  StartTime:interval:EndTime
% showfig: is a switch to decide whether you like to plot the data or just dowload into workspace
% dshiift: switch to decide whether you would like to cancel the shift caused by data acqusition system
% example： [xx,time,chns]=downloaddata(682,'ip01-02_h','-2:7:1e-3',1,0);
%                   [xx,time,chns]=downloaddata(682,'ip01,ip02','-2:7:1e-3',1,0);
datatime_default='0:5:1e-3';
showfig_default=0;
dshift_default=0;
dshiftTime_default=0.5; % The default time to do the polyfit of the rawdata is 0.5 seconds;
currentFilePath = mfilename('fullpath');
[currentDir,~,~] = fileparts(currentFilePath);
[parentDir,~,~] = fileparts(currentDir);
filepath = fullfile(parentDir,"plotFunction/mycolors.mat");
temp=load(filepath);
colors=temp.colors;
if (nargin <3) || isempty(datatime), datatime = datatime_default; end
if (nargin <4) || isempty(showfig), showfig = showfig_default; end
if (nargin <5) || isempty(dshift), dshift = dshift_default; end
if (nargin <6) || isempty(dshift), dshiftTime = dshiftTime_default; end
% 获取当前运行的.m文件的完整路径

try
    CurrentChannel=extractMultipleStrings(chns);  % change the input string to channel names
catch
    CurrentChannel=chns;
end


strTreeName='exl50u';
server='192.168.20.11';   %下载数据服务器
server2='192.168.20.41';   %下载数据服务器
try
    initServerTree(server,strTreeName,shotnum)
catch
    initServerTree(server2,strTreeName,shotnum)
end
outputData=[];
%--------    根据通道的数量，利用for循环进行下载数据-------------------------
for i=1:length(CurrentChannel)    %下载数据的数量
    [z,time,unitStr,infoTemp]=mydb(CurrentChannel{i},datatime,strTreeName);  %调用子函数mydb进行数据下载
    if dshift                   %是否要对数据进行0漂处理
        try
            pattern = '^([-+]?\d+)'; % 正则表达式模式
            match = regexp(datatime, pattern, 'match');
            numberStr = match{1}; % 提取匹配的字符串
            t1 = str2double(numberStr); % 转换为数字
            disp(['shift operation from[',num2str(t1),':',num2str(t1+dshiftTime),']'])
            fs=str2double(datatime(end-3:end));
            shift_dy= z(1:dshiftTime/fs);
            shift_dx=time(1:length(shift_dy));
            p1fit=polyfit(shift_dx,shift_dy,1);
            p1value=polyval(p1fit,time);
            z=z-p1value;
        end
    end
    temp=['outputData.',CurrentChannel{i},'=z;'];
    try
        outputArray(:,i)=z;
    catch
        outputArray(:,i)=z(1:end-1,1);
    end
    eval(temp);
    if showfig==1
        figure('Color',[1,1,1]);stackplot({{time,z,[CurrentChannel{i},'(',unitStr,')']}},['shotnum',num2str(shotnum)]);
        % figure('Color',[1,1,1]);stackplot({{time,z,unitStr}},['shotnum',num2str(shotnum)]);
        legend([CurrentChannel{i},'(',unitStr,')']);
    end
        info{i}=infoTemp;
end
% --------------如果showfig==2 表明要把所有通道的数据绘制到一张图上
if showfig==2
    for k=1:length(CurrentChannel)
        if k==1
            eval(['temp=outputData.',CurrentChannel{k},';'])
            figure('Color',[1 1 1]);stackplot({{time,temp,CurrentChannel{i}}},['shotnum',num2str(shotnum)]);
        else
            eval(['temp=outputData.',CurrentChannel{k},';'])
            hold on;
            plot(time,temp,'LineWidth',2.5,'Color',colors(k,:));
        end
    end
    legend(CurrentChannel);
end
%-----------------------------------------------
initServerTree;
%-----------------------------------------------
    function initServerTree(varargin)
        if nargin>0  % should be 3
            %% connect and open
            mdsconnect(varargin{1}); % server
            mdsopen(varargin{2},varargin{3}); % tree and shot
        else
            try
                %% close and disconnect
                mdsclose;
                mdsdisconnect;
            catch
                msgbox('initServerTree, wrong when close and disconnect');
            end
        end
    end
    function [y,x,unitStr,infomation]=mydb(CurrentChannel,datatime,strTreeName)
        if ~isempty(datatime)
            timeWindow=datatime;
            pattern =':'; % '[-\d\.]+';
            timeResults = regexpi(timeWindow,pattern,'split');
            if strcmpi(timeResults{3},'nan')
                timeContext=['SetTimeContext('  timeResults{1}   ','  timeResults{2}  ',0.001)'];
            elseif isnumeric(str2double(timeResults{3})) &&  str2double(timeResults{3})>0
                timeContext=['SetTimeContext('  timeResults{1}   ','  timeResults{2}  ','  timeResults{3} ')'];
            else
                timeContext=['SetTimeContext('  timeResults{1}   ','  timeResults{2} ')'];
            end
            mdsvalue(timeContext);
        end

        try
            x=mdsvalue(['dim_of(\' CurrentChannel ')']);
            y=mdsvalue(['\' CurrentChannel]);
            currentshotnum=mdsvalue('current_shot(''exl50u'')');
            infostring=mdsvalue(['\' CurrentChannel,'.info']);
            try
                infomation=extractInfo(infostring);
            catch
                infomation='';
            end
            try
                datechn=['ad',CurrentChannel];
                shotDate = mdsvalue(['DATE_TIME(getnci(\' datechn ',"TIME_INSERTED"))']);
            catch
                datechn='ip';
                shotDate = mdsvalue(['DATE_TIME(getnci("\\' strTreeName '::TOP:FBC:' datechn '","TIME_INSERTED"))']);
            end
            unitStr = mdsvalue(['units_of(\' CurrentChannel ')']);
            if strcmp(unitStr,' ')
                unitStr=chnUnit(CurrentChannel);
            end
        catch
            x=0;
            y=0;
            shotDate=nan;
            unitStr=nan;
            disp('There is no such data in Server or chnnel name wrong!')
            return;
        end
        if    ~isnumeric(x)
            x=0;
            y=0;
            unitStr='';
        end
        infomation.shotDate=shotDate;
        infomation.currentshotNum=currentshotnum;
    end
  function info = extractInfo(jsonStr)
    % Example JSON string
    % jsonStr = '{"factor":-282.1, "unit": "g"}';

    % Parse the JSON string into a MATLAB structure
    info = jsondecode(jsonStr);
    
    % Convert any numeric strings to numbers
    fields = fieldnames(info);
    for ii = 1:numel(fields)
        key = fields{ii};
        value = info.(key);
        
        % Check if the value is a string that represents a number
        if ischar(value) && any(isstrprop(value, 'digit'))
            if contains(value, '.')
                info.(key) = str2double(value);  % Convert to double if it contains a decimal point
            else
                info.(key) = str2num(value);  % Convert to number (integer)
            end
        end
    end
end

end