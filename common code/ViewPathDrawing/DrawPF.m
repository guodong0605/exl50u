function PFParameter=DrawPF(filepath,figFlag)
if nargin<2
    figFlag=1;
end
PFcenter_R=xlsread(filepath,4,'K3:K17');  PFcenter_R=PFcenter_R';
PFcenter_Z=xlsread(filepath,4,'L3:L17');  PFcenter_Z=PFcenter_Z';
PF_W=xlsread(filepath,4,'M3:M17');        PF_W=PF_W';
PF_H=xlsread(filepath,4,'N3:N17');        PF_H=PF_H';
PF_angle=xlsread(filepath,4,'R3:R17');    PF_angle=PF_angle';

PF_X=[PFcenter_R-PF_W/2;  PFcenter_R-PF_W/2;  PFcenter_R+PF_W/2;  PFcenter_R+PF_W/2;  PFcenter_R-PF_W/2;  ];
PF_Z=[PFcenter_Z-PF_H/2;  PFcenter_Z+PF_H/2;  PFcenter_Z+PF_H/2;  PFcenter_Z-PF_H/2;  PFcenter_Z-PF_H/2;  ];
pfcolor=[247 92 47]/255;

PFParameter.X=PF_X;
PFParameter.Z=PF_Z;
PFParameter.angle=PF_X;
PFParameter.color=pfcolor;
PFParameter.RR=PFcenter_R;
PFParameter.ZZ=PFcenter_Z;

if figFlag
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
end