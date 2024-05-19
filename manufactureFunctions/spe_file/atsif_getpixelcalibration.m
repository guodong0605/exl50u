function [ret,calVal]=atsif_getpixelcalibration(source, axis, pixel)

%AT_U32 ATSIF_GetPixelCalibration (ATSIF_DataSource _source, ATSIF_CalibrationAxis _axis,
%                                  AT_32 _i_pixel, double * _d_calibValue)
%
%
%Description :	This function is used to retrieve the calibrated value (e.g. wavelength) 
%               for the corresponding pixel in the source data of the SIF file.
%               The data source is selected using the ATSIF_DataSource 
%               enumeration which has the following values:-
%
%               0 - Signal
%               1 - Reference
%               2 - Background
%               3 - Live
%               4 - Source 
%               
%               The axis is selected using the ATSIF_CalibrationAxis enumeration, which
%               has the follwoing values:-
%
%               0 - X-Axis
%               1 - Y-Axis
%               2 - Z-Axis
%
%Arguments	 :  source   - The enumeration for selecting the SIF file data source
%               axis     - The enumeration for selecting the axis value
%               pixel    - The pixel to interrogate
%
%Return		 :  ret      - Check the help for return code meanings
%               calVal   - The corresponding pixel calibration
%

[ret,calVal] = atsifiomex('ATSIF_GetPixelCalibration', source, axis, pixel);