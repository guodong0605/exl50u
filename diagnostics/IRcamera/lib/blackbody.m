% Radiance of a black body.
%	x = blackbody(sigma,T) gives the radiance [watt/m^2 cm^-1 sr] of a black
%       body at wavenumber SIGMA [cm^-1] and temperature T [K].
%
%   x = blackbody(sigma,T,units) returns the radiance in the
%   specified units. NOT YET IMPLEMENTED.
%
%	The size of X is the common size of the input arguments. A scalar input
%	functions as a constant matrix of the same size as the other inputs.
%
%   INPUTS
%       sigma: spectral grid, Nx1. Units are the same as 'unit' input parameter.
%              (defaults to 'cm^-1')
%       T: blackbody temperature, 1xM row vector, [K].
%       units: parameter-value pair identifying how to return the quantities.
%               Ex. blackbody(sigma,T,'units','um'),
%                   blackbody(sigma,T,'units','cm^-1') [default]
%
%   OUTPUTS
%       x: NxM vector in radiance units according to that of the spectral grid.
%
%	Default values for T is 273.15.
%