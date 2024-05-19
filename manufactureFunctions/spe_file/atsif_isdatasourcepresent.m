function [ret,present]=atsif_isdatasourcepresent(source)

%AT_U32 ATSIF_IsDataSourcePresent(ATSIF_DataSource _source, AT_32 *_i_present)
%
%Description :	This function is used to determine if a particular data source is present 
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
%               prsent - 1 if prsent, 0 if not
%

[ret,present] = atsifiomex('ATSIF_IsDataSourcePresent', source);