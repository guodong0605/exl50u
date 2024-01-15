function [outputArray,time,outputData,shotDate]=downloaddata(shotnum,chns,datatime,showfig,dshift)
% Example [xx,time]=downloaddata(17103,{'div004-06','div011-16'},'0:5:1e-3',1)
% This function is used to download data from EXl50U server, you can download multiple channels in one command,
% outputArray: the output oclf data of m*n  m is the number of data series and  n is the number of chnnels;
% time： the time series of data
% outputData: struct with  channel name and channel data;
% shotnum: just name the shot you want to download data;
% chns: Can be a cell ,like {'chn1','chn3-4'}， then you can download
% chn1,chn3,chn4, or you can just download one chn like 'chn' without bracket{}
% datatime,  StartTime:interval:EndTime
% showfig: is a switch to decide whether you like to plot the data or just dowload into workspace
% dshiift: switch to decide whether you would like to cancel the shift caused by data acqusition system
CurrentChannel=extractMultipleStrings(chns);  % change the input string to channel names
% dshift=0;
dshiftTime=0.1; % The default time to do the polyfit of the rawdata is 2 seconds;

if nargin<3
    datatime=[];
    showfig=0;
    dshift=0;
end
if nargin<4
    showfig=0;
    dshift=0;
end

strTreeName='exl50u';
server='192.168.20.11';   %下载数据服务器
initServerTree(server,strTreeName,shotnum)
outputData=[];
% myDate=mdsvalue(['DATE_TIME(getnci("\\' strTreeName '::TOP:FBC:' CurrentChannel '","TIME_INSERTED"))'])
if iscell(CurrentChannel)  %判断如果是多通道，则把输出数据按照结构体进行输出
    for i=1:length(CurrentChannel)
        [z,time]=mydb(CurrentChannel{i},datatime);
        if dshift
            fs=str2num(datatime(end-3:end));
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
        end
    end
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

    end
else
    [outputData,time,shotDate]=mydb(CurrentChannel,datatime);
    if dshift
        fs=str2num(datatime(end-3:end));
        shift_dy= z(1,dshiftTime/fs);
        shift_dx=time(1:length(shift_dy));
        p1fit=polyfit(shift_dx,shift_dy,1);
        p1value=polyval(p1fit,time);
        outputData=z-p1value;
    end

    outputArray=outputData;
    if showfig
        figure;stackplot({{time,outputData,CurrentChannel}},['shotnum',num2str(shotnum)]);
    end
end
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

    function [y,x,shotDate]=mydb(CurrentChannel,datatime)
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
            shotDate=mdsvalue(['DATE_TIME(getnci("\\EXL50U::TOP:FBC:' CurrentChannel '","TIME_INSERTED"))']);
        catch
            x=0;
            y=0;
        end
    end
end