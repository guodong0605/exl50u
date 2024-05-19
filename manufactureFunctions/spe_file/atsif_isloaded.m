function [ret,loaded] = atsif_isloaded()

%AT_U32 ATSIF_IsLoaded(AT_32 * _i_loaded)
%
%Description :	This function is used to determine if a SIF file is currently loaded.  
%                
%
%Arguments	 :  NONE
%
%Return		 :  ret    - Check the help for return code meanings
%               loaded - 1 if loaded, 0 if not
%

[ret,loaded] = atsifiomex('ATSIF_IsLoaded');