function [x,z,angle]=viewpoint(windowname,dd,dx,dy)
% dd表示离开法兰面法线的距离，正表示远离，负表示靠近中心柱
% dx表示在极向界面上上下的位移，+上   -下
% dy表示在环向的移动位置
% x,z,angle分别表示观测点所在的极向位置(x,z)以及环向角度angle

up1r=2169; theta=45/180*pi;  %顶部U1窗口的中心点坐标位置
down1r=2169; 

up2x=800; up2z=1816.5;       %顶部U2窗口的中心点坐标位置
down2x=800; down2z=-1816.5;

side1x=1845; side1z=900;    %S1窗口的位置
side2x=1865;  side2z=0;     %S2窗口的位置
side3x=1845; side3z=-900;   %S3窗口的位置

switch windowname
    case 'S1'
        x=side1x+dd;
        z=side1z+dx;
        angle=dy/side1x;
    case 'S2'
        x=side2x+dd;
        z=side2z+dx;
        angle=dy/side2x;
    case 'S3'
        x=side3x+dd;
        z=side3z+dx;
        angle=dy/side3x;
    case 'U1'
        x=1448+dd*cos(theta)-dx*sin(theta);
        z=1614.5+dd*sin(theta)+dx*cos(theta);
        angle=dy/1448;
    case 'U2'
        x=up2x+dx;
        z=up2z+dd;
        angle=dy/up2x;
    case 'L1'
        x=1448+dd*cos(theta)+dx*sin(theta);
        z=-1614.5-dd*cos(theta)+dx*cos(theta);
        angle=dy/1448;
    case 'L2'
        z=down2z-dd;
        x=down2x+dx;
        angle=dy/down2x;
end

angle=angle/pi*180;

end