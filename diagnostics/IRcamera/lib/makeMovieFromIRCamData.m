function makeMovieFromIRCamData(PathName, movie_name, framerate, ColormapName, MinMaxScaling, saveJPGFrames)
% Creates a movie from a hcc file from Telops Camera.
%
% makeMovieFromIRData
%
%  Examples:
%
%
% INPUTS
%  PathName:            File path to the *.hcc file(s), eg: 'D:\'
%                       If left empty, the function will ask you to 
%                       locate the directory. If more than 1 hcc file is
%                       found, all hcc files will be concanated.
%
%  movie_name:          Name of the saved movie, eg: 'MyMovie'
%                       If left empty, movie_name='MyMovie'
%
%  framerate:           Output frame rate of the movie [Hz]
%                       If left empty, framerate=24;
%
%  ColormapName:        Color map to be used for the movie, eg: 'bone'
%                       Possible colormaps are: 'jet', 'HSV', 'hot',
%                       'cool', 'spring', 'summer', 'autumn', 'winter',
%                       'gray', 'bone', 'copper', 'lines'
%
%  MinMaxScaling:       Min and max temperature [K] values for scaling, 
%                       eg: [290 300]   
%                       If left empty, automatic scaling is applied
%
%  saveJPGFrames:       Flag to enable saving of each IR frame in jpg format 
%   
% OUTPUTS
%  None:

% References
%

% TODO %

% Authors: Jean-Philippe Gagnon

% -----  Change Record:  --------------------------------------------------
% Version  Date          Name   Comment
% 1.0      08 Aug 2017   JGA    Creation

%  Copyright Telops 2010
%  $Revision: 12606 $
%  $Author: jgagnon $
%  $LastChangedDate: 2017-10-16 09:22:30 -0400 (lun., 16 oct. 2017) $


%% INITIALIZATION

if nargin < 1
    msg = ['Select the directory containing the *.hcc file(s).'];
    [PathName] = uigetdir('D:\', msg);
    if PathName == 0
        error('User pressed Cancel.');
    end
    PathName = [PathName filesep];
    hccFiles=dir([PathName '\*.hcc']);
    filesnum = length(hccFiles);
else
    if ~strcmp(PathName(end),filesep)
        PathName = [PathName filesep];
    end
    hccFiles=dir([PathName '*.hcc']);
    filesnum = length(hccFiles);
end

if nargin < 2    
    movie_name = 'MyMovie';
end

if nargin < 3
    framerate = 24;
end

if nargin < 4
    ColormapName = 'bone';
end

if nargin < 5
    MinMaxScaling = 'Auto';
end

if nargin < 6
    saveJPGFrames = 'false';
end


%% Make Movie

% Load data
if filesnum == 1
    [D,H] = readIRCam([PathName hccFiles.name]);
elseif filesnum > 1
    for i=1:filesnum
        [DD,HH] = readIRCam([PathName hccFiles(i).name]);
        D=cat(1,D,DD);
        H=cat(1,H,HH);
    end
    clear 'DD' 'HH'
else
    error('No files found');
end


% Calculate intial time
t0=double(H(1).POSIXTime)+double(H(1).SubSecondTime)*1e-7; 

figure,
for jj=1:size(D,1) % frames
      
    t_rel(jj)=(double(H(jj).POSIXTime)+double(H(jj).SubSecondTime)*1e-7) - t0;
    t_abs(jj)=(double(H(jj).POSIXTime)+double(H(jj).SubSecondTime)*1e-7);
    
    if strcmp(MinMaxScaling,'Auto') || isempty(MinMaxScaling)
        clims = imageScalingLimits(D(jj,:));
    else
        clims = MinMaxScaling;
    end
    
    h=imagesc(formImage(H(jj),D(jj,:)),clims);
    axis('image');
    colorbar;
    colormap(ColormapName);
    set(gcf,'color','w');
    title(['Frame ',num2str(jj),' Time ',num2str(t_rel(jj)),' s'])
    drawnow
    M1(jj)=getframe(gcf);
%     if saveJPGFrames
%         saveas(h,[PathName 'Frame_Num_ ',num2str(jj),'.jpg'],'jpg')
%     end
end


clear mex

v = VideoWriter(movie_name,'Uncompressed AVI');
v.FrameRate = framerate;
open(v);
writeVideo(v,M1);
close(v)

close all;
disp(' ');
disp(' ');
disp('************');
disp([num2str(movie_name), '.avi created in: ', num2str(PathName)]);
disp('************');
disp(' ');
disp(' ');

end
