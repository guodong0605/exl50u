% Write a frame sequence to file(s) in the Telops IRCam format (.hcc).
%
%   n_writeIRCam(Header,Data,filename,Nframes_per_file,SaturatedPixels,BadPixels)
%
%   Write a frame sequence to a single file or to a sequence of files using the Telops
%   infrared camera format.
%
%   The pixel values must be along columns. To obtain such an array from a 3D matrix
%   with dimensions (NFrames,Width,Height), one must reshape the Data like this:
%        Data = unfoldImage(Header(1), Data_im);
%
%   [...] = n_writeIRCam(..., 'Param1', value1, 'Param2', value2, ...) uses
%   parameter-value pairs to control the writing operation.
%
%       Parameter name   Value
%       --------------   -----
%       'PixelMapping'   The method used to map the (real) pixel values to uint16 format
%                        in the binary image part of the .hcc file. Possible methods are:
%                        'AutomaticImage' (adjusted individually for each image),
%                        'AutomaticSequence' (adjusted globally for the whole sequence)
%                        and 'Fixed' (taken from the image header). The default value is
%                        'AutomaticImage'.
%
%   INPUTS
%       Header : vector of header structures in the IRCam format
%       Data   : (num frames, Width x Height) matrix of data to write
%       Nframes_per_file [optional]
%              : specifies the number of frames to write per file; if > 1, files will be
%                appended with a sequence number
%       SaturatedPixels [optional]
%              : logical matrix (same size as "Data") of saturation statuses, only
%                available for XML >= 10; their value is forced to xFFFF; if not supplied,
%                no pixel is considered saturated 
%       BadPixels [optional]
%              : logical matrix (same size as "Data") of bad pixels statuses, only
%                available for XML >= 10; their value is forced to xFFFE when header field
%                "BPRApplied" is false; if not supplied, all nans are still considered bad
%                pixels
%