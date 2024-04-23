% Unfold a formImage()'d image using to the original 1D orientation
%   img_1D = unfoldImage(OP, img_2D)
%
%  This function perform the exact inverse of formImage().
%
% INPUTS:
%   OP     : a structure with the following fields: .Width, .Height, .FlipLR,
%            .FlipUD (or .ReverseX and .ReverseY)
%   img_2D : an image matrix as returned by formImage().
%
% OUTPUT:
%   img_1D : a NxM data matrix with spatial data along its 2nd dimension (M=HxW)
%