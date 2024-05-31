function setup_spectrometer(extTrig,shotno)
if nargin <1  extTrig=1;end
if nargin <2  shotno=100000; end
% 相机参数列表
port = 41234;
dec712ip = '192.168.0.148';
thresh = 2200;
expo = 0.047;
expp = expo + 0.002;
nimages = 100;
%连接相机
dec712 = tcpip(dec712ip, port);   %连接XCS相机
fopen(dec712);
% 给相机发送参数，设置相机参数
send_command(dec712, 'setthreshold uhighg ', num2str(thresh));  % 2200  阈值
send_command(dec712, 'nimages ', int2str(nimages));                     % 拍摄帧数
send_command(dec712, 'expperiod ', num2str(expp));                     % 曝光周期
send_command(dec712, 'exptime ', num2str(expo));                         % 曝光时间
send_command(dec712, 'imgpath ', shotpath, int2str(shotno));        % 存储数据名称
if expp - expo < 0.001
    expp = expo + 0.001;
    warndlg('EXPP-EXPO<0.001');
end

if extTrig ==1
    send_command(dec712, 'extt ', int2str(shotno), '_.tif');
else
    send_command(dec712, 'exposure ', int2str(shotno), '_.tif');
end
fclose(dec712);
end

function send_command(dec712, varargin)
command = strcat(varargin{:}, newline);
fwrite(dec712, command);
pause(1.0);
end
