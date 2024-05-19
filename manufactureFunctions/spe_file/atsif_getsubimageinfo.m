function [ret,left,bottom,right,top,hBin,vBin]=atsif_getsubimageinfo(source, index)

%AT_U32 ATSIF_GetSubImageInfo(ATSIF_DataSource _source, AT_U32 _ui_index, AT_U32 * _ui_left,
%                             AT_U32 * _ui_bottom,AT_U32 * _ui_right, AT_U32 * _ui_top,
%                             AT_U32 * _ui_hBin, AT_U32 * _ui_vBin)
%
%
%Description :	This function is used to retrieve the information about each sub-image in 
%               the SIF file. The data source is selected using the ATSIF_DataSource 
%               enumeration which has the following values:-
%
%               0 - Signal
%               1 - Reference
%               2 - Background
%               3 - Live
%               4 - Source 
%
%Arguments	 :  source - The enumeration for selecting the SIF file data source
%               index  - The sub-image index
%
%Return		 :  ret    - Check the help for return code meanings
%               left   - The left coordinate of the sub-image
%               bottom - The bottom coordinate of the sub-image
%               right  - The right coordinate of the sub-image
%               top    - The top coordinate of the sub-image
%               hBin   - The horizontal binning used in the selected sub-image
%               vBin   - The vertical binning used in the selected sub-image
%

[ret,left,bottom,right,top,hBin,vBin] = atsifiomex('ATSIF_GetSubImageInfo', source, index);