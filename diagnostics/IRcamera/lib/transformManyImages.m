% function Y = transformManyImages(X,R,varargin)
% Apply the 3x3 affine transform R on images in X
%
% Y = transformManyImages(X,R)
%
% X : a set of P MxN images as a MxNxP matrix in single float format (P>=1)
% R : Q 3x3 transform double float matrices to transform the images with, 
%     where Q=P or Q=1
%
% Currently, the bottow row of R is ignored, that is, R(3,:) is assumed to be [0 0 1]
%
% The output images Y are cropped to the same size as X
%
% Uses OpenCVs warpAffine() function (requires a valid OpenCV installation)
%