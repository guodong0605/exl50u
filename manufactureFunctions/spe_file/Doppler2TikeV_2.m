function [TikeV] = Doppler2TikeV(lambda_Doppler,amu,x0)
% Doppler2TikeV - ion temperature from Doppler width, amu and wavelength
%
% calculates ion temperature from Doppler width,amu and wavelength
%  
% Syntax:  [TikeV] = Doppler2TikeV (lambda_Doppler,amu,x0)
%
% Input parameters:
%  lambda Doppler - doppler shift ( angstrom)
%  amu - Atomic mass of ion
%  x0  - wavelength ( angstrom)
%
% Output parameters:
%  TikeV    - Ion temperature(keV)
%               
%
%% See also: <otherfunctionName> , <yetAnotherFunc>


%% File Details
% Author:  <author , company>
% History: yyyy.mm.dd (authorId) <what has been done>
%
% 2010.01.22 (BMos) include of physics constants + header update.
%-------------------------------------------------------------------------%
%% Function body

% include of various physics constants
PROTON_MASS=1.672621637e-27;
SPEED_OF_LIGHT=2.99792458e8;
KEV=1.602176487e-16;
%
% c  =2.998e8;
% mp =1.673e-27;
% ek =1.602e-16;
TikeV= [lambda_Doppler/(7.68e-5*x0)]^2*amu/KEV;


end % Doppler2TikeV (end of function)
