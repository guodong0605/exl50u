filename='E:\RGA\pvst';
[combinedData,info] = importAllRGAData(filename,1);
load('E:\git\exl50u\common code\downloaddata\data\shotinfo.mat');
shottime=shotinfo(:,3);
rgaTime=combinedData(:,1);
%%
posixTimes=combinedData(:,1);
water=combinedData(:,2);

time = datetime(posixTimes, 'ConvertFrom', 'posixtime');
figure;stackplot({{time,water,'Water(Pa),Water_mean'}},'RAGdate')
set(gca,'yscale','log')
ax = gca;  % 获取当前坐标轴句柄
ax.XAxis.TickLabelFormat = 'yyyy-MM-dd HH:mm:ss';  % 使用\n换行符分隔日期和时间
ax.XAxis.TickLabelRotation = 10;
legend(info.elementName)
%%
Mdl = KDTreeSearcher(rgaTime);
% 查找每个RGAdata中的时间点在shotinfo中的最近点
idx = knnsearch(Mdl, shottime);
%%

% idx现在包含了RGAdata中每个时间点在shotinfo中最近点的索引
idx(idx == 1) = NaN;
nonNaNIndices = find(~isnan(idx));
% 从RGAdata中取出对应的点
% 初始化一个相同大小的结果数组
% 仅对idx中非NaN的值进行操作  
temp=idx(nonNaNIndices);

shots=shotinfo(:,1);
selectshot=shots(nonNaNIndices);

% plot the data
load("E:\git\exl50u\common code\plotFunction\mycolors.mat");

figure('Color',[1 1 1])

for i=1:size(combinedData,2)-1
    RGAdata=combinedData(:,i+1);
    selectedRGAdata = RGAdata(temp);
    hold on; plot(selectshot,selectedRGAdata,'-o','LineWidth',2,'Color',colors(i,:))
end
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
title('RGA')
ax = gca;  % 获取当前坐标轴句柄
legend(info.elementName)



