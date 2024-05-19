function [ret,noframes]=atsif_getnumberframes(source)

%AT_U32 ATSIF_GetNumberFrames(ATSIF_DataSource _source, AT_U32 * _ui_images)
%
%
%Description :	This function is used to retrieve the number of frames in the SIF file.
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
%
%Return		 :  ret    - Check the help for return code meanings
%               noframes - The number of frames in the SIF file
%

[ret,noframes] = atsifiomex('ATSIF_GetNumberFrames', source);