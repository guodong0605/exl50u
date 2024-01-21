function [pf_handle,text_handle]=DrawPF(filepath)

PFcenter_R=xlsread(filepath,3,'K3:K17');  PFcenter_R=PFcenter_R';
PFcenter_Z=xlsread(filepath,3,'L3:L17');  PFcenter_Z=PFcenter_Z';
PF_W=xlsread(filepath,3,'M3:M17');        PF_W=PF_W';
PF_H=xlsread(filepath,3,'N3:N17');        PF_H=PF_H';
PF_angle=xlsread(filepath,3,'R3:R17');    PF_angle=PF_angle';

PF_X=[PFcenter_R-PF_W/2;  PFcenter_R-PF_W/2;  PFcenter_R+PF_W/2;  PFcenter_R+PF_W/2;  PFcenter_R-PF_W/2;  ];
PF_Z=[PFcenter_Z-PF_H/2;  PFcenter_Z+PF_H/2;  PFcenter_Z+PF_H/2;  PFcenter_Z-PF_H/2;  PFcenter_Z-PF_H/2;  ];
pfcolor=[247 92 47]/255;

for i=1:size(PF_X,2)
    if PF_angle(i)==90
        pf_handle{i}=patch(PF_X(:,i),PF_Z(:,i),pfcolor);
        if i==1
            text_handle{i}=text(PFcenter_R(i)+0.1,PFcenter_Z(i),'CS');
        else
            text_handle{i}=text(PFcenter_R(i)+0.1,PFcenter_Z(i),['PF',num2str(i-1)]);
        end

    else
        angle=PF_angle(i)/180*pi;
        rotation_matrix = [cos(angle), -sin(angle); sin(angle), cos(angle)];
        tempX=PF_X(:,i);
        tempZ=PF_Z(:,i);
        X=(tempX-PFcenter_R(i))*cos(angle)+(tempZ-PFcenter_Z(i))*sin(angle)+tempX;
        Z=-(tempX-PFcenter_R(i))*sin(angle)+(tempZ-PFcenter_Z(i))*cos(angle)+tempZ;
        pf_handle{i}=patch(X,Z,pfcolor);
        text_handle{i}=text(PFcenter_R(i)-0.2,PFcenter_Z(i)+0.2,['PF',num2str(i-1)]);
    end
end
end