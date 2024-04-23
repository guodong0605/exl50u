% Form a correctly oriented 2D image from its 1D vector version for imagesc.
%   img_2D = formImage(OP, img_1D)
%
% INPUTS:
%   OP     : a structure with the following fields: .Width, .Height, .FlipLR,
%            .FlipUD (or .ReverseX and .ReverseY)
%   img_1D : a NxM data matrix with spatial data along its 2nd dimension (M=HxW)
%
% OUTPUT:
%   img_2D : a HxWxN image array; if N==1, returns a HxW image
%