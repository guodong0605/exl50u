function [outputArray,time,outputData,unitStr,shotDate]=downloaddata(shotnum,chns,datatime,showfig,dshift)
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

if (nargin <3) || isempty(datatime), datatime = datatime_default; end
if (nargin <4) || isempty(showfig), showfig = showfig_default; end
if (nargin <5) || isempty(dshift), dshift = dshift_default; end


try
    CurrentChannel=extractMultipleStrings(chns);  % change the input string to channel names
catch
    CurrentChannel=chns;
end
dshiftTime=0.5; % The default time to do the polyfit of the rawdata is 0.5 seconds;
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
        [z,time,unitStr,shotDate]=mydb(CurrentChannel{i},datatime,strTreeName);  %调用子函数mydb进行数据下载
        if dshift                   %是否要对数据进行0漂处理
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
        temp=['outputData.',CurrentChannel{i},'=z;'];
        try
            outputArray(:,i)=z;
        catch
            outputArray(:,i)=z(1:end-1,1);
        end
        eval(temp);
        if showfig==1
            figure('Color',[1,1,1]);stackplot({{time,z,CurrentChannel{i}}},['shotnum',num2str(shotnum)]);
            % figure('Color',[1,1,1]);stackplot({{time,z,unitStr}},['shotnum',num2str(shotnum)]);
            legend(CurrentChannel{i});
        end
    end
    % --------------如果showfig==2 表明要把所有通道的数据绘制到一张图上
    if showfig==2
        for k=1:length(CurrentChannel)
            if k==1
                eval(['temp=outputData.',CurrentChannel{k},';'])
                figure;stackplot({{time,temp,CurrentChannel{i}}},['shotnum',num2str(shotnum)]);
            else
                eval(['temp=outputData.',CurrentChannel{k},';'])
                hold on;
                plot(time,temp,'LineWidth',2.5);
            end
        end
        legend(CurrentChannel);
    end
    %-----------------------------------------------
initServerTree;

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

    function [y,x,unitStr,shotDate]=mydb(CurrentChannel,datatime,strTreeName)
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
            try
                datechn=['ad',CurrentChannel];
                shotDate = mdsvalue(['DATE_TIME(getnci(\' datechn ',"TIME_INSERTED"))']);    
            catch
                datechn='ip';
                shotDate = mdsvalue(['DATE_TIME(getnci("\\' strTreeName '::TOP:FBC:' datechn '","TIME_INSERTED"))']);               
            end
             unitStr = mdsvalue(['units_of(\' CurrentChannel ')']);
        catch
            x=0;
            y=0;
            shotDate=nan;
            unitStr=nan;
            disp('There is no such data in Server or chnnel name wrong!')
            return;
        end
    end
end