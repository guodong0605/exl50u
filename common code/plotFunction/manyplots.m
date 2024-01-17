function manyplots(shotnum,chns,t1,t2,fs)
datatime=[num2str(t1),':',num2str(t2),':',num2str(fs)];
CurrentChannel=extractMultipleStrings(chns);  %多通道名字转换
[y,t,chns]=downloaddata(shotnum,chns,datatime,0,1);
figure;set (gcf,'Units','normalized','color','w'); % figure 1
color_cell= mycolor(size(CurrentChannel,2));
for i=1:size(y,2)
    hold on;plot(t,y(:,i),'LineWidth',1.5,'Color',color_cell(i,:))
end
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
xlabel('Time(s)');
ylabel('data(V)');
t1=fieldnames(chns);
l1=legend(t1);
title(num2str(shotnum))
set(l1,'fontSize',10)