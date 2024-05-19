function ret=atsif_readfromfile(filename)

%AT_U32 ATSIF_ReadFromFile(AT_C * _sz_filename)
%
%Description :	This function is used to open a SIF file where the file name and path 
%               are contained in the character array _sz_filename.
%
%Arguments	 :  string containing the file path
%
%Return		 :  Check the help for return code meanings
%
%Note	     :  If the file is opened with an access mode of ATSIF_ReadAll then ATSIF_CloseFile 
%               must be called to free access to the file.

ret = atsifiomex('ATSIF_ReadFromFile',filename);