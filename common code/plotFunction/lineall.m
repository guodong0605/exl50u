function xcoords = lineall(n, hfig, linecolor, linestyle)
% LINEALL plot lines on all stackplot obj.
% SYNTAX 
% y = LINEALL(n, fighandle, linecolor)  :   % plot n lines on figure, by default n=1;
%                                           % default linecolor = 'r', means 'red'
%                         return the x-coordinates of the lines.
%
% y = LINEALL(n, fighandle) : plot n lines on figure, by default n=1; 
%                         return the x-coordinates of the lines.
% y = LINEALL(n) : handle can be the handle of a figure, by default
%                   handle=gcf.
%
% Examples:
% plot 2 lines on current stackplot obj.
% >> lineall(2);clc
% use right mouse button to cancle previous line.
% >> lineall(5)
% plot 5 red lines
% >> lineall(5, gcf, 'r');
%
% Remove all lineall objects
% >> delineall  % 
% >> delete(findall(gcf, 'tag','lineall'))
%
% See also:
% setptr, moveptr, delineall
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).

% Copyright (c) CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2012
% Author: lantao
% Email: lantao@ustc.edu.cn
% All Rights Reserved.
% $Revision: 1.0$ Created on: 11-Sep-2012 15:06:26
%           $1.1$ Add Escape key strategy: 10-Jan-2014 8:11:34
%           $1.2$ Add right mouse button function: 16-Jan-2014 11:49:30

error(nargchk(0,4,nargin));   % check input arguments

if nargin<2, hfig = gcf; end  % default = gcf
if nargin<1, n = 1; end   % default = 1

if ~ishandle(hfig)
    error('first input argument should be figure handle!');
end

% linecolor
if nargin <3, linecolor = 'magenta'; end

% linestyle
if nargin<4, linestyle = '--'; end

% linewidth
linewidth = 2;

% tag
tag = 'lineall';

xcoords = [];

try
    figure(hfig); % focus on fig
    
    % plot
    allaxes = findallaxes(hfig);
    hlineall = zeros(length(allaxes), n);  % all lineall handles
    xcoords = zeros(n,1);
    ii = 1;
    while ii <= n
        [x, ~, button] = ginput(1);
        if button==27   % if button  = Escape button, then break
            ii = ii + 1;
            break;
        end
        
        
        if button==3   % if button = right button, then redraw
            if ii > 1
                ii = ii - 1;
                for jj=1:length(allaxes)
                    delete(hlineall(jj,ii));
                end
            end
           continue
        end
        
%         hg = hggroup;
        xcoords(ii) =  x;
        for jj=1:length(allaxes)
            XX = [x x];
            YY = ylim(allaxes(jj));
            hlineall(jj,ii) = line(XX, YY, 'linestyle', linestyle, 'color',linecolor, 'linewidth', linewidth,'parent', ...
                allaxes(jj), 'handlevisibility','off','tag', tag);
        end
        
        ii = ii + 1;
    end
    
catch  E1
    % throw error
    rethrow(E1);
end


function Axes = findallaxes(fh)
allaxes = findobj(fh,'Type','axes');

% remove the colorbar axes

Axes = allaxes(~ismember(get(allaxes,'Tag'),{'legend','Colorbar'}));

% Axes = allaxes;
% for ii=1:length(Axes)
%     if strcmpi(get(Axes(ii),'Tag'), 'Colorbar')
%         Axes(ii)= [];
%     end
% end