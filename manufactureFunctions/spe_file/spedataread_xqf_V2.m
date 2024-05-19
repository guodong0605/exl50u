clear all;clc;
Shotnum=03095;
Shotnum2=17731;
exposure=40;
frame_select=23;
frame_select1=17;
%frame_select1=frame_select;
%%%%%%%加载数据模块
sp = loadSPE('E:\A-EXL-50U matlab\bremslung\spedata_read\data\03106_CW612.spe'); %整体数据结构
data=sp.int; %提取所有数据

exp=sp.expo_time;%曝光时间
wave=sp.wavelength;%波长信息
[row_num,col_num,frame_num]=size(data);
Y = 1:1:51;
Y=Y';
%Y=flip(Y);


[data_sif, sif_properties, xaxis, yaxis, zaxis] =sifread('E:\A-EXL-50U matlab\bremslung\spedata_read\sifdata\17731_50_CW610.sif');
b=data_sif(:,:,17);%提取有数据的单帧图像
c=sum(b);
backg_sif=median(data_sif(:));

figure();
t = tiledlayout(2,1); %一定要查阅帮助文档，看tiledlayout()函数
ax1 = nexttile;
imagesc(ax1,xaxis,yaxis,b);
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
%f_data=delSpikes2DSpec(f_data);
offset=1.15;
figure;
t = tiledlayout(4,1); %一定要查阅帮助文档，看tiledlayout()函数
ax1 = nexttile;
imagesc(ax1,wave,Y,f_data);
%set(gca,'YDir','normal')
colorbar;
colormap('gray');%hot cool
caxis([backg backg+100]);%改变对比度
title(['PI谱仪 Shotnum ', num2str(Shotnum),'  frame',num2str(frame_select),'CW 612nm'])


ax2 = nexttile;
imagesc(ax2,xaxis-offset,yaxis,b);
%set(gca,'YDir','normal')
colorbar;
colormap('gray');%hot cool
caxis([backg_sif backg_sif+10]);%改变对比度
title(['Mc谱仪 Shotnum ', num2str(Shotnum2),'  exposure',num2str(exposure),'ms CW 610nm'])
ylim([backg_sif-100,backg_sif+500]);

ax3 = nexttile;
%plot(ax4,wave,f_data(25,:),xaxis-0.6,c/100)
yyaxis left; % 使用左 Y 轴
plot(ax3,wave,f_data(25,:), 'b'); % 绘制第一条曲线
ylim([backg-100,3000]);
yyaxis right; % 使用右 Y 轴
plot(ax3,xaxis-offset,c, 'r'); % 绘制第二条曲线
ylim([15000,18000]);
% 添加标签和标题
xlabel('x');
ylabel('PI spectrometer', 'Color', 'b'); % 左 Y 轴标签
ylabel('Mc spetrometer', 'Color', 'r'); % 右 Y 轴标签
%title('两条曲线的图示');
title(['PI谱仪 CW612nm 与 Mc 谱仪 CW 610nm 对比'])
set(gca,'YDir','normal')


ax4 = nexttile;
plot(ax4,xaxis-offset,c,'r');
title(['Mc谱仪 CW610nm'])
hold on;
linkaxes([ax1,ax2,ax3,ax4],'x');

xlabel(t,'Wave(nm)')
ylabel(t,'Counts')
xlim([605,620]);
%xticklabels(ax1,{})
t.TileSpacing = 'tight'; %保证两幅图之间没有间隔
t.Padding = 'compact'; %每幅图和图框之间紧凑距离

