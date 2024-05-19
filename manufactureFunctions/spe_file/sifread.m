
% Read SIF data and all properties
%example:[data_arr, sif_properties, xaxis, yaxis, zaxis] = sifread('E:\新奥工作\诊断项目\诊断类\EUV VUV诊断\数据处理\matlab\SIFREAD--read sif document\420.sif');
%多帧example: [data_arr, sif_properties, xaxis, yaxis, zaxis] =sifread('E:\A-EXL-50U matlab\EUVandVUV\VUVdata\02261.sif'); 路径不要带中文
function [data_arr,sif_properties,xaxis,yaxis,zaxis] = sifread(FileName,varargin)
sifobj = 0;

%atsif_readfromfile('D:\2261.sif');  % This function is used  to open a SIF file where the file name and path are contained
atsif_readfromfile(FileName);  % This function is used  to open a SIF file where the file name and path are contained
property_names=...
                {'Type'   'Active'   'Version'   'Time'   'FormattedTime'   'FileName'   ...
                'Temperature'   'SIDisplacement'   'TriggerLevel'   'Operation'  ...
                'UnstabalizedTemperature'   'Head'   'HeadModel'   'StoreType'   'DataType'   ...
                'SINumberSubFrames'   'PixelReadOutTime'   'TrackHeight'   'ReadPattern'...
                'ReadPatternFullName'   'ShutterDelay'   'CentreRow'   'RowOffset'   ...
                'Mode'   'ModeFullName'   'TriggerSource'   'TriggerSourceFullName'   ...
                'ExposureTime'   'Delay'   'IntegrationCycleTime'   'NumberIntegrations'...
                'KineticCycleTime'   'FlipX'   'FlipY'   'Clock'   'AClock'   'IOC'   'Frequency'...
                'NumberPulses'   'FrameTransferAcquisitionMode'   'BaselineClamp'...
                'PreScan'   'EMRealGain'   'BaselineOffset'   'SWVersion'   'SWVersionEx'...
                'MCP'   'Gain'   'VerticalClockAmp'   'VerticalShiftSpeed'   'OutputAmplifier'...
                'PreAmplifierGain'   'Serial'   'DetectorFormatX'   'DetectorFormatZ'...
                'NumberImages'   'NumberSubImages'   'SubImageHBin'   'SubImageVBin'...
                'SubImageLeft'   'SubImageRight'   'SubImageTop'   'SubImageBottom'...
                'Baseline'   'CCDLeft'   'CCDRight'   'CCDTop'   'CCDBottom'   'Sensitivity'...
                'DetectionWavelength'   'CountConvertMode' 'IsCountConvert'...
                'XAxisType'   'XAxisUnit'   'YAxisType'   'YAxisUnit'   'ZAxisType'   'ZAxisUnit'...
                'UserText'   'IsPhotonCountingEnabled'   'NumberThresholds'   'Threshold1'...
                'Threshold2'   'Threshold3'   'Threshold4'   'AveragingFilterMode'...
                'AveragingFactor'   'FrameCount'   'NoiseFilter'   'Threshold'...
                'TimeStamp', 'OutputAEnabled', 'OutputAWidth', 'OutputADelay', 'OutputAPolarity',...
                 'OutputBEnabled', 'OutputBWidth', 'OutputBDelay', 'OutputBPolarity',...
                 'OutputCEnabled', 'OutputCWidth', 'OutputCDelay', 'OutputCPolarity',...
                 'GateMode', 'GateWidth', 'GateDelay', 'GateDelayStep', 'GateWidthStep'};

sif_properties=struct();
for i=1:length(property_names)    
    [~,sif_properties.(property_names{i})]=atsif_getpropertyvalue(sifobj,property_names{i});
%show all property values
%     disp([property_names{i},': ',property_values{i}])    
end

imagesize=[(str2double(sif_properties.SubImageRight)-str2double(sif_properties.SubImageLeft)+1)/...
    str2double(sif_properties.SubImageHBin),...
    (str2double(sif_properties.SubImageTop)-str2double(sif_properties.SubImageBottom)+1)/...
    str2double(sif_properties.SubImageVBin)];
if str2double(sif_properties.NumberSubImages)~=1
    if (-str2double(sif_properties.SubImageLeft)+str2double(sif_properties.SubImageRight)+1)...
            ==str2double(sif_properties.DetectorFormatX)
        imagesize(2)=imagesize(2)*str2double(sif_properties.NumberSubImages);        
    else
        warning('Unexpected subimage mode!')
    end

end
sif_properties.subimageinfo=nan(str2double(sif_properties.NumberSubImages),6);
for j=1:(str2double(sif_properties.NumberSubImages)) 
    [~,left,bottom,right,top,hBin,vBin]=atsif_getsubimageinfo(sifobj,j-1);
    sif_properties.subimageinfo(j,:)=[left,bottom,right,top,hBin,vBin];
end

frame_num=str2double(sif_properties.NumberImages);

if sum(cellfun(@(x)strcmpi(x,'no data'),varargin))
    data_arr=[];
else
    [~,data_arr]=atsif_getallframes(sifobj, prod([imagesize,frame_num]));
    data_arr=double(reshape(data_arr,[imagesize,frame_num]));
    data_arr=permute(data_arr,[2,1,3]);
end
% xaxis=zeros(1,imagesize(1));
xaxis=sif_properties.subimageinfo(1,1):sif_properties.subimageinfo(1,5):sif_properties.subimageinfo(1,3);
yaxis=[];
for j=1:(str2double(sif_properties.NumberSubImages)) 
    yaxis=[yaxis,sif_properties.subimageinfo(j,2)+(sif_properties.subimageinfo(j,6)-1)/2:...
        sif_properties.subimageinfo(j,6):sif_properties.subimageinfo(j,4)];%#ok  
    if ~isequal(xaxis,sif_properties.subimageinfo(1,1):sif_properties.subimageinfo(1,5):sif_properties.subimageinfo(1,3))
        error('different xaxis in one image?')
    end
end
    
zaxis=1:frame_num;

xaxis=getpixelcalibration(sifobj, 0,xaxis);
yaxis=getpixelcalibration(sifobj, 1,yaxis);
zaxis=getpixelcalibration(sifobj, 2,zaxis);

atsif_closefile; % close the opened file.

end


function [xyzaxisout]=getpixelcalibration(sifobj,dim,xyzaxis)
xyzaxisout=nan(size(xyzaxis));
for ind=1:length(xyzaxis)
    i=xyzaxis(ind);
    if round(i)==i
        [~,xyzaxisout(ind)]=atsif_getpixelcalibration(sifobj, dim, i);
    else
        [~,tmp0]=atsif_getpixelcalibration(sifobj, dim, floor(i));
        [~,tmp1]=atsif_getpixelcalibration(sifobj, dim, ceil(i));
        xyzaxisout(ind)=interp1([floor(i),ceil(i)],[tmp0,tmp1],i);
    end
end
end
 %xqf 编写
