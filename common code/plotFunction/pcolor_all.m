function h = pcolor_all(varargin)
% PCOLOR_ALL Pseudocolor (checkerboard) plot for showing all data
%   PCOLOR_all has some fix to the origin version "pcolor"
%   1)  Show the value of last row and column
%   2)  Move the center of grid to the physical center not the edge.
%
% SYNTAX
% h = PCOLOR_ALL(C)
%
% h = PCOLOR_ALL(X,Y,Z)
%
% Examples:
% description of example for pcolor_all
% >> [output] = pcolor_all(A);
%
% See also:
% pcolor, imagesc
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).

% Copyright (c) CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2012
% Author: Tao Lan
% Email: lantao@ustc.edu.cn
% All Rights Reserved.
% $Revision: 1.0$ Created on: 29-Mar-2012 22:10:33

% write down your codes from here.
[cax,args,nargs] = axescheck(varargin{:});

% check number fo input arguments
error(nargchk(1,4,nargs))

cax = newplot(cax);
hold_state = ishold(cax);

if nargs == 1
    x = args{1};
    [m,n] = size(x);   % row --> m,    column --> n
    x(m+1,:) = x(m,:);
    x(:,n+1) = x(:,n);
    n = n + 1;
    m = m + 1;
    temp1 = 0.5:n;
    temp2 = 0.5:m;
    hh = surface('XData',temp1,'YData',temp2,'ZData',zeros(size(x)),'CData',x,'parent',cax);
    lims = [min(temp1) max(temp1) min(temp2) max(temp2)];
elseif nargs == 3
    [x,y,c] = deal(args{1:3});
    
    [m,n] = size(x);
    if min(m,n) ~= 1
        step = x(:,2) - x(:,1);
        x(:,n+1) = x(:,n) + step;
        x(m+1,:) = x(m,:);
        x = x - step(1)/2;
    else
        step = x(2) - x(1);
        x(max(m,n)+1) = x(max(m,n)) + step;
        x =x -step/2;
    end
    
    [m,n] = size(y);
    if min(m,n) ~= 1
        step = y(2,:) - y(1,:);
        y(m+1,:) = y(m,:) + step;
        y(:,n+1) = y(:,n);
        y = y - step(1)/2;
    else
        step = y(2) - y(1);
        y(max(m,n)+1) = y(max(m,n)) + step;
        y = y - step/2;
    end
    
    [m,n] = size(c);   % row --> m,    column --> n
    c(m+1,:) = c(m,:);
    c(:,n+1) = c(:,n);
    
    hh = surface(x,y,zeros(size(c)),c,'parent',cax);
    lims = [min(min(x)) max(max(x)) min(min(y)) max(max(y))];
else
    error('Must have one or three input data arguments.')
end
if ~hold_state
    set(cax,'View',[0 90]);
    set(cax,'Box','on');
    set(cax,'Layer','top');   % set current axis to top layer, so the axis tick can be visible
    axis(cax,lims);
end
if nargout == 1
    h = hh;
end