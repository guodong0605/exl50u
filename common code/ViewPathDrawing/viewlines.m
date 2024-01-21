function cross_points=viewlines(windowname,point,theta1,theta2,num,CrossLineR)
thetas=linspace(theta1,theta2,num);
x0=point(1);
y0=point(2);
tilt_theta=45;

c1=430;     c2=430;    c3=392;    c4=352;  c5=352;          c6= 340.302; c7=340.3;   c8=288.7;  c9=250;
d1=1645;  d2=1620;  d3=1620;  d4=1580; d5=1220.5;    d6=1188.4;   d7=1188.4; d8=1138;    d9=1138;
x1=0;        x2=1062.5; x3=1178.5;    x4=1561; x5=1655;
y1=1645;     y2=1645;   y3=1625.85;  y4=1170; y5=1170;

inlines=[c1 d1;c2 d2;c3 d3;c4 d4;c5 d5;c6 d6;c7 d7;c8 d8;CrossLineR d9
    CrossLineR -d9;c8 -d8;c7 -d7;c6 -d6;c5 -d5;c4 -d4;c3 -d3;c2 -d2;c1 -d1;
     x2 -y2;x3 -y3;  x4 -y4; x5 -y5; x5 y5;x4 y4; x3 y3; x2 y2;c1 d1];  
      

switch windowname
    case 'S1'
        slopes=tand(thetas+180);
    case 'S2'
        slopes=tand(thetas+180);
    case 'S3'
        slopes=tand(thetas+180);
    case 'U1'
        slopes=tand(thetas+180+tilt_theta);
    case 'U2'
        slopes=tand(thetas+270);
    case 'L1'
        slopes=tand(thetas+180-tilt_theta);
    case 'L2'
        slopes=tand(thetas+270);

end
kk=1; %遍历真空室每两条相邻的边，用于寻找交叉点
for i=1:size(inlines,1)-1 
    vv_p1=inlines(i,:);
    vv_p2=inlines(i+1,:);
    x_max=max(vv_p1(1),vv_p2(1));
    x_min=min(vv_p1(1),vv_p2(1));
    y_max=max(vv_p1(2),vv_p2(2));
    y_min=min(vv_p1(2),vv_p2(2));

    vv_k=(vv_p2(2)-vv_p1(2))/(vv_p2(1)-vv_p1(1));
    vv_b=vv_p1(2)-vv_k*vv_p1(1);   
    %多边形的相邻两边组成的直线 y=vv_k*x+vv_b;
    
    %% 遍历每一条射线，寻找射线和真空室边的交点坐标
    for k=1:num
        line_k=slopes(k);
        line_b=y0-line_k*x0; %观察点视线 y=line_k*x+line_b;
        %如果两条线平行则没有交点
        if line_b==vv_k
            continue;
        elseif abs(vv_k)==Inf && abs(line_k)~=Inf
            cross_point_x=vv_p1(1);
        elseif abs(vv_k)~=Inf && abs(line_k)==Inf
            cross_point_x=x0;
        else
            cross_point_x=(vv_b-line_b)/(line_k-vv_k);  %两条直线相交后的x点坐标
        end        
        
        if cross_point_x>=x_min && cross_point_x<=x_max
            cross_point_y=line_k*cross_point_x+line_b;  %两条直线相交后的y点坐标
            if cross_point_y>=y_min && cross_point_y<=y_max
                cross_point(kk,:)=[cross_point_x,cross_point_y];
                kk=kk+1;
            else
                continue;
            end
        else
            continue;
        end
    end    
end

for k=1:size(cross_point,1)
    dis=(cross_point(k,1)-x0)^2+(cross_point(k,2)-y0)^2;
    cross_point(k,3)=dis;
end
[sorted_data, indices] = sortrows(cross_point, 3);
cross_points=sorted_data(size(cross_point,1)/2+1:end,1:2);

%%


















