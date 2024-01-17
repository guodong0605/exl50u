function handleOut = stackplot(Waveform,iTitle, Xlabel)
%STACKPLOT plot signal with stacking method.
%Syntax
%  HANDLEOUT = STACKPLOT(WAVEFORM, RANGE, DIV, GRIDOPT, TITLE, XLABEL)
%    Plot signal in stack
%    WAVEFORM 是嵌套的2层cell: {{time, data, Unit}, ...}
%    其中Unit是可选的
%    RANGE is the time axis range, default is using MATLAB's default value.
%    DIV: div value for stacking axes, default =0.02. if div=0, the
%         adjacent axes will be connected.
%    handleOut  :   return the handle object of each figure. 
%    title: the title for the figure
%    xlabel: the xlabel in the last axe
%
% Example:
%
%  stackplot({{t1, data1,'Volt (V)'},{t2, data2, 'Is (A)'}}, [], [], [], 'I-V plot', 'Time (ms)');
%
% See also:
% PLOT, SUBPLOT, AXES, XLIM, YLIM, SUBLABEL              
colors=[0,0,0;1 0 0;0,1,0;0,0,1;1,0,0.761904761904762;0,0,0;0.0793650793650794,0.582677165354331,1;0,0.582677165354331,0.349206349206349;0.523809523809524,0.149606299212598,0;0,0,0.412698412698413;0.253968253968254,0.527559055118110,0.603174603174603;0,1,0.984126984126984;0.698412698412698,1,0.492063492063492;1,0.653543307086614,0.936507936507937;0.634920634920635,0.385826771653543,1;0.444444444444444,0,0.269841269841270;1,0.173228346456693,0.428571428571429;1,0.574803149606299,0.0476190476190476;0.746031746031746,0.669291338582677,0.380952380952381;0.190476190476190,0.212598425196850,0;0,0.0708661417322835,0.158730158730159];
if nargin < 1
    display(['>> help ' mfilename])
    eval(['help ' mfilename]);
    error('Too less input parameters!');
end

Range = [];  % default plot range
div = 0; % divide default value
gridopt = 'grid off'; % grid option default
iTitle_default = [];  % default title
iXlabel_default = 'Times(s)';  % xlabel

if nargin < 2
    iTitle = iTitle_default;
elseif isempty(iTitle)
    iTitle = iTitle_default;
end % default
if nargin < 3
    Xlabel = iXlabel_default;
end

if ~iscell(Waveform)
    error('Input waveform must be cell.')
end
wavenum = length(Waveform);
stackplottag = 'stackplot';

if wavenum ~= 1
    clf
end

XLim = Range;
for i = 1:wavenum
    position = [0 0 0 0];
    position(1) = 0.15; % position is defined as [left bottom width height].
    position(2) = 0.95 - i*0.82/wavenum;
    position(3) = 0.75;
    position(4) = 0.82/wavenum - div;
    if wavenum ~= 1
        subplot('Position', position);
    end
    temp = Waveform{i};

    switch length(temp)
        case 2
            hg{i} = plot(temp{1:end}, 'Tag', stackplottag,'linewidth',2,'color',colors(i,:));
            t1=legend(temp{end});set(t1,'interpreter','none')
            ylabel(temp(end),'interpreter','none');
        case 3
            hg{i} = plot(temp{1:2}, 'Tag', stackplottag,'linewidth',2,'color',colors(i,:));
            t1=legend(temp{end});set(t1,'interpreter','none','FontSize',10)
            ylabel(temp(end),'interpreter','none');
        otherwise 
            nplot=length(temp)-2;
            str=temp{end};
            if length(temp{end})>1
            str=regexp(temp{end}, ',', 'split');
            end
            
            for j=1:nplot
                hold on; hg{i}=plot(temp{1},temp{j+1}, 'Tag', stackplottag,'linewidth',2,'color',colors(j,:)); 
                if j==nplot
                t1=legend(str);set(t1,'interpreter','none','FontSize',12)
                ylabel(str{1},'interpreter','none');
                end
            end
    end
              
    
%%
%%
%     setytick(gca,4,1);
    allaxes(i) = gca;
    set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
    if strcmpi(gridopt,'grid')
        grid on;
    end
    
    %     box off;
    
    if ~isempty(XLim)
        xlim(XLim)
    end
    if length(temp) > 2
        if ~ischar(temp{end})
%             ylab = ['Sig' num2str(i)];
            ylab = ['Signal'];
        else
            if strncmpi(temp{end}, 'dx', 2) || strncmpi(temp{end}, 'dy', 2)
                ylim([-1 1]);
            end
            ylab = temp{end};
        end
    else
        ylab = ['Signal'];
    end
    set(gca,'FontName','Times New Roman')
    ax = gca;
%     h= get(ax, 'ylabel');
%     set(h, 'FontAngle',  'normal', ...
%            'FontName',   'Times New Roman', ...
%            'FontUnits',  'points',...
%             'FontSize',  16, ...
%            'FontWeight', 'bold', ...
%            'string', ylab,'Interpreter','LaTex');
    %ylabel(ylab);
    
    if i ~= wavenum
        set(gca, 'XTickLabel',[])
    end
end


if ~isempty(iTitle)
    temp = hg{1};
    title(get(temp(1), 'parent'), iTitle)
end

ax = gca;
h = get(ax, 'xlabel');
set(h, 'FontAngle',  'normal',  'FontName',   'Times New Roman', 'FontUnits',  'points', 'FontSize',  17, 'FontWeight', 'bold',  'string', Xlabel,'Interpreter','none');
 
% link all x axes
nn = 1;
for ii = 1:length(hg)
    for jj = length(hg{ii})
        all_axes(nn) = get(hg{ii}(jj), 'parent');
        nn = nn + 1;
    end
end
if length(all_axes)>1
    linkaxes(all_axes, 'x');    % link all x-axes
end

% link all x-axes' scale
hlinks = linkprop(all_axes, 'xscale');
KEY = 'graphics_linkaxes_scale';
for ii = 1:length(all_axes)
    setappdata(all_axes(ii), KEY, hlinks);
end

% output handles
if nargout >= 1
    handleOut = hg;
end