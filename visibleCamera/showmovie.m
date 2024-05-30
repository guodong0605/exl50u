function showmovie(shotnum, t1, t2, name)
% showmovie(3001,2,2.2,'test4')
chn1='ip';
chn2='ha009';
ylabel1='IP(kA)';
ylabel2='Ha(au)';

dt = 0.5;
dframe = 3;
Fs=1e-3;
datatime=[num2str(t1),':',num2str(t2),':',num2str(Fs)];
[~, frame, time] = downloadcine(shotnum, t1+dt, t2+dt, dframe);
time=time-0.5;
desktopPath = getenv('USERPROFILE'); % 对于Windows系统
desktopPath = fullfile(desktopPath, 'Desktop');
folderName = '实验日志';
folderPath = fullfile(desktopPath, folderName);

% 检查"实验日志"文件夹是否存在
if ~exist(folderPath, 'dir')
    % 如果不存在，则创建该文件夹
    mkdir(folderPath);
end

mp4filename = ['C:\Users\Administrator\Desktop\实验日志\', name, '.mp4'];

[ip, tip] = downloaddata(shotnum, chn1,datatime, 0, 0);
[ne, tne] = downloaddata(shotnum, chn2, datatime, 0, 0);

v = VideoWriter(mp4filename, 'MPEG-4');
v.FrameRate = 10;
open(v);

fig = figure(1);
set(fig, 'position', [10, 10, 1100, 800]);

% 左边为 movie
subplot('Position', [0.05, 0.1, 0.4, 0.8]);
img = imagesc(reshape(double(frame(1, :, :)), size(frame, 2), size(frame, 3)), [100, 450]);
colormap(gray);
colorbar off;
t1 = text(10, 10, ['t=', num2str(time(1)), 's'], 'FontSize', 16, 'Color', 'white', 'FontName', 'TimesNewRoman');

% 右边为曲线的时间演化
subplot('Position', [0.55, 0.1, 0.4, 0.8]);
[hax, hline1, hline2] = plotyy(tip, ip, tne, ne);
set([hline1, hline2], 'LineWidth', 2.5);
ylabel(hax(1), ylabel1, 'interpreter', 'tex');
ylabel(hax(2), ylabel2, 'interpreter', 'tex');
set(hax(1), 'FontWeight', 'bold', 'FontSize', 13, 'LineWidth', 1.2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
set(hax(2), 'FontWeight', 'bold', 'FontSize', 13, 'LineWidth', 1.2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')

% 初始化参考线
refLine = plot(hax(1), [tip(1), tip(1)], [min(ip)*0.8, max(ip)*1.1], '--r', 'LineWidth', 1.2);

for i = 1:length(time)
    % 更新参考线位置
    set(refLine, 'XData', [tip(round(i*length(ip)/length(time))), tip(round(i*length(ip)/length(time)))]);

    % 更新图像数据
    set(img, 'CData', reshape(double(frame(i, :, :)), size(frame, 2), size(frame, 3)));

    % 更新时间标签
    set(t1,'String',['t=', num2str(time(i)), 's'])
    current_frame = getframe(fig);
    writeVideo(v, current_frame);
end
close(v);
end
