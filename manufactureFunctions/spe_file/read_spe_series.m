function read_spe_series()
close all;clear all;clc;
shot=02992;
mdsconnect('192.168.20.11');
mdsopen('exl50u',shot);
Level=3;
signal='oma02';%%oma02谱仪PI320；oma01为mp2061；xcs为XCS时序信号?
FrameTime = ReadFrameTime(shot,signal,Level);
[IF,LF]=Time_sequence_CXRS(shot,signal);

% mdsclose;
% mdsdisconnect;
% keyboard
