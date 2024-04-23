% readIRCam Image sequence reader for Telops infrared camera files (.hcc).
%
%   Data = readIRCam(filename,varargin) reads a single file, or a sequence of files, as
%   output from Telops infrared cameras. Data is an array of frames containing pixel
%   values along columns (<NFrames x NPixels>).
%
%   [...,Header] = readIRCam(...) also reads image headers, each frame having its own
%   header.
%
%   To obtain a rectangular matrix for imaging purposes, one should reshape
%   "Data" like this:
%        Data_im = reshape(Data, [], Header(1).Width, Header(1).Height);
%   or simply
%        Data_im = formImage(Header(1), Data);
%   A 3D matrix with dimensions (NFrames,Width,Height) is returned.
%
%   [...,SaturatedPixels,BadPixels] = readIRCam(...) enables to
%   extract supplementary parameters about frame validity, and identification of saturated
%   or bad pixels.
%
%   [...] = readIRCam(..., 'Param1', value1, 'Param2', value2, ...) uses parameter-value
%   pairs to control the reading operation.
%
%       Parameter name   Value
%       --------------   -----
%       'Peek'           A logical value. If true, "Data" is replaced by the number of
%                        frames contained within the sequence "filename". When the
%                        sequence includes multiple files, "Data" returns a vector of the
%                        number of frames of each file. "Header" (if required) contains
%                        the header of the first frame of the sequence.
%                        The default value is false.
%
%       'HeadersOnly'    A logical value. If true, only the frame headers are read.
%                        The default value is false.
%
%       'Frames'         A single non-negative integer value, or list of values, stating
%                        the specific frames that have to read.
%                        The default value is all frames.
%
%       'Rows'           A single non-negative integer value, or list of values, stating
%                        the specific rows that have to read.
%                        The default value is all rows.
%
%       'SPAssignment'   The method used to assign a value to each saturated pixel. The
%                        possible methods are: 'max', 'median' and 'nan'.
%                        Only available for XML >= 10.
%                        The default method is 'max'.
%
%       'BPAssignment'   The method used to assign a value to each bad pixel. The possible
%                        methods are: 'median' and 'nan'.
%                        Only available for XML >= 10.
%                        The default method is 'median'.
%
%   INPUT
%       filename : a string pointing to a single file or to a set of files with
%                  a common name (e.g. 'path_to_file/filename.hcc' or
%                  'path_to_file/commonname*.hcc'), it may also be a cell array of strings
%                  (e.g. {'filename1.hcc', 'filename2*.hcc'})
%
%   OUTPUT
%       Data : pixel data
%              - <NFrames, Width x Height> array by default
%              - <NFrames, NRows x Height> array when specific 'Rows' are requested
%              - empty array when only 'HeadersOnly' is requested
%       Header : a vector of <Nframes x 1> header structures, one for each decoded frame
%       specialPixelMap : Map of the special pixels with the corresponding
%       code
%       specialNonBadPixelMap : Map of the special pixel after bad pixel
%       replacement
%       The special pixel code are : 
%       LowerDigitalSaturation = 1;
%       UpperDigitalSaturation = 2;
%       SpecialTag3 = 3;
%       SpecialTag4 = 4;
%       SpecialTag5 = 5;
%       SpecialTag6 = 6;
%       SpecialTag7 = 7;
%       SpecialTag8 = 8;
%       SpecialTag9 = 9;
%       BlankImageTranslation = 10;
%       BadEmissivityCorrection = 11;
%       UnderCalibrationRange = 12;
%       OverCalibrationRange = 13;
%       BadPixelTag = 14;          % Code de pixel d閒ectueux
%       SaturatedPixelTag = 15;    % Code de pixel satur�
%
%   USAGE
%       readIRCam(filename) % all frames, all rows
%
%       readIRCam(filename, 'HeadersOnly', true) % read headers only
%
%       readIRCam(filename, 'HeadersOnly', true, 'Frames', 11:20) % headers only, frames 11 to 20
%
%       readIRCam(filename, 'Frames', 1:2:10) % 5 frames, skip one frame between readouts
%
%       readIRCam(filename, 'Frames', 100, 'Rows', 10:20) % only frame 100, rows 10 through 20
%
%       readIRCam(filename, 'Rows', 10) % all frames, row 10 only
%
%       N = readIRCam(filename, 'Peek') % number of frames in the sequence
%
%       readIRCam(..., 'SPAssignment', 'nan') % all saturated pixels are assigned to "nan"
%
%       readIRCam(..., 'BPAssignment', 'nan') % all bad pixels are assigned to "nan"
%