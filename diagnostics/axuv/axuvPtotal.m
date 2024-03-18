function [outputArg1,outputArg2] = axuvPtotal(shotnum,t1,t2)
%获取axuv某一炮数据
Fs=1e3;
dshift=1;
datatime=[num2str(t1),':',num2str(t2),':',num2str(1/Fs)];
chns='axuv001-16';
[axuvData,time]=downloaddata(shotnum,chns,datatime,0,dshift);
delta_r=[48.72 64.81 62.05 59.47 57.03 54.75 52.6 50.58 48.66 47.05 44.99  43.53 42.01 40.57 39.19  37.88];
Number=16;
%%
%一.AXUV信号后处理程序（计算等离子体的辐射功率：2~6keV)
%探测器阵列的数目；
%第一部分计算：探测器的弦立体角
A_ap=5;  %5mm*1mm                                                                  %探测器前面小孔的面积(平方mm）
A_det=10;    %5mm*2mm                                                               %单道探测器阵面的面积；（平方毫米）
channel=32/2;%zc AXUV一共有两个阵列32个通道，32/2将上下两个阵列分开，上16通道，下16通道
leng=33.5/16;%mm,zc AXUV一个阵列的侧视图长度是33.5mm，一个阵列有16个通道，平均一个通道占据长度是该值
L=leng/2+leng*(0:channel/2-1);%zc 认为小孔中心就在整个阵列的中心，计算小孔中心到单个通道中心沿探测器平面方向的长度，L给出的是8各通道的数值
d=44.4;%mm,小孔平面与探测器平面间的水平距离；
cosseta1=d./sqrt(L.^2+d^2);%zc setal就是观察弦与探测器/准直孔平面法线的夹角，探测器与准直孔平面平行
for i=1:8
    K(i)=(A_ap.*A_det.*cosseta1(i)^4./(4.*pi.*d^2));                       %第i个探测器的弦的相对立体角（每平方毫米）
end
K=[K,flip(K)];
%%
%第二部分计算：有效的弦积分信号
G=10^6;                                                                       %探测器的放大增益（V/A)
S=0.26;                                                                  %探测器的响应度(A/W)
leng_t=length(axuvData); % 单通道时间长度
p=ones(leng_t,Number);
for i=1:Number
    p(:,i)=axuvData(:,i)./K(i)./G./S;                                               %第i个探测器有效的弦积分信号
end
%第三部分计算总功率,
% 打开文件 将derta_r的值从txt文件中读取出来， %第i根弦与第i+1根弦的平均距离（毫米）

R=0.8*1000;
temp=ones(leng_t,Number);
for i=1:Number
    temp(:,i)=2*pi*R*delta_r(i).*p(:,i);
end
P_total=sum(temp,2);
% 缺少后续的平滑
figure('Color',[1 1 1]);
stackplot({{time,P_total/1e3,'P Total(kW)'}},[num2str(shotnum),'辐射功率'],'time(s)')
end

