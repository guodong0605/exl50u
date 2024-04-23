% Merge data of a Telops IRCam EHDRI sequence or HDRFW sequence into a 
% high dynamic range single channel sequence
%
%   The sequence may contain many .hcc files. 
%
% EXAMPLE
%   mergeHdrSequence('FullSequenceName', 'D:\EHDRISequence\')
%   mergeHdrSequence('FullSequenceName', 'D:\EHDRISequence\', ...
%       'FullMergedSequenceName', 'D:\NewSequenceName')
%   mergeHdrSequence('FullSequenceName', 'D:\HDRFWSequence\', ...
%       'ParameterFile', 'D:\Test\parameterFileExemple.xml')
%   mergeHdrSequence('FullSequenceName', 'D:\HDRFWSequence\', ...
%       'ParameterFile', 'D:\Test\parameterFileExemple.xml', ...
%       'SpatialFiltering',true,'SpatialFilterLevel',2)  
%   mergeHdrSequence('FullSequenceName', 'D:\EHDRISequence\', ...
%       'TimeFiltering',true,'TimeFilterLevel',1)
%
% PARAMETERS/VALUES PAIRS
%  FullSequenceName       : complete name of the sequence to be merged 
%  FullMergedSequenceName : complete name of the merged sequence (default 
%                           is "FullSequenceName" suffixed with 
%                           '_EHDRIMerged' or HDRFWMerged)
%  ParameterFile          : path to the parameter file required for HDRFW 
%                           sequence   
%
% Optional Parameters
% SpatialFiltering : apply spatial filtering (default false)
% SpatialFilterLevel : Level of filtering (default 1) allowed value are
% integer from 1 to 4
% TimeFiltering : apply temporal filtering (default false)
% TimeFilterLevel : Level of filtering (default 1) allowed value are
% integer from 1 to 5
% The user may enable time filtering and/or spatial filtering to reduce
% artefacts caused by scene dynamics. 
%