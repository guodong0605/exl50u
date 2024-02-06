function setlayer(varargin)
% SETLAYER  change the object layer
%   SETLAYER(OBJ, LAYER)  set the OBJ as the LAYER in the current axes.
%   OBJ is the handle. If LAYER exceed the current layers, a warnning
%   triggered and place the OBJ as bottom. If LAYER <1, the OBJ is placed
%   at the top layer. If LAYER== inf, the OBJ is placed at the bottom
%   layer. LAYER is -1 by default.
%
%   SETLAYER(AX, ... ) set the OBJ as the LAYER in the axes of AX.
%
%   The similar function UISTACK can offer almost the same feather of 
%   changing layer.
%
%Example:
%   >>plot([0 0.25 0.5 0.75 1 1.25], [0 0.25 0.5 0.75 1 1.25].^2, 'r-o');
%   >>ph = patch([0 1 1 0], [ 0 0 1 1], 'y'); % a squre in yellow
%   >>setlayer(ph,inf);   % set the patch at the bottom layer
%
%   See also gca, uistack

%   Copyright 1958-2008 Lan Tao @Univ. of Sci. & Tech. of China
%   $Revision: 1.0 $ $Data: 2008/09/09 10:32:13$

narginchk(2,3);   % check input arguments

if ishandle(varargin{1})
    handletype = get(varargin{1},'Type');
    if strcmpi(handletype, 'axes')
        setaxes = varargin{1};
        if ishandle(varargin{2})
            setobj  = varargin{2};
        else
            error('Second input parameter should be a handle');
        end
        setlayer = varargin{3};
    else
        setaxes = gca;
        if ishandle(varargin{1})
            setobj  = varargin{1};
        else
            error('Second input parameter should be a handle');
        end
        setlayer = varargin{2};
    end
else
    error('First input parameter should be a handle.');
end

alllayers = get(setaxes,'Children');  % get the layers in setaxes.
currentlayer = find(alllayers==setobj);      
if isnan(currentlayer)
    error('obj is not in the axes!!!');
end

if setlayer <1, setlayer = 1; end  % top layer
if setlayer > length(alllayers), setlayer = length(alllayers); end  % bottom layer

if currentlayer == setlayer
    return;
elseif currentlayer > setlayer
    alllayers(setlayer+1:currentlayer) = alllayers(setlayer:currentlayer-1);
    alllayers(setlayer) = setobj;
else
    alllayers(currentlayer:setlayer-1) = alllayers(currentlayer+1:setlayer);
    alllayers(setlayer) = setobj;
end

set(setaxes, 'Children', alllayers);
