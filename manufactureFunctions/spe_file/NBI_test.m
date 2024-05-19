function NBI_test()
close all;clear all;clc;
shot=23397;
mdsconnect('192.168.20.11');
mdsopen('exl50',shot);
name='BES';
% Level=3;
% signal='oma02';%%oma02为TPI320，oma01为Mp2061；xcs为XCS诊断�?
% FrameTime = ReadFrameTime(shot,signal,Level);
[IF,LF]=Time_sequence_CXRS(shot);
sp = loadSPE(['Y:\data\NBI test\',num2str(shot),'.spe']);%
data=sp.int;
[ax,bx,cx]=size(data);
spedata(1:ax,1:bx,1:cx)=0;
for i=1:cx
    spedata(:,:,i)=data(:,:,i);
end 
frame=[IF-1 IF+2 IF+4 IF+6];
channel=24;
for i=1:length(frame)
figure(1);
image(spedata(:,:,frame(i)),'CDataMapping','scaled');
colormap(lines);
spe=spikedel(spedata(channel,:,frame(i)));
figure(20);%%sp.wavelength
plot(sp.wavelength,spe,'LineWidth',2);hold on;
 xlabel('Wavelength(nm)','FontSize',16,'FontName','Times New Roman')
 ylabel([name,' Intensity(cts)'],'FontSize',16,'FontName','Times New Roman')
 title(['#',num2str(shot),'  ',name,' line @ 282nm'])
 set(gca,'FontSize',16,'FontName','Times New Roman');
end
legend;
keyboard
% for k=1:cx
%     for i=1:ax