function plot_Ti()
clear all; clc; close all;
shot=03359;
% shot1=[25611:25615];
while shot<100000
% for i=1:length(shot1)%%
%         shot=shot1(i);
%         keyboard  
        rx=exist([cd,'\results\',num2str(shot),'.mat']); %#ok<EXIST>
        if rx==0
            readspedataB(shot);
        end   
    load([cd,'\results\',num2str(shot),'.mat']);
    % exposure=time;
    channel=[303 406 481 534 580 638 741 857 910];%mm
    mdsconnect('192.168.20.11');
    mdsopen('exl50u',shot);
    Level=3;
    signal='oma02';%%oma02为PI320信号；oma01为mp2061为信号；XCS为弯晶谱仪器信号
    FrameTime = ReadFrameTime(shot,signal,Level);
%         keyboard
    [IF,LF]=Time_sequence_CXRS(shot,signal);
%     mdsclose;
%     mdsdisconnect;
    ptime=0;
     while isempty(FrameTime)&&ptime<61
        % pause(5);
         ptime=ptime+5
         FrameTime = ReadFrameTime(shot,signal,Level);
     end

    mdsclose;
    mdsdisconnect;
%     Frame=FrameTime;%1:cx;
    [ax,bx]=size(Ti);
    if isempty(FrameTime)
        Frame=1:bx;
    elseif length(FrameTime)>bx
%         clear Frame;
        Frame=FrameTime(1:bx);
    elseif length(FrameTime)<bx
        Frame=[FrameTime (FrameTime(end)-FrameTime(end-1))*(0:length(bx)-length(FrameTime))];
    end
        exposure=Frame;
% %     keyboard
    for i=1:length(R)
        for j=1:length(Frame)
            if Tierr(i,j)>Ti(i,j)
               Ti(i,j)=0;  
               Tierr(i,j)=0;
            end
        end
    end
%      keyboard
    for i=1:length(channel)
        [temp,index]=min(abs(R(:,1)-channel(i)));
        Rin(i)=R(index,1);
        [temp,xx1]=find(Ti(index,:)>0);
        index;
%%       图形绘制
       figure(4)
        if i<=7
%         errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'-o','LineWidth',2);hold on
        errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'-','LineWidth',2);hold on
        errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'o','LineWidth',0.5);hold on
        elseif i>7 & i<=14
%         errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'-d','LineWidth',2);hold on
        errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'-','LineWidth',2);hold on
        errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'d','LineWidth',0.5);hold on
        elseif i>14
%         errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'-^','LineWidth',2);hold on
        errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'-','LineWidth',2);hold on
        errorbar(Frame(xx1),Ti(index,xx1),Tierr(index,xx1),'^','LineWidth',0.5);hold on
        end
%       xlim([1 1.5]); 
        ylim([0 500]);
    % keyboard
    end
     unit='mm';
     name='R';
     legend_str=legend_upgrs(Rin,unit,name);
     legend(legend_str);
     xlabel('time(s)','FontSize',11,'FontName','Times New Roman')
     ylabel('Ti(eV)','FontSize',11,'FontName','Times New Roman')
     title(['#',num2str(shot),' BIV line @ 282nm;   ',' w/instr.width;',' Ti-instr=',num2str(round(IFTi*1000)),'eV'])
      set(gca,'FontSize',11,'FontName','Times New Roman')
      grid on
%       keyboard
    %% %time evolution
    %time=[0.5 1.1 1.3 1.4 1.6 1.8 2.1];%[0.5 1.1 1.368 1.85 2.2 2.3 2.8];
%     keyboard
    if isempty(IF)==0
        time=[1.150 1.239 1.50 1.544 1.590 1.632 1.675 1.72 1.76];
    else 
       time = [FrameTime(IF(1)-1) FrameTime(IF(1)+1)  FrameTime(IF(1)+2) ];%[0.67 0.79 0.92];
    end
%     keyboard
    for i=1:length(time)
        [temp,index]=min(abs(exposure-time(i)));
        Fra(i)=index;
       [temp,yy]=find(Ti(:,Fra(i))~=0);% [temp,xx]=find(Ti(:,Fra(i))~=0);
        yy=temp;%xx=temp;
                
       figure(5)
%         set(gcf, 'position', [300, 50, 900, 700])
%         ylim([0 150])
        % subplot(2,1,1)
       % plot(R(xx,1),Intensity(xx,Fra(i)),'-o','LineWidth',2);hold on;
       if i<=7
           plot(R(yy,1),Intensity(yy,Fra(i)),'-o','LineWidth',2);hold on;
       elseif i>7 & i<=14
           plot(R(yy,1),Intensity(yy,Fra(i)),'-d','LineWidth',2);hold on;
       elseif i>14
           plot(R(yy,1),Intensity(yy,Fra(i)),'-^','LineWidth',2);hold on;
       end
        ylabel('BIV Intensity(cts)','FontSize',16,'FontName','Times New Roman');
         xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
%         xlim([300 1000])
         %legend;
         unit='s';
          name='time';
%     keyboard
        legend_str=legend_upgrs(time,unit,name);
        legend(legend_str);
        title(['       #',num2str(shot),' BIV line @ 282nm;   ','w/instr.width;',' Ti-instr=',num2str(round(IFTi*1000)),'eV']);
        set(gca,'FontSize',11,'FontName','Times New Roman');
        grid on
        %subplot(2,1,2)
 
       figure(6)
        if i<=7
            errorbar(R(yy,1),Ti(yy,Fra(i)),Tierr(yy,Fra(i)),'o','LineWidth',2);hold on%errorbar(R(xx,1),Ti(xx,Fra(i)),Tierr(xx,Fra(i)),'o','LineWidth',2);hold on
        elseif i>7 & i<=14
            errorbar(R(yy,1),Ti(yy,Fra(i)),Tierr(yy,Fra(i)),'d','LineWidth',2);hold on
        elseif i>14
            errorbar(R(yy,1),Ti(yy,Fra(i)),Tierr(yy,Fra(i)),'^','LineWidth',2);hold on
        end
        
%         xlim([300 1000]);
        %ylim([0 200])
    end
     unit='s';
     name='time';
%     keyboard
     legend_str=legend_upgrs(time,unit,name);
     legend(legend_str);
     xlabel('R(mm)','FontSize',11,'FontName','Times New Roman');
     ylabel('Ti(eV)','FontSize',11,'FontName','Times New Roman');
%      title(['#',num2str(shot),' BIV line @ 282nm'])
     title(['#',num2str(shot),' BIV line @ 282nm;   ','w/instr.width;',' Ti-instr=',num2str(round(IFTi*1000)),'eV']);
     set(gca,'FontSize',11,'FontName','Times New Roman');
     grid on
    %keyboard
    pause(5) %%%程序暂停pausetime。
   
    %  figure(7)
%         plot(R(1:12,1),Intensity(1:12,Fra(i)),'-o',R(13:52,1),Intensity(13:52,Fra(i)),'-o','LineWidth',2);hold on;
%         ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
%         xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
%         figure(7);
%         image(Ti(yy,Fra(i)),'CDataMapping','scaled');
%         colormap(lines); 
                       
%        figure(55)
% %         keyboard
%     %     subplot(2,1,1)
%         plot(Frame(xx1),Intensity(index,xx1),'-o','LineWidth',2);hold on;
%         ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
%         xlabel('time(s)','FontSize',16,'FontName','Times New Roman');
%         legend;
%          ylim([0 200]);
    %     subplot(2,1,2)
%     keyboard
       
    %     下载图片数据到本地
    fpath = 'C:\Users\Lenovo\Desktop\20220708\';
    figure(4);
    saveas(gcf,[fpath,'jpg\',num2str(shot),'_other_TI.jpg']);
    saveas(gcf,[fpath,'figure\',num2str(shot),'_time.fig']);

    figure(5);
    saveas(gcf,[fpath,'jpg\',num2str(shot),'_other_BIV.jpg']);
    saveas(gcf,[fpath,'figure\',num2str(shot),'_BIV.fig']);
    
    figure(6);
    saveas(gcf,[fpath,'jpg\',num2str(shot),'_other_prof.jpg']);
    saveas(gcf,[fpath,'figure\',num2str(shot),'_prof.fig']);
    %%%
%     上传图片数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     shot=25160;
    fpath = 'C:\Users\Lenovo\Desktop\20220708\';
    ftpobj = ftp('192.168.20.14','ftpuser','FTPqwe123');
    cd(ftpobj,'Ti');
%      file_name = [fpath,'jpg\',num2str(shot),'_prof.jpg'];
    file_name = [fpath,'jpg\',num2str(shot),'_other_TI.jpg']; % path and name ——> shot_other_TI.png
    mput(ftpobj,file_name); 
    file_name_prof = [fpath,'jpg\',num2str(shot),'_other_BIV.jpg'];
    mput(ftpobj,file_name_prof);  
    file_name_prof = [fpath,'jpg\',num2str(shot),'_other_prof.jpg'];
    mput(ftpobj,file_name_prof);  
    close(ftpobj);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     close all;
% 
    shot=shot+1;  
    sifrx=exist(['Z:\',num2str(shot),'.spe']); %#ok<EXIST>  
    %pause(30) %%%程序暂停pausetime。
    filesize=1000;
    if sifrx>0
        fileinfo=dir(['Z:\',num2str(shot),'.spe']);
        filesize=fileinfo.bytes; 
    end
    pausetime=0;  

    
%     keyboard
    while (sifrx==0 && pausetime<6000)||(filesize<100000 && pausetime<6000)
            pausetime=30+pausetime;
            disp(['Waiting ',num2str(pausetime),'s for the next shot:',num2str(shot)])
            disp(['Attention!  Please stop the module manualy with Ctrl + C'])
            pause(30) %%%程序暂停pausetime。
            datetime
            sifrx=exist(['Z:\',num2str(shot),'.spe']); %#ok<EXIST> 
            if sifrx>0
         
        fileinfo=dir(['Z:\',num2str(shot),'.spe']);
%         keyboard
        filesize=fileinfo.bytes;
        while filesize<102400&&sifrx>0
            pausetime=35+pausetime;
            fileinfo=dir(['Z:\',num2str(shot),'.spe']);
            filesize=fileinfo.bytes; 
            pause(30) %%%程序暂停pausetime。
        end
            end
        if pausetime>=6000
            return;
        end
    end
 end
end
 

