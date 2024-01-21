function drawprofile(shotnum,chnnames,Tstart,Tend,Tprofile,isShift,figtype)
% This function is used to interactively plot the profile of data ;
% t is the time span during which to get the data distribution;
% chnnames is the collection of the channel,like 'mp001-010t'，'axuv001-010
Tstart_default=-1;
Tend_default=5;
Tprofile_default=1;
isShift_default=1;
figtype_default=1;
if (nargin <3) || isempty(Tstart), Tstart = Tstart_default; end
if (nargin <4) || isempty(Tend), Tend = Tend_default; end
if (nargin <5) || isempty(Tprofile), Tprofile = Tprofile_default; end
if (nargin <6) || isempty(isShift), isShift = isShift_default; end
if (nargin <7) || isempty(figtype), figtype = figtype_default; end

dt=0.2;       % used to do the average of the raw data,  the average value=mean(t+dt)
t1=Tprofile-dt/2;   %The time start to do the average
t2=Tprofile+dt/2;  %The time end to do the
%
%
%
% average
step=0.001;          % data sample time span
acq_start=-1;        %
fs=1e-3;
data_start=(t1-acq_start)/fs+1;
data_end=(t2-acq_start)/fs;
datatime=[num2str(acq_start),':5:',num2str(step)];
[data,time,chns]=downloaddata(shotnum,chnnames,datatime,0,isShift_default); %下载数据
data_profile=1;

%%
%--------------------draw the data figure-----------------------------------
f1=figure;set (gcf,'Units','normalized','color','w'); % figure 1
color_cell= mycolor(size(data,2));
if figtype==1
    for i=1:size(data,2)
        hold on;plot(time,data(:,i),'LineWidth',1.5,'Color',color_cell(i,:))
    end
else
    fieldNames = fieldnames(chns); % 提取并转换数字
    numbers = zeros(length(fieldNames), 1);
    for i = 1:length(fieldNames)
        numStr = regexp(fieldNames{i}, '\d+', 'match'); % 提取数字部分
        numbers(i) = str2double(numStr{1}); % 转换为数字
    end
    sortedNumbers = sort(numbers);  % 排序
    [T,R]=meshgrid(time,sortedNumbers);
    contourf(T,R,data','--')
    colorbar;
    colormap('Jet')
end
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
xlabel('Time(s)');
ylabel('Channel');
chnname=fieldnames(chns);
l1=legend(chnname);
title(num2str(shotnum))
set(l1,'fontSize',10)
%%
if data_profile
    gcaylim=get(gca,'Ylim');
    d1=gcaylim(1);
    d2=gcaylim(2);
    hold on;
    roi=drawrectangle("Color",[1,0,0],'Position',[t1  d1  dt d2-d1]);
    addlistener(roi,'ROIMoved',@allevents);

    for i=1:size(data,2)
        data_mean(i)=mean(data(data_start:data_end,i));
    end

    num=[];
    for k=1:length(chnname)
        temp=regexp(chnname{k},'\d+','match');
        num(k)=str2double(temp{1});
    end
    figure('Color',[1 1 1],'name','dataprofile');
    axe2=plot(num,data_mean,'--o','LineWidth',2.5,'MarkerSize',8,'MarkerFaceColor',[1 0 0 ],'MarkerEdgeColor',[1 0 0 ]);
    xlabel('Vale(s)');
    ylabel('Channel');
    set(gca, 'FontName',   'Times New Roman', 'FontUnits',  'points','FontSize',  15, 'FontWeight', 'bold', 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on');
    legend(['profile @',num2str(t1+dt/2),'s'])
    setappdata(0,'fs',fs);
    setappdata(0,'num',num);
    setappdata(0,'acq_start',acq_start);
    setappdata(0,'figtype',figtype);
end
    function allevents(src,evt)
        p=src.Position;
        t1=p(1); t2=p(1)+p(3);
        fs=getappdata(0,'fs');
        acq_start=getappdata(0,'acq_start');
        num=getappdata(0,'num');
        figtype=getappdata(0,'figtype');
        dataStart=round((t1-acq_start)/fs);
        dataEnd=round((t2-acq_start)/fs);
        if figtype==1   %如果是线条
            thisline=findobj(src.Parent.Children,'type','Line');
            for i=1:length(thisline)
                temp=thisline(i);
                mean_y(i)=mean(temp.YData(dataStart:dataEnd));
            end
        else   %如果是contour
            thisline=findobj(src.Parent.Children,'type','Contour');
            Zdata=thisline.ZData;
            Ydata=thisline.YData;
            RR=Ydata(:,1);
            Z=Zdata(:,dataStart:dataEnd);
            for k=1:size(Z,1)
                 mean_y(k)=mean(Z(k,:));
            end
        end

        %%
        findfig=findobj(0,'type','figure','name','dataprofile');
        if ~isempty(findfig)
            ax=findobj(findfig.Children,'type','Axes');
            ax.Children.YData= mean_y;
            figure(findfig);
            %     legend(['profile @',num2str(t1),'-',num2str(t2),'s'])
            ax.Legend.String=['profile @',num2str(round((t1+t2)/2*1e3)),'ms',',\delta t=',num2str(round((t2-t1)*1000))];
        else
            figure('Color',[1 1 1],'name','dataprofile');
            axe2=plot(num,mean_y,'--o','LineWidth',2.5,'MarkerSize',8,'MarkerFaceColor',[1 0 0 ],'MarkerEdgeColor',[1 0 0 ]);
            set(gca, 'FontName',   'Times New Roman', 'FontUnits',  'points','FontSize',  15, 'FontWeight', 'bold', 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on');
            legend(['profile @',num2str(round((t1+t2)/2*1e3)),'ms',',\delta t=',num2str(round((t2-t1)*1000))])
        end
    end
end