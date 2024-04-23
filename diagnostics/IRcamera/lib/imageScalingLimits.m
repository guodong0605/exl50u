% Calculate a pixel range [clims(1), clims(2)] to be used with MATLAB function imagesc(...,clims).
%   clims = imageScalingLimits(ImageVect,thresh)
% 
%   Calculates a pixel range [clims(1), clims(2)] to be used with MATLAB function
%   imagesc(...,clims). See IMAGESC fordetails.
%
%     clims(1): thresh*100 percentile
%     clims(2): (1-thresh)*100 percentile
%
%   USAGE:  clims = ImageScalingLimits(myimagevectorized);
%         clims = ImageScalingLimits(myimagevectorized, 0.04)
%
%   INPUTS:
%     ImageVect: a row or column vector containing the intensity of the pixels.
%                For an image myimage of size (xsize,ysize), vectorialize
%                myimage so that a typical function call resemble
%                  clims = ImageScalingLimits(myimage(:));
%                more than more frames may be passed as a matrix of 
%                (Nframes x Npixels)
%     thresh: a number between 0 and 0.5; default is 0.04; see OUTPUTS section 
%
%   OUTPUTS:
%     clims: 1x2 cvector for a single frame, [nframes x 2] for a set of frames 
%            matrix.
%         
%
% EXAMPLE 1: myimage is a vector of length YsizeImage*XsizeImage
%
%    clims = ImageScalingLimits(myimage); figure; 
%    imagesc(reshape(myimage,YsizeImage,XsizeImage)),clims);
%
% EXAMPLE 2: myimage is a matrix of size (YsizeImage,XsizeImage)
%
%    clims = ImageScalingLimits(myimage(:)); figure;
%    imagesc(reshape(myimage,YsizeImage,XsizeImage)),clims);
%    
%