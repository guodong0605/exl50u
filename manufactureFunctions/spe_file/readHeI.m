close all;clear all;clc;
shot=20787;
% [data, header] = readSPE([cd,'\rawdata\','shot-  ',num2str(shot),'.spe']);
sp = loadSPE([cd,'\rawdata\',num2str(shot),'.spe']);%
data=sp.int;
[ax,bx,cx]=size(data);
exposure=-0.9+(sp.expo_time)*([0:cx-1]);%1.2288ms
spedata(1:ax,1:bx,1:cx)=0;
for i=1:cx
    spedata(:,:,i)=data(:,:,i);
end 
frame=10;
figure(1);
image(spedata(:,:,frame),'CDataMapping','scaled');
colormap(lines);
figure(20);
plot(sp.wavelength,spedata(40,:,frame),'LineWidth',2);
xlabel('Wavelength(nm)','FontSize',16,'FontName','Times New Roman')
ylabel('BIV Intensity(cts)','FontSize',16,'FontName','Times New Roman')
title(['#',num2str(shot),' BIV line @ 282nm'])
set(gca,'FontSize',16,'FontName','Times New Roman')
keyboard