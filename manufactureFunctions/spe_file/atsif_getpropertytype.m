function [ret,type]=atsif_getpropertytype(source, propName)

%AT_U32 ATSIF_GetPropertyType(ATSIF_DataSource _source, const AT_C * _sz_propertyName,
%                             ATSIF_PropertyType * _propertyType)
%
%
%Description :	This function is used to determine the type of each property.
%               The data source is selected using the ATSIF_DataSource 
%               enumeration which has the following values:-
%
%               0 - Signal
%               1 - Reference
%               2 - Background
%               3 - Live
%               4 - Source 
%
%Arguments	 :  source   - The enumeration for selecting the SIF file data source
%               propName - The selected property chosen from the list of property types
%
%               Available Properties:
%
%                 'Type'   'Active'   'Version'   'Time'   'FormattedTime'   'FileName'   
%                 'Temperature'   'SIDisplacement'   'TriggerLevel'   'Operation'  
%                 'UnstabalizedTemperature'   'Head'   'HeadModel'   'StoreType'   'DataType'   
%                 'SINumberSubFrames'   'PixelReadOutTime'   'TrackHeight'   'ReadPattern'
%                 'ReadPatternFullName'   'ShutterDelay'   'CentreRow'   'RowOffset'   
%                 'Mode'   'ModeFullName'   'TriggerSource'   'TriggerSourceFullName'   
%                 'ExposureTime'   'Delay'   'IntegrationCycleTime'   'NumberIntegrations'
%                 'KineticCycleTime'   'FlipX'   'FlipY'   'Clock'   'AClock'   'IOC'   'Frequency'
%                 'NumberPulses'   'FrameTransferAcquisitionMode'   'BaselineClamp'
%                 'PreScan'   'EMRealGain'   'BaselineOffset'   'SWVersion'   'SWVersionEx'
%                 'MCP'   'Gain'   'VerticalClockAmp'   'VerticalShiftSpeed'   'OutputAmplifier'
%                 'PreAmplifierGain'   'Serial'   'DetectorFormatX'   'DetectorFormatZ'
%                 'NumberImages'   'NumberSubImages'   'SubImageHBin'   'SubImageVBin'
%                 'SubImageLeft'   'SubImageRight'   'SubImageTop'   'SubImageBottom'
%                 'Baseline'   'CCDLeft'   'CCDRight'   'CCDTop'   'CCDBottom'   'Sensitivity'
%                 'DetectionWavelength'   'CountConvertMode''IsCountConvert'
%                 'XAxisType'   'XAxisUnit'   'YAxisType'   'YAxisUnit'   'ZAxisType'   'ZAxisUnit'
%                 'UserText'   'IsPhotonCountingEnabled'   'NumberThresholds'   'Threshold1'
%                 'Threshold2'   'Threshold3'   'Threshold4'   'AveragingFilterMode'
%                 'AveragingFactor'   'FrameCount'   'NoiseFilter'   'Threshold'
%                 'TimeStamp'
%                  To retrieve the time stamp information create the property name like so:
%                   'TimeStamp 0' will return the first frame time stamp (0 based index)
%                   'TimeStamp n-1' will return the nth frame time stamp
%
%Return		 :  ret      - Check the help for return code meanings
%               propType -  The type of the property :
%                            0 - char
%                            1 - unsigned char
%                            2 - int32
%                            3 - unsigned int32
%                            6 - float
%                            7 - double
%                            8 - string

[ret,propType] = atsifiomex('ATSIF_GetPropertyType', source, propName);