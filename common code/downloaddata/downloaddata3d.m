function outputData = downloaddata3d(shotnum, type,t1,t2,dframe,isframe,img_filter)
% DOWNLOADDATA3D Retrieves diagnostic data based on shot number and diagnostic type
% Input:
%   shotnum - The shot number to retrieve
%   type    - The type of diagnostics ('VUV', 'vis', 'cxrs', etc.)

% Convert type to lowercase to handle case-insensitive input
if nargin<4 t2=t1; end
if nargin<5 dframe=1; end
if nargin<6 isframe=1; end
if nargin<7 imf_filter=1; end

type = lower(type);

% Determine the file path and output description based on the type of diagnostics
switch type
    case 'euvl'
        filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\EUV\EUVL';
        outputData.description = 'VUV diagnostics to measure the';
        fileExtension = '.SIF';
        fileflag = 1;
        triggerTime=0;
    case 'euvs'
        filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\EUV\EUVL';
        outputData.description = 'VUV diagnostics to measure the';
        fileExtension = '.SIF';
        fileflag = 1;
        triggerTime=0;
    case 'vuv'
        filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\VUV';
        outputData.description = 'VUV diagnostics to measure the';
        fileExtension = '.SIF';
        fileflag = 1;
        triggerTime=0;
    case 'vis'
        filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\Visible_Spectrometer\data';
        outputData.description = 'VIS diagnostics to measure the';
        fileExtension = '.sif';
        fileflag = 1;
        triggerTime=0;
    case 'cxrs'
        filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\Visible Spectrometer\data';
        outputData.description = 'CXRS diagnostics to measure the';
        fileExtension = '.spe';
        fileflag = 2;
        triggerTime=0;
    case 'm60'
        filepath = '\\192.168.20.29\EXL50-Camera\M60';
        outputData.description = 'Visible camera installed on mid-plane of 60 degree';
        fileExtension = '.cine';
        fileflag = 3;
        triggerTime=-0.5;
    case 'm150'
        filepath = '\\192.168.20.29\EXL50-Camera\M150';
        outputData.description = 'Visible camera installed on mid-plane of 150 degree';
        fileExtension = '.cine';
        fileflag = 3;
        triggerTime=-0.5;
    case 'irc'
        try 
        cameraPath = '\\192.168.20.29\EXL50-Camera\exl50u\IRC-S2-150\';
        shotDate=shotdate(shotnum); %通过日期判断存放文件夹
        if shotnum<1e4
            shotname=[num2str(shotDate),'\0',num2str(shotnum),'\','0',num2str(shotnum),'.hcc'];
        else
            shotname=['\',num2str(shotnum),'\',num2str(shotnum),'.hcc']; %构建文件存储路径
        end
        filepath=[cameraPath,shotname];
        outputData.description = 'infrared camera installed on mid-plane of 150 degree ';
        fileExtension = '.hcc';
        fileflag = 4;
        triggerTime=-0.5;
        found=true;
        catch
            found = false;
        end
    otherwise
        error('Unsupported diagnostic type.');
end

if fileflag<4
    % Search for files with the specified extension in the determined directory
    fileList = searchFiles(filepath, fileExtension);
    % Initialize variable to track if a matching file is found
    found = false;
    % Find the file corresponding to the given shot number
    for i = 1:length(fileList)
        [~, filename] = fileparts(fileList{i});
        switch fileflag
            case 1|| 2
                sifnumber = str2double(filename);
            case 3
                sifnumber = str2double(filename(6:end));
        end
        if isnan(sifnumber)
            sifnumber = 0; % Handle cases where conversion fails
        end
        if shotnum == sifnumber
            filepath = fileList{i};
            found = true;
            break;
        end
    end
end
% Check if file was found; if not, throw an error and exit
if ~found
    error('No corresponding file found in NAS database. Please check.');
end

% Read data from the file
switch fileflag
    case 1
        [data_arr, sif_properties, xaxis, yaxis, zaxis] = sifread(filepath);
        exposuretime=sif_properties.ExposureTime;
        delay=sif_properties.Delay;
        timeseies=1:size(data_arr,3);
        time=(triggerTime+str2double(exposuretime))/2+timeseies*str2double(delay);
        % Find the nearest indices for t1 and t2
        [~, t1Index] = min(abs(time - t1));
        [~, t2Index] = min(abs(time - t2));
        outputData.value = data_arr(:,:,t1Index:dframe:t2Index);
        outputData.time=time(t1Index:dframe:t2Index);
        outputData.Xaxis = xaxis;
        outputData.XaxisUnit = 'nm';
        outputData.Yaxis = yaxis;
        outputData.YaxisUnit = 'Count';
        outputData.Zaxis = zaxis;
        outputData.ZaxisUnit = 'Frame';
        outputData.info=sif_properties;
    case 2
        sp = loadSPE(filepath);
        outputData.Value = sp.int; % Extract all data
        outputData.wave = sp.wavelength;
    case 3
        [info,picture,t]=readcine(filepath,t1,t2,dframe,isframe);
        outputData.value=picture;
        outputData.time=t;
        outputData.info=info;
        outputData.Xaxis = (-1280/2:1280/2)*3.215/1e3;
        outputData.XaxisUnit = 'mm';
        outputData.Yaxis =  (-400/2:400/2)*3.215/1e3;
        outputData.YaxisUnit = 'mm';
        outputData.Zaxis = picture;
        outputData.ZaxisUnit = 'Frame';
    case 4
        dt=0.5;
        [IRdata,time,info]=readhcc(filepath,t1+dt,t2+dt,dframe,isframe);
        Xpixel=4.78;
        Ypixel=4.78;
        Xcenter=327;
        Ycenter=260;
        R1=linspace(-Xcenter*Xpixel/1e3,(info.width-Xcenter)*Xpixel/1e3,size(IRdata,2));
        Z1=linspace(-Ycenter*Ypixel/1e3,(info.height-Ycenter)*Ypixel/1e3,size(IRdata,1));

        outputData.value=IRdata;
        outputData.time=time;
        outputData.info=info;
        outputData.Xaxis = R1;
        outputData.XaxisUnit = 'mm';
        outputData.Yaxis =  Z1;
        outputData.YaxisUnit = 'mm';
        outputData.Zaxis = IRdata;
        outputData.ZaxisUnit = '\degree';

end


end
