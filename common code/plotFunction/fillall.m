function fillall(varargin)
%FILLALL Fill all stack plot with the same area in x axis.
%   FILLALL(X1,X2,C) fill all stackplot with the same area from X1 to X2 in
%   color specified by C.
%
%   If C is a single character string chosen from the list 'r','g','b',
%   'c','m','y','w','k', or an RGB row vector triple, [r g b], the
%    area is filled with the constant specified color. C is 'y' meaning
%    yellow by default.
%
%   FILLALL([ax1 ax2...], ...) fill the area in the axes ax1, ax2 and etc.
%
%   See also patch, fill, fill3, area
% example  fillall(1,14,'[1,0,0]',0.2);

error(nargchk(2,4,nargin));   % check input arguments

selectcolor = 'r';
if isscalar(varargin{1})
%    if ishandle(varargin{1})
    if 0
        allaxes = varargin{1};
        if nargin<3
            error(['input args not enough. nargin=' num2str(nargin) ' <3']);
        end
        X1 = varargin{2};
        X2 = varargin{3};
        if nargin>3
            selectcolor = varargin{4};
        end
    else
        allaxes = findallaxes(gcf);
        X1 = varargin{1};
        X2 = varargin{2};
        if nargin>2 
            selectcolor = varargin{3};
        end
    end
else
    if isvector(varargin{1})
        if ~all(ishandle(varargin{1}))
            error('the first input arg contains illegal handle.')
        end
        allaxes = varargin{1};
        X1 = varargin{2};
        X2 = varargin{3};
        if nargin > 3
            selectcolor = varargin{4};
        end
    else
        error('the first input arg is not handle vectors')
    end
end

doFillWork(allaxes, X1, X2, selectcolor);

function Axes = findallaxes(fh)
temp = findobj(fh,'Type','axes');
Axes = temp;
% remove the colorbar axes
for ii=1:length(Axes)
    if strcmpi(get(Axes(ii),'Tag'), 'Colorbar')
        Axes(ii)= [];
    end
end

function doFillWork(allaxes, X1, X2, selectcolor)
for ii=1:length(allaxes)
    currentylim = ylim(allaxes(ii));
    Y = [currentylim(2) currentylim(2)];
    X = [X1 X2];
    hold(allaxes(ii), 'on');
    h = area(allaxes(ii), X,Y,'BaseValue', currentylim(1));
    set(allaxes(ii),'Layer','top')
    set(h,'FaceAlpha',0.2,'Facecolor', selectcolor,'EdgeColor', selectcolor, ...
        'LineStyle', '-', 'Tag', 'Shadow');
    hold(allaxes(ii), 'off');
    set(0, 'ShowHiddenHandles','on');
    ylim(allaxes(ii), currentylim);
    allchildren = get(allaxes(ii),'Children');
    allchildren = setlayertobottom(allchildren(:),h);
    set(allaxes(ii), 'Children', allchildren);
    set(h, 'handlevisibility','off');
    set(0, 'ShowHiddenHandles','off');
end

function y = setlayertobottom(childrens, ch)
position = find(childrens==ch);
if isempty(position)
    y = childrens;
else
    if position==length(childrens)
        y = childrens;
    else
        y = childrens;
        alltypes = get(childrens,'Tag');
        for ii=length(childrens):-1:1
            if ~strcmpi(alltypes{ii},'Shadow')
                y(position:ii) = circshift(childrens(position:ii),-1);
                break;
            end
        end
    end
end
