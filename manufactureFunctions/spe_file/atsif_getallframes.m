function [ret,data]=atsif_getallframes(source, size)

%AT_U32 ATSIF_GetAllFrames(ATSIF_DataSource _source, float * _pf_data, AT_U32 _ui_bufferSize)
%
%
%Description :	This function is used to retrieve all the frames of data in the SIF file.
%               The data source is selected using the ATSIF_DataSource 
%               enumeration which has the following values:-
%
%               0 - Signal
%               1 - Reference
%               2 - Background
%               3 - Live
%               4 - Source 
%
%Arguments	 :  source - The enumeration for selecting the SIF file data source
%               size   - The number of pixels in the float array
%
%Return		 :  ret    - Check the help for return code meanings
%               data   - The array of float data containing all frames in the SIF file
%

[ret,data] = atsifiomex('ATSIF_GetAllFrames', source, size);