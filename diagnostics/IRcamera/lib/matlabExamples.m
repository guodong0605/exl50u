% Script matlabExamples

% This script uses the main functions available in the toolbox to show how
% they can be used in real contexts.

% Auteur : V閞onique Zambon
% Compagnie : Telops Inc.
% -----  Registre de changements :  ------------------------------------------------------
% Version  Date          Nom    Commentaires
% 
%  Copyright Telops 2020
%  $Revision:  $
%  $Author:  $
%  $LastChangedDate:  $
%  $HeadURL:  $

%% load sequence data
[data, header, specialPixelMap,specialNonBadPixelMap] = readIRCam(mypath, 'Frames', 1:10); 


%% Display frame
clc
frame = data(1,:)-273.15;
image_2D = formImage(header(1), frame);
cLim = imageScalingLimits(frame,0.01); % Pixel range is defined by the 1st and 99th percentile
figure(1)
imagesc(image_2D, cLim)
axis 'image'
colorbar


%% Area of Interest
clc
aoi = buildAoi(596-384, 402-158, 384, 158);
idx_aoi = getAoiIndices(header(1,:), aoi);

aoi_data = frame(idx_aoi);
op = aoi;
op.ReverseX = header(1).ReverseY;
op.ReverseY = header(1).ReverseY;
aoi_2D = formImage(op, aoi_data);
cLim = imageScalingLimits(aoi_data,0.01);
figure(2)
imagesc(aoi_2D, cLim)
axis 'image'
colorbar

%% Max temporal profile
clc
%time vector
time = double([header.POSIXTime])+double([header.SubSecondTime])*1e-7-double(header(1).POSIXTime)-double(header(1).SubSecondTime)*1e-7;


figure(3)
plot(time, max(data(:,idx_aoi)')-273.15)
xlabel('time [s]')
ylabel('temperature [oC]')

%% write .hcc file EDHRI example
clc
[data, header] = readIRCam('C:\Telops\RevealIR Demo Data\Soldering iron.hcc');% Sequence recorded with EHDRI mode
data1 = data([header.EHDRIExposureIndex]==1, :);
header1 = header([header.EHDRIExposureIndex]==1);
for i=1:numel(header1)
    header1(i).EHDRIExposureIndex=5;
end
% create a hcc file with only frames of the second exposure time
writeIRCam(header1, data1, 'C:\Telops\RevealIR Demo Data\Soldering iron new hcc.hcc'); 

%% write .hcc file MS example
clc
[data, header] = readIRCam('C:\Telops\RevealIR Demo Data\Lighter.hcc'); % Sequence recorded with MS mode, filter wheel turning
data1 = data([header.FWPosition]==0, :);
header1 = header([header.FWPosition]==0);
for i=1:numel(header1)
    header1(i).FWMode=0;
    header1(i).FWSpeed=0;
    header1(i).FWSpeedSetpoint=0;
end
% create a hcc file with only frames of the first filter wheel position.
writeIRCam(header1, data1, 'C:\Telops\RevealIR Demo Data\Lighter new hcc.hcc')

%% Saturate pixel map
clc
[~, header, SPM] = readIRCam('C:\Telops\RevealIR Demo Data\Soldering iron.hcc'); 
BPMap1 = SPM(1,:)==15;
figure(4)
imagesc(formImage(header(1),BPMap1));
axis 'image'
colormap(gray)

%% check data integrity
clc

[~, h] = readIRCam('C:\Telops\RevealIR Demo Data\Fireworks.hcc', 'HeadersOnly', true);
if ~any(diff(double([h.FrameID]))~=1)
    statut='Data integrity=PASS';
else
    statut='Data integrity=FAIL';
end
disp(statut)


%% export flag data

[d,header] = readIRCam('C:\Telops\RevealIR Demo Data\Fireworks.hcc'); % This sequence has some frames flagged (30 to 80) in it
data1 = d([header.FrameFlag]==1, :);
header1 = header([header.FrameFlag]==1, :);
% create a hcc file with only flagged frames
writeIRCam(header1, data1, 'C:\Telops\RevealIR Demo Data\new_hccFlag.hcc')