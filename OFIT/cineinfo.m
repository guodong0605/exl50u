function info=cineinfo(camera,shotnum)
% This function is based on cine format of Phantom camera,
% cinefilename is the direction of cine file.
% varagin is the optional input parameter, Usually it should be {start_frame,end_frame},
% start and end time, if you just want the first frame to the end frame,just ignore it.
% flag is used to specifies wether you want to download frames (falg=1) or
% you just want  to get the information of current shot (flage=0);
% Edited by GuoDong 2020-03-27

% CAUTION   there are two cameras around EXL50
if camera==1
    camera='M150';
else
    camera='M60';
end

switch camera
    case 'M120'
        if shotnum>=15213
            cameraPath=['\\192.168.20.29\exl50-camera\',camera];
        else
            cameraPath=['\\192.168.20.25\exl50-camera\',camera];
        end
    case 'D240'
        if shotnum>=15130
            cameraPath=['\\192.168.20.29\exl50-camera\',camera];
        else
            cameraPath=['\\192.168.20.25\exl50-camera\',camera];
        end
    case 'M150'
            cameraPath='\\192.168.20.29\EXL50-Camera\M150';
    case 'M60'
            cameraPath='\\192.168.20.29\EXL50-Camera\M60';
end

%-------cine format------------------
%%
fileList = searchFiles(cameraPath, '.cine');
cinefilename=[];
for i = 1:length(fileList)
    temp=fileList{i};
    [~,filename]= fileparts(temp);
    cinenumber=str2double(filename(6:end));
    if shotnum==cinenumber
        cinefilename=temp;
        break;
    end
end

if isempty(cinefilename)
    msg=['There is No such a shotnum in database：',num2str(shotnum)];
    error(msg)
end

fid=fopen(cinefilename,'r');
cinefileheader={'Type','HeaderSize','Compression','Version','FirstMovieImage','TotalImageCount','FirstImageNo','ImageCount','OffImageHeader','OffSetup','OffImageOffsets'};
cinefileheader_pointer={'0000','0002','0004','0006','0008','000C','0010','0014','0018','001C','0020'};
cinefileheader_type={'uint16','uint16','uint16','uint16','int32','uint32','int32','uint32','uint32','uint32','uint32'};

bitmapinfoheader={'biSize','biWidth','biHeight','biPlanes','biBitCount','biCompression','biSizeImage','biXPelsPerMeter','c'};
bitmapinfoheader_pointer={'002C','0030','0034','0038','003A','003C','0040','0044','0048'};
bitmapinfoheader_type={'uint32','int32','int32','uint16','uint16','uint32','uint32','int32','int32'};

setup_name={'Length','FrameRate ','ImWidth','ImHeight','BlackLevel','WhiteLevel','LensAperture','LensFocusDistance','RealBPP','exposure'};
setup_pointer={'00E2','0354','0335','0337','16B8','16BC','17C0','17C4','03D4','0358'};
setup_type={'uint16','uint32','uint8','int32','uint32','uint16','uint16','int32','int32','uint32'};

for i=1:length(cinefileheader)
    fseek(fid, hex2dec(cinefileheader_pointer(i)), 'bof');
    temp1{i}=fread(fid, 1, cinefileheader_type{i});
end

for i=1:length(bitmapinfoheader)
    fseek(fid, hex2dec(bitmapinfoheader_pointer(i)), 'bof');
    temp2{i}=fread(fid, 1, bitmapinfoheader_type{i});
end

for i=1:length(setup_name)
    fseek(fid, hex2dec(setup_pointer(i)), 'bof');
    temp3{i}=fread(fid, 1, setup_type{i});
end
%%
info.FirstMovieImage=temp1{5};
info.TotalMovieImage=temp1{6};
info.FirstImage=temp1{7};
info.TotalImage=temp1{8};
info.EndImage=temp1{8}+temp1{7}-1;
info.Width=temp2{2};
info.Height=temp2{3};
info.biCompression=temp2{6};
info.biSizeImage=temp2{7};
info.biXPelsPerMeter=temp2{8};
info.biYPelsPerMeter=temp2{9};
info.FrameRate=temp3{2};
info.LensAperture=temp3{7};
info.LensFocusDistance=temp3{8};
info.RealBPP=temp3{9};
info.exposure=temp3{10};
info.name=cinefilename;
%%
end