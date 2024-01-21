function probe_handle=DrawMagneticProbe(filepath)
mpcolor=[1,0,0];
Bt_X=xlsread(filepath,1,'B2:B49');
Bt_Z=xlsread(filepath,1,'C2:C49');
theta=xlsread(filepath,1,'D2:D49');
W=xlsread(filepath,1,'F2:F49');
H=xlsread(filepath,1,'H2:H49');
rect1=[Bt_X-W/2,Bt_X-W/2,Bt_X+W/2,Bt_X+W/2,Bt_X-W/2]/1000;
rect2=[Bt_Z-H/2,Bt_Z+H/2,Bt_Z+H/2,Bt_Z-H/2,Bt_Z-H/2]/1000;
for i=1:length(Bt_X)
    if mod(theta(i),90)~=0
        theta1=theta(i)/180*pi;
        tempX=rect1(i,:);
        tempZ=rect2(i,:);
        X=(tempX-Bt_X(i)/1e3)*cos(theta1)+(tempZ-Bt_Z(i)/1e3)*sin(theta1)+Bt_X(i)/1e3;
        Z=-(tempX-Bt_X(i)/1e3)*sin(theta1)+(tempZ-Bt_Z(i)/1e3)*cos(theta1)+Bt_Z(i)/1e3;
        probe_handle{i}=patch(X,Z,mpcolor);
    else
        probe_handle{i}=patch(rect1(i,:),rect2(i,:),mpcolor);
    end
end
end