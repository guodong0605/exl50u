function ret=atsif_closefile()

%AT_U32 ATSIF_CloseFile()
%
%Description :	This function is used to close the currently opened  SIF file.  
%               This should be called whenever the SIF has been opened using the 
%               ATSIF_ReadAll enumeration and is no longer needed by the calling program. 
%
%Arguments	 :  NONE
%
%Return		 :  Check the help for return code meanings
%

ret = atsifiomex('ATSIF_CloseFile');