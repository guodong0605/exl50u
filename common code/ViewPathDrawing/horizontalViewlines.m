function crossPoints=horizontalViewlines(x,angle,theta1,theta2,num)
%x 表示观测点距离轴线的距离，angle表示环向观测的角度，theta是观测范围，num是观测线的数量
x=x/1e3;
thetas=linspace(theta1,theta2,num)+angle;
r1=1655/1e3;
r2=250/1e3;
x0=x*cosd(angle);
y0=x*sind(angle);


for i=1:length(thetas)
    k=tand(thetas(i));  % 直线的斜率
    [x1,y1,x2,y2]=linecircle(x0,y0,k,0,0,r2);
    if ~isnan(x1)
        [tempx,tempy]= findNearestPoints(x0, y0, [x1,x2],[y1,y2],1,1);
        crossPoints(i,:)=[tempx(1),tempy(1)];
    else
        [x1,y1,x2,y2]=linecircle(x0,y0,k,0,0,r1);
        if ~isnan(x1)
         [tempx,tempy]= findNearestPoints(x0, y0, [x1,x2],[y1,y2],1,0);
        crossPoints(i,:)=[tempx(1),tempy(1)];
        else
            continue;
        end

    end
end
end