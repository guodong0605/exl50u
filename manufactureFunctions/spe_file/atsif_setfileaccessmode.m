function ret=atsif_setfileaccessmode(readmode)

%AT_U32 ATSIF_SetFileAccessMode(ATSIF_ReadMode _mode)
%
%Description :	This function is used to select if the entire SIF file should be read 
%               or just the header section.  The read mode determines if the whole file 
%               or just the header information is read.
%
%Arguments	 : 0 - Read all
%              1 - Header Only
%
%Return		 : Check the help for return code meanings

ret = atsifiomex('ATSIF_SetFileAccessMode',readmode);