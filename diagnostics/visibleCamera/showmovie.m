function showmovie(shotnum,leftchn,rightchn,t1, t2)
%  showmovie(3001,2,2.2,'test4')
leftchn='m60';
rightchn='ip,hcn_ne001,axuv001,i_cs';

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

mp4filename = ['C:\Users\Administrator\Desktop\实验日志\', shotnum, '.mp4'];

v = VideoWriter(mp4filename, 'MPEG-4');
v.FrameRate = 10;
open(v);

fig = figure(1);
set(fig, 'position',  [50, 50, 1600, 800]);
subplot('Position', [0.05, 0.1, 0.5, 0.8]); % 左边subplot位置
hold on;
subplot('Position', [0.60, 0.1, 0.3, 0.8]); % 左边subplot位置
% 绘制ip和ne的曲线




% 初始化参考线
refLine = plot(hax(1), [tip(1), tip(1)], [min(ip)*0.8, max(ip)*1.1], '--r', 'LineWidth', 1.2);

% 在第二个subplot中初始化图像显示
y2 = subplot('Position', ypos{2});
set(gca, 'FontWeight', 'bold', 'FontSize', 12, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')

img = imagesc(reshape(double(frame(1, :, :)), size(frame, 2), size(frame, 3)), [100, 450]);
colormap(y2, gray);
colorbar off;
t1=text(800, 100, ['t=', num2str(tip(1)), 's'], 'FontSize', 16, 'Color', 'white', 'FontName', 'TimesNewRoman', 'Parent', y2);

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