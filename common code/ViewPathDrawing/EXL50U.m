DiagnosticName='IR Camera';
windowname='S2-240';
dr=50;    %观测点距离法兰面的径向距离
dx=0;  % 观测点沿着水平方向移动的距离
dy=0;  % 观测点沿着垂直方向移动的距离

verticalTheta=[5,-24];  %水平观测的视线角度范围，即过观测点的法兰面的法线两侧，左为负角度，右为正角度
verticalNum=10;           %绘制视线的条数
horizontalTheta=[0,0];%垂直视线的观测角度
horizontalNum=1;         %绘制视线的条数
plasmaShape=2;           % 大等离子体位形，1表示小等离子体等位形

CrossLineR=600 ;% 如果想找到视线和等离子体磁轴的交点，可以把该值换为0.6或0.8
%-------------------------------------------------
filepath='D:\matlab code\EXL50U\EXL50U magnetic data.xlsx';
filepath2='D:\matlab code\EXL50U\EXL-50U plasma .xlsx';
figure('color',[1,1,1],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.8,0.8]) 
a1=subplot(1,2,1,'Box','on');
%=----------------------------
drawTheVacuumVessel()
plasmaR=drawPlasma(filepath2,'EXL-50U',plasmaShape);
DrawTheCoil(filepath);
DrawFlange(filepath,windowname)
DrawTheMagneticProbe(filepath);
%---------------------------------------------------
title(['Poloidal View  :',DiagnosticName] );
axis equal;
xlim([-0.1,2.5]);
ylim([-2.5,2.5])
%--------设置观测点---------------------------
windowStr=windowname(1:2);
[x,z,dtheta]=viewpoint(windowStr,dr,dx,dy);
%-------绘制观测线，即视线和真空室边界的各个交点
crossPoints= viewlines(windowStr,[x,z],verticalTheta(1),verticalTheta(2),verticalNum,CrossLineR);
for i=1:size(crossPoints,1)
    hold on;    
    plot([x/1e3,crossPoints(i,1)/1e3],[z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g')   
end

 tx=text(x/1e3+0.04,z/1e3,['(',num2str(verticalTheta(1)),'$^\circ$',' ',num2str(verticalTheta(2)),'$^\circ$',')']);
 set(tx,'interpreter','Latex','FontSize',14,'Color','b','FontWeight','bold')
  text(x/1e3+0.04,z/1e3+0.05,num2str(x));
%%  绘制环向观测
a1=subplot(1,2,2,'Box','on');
angle=str2double(windowname(4:end))+dtheta;
exl50uToroidalPlot(x,angle)
title(['Toloidal View  :',DiagnosticName] );
cneteriod_radii=0.25;
h=rectangle('position',[-plasmaR,-plasmaR,plasmaR*2,plasmaR*2], 'Curvature',[1,1], 'FaceColor',[0.65	0.035	0.96	0.1]) ;      % 画出中心柱圆形框，填充黑色
rectangle('position',[-cneteriod_radii,-cneteriod_radii,(cneteriod_radii)*2,(cneteriod_radii)*2],...
   'Curvature',[1,1], 'FaceColor',[0.7 0.7 0.7],'EdgeColor','k','LineWidth',2)       % 画出中心柱圆形框，填充黑色
toroidalPoints=horizontalViewlines(x,angle,horizontalTheta(1),horizontalTheta(2),horizontalNum);
 for i=1:size(toroidalPoints,1)
    hold on;    
    plot([x*cosd(angle)/1e3,toroidalPoints(i,1)],[x*sind(angle)/1e3,toroidalPoints(i,2)],'--ro','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g')
  
 end
  tx=text(x*cosd(angle)/1e3+0.04,x*sind(angle)/1e3,['(',num2str(horizontalTheta(1)),'$^\circ$',' ',num2str(horizontalTheta(2)),'$^\circ$',')']);
set(tx,'interpreter','Latex','FontSize',14,'Color','b','FontWeight','bold')
xlim([-2.5,2.5]);
ylim([-2.5,2.5]);




