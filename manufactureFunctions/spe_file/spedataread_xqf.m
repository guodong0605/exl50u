clear all;clc;
Shotnum=03095;
Shotnum1=03357;
Shotnum2=03311;
exposure=500;
frame_select=23;
%frame_select1=21;
frame_select1=frame_select;
%%%%%%%加载数据模块
sp = loadSPE('E:\A-EXL-50U matlab\bremslung\spedata_read\data\03095_CW532.spe'); %整体数据结构
data=sp.int; %提取所有数据

exp=sp.expo_time;%曝光时间
wave=sp.wavelength;%波长信息
[row_num,col_num,frame_num]=size(data);
Y = 1:1:51;
Y=Y';
%Y=flip(Y);

sp1 = loadSPE('E:\A-EXL-50U matlab\bremslung\spedata_read\data\03357.spe'); %整体数据结构
data1=sp1.int; %提取所有数据
f_data1=data1(:,:,frame_select);%提取某一帧数据
exp1=sp1.expo_time;%曝光时间
wave1=sp1.wavelength;%波长信息
[row_num1,col_num1,frame_num1]=size(data1);

[data_sif, sif_properties, xaxis, yaxis, zaxis] =sifread('E:\A-EXL-50U matlab\bremslung\spedata_read\sifdata\03311_532nm_300g.sif');
b=data_sif(300:500,:);%提取有数据的单帧图像
c=sum(b);
backg_sif=median(data_sif(:));

figure();
t = tiledlayout(2,1); %一定要查阅帮助文档，看tiledlayout()函数
ax1 = nexttile;
imagesc(ax1,xaxis,yaxis,data_sif);
set(gca,'YDir','normal')
colorbar;
colormap('gray');%hot cool
caxis([backg_sif backg_sif+30]);%改变对比度
title(['Shotnum ', num2str(Shotnum2),'  exposure',num2str(exposure)])

ax2 = nexttile;
plot(ax2,xaxis,c);
hold on;
linkaxes([ax1,ax2],'x');
%%%%%

%%%%%过滤硬X射线模块

backg=median(data(:));%将中位数作为本底
T=1000;%设置阈值
backg1=median(data1(:));%将中位数作为本底
T1=1000;%设置阈值

% for i = 1:size(data, 1)
%     for j = 1:size(data, 2)-1
%         for k = 1:size(data, 3)-1
%         % 检查当前元素是否大于阈值
%             if data(i, j,k) > T
%                 if data(i, j,k+1) < T
%                     data(i, j,k)=backg;
%                 else
%                     continue;
%                 end
%             else
%                 continue;
%             end
%         end
%     end
% end
%              
% 
% for i = 1:size(data1, 1)
%     for j = 1:size(data1, 2)-1
%         for k = 1:size(data1, 3)-1
%         % 检查当前元素是否大于阈值
%             if data1(i, j,k) > T1
%                 if data1(i, j,k+1) < T1
%                     data1(i, j,k)=backg1;
%                 else
%                     continue;
%                 end
%             else
%                 continue;
%             end
%         end
%     end
% end

%%%%%绘图模块
f_data=data(:,:,frame_select);%提取某一帧数据
f_data1=data1(:,:,frame_select1);%提取某一帧数据
figure;
t = tiledlayout(6,1); %一定要查阅帮助文档，看tiledlayout()函数
ax1 = nexttile;
imagesc(ax1,wave,Y,f_data);
%set(gca,'YDir','normal')
colorbar;
colormap('gray');%hot cool
caxis([backg backg+100]);%改变对比度
title(['PI谱仪 Shotnum ', num2str(Shotnum),'  frame',num2str(frame_select),'CW 532nm'])

ax2 = nexttile;
imagesc(ax2,wave1*2,Y,f_data1);
%set(gca,'YDir','normal')
colorbar;
colormap('gray');%hot cool
caxis([backg1 backg1+20]);%改变对比度
title(['PI谱仪 Shotnum ', num2str(Shotnum1),'  frame',num2str(frame_select1),'CW 266nm'])
%title(['Shotnum ', num2str(Shotnum1)]);

ax3 = nexttile;
imagesc(ax3,xaxis-0.6,yaxis,b);
%set(gca,'YDir','normal')
colorbar;
colormap('gray');%hot cool
caxis([backg_sif backg_sif+10]);%改变对比度
title(['Mc谱仪 Shotnum ', num2str(Shotnum2),'  exposure',num2str(exposure),'ms CW 532nm'])
ylim([backg_sif-100,backg_sif+500]);

ax4 = nexttile;
%plot(ax4,wave,f_data(25,:),xaxis-0.6,c/100)
yyaxis left; % 使用左 Y 轴
plot(ax4,wave,f_data(25,:), 'b'); % 绘制第一条曲线
ylim([backg-100,1500]);
yyaxis right; % 使用右 Y 轴
plot(ax4,xaxis-0.63,c, 'r'); % 绘制第二条曲线
%ylim([backg_sif-100,backg_sif+300]);
% 添加标签和标题
xlabel('x');
ylabel('PI spectrometer', 'Color', 'b'); % 左 Y 轴标签
ylabel('Mc spetrometer', 'Color', 'r'); % 右 Y 轴标签
%title('两条曲线的图示');
title(['PI谱仪 CW532nm 与 Mc 谱仪 CW 532nm 对比'])
set(gca,'YDir','normal')

ax5 = nexttile;
plot(ax5,wave1*2,f_data1(25,:))
ylim([backg1-100,1500]);
title(['PI谱仪 CW266nm'])

ax6 = nexttile;
plot(ax6,xaxis-0.6,c);
title(['Mc谱仪 CW532nm'])
hold on;
linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x');

xlabel(t,'Wave(nm)')
ylabel(t,'Counts')
xlim([524,540]);
%xticklabels(ax1,{})
t.TileSpacing = 'tight'; %保证两幅图之间没有间隔
t.Padding = 'compact'; %每幅图和图框之间紧凑距离

