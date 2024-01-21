function tf_handle=DrawTF(filepath)
TFinX=xlsread(filepath,3,'A2:A28');
TFinZ=xlsread(filepath,3,'B2:B28');
TFoutX=xlsread(filepath,3,'C2:C28');
TFoutZ=xlsread(filepath,3,'D2:D28');
TF_X=[TFinX;TFoutX];
TF_Z=[TFinZ;TFoutZ];
VV_X=xlsread(filepath,3,'E2:E731');
VV_Z=xlsread(filepath,3,'F2:F731');

PFcenter_R=xlsread(filepath,3,'K3:K17');  PFcenter_R=PFcenter_R';
PFcenter_Z=xlsread(filepath,3,'L3:L17');  PFcenter_Z=PFcenter_Z';
PF_W=xlsread(filepath,3,'M3:M17');        PF_W=PF_W';
PF_H=xlsread(filepath,3,'N3:N17');        PF_H=PF_H';
PF_angle=xlsread(filepath,3,'R3:R17');    PF_angle=PF_angle';

PF_X=[PFcenter_R-PF_W/2;  PFcenter_R-PF_W/2;  PFcenter_R+PF_W/2;  PFcenter_R+PF_W/2;  PFcenter_R-PF_W/2;  ];
PF_Z=[PFcenter_Z-PF_H/2;  PFcenter_Z+PF_H/2;  PFcenter_Z+PF_H/2;  PFcenter_Z-PF_H/2;  PFcenter_Z-PF_H/2;  ];

tfcolor=[249 191 69]/255;
pfcolor=[247 92 47]/255;
mpcolor=[58 143 183]/255;

tf_handle=patch(TF_X,TF_Z,[1,1,0],'EdgeColor',tfcolor);

end