% Get indices of an area of interest (AOI) relative to a full frame (F)
%   [AOI_idx, AOI_out] = getAoiIndices (F, AOI_in)
%
%   Provides the indices of an area of interest (AOI) relative to a full frame
%   (F). 
%
%   Usage:
%   AOI_idx = getAoiIndices(F, AOI_in)
%   [AOI_idx, AOI_out] = getAoiIndices(F, AOI_in)
%
%   Example:
%   ...
%
% ------------------------------------------------------------------------------------
% INPUT VARIABLES:
% F                     : structure containing the information relative to the full frame
%    .Width             : width of the full frame
%    .Height            : height of the full frame
%    .FlipLR            : flip left-right flag of the full frame (or .ReverseX)
%    .FlipUD            : flip up-down flag of the full frame (or .ReverseY)
% AOI_in                : structure containing the information relative to the area of
%                         interest (AOI) in the GUI referential
%    .Width             : width of the AOI in the GUI referential
%    .Height            : height of the AOI in the GUI referential
%    .OffsetX           : horizontal offset of the AOI in the GUI referential (referred to
%                         0)
%    .OffsetY           : vertictal offset of the AOI in the GUI referential (referred to
%                         0)
% ------------------------------------------------------------------------------------
% OUTPUT VARIABLES:
% AOI_idx               : vector of indices corresponding to the AOI
% AOI_out               : structure containing the information relative to the area of
%                         interest (AOI) in the native referential
%    .Width             : width of the AOI in the native referential
%    .Height            : height of the AOI in the native referential
%    .OffsetX           : horizontal offset of the AOI in the native referential (referred
%                         to 0)
%    .OffsetY           : vertictal offset of the AOI in the native referential (referred
%                         to 0)
%    .FlipLR            : flip left-right flag of the AOI in the native referential
%                         (referred to 0)
%    .FlipUD            : flip up-down flag of the AOI in the native referential (referred
%                         to 0)
% ------------------------------------------------------------------------------------
% INTERNAL VARIABLES:
% AOI                   : structure containing the information relative to the area of
%                         interest (AOI) in the native referential
%    .Width             : width of the AOI in the native referential
%    .Height            : height of the AOI in the native referential
%    .OffsetXG          : horizontal offset of the AOI in the GUI referential (referred
%                         to 0)
%    .OffsetYG          : vertictal offset of the AOI in the GUI referential (referred
%                         to 0)
%    .FlipLR            : flip left-right flag of the AOI in the native referential
%                         (referred to 0)
%    .FlipUD            : flip up-down flag of the AOI in the native referential (referred
%                         to 0)
%    .OffsetXN          : horizontal offset of the AOI in the native referential (referred
%                         to 0)
%    .OffsetYN          : vertictal offset of the AOI in the native referential (referred
%                         to 0)
%    .IndexN            : vector of the indices of the AOI in the native referential
%    .xN                : vector of the columns of the AOI in the native referential
%    .yN                : vector of the rows of the AOI in the native referential
% F                     : structure containing the information relative to the full frame
%    .IndexN            : vector of the indices of the AOI in the native referential
%    .xN                : vector of the columns of the AOI in the native referential
%    .yN                : vector of the rows of the AOI in the native referential
% ------------------------------------------------------------------------------------
%