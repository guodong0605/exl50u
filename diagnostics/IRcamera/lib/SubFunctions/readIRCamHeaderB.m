% Decode header portion of a Telops image (.hcc format), with appropriate adjustments
%
%   H = readIRCamHeader(bytes);
%
%   INPUT
%       bytes: an array of headers in uint8 (byte) format <Nframes x Nbytes>
%
%   OUTPUT
%       H: an array of header structures <Nframes x 1>
%