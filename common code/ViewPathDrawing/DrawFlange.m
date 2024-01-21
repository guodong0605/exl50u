function flange_handle=DrawFlange(filepath,windownum)
%%
S1out_X=xlsread(filepath,4,'B19:B26');
S1out_Z=xlsread(filepath,4,'C19:C26');

S2out_X=xlsread(filepath,4,'B27:B34');
S2out_Z=xlsread(filepath,4,'C27:C34');

S3out_X=xlsread(filepath,4,'B35:B42');
S3out_Z=xlsread(filepath,4,'C35:C42');

S1in_X=xlsread(filepath,4,'D19:D26');
S1in_Z=xlsread(filepath,4,'E19:E26');

S2in_X=xlsread(filepath,4,'D27:D34');
S2in_Z=xlsread(filepath,4,'E27:E34');

S3in_X=xlsread(filepath,4,'D35:D42');
S3in_Z=xlsread(filepath,4,'E35:E42');

U1out_X=xlsread(filepath,4,'B11:B18');
U1out_Z=xlsread(filepath,4,'C11:C18');
U1in_X=xlsread(filepath,4,'D11:D14');
U1in_Z=xlsread(filepath,4,'E11:E14');

U2out_80_X=xlsread(filepath,4,'B3:B10');
U2out_80_Z=xlsread(filepath,4,'C3:C10');
U2in_80_X=xlsread(filepath,4,'D3:D6');
U2in_80_Z=xlsread(filepath,4,'E3:E6');

U2out_150_X=xlsread(filepath,4,'F3:F10');
U2out_150_Z=xlsread(filepath,4,'G3:G10');
U2in_150_X=xlsread(filepath,4,'H3:H6');
U2in_150_Z=xlsread(filepath,4,'I3:I6');

%%
flange_handle{1}=patch(S1out_X/1e3,S1out_Z/1e3,'k');
flange_handle{2}=patch(S2out_X/1e3,S2out_Z/1e3,'k');
flange_handle{3}=patch(S3out_X/1e3,S3out_Z/1e3,'k');
flange_handle{4}=patch(S1in_X/1e3,S1in_Z/1e3,'w','EdgeColor','w');
flange_handle{5}=patch(S2in_X/1e3,S2in_Z/1e3,'w','EdgeColor','w');
flange_handle{6}=patch(S3in_X/1e3,S3in_Z/1e3,'w','EdgeColor','w');
%-----------------------------------
flange_handle{7}=patch(U1out_X/1e3,U1out_Z/1e3,'k');
flange_handle{8}=patch(U1in_X/1e3,U1in_Z/1e3,'w','EdgeColor','w');



CF150=[0,60,300];
CF350=[0,90,180,270];

if ismember(windownum,CF150)
    flange_handle{9}=patch(U2out_150_X/1e3,U2out_150_Z/1e3,'k');
    flange_handle{10}=patch(U2in_150_X/1e3,U2in_150_Z/1e3,'w','EdgeColor','w');

    flange_handle{11}=patch(U2out_150_X/1e3,-U2out_150_Z/1e3,'k');
    flange_handle{12}=patch(U2in_150_X/1e3,-U2in_150_Z/1e3,'w','EdgeColor','w');
else

    flange_handle{9}=patch(U2out_80_X/1e3,U2out_80_Z/1e3,'k');
    flange_handle{10}=patch(U2in_80_X/1e3,U2in_80_Z/1e3,'w','EdgeColor','w');

    flange_handle{11}=patch(U2out_80_X/1e3,-U2out_80_Z/1e3,'k');
    flange_handle{12}=patch(U2in_80_X/1e3,-U2in_80_Z/1e3,'w','EdgeColor','w');

end
if ~ismember(windownum,CF350)
    flange_handle{13}=patch(U1out_X/1e3,-U1out_Z/1e3,'k');
    flange_handle{14}=patch(U1in_X/1e3,-U1in_Z/1e3,'w','EdgeColor','w');
end

end