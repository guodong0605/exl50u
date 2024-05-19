function [lambda_Doppler] = TikeV2Doppler(Ti,amu,x0)
% TikeV2Doppler - calculate equivalent Doppler width
%
% TikeV2Doppler calculates for a given centre wavelength and atomic mass 
% unit the equivalent Doppler width, assuming a Gaussian spectral shape.
% 
% Note: The Doppler-width is not the same as the FWHM.
%       See also inverse function Doppler2TikeV which returns the equivalent 
%       ion temperature for a given Doppler width
%       
% Syntax:  [lambda_Doppler] = TikeV2Doppler(Ti,amu,x0);
%
% Input parameters:
%    ti   : local ion temperature (keV)
%    amu  : Atomic mass unit
%    x0   : central wavelength of CX spectrum (e.g. A)
%
% Output parameters:
% 	 lambda_Doppler : Doppler width in same units as centre wavelength  
%               
%
%% See also:


%% File Details
% Author:  <author , company>
% History: yyyy.mm.dd (authorId) <what has been done>
%
% 2010.01.22 (BMos) include of physics constants
%-------------------------------------------------------------------------%
%% Function body

% include of various physics constants

PROTON_MASS=1.672621637e-27;
SPEED_OF_LIGHT=2.99792458e8;
KEV=1.602176487e-16;
lambda_Doppler=x0*sqrt(2*Ti*KEV/amu/PROTON_MASS)/SPEED_OF_LIGHT;
% FWHM = sqrt(4*log(2))*lambda_Doppler;


end % TikeV2Doppler (end of function)
