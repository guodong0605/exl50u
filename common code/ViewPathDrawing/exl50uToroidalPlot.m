function exl50uToroidalPlot(xp,angle)
vessel_inner_radii=1655/1e3;
vessel_side_wall=20/1e3;
cneteriod_radii=250/1e3;


rectangle('position',[-vessel_inner_radii-vessel_side_wall,-vessel_inner_radii-vessel_side_wall,(vessel_inner_radii+vessel_side_wall)*2,(vessel_inner_radii+vessel_side_wall)*2],...
   'Curvature',[1,1], 'FaceColor','k','EdgeColor','k','LineWidth',2)                 % 画出真空室外壁圆形框，填充黑色
rectangle('position',[-vessel_inner_radii,-vessel_inner_radii,(vessel_inner_radii)*2,(vessel_inner_radii)*2],...
   'Curvature',[1,1], 'FaceColor','w','EdgeColor','k','LineWidth',2)                 % 画出真空室内壁圆形框，填充白色
% rectangle('position',[-cneteriod_radii,-cneteriod_radii,(cneteriod_radii)*2,(cneteriod_radii)*2],...
%    'Curvature',[1,1], 'FaceColor',[0.7 0.7 0.7],'EdgeColor','k','LineWidth',2)       % 画出中心柱圆形框，填充黑色
axis equal;
% -----------绘制法兰圆盘------------
flange1_x=[1626.5,1780,1780,1854,1854,1780,1780,1626.5]/1e3;
flange1_z=[-312,-312,-350,-350,350,350,312,312]/1e3;
flange1_xx=[1626.5,1824,1824,1626.5]/1e3;
flange1_zz=[-300,-300,300,300]/1e3;

flange1_out=[flange1_x',flange1_z'];
flange1_in=[flange1_xx',flange1_zz'];
flange1_angle=[0,60,90,120,210,270];

for i=1:length(flange1_angle)
    theta=flange1_angle(i)-0;
    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    newPositonOut=flange1_out*R;
    newPositonIn=flange1_in*R;
       
    patch(newPositonOut(:,1),newPositonOut(:,2),[0,0,0.4]);
    patch(newPositonIn(:,1),newPositonIn(:,2),[1,1,1],'EdgeColor',[1,1,1]);
end

flange2_x=[-1656,-1786,-1786,-1854,-1854,-1786,-1786,-1656]/1e3;
flange2_z=[260,260,295,295,-295,-295,-260,-260]/1e3;
flange2_xx=[-1630,-1824,-1824,-1630]/1e3;
flange2_zz=[-250,-250,250,250]/1e3;

flange2_out=[flange2_x',flange2_z'];
flange2_in=[flange2_xx',flange2_zz'];
flange2_angle=[30,150,180,240,300,330];


for i=1:length(flange2_angle)
    theta=flange2_angle(i)-180;
    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    newPositonOut=flange2_out*R;
    newPositonIn=flange2_in*R;       
    patch(newPositonOut(:,1),newPositonOut(:,2),[0,0,1]);
    patch(newPositonIn(:,1),newPositonIn(:,2),[1,1,1],'EdgeColor',[1,1,1]);
end




%-------------------
fontlabel=linspace(330,0,12);     %圆形角度标记 从0 间隔30 至360
for k=1:12
    xk=2*cos(-2*pi/12*k);
    yk=2*sin(-2*pi/12*k);
    h=text(xk,yk,num2str(fontlabel(k)),'fontsize',15,'color',[0 0 0],'HorizontalAlignment','center');
end
x2=xp*cos(angle/180*pi);
y2=xp*sin(angle/180*pi);   %计算安装诊断的X和Z位置
% hold on;plot(x2/1e3,y2/1e3,'o','MarkerSize',12,'MarkerEdgeColor','r','MarkerFaceColor','r') %画出安装诊断的X和Z位置
%画出安装诊断和中心店的交点
                                     %标题
%---------------------画限制器-----------------------------
end