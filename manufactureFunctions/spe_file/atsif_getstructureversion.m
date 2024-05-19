function [ret,versH,versL]=atsif_getstructureversion(element)

%AT_U32 ATSIF_GetStructureVersion(ATSIF_StructureElement _element, 
%                                 AT_U32 * _ui_versionHigh, AT_U32 * _ui_versionLow)
%
%
%Description :	This function is used to retrieve the version of each structure element 
%               in the SIF file.  The structure element is selected using the 
%               ATSIF_StructureElement enumeration which has the following values:-
%
%               0 - File
%               1 - Insta
%               2 - Calib
%               3 - Andor
%
%Arguments	 :  element - The enumeration for selecting the SIF file structure element
%
%Return		 :  ret    - Check the help for return code meanings
%               versH  - The high component of the version number
%               versL  - The low component of the version number
%

[ret,versH,versL] = atsifiomex('ATSIF_GetStructureVersion', element);