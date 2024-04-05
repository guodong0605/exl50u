function [vv_in,vv_out,post]=drawVacuumVessel(figFlag)
%% plot the EXL-50U vacuum vessel,the point data comes from CAD
if nargin<1
    figFlag=1;
end
%真空室内边界点
x1=0;        x2=1162.5; x3=1561;    x4=1655;
y1=1645;     y2=1645;   y3=1170;  y4=1170;
% 下面是真空室外围尺寸
xx1=0;        xx2=1176.43;     xx3= 1575;        xx4=1675;
yy1=1675;   yy2=1675;         yy3= 1200;        yy4=1200;
% 下面是中心柱外形
c1=430;     c2=430;    c3=392;    c4=352;  c5=352;          c6= 340.302; c7=340.3;   c8=288.7;  c9=250;
d1=1645;  d2=1620;  d3=1620;  d4=1580; d5=1220.5;    d6=1188.4;   d7=1188.4; d8=1138;    d9=1138;

vv_in=[x1 y1;  x2 y2;   x3 y3;   x4 y4;  x4 -y4; x3 -y3;  x2 -y2;-x1 -y1];

vv_out=[xx1 yy1;  xx2 yy2; xx3 yy3; xx4 yy4; xx4 -yy4; xx3 -yy3;  xx2 -yy2; -xx1 -yy1];
% 中心柱截面数据点
post=[0,d1;c1 d1;c2 d2;c3 d3;c4 d4;c5 d5;c6 d6;c7 d7;c8 d8;c9 d9
    c9 -d9;c8 -d8;c7 -d7;c6 -d6;c5 -d5;c4 -d4;c3 -d3;c2 -d2;c1 -d1;
    0,-d1];
%真空室内壁的多个点组成的多边形
inlines=[c1 d1;c2 d2;c3 d3;c4 d4;c5 d5;c6 d6;c7 d7;c8 d8;c9 d9
    c9 -d9;c8 -d8;c7 -d7;c6 -d6;c5 -d5;c4 -d4;c3 -d3;c2 -d2;c1 -d1;
    x2 -y2;x3 -y3;  x4 -y4; x4 y4; x3 y3; x2 y2;c1 d1];

if figFlag
    patch(vv_out(:,1)/1e3,vv_out(:,2)/1e3,[0,0,0]);
    hold on;patch(vv_in(:,1)/1e3,vv_in(:,2)/1e3,[1,1,1]);
    hold on;patch(post(:,1)/1e3,post(:,2)/1e3,[0.4,0.4,0.4]);
end
end