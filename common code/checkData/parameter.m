function fig=parameter(shotnum,t1,t2,waveform,Fs)
% This Fuction is used to simply draw the EXl50 discharge parameters as you Want
% shotnum is the shot you are interested
% t1 is the start time of data sequence
% t2 is the end time of data sequence
% waveform is  the Channels you want to draw,
% in this example,'IP' will draw in the top subplot,The next will be {'ne','ha001'} which means that Ha and ne will be plotted
% in the same subplot,If you want to draw more contents in single subplot just put more channels in the same bracket{};
% example: parameter(951,-2,5,{{'ipf09','ipf10'},{'ipf05','ipf06'},{'ipf07','ipf08'}},1e5)
if nargin<5
    Fs=1e3;   % the default Sample rate
end
sgoalyfilt_flag=0;
div=0.000;      % the default space between two  subplots, if div=0, there is no space between two subplots.
datatime=[num2str(t1),':',num2str(t2),':',num2str(1/Fs)];
wavenum=length(waveform);
% f1=figure;set (gcf,'Units','normalized','Position',[0.1,0.1,0.25,0.7], 'WindowStyle', 'modal'); % figure 1
fig=figure;set (gcf,'Units','normalized','color','w'); % figure 1
title(['Shot',num2str(shotnum)])
fullPath = mfilename('fullpath');
fileDir = fileparts(fileparts(fileparts(fullPath)));
dataFilePath = fullfile(fileDir, 'common code/plotFunction/mycolors.mat');
load(dataFilePath);
figure_line_width=2;
plotlinewidth=2.5;
titlefontsize=14;
legend_fontsize=10;
legend_box='off';
ylabelfontsize=8;
for i = 1:wavenum
    position = [0 0 0 0];
    position(1) = 0.18; % position is defined as [left bottom width height].
    position(2) = 0.95 - i*0.85/wavenum;
    position(3) = 0.72;
    position(4) = 0.85/wavenum - div;
    if wavenum ~= 1
        subplot('Position', position);
    end
    temp_chn = waveform{i};
    %%
    switch iscell(temp_chn)
        case 0
            [y,t,~,unitStr,~]=downloaddata(shotnum,temp_chn,datatime);
            if sgoalyfilt_flag
                y= sgolayfilt(y,3,21);
            end
            if max(abs(y))>1e3
                y=y/1e3;
                unitflag=1;
            else
                unitflag=0;
            end
            hg{i} = plot(t,y,'linewidth',plotlinewidth,'Color',colors(1,:));
            tt=legend(temp_chn);
            if unitflag
                ylabel(['k',unitStr{i}],'Interpreter','tex','fontSize',ylabelfontsize)
            else
                ylabel(unitStr{i},'Interpreter','tex','fontSize',ylabelfontsize)
            end
            set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
            allaxes(i) = gca;
            ax = gca;

            % unit=units(find(strcmp(temp_chn,units_name)));
            % if isempty(unit)  unit={'V'}; end
            if unitflag
                ylabel(['k',unitStr]);
            else
                ylabel(unitStr);
            end

            set(gca, 'FontAngle',  'normal', 'FontName','Helvetica', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
            set(tt,'FontSize',legend_fontsize,'box',legend_box);
            if i ~= wavenum
                set(gca, 'XTickLabel',[])
            end
        otherwise
            nplot=length(temp_chn);
            for j=1:nplot
                [y,t,~,unitStr,~]=downloaddata(shotnum,temp_chn{j},datatime);
                if j==1
                    if max(abs(y))>1e3
                        unitflag=1;
                        k=1e3;
                    else
                        unitflag=0;
                        k=1;
                    end
                end

                if sgoalyfilt_flag
                    y= sgolayfilt(y,3,21);
                end
                if j == 1
                    hg{i} = plot(t,y/k,'linewidth',plotlinewidth,'Color',colors(j,:));
                else
                    hold on; plot(t,y/k,'linewidth',plotlinewidth,'Color',colors(j,:));
                end
                if j==nplot
                    tt=legend(temp_chn);
                    if unitflag
                        ylabel(['k',unitStr],'Interpreter','tex','fontSize',ylabelfontsize)
                    else
                        ylabel(unitStr,'Interpreter','tex','fontSize',ylabelfontsize)
                    end
                end
                warning off;
                set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
                allaxes(i) = gca;
                ax = gca;
                set(gca, 'FontAngle',  'normal', 'FontName',   'Helvetica', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
                try
                    set(tt,'FontSize',legend_fontsize,'box',legend_box,'Interpreter','none');
                end
                if i ~= wavenum
                    set(gca, 'XTickLabel',[])
                end

            end
    end
    %%
    if i == 1
        title(['Shot:',num2str(shotnum)]);
    end
end

nn = 1;
for ii = 1:length(hg)
    for jj = length(hg{ii})
        all_axes(nn) = get(hg{ii}(jj), 'parent');
        %         setytick(all_axes(nn),3);
        %         MyYTick(all_axes(nn),3,0);
        nn = nn + 1;
    end
end
% set(f1,'WindowButtonUpFcn',{@yticks_callback,gcf},'KeyPressFcn',{@yticks_callback,handles});
% set(f1,'WindowButtonUpFcn',{@yticks_callback,gcf});

if length(all_axes)>1
    linkaxes(all_axes, 'x');    % link all x-axes
end
xlabel('Time(s)')
xlim([t1,t2])
end