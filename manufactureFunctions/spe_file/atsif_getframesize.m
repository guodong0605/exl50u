function [ret,size]=atsif_getframesize(source)

%AT_U32 ATSIF_GetFrameSize(ATSIF_DataSource _source, AT_U32 * _ui_size)
%
%
%Description :	This function is used to retrieve the number of pixels in each frame 
%               in the SIF file.  The data source is selected using the ATSIF_DataSource 
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
%               size   - The number of pixels in each frame in the SIF file
%

[ret,size] = atsifiomex('ATSIF_GetFrameSize', source);