clear;clc
Shotnum2=03311;
exposure=500;
CW=60d0;
[data_sif, sif_properties, xaxis, yaxis, zaxis] =sifread('E:\A-EXL-50U matlab\bremslung\spedata_read\sifdata\03326_600nm_300g.sif');
b=data_sif(300:500,:);%提取有数据的单帧图像
c=sum(b);
backg_sif=median(data_sif(:));
back=median(c);
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

% 修改第二个子图的纵坐标轴范围
ylim(ax2, [back-1000, back+3000]);
% 设置第二个子图的横坐标轴范围
xlim(ax2, [CW-25, CW+25]);

hold on;
linkaxes([ax1,ax2],'x');
