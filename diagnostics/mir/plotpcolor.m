function plotpcolor(shotnum,t1,t2,waveform,Fs)
% This Fuction is used to simply draw the EXl50 discharge parameters as you Want
% shotnum is the shot you are interested
% t1 is the start time of data sequence
% t2 is the end time of data sequence
% waveform is  the Channels you want to draw,
% in this example,'IP' will draw in the top subplot,The next will be {'ne','ha001'} which means that Ha and ne will be plotted
% in the same subplot,If you want to draw more contents in single subplot just put more channels in the same bracket{};
% example: parameter(951,-2,5,{{'ipf09','ipf10'},{'ipf05','ipf06'},{'ipf07','ipf08'}},1e5)
div=0.000;      % the default space between two  subplots, if div=0, there is no space between two subplots.
datatime=[num2str(t1),':',num2str(t2),':',num2str(1/1e3)];
datatime2=[num2str(t1),':',num2str(t2),':',num2str(1/Fs)];
%
window = hamming(1024); % 窗函数
noverlap = 128; % 重叠样本数
nfft = 1024; % FFT点数

%

wavenum=length(waveform)+1;
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
    subplot('Position', position);
    if i<wavenum
        temp_chn = waveform{i};
        nplot=length(temp_chn);
        for j=1:nplot
            [y,t,~,unitStr,~]=downloaddata(shotnum,temp_chn{j},datatime);
            if max(abs(y))>1e3
                unitflag=1;
                k=1e3;
            else
                unitflag=0;
                k=1;
            end
            hold on; hg{i}=plot(t,y/k,'linewidth',plotlinewidth,'Color',colors(j,:));
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
            set(gca, 'FontAngle',  'normal', 'FontName',   'Helvetica', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
            try
                set(tt,'FontSize',legend_fontsize,'box',legend_box,'Interpreter','none');
            end
            if i ~= wavenum
                set(gca, 'XTickLabel',[])
            end
        end
    else
        temp_chn = waveform{i-1};
        [y,t,~,unitStr,~]=downloaddata(shotnum,temp_chn,datatime2);
        [s, f, tfreq, p] = spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
        p_db = 10*log10(abs(p)); % 计算分贝值
        hg{i}=pcolor(tfreq+t(1), f/1000, p_db ); shading interp;
        xlabel('Time (s)');
        ylabel('Frequency (kHz)');
        set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
        set(gca, 'FontAngle',  'normal', 'FontName',   'Helvetica', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
        legend(temp_chn)
    end
end
%%
if i == 1
    title(['Shot:',num2str(shotnum)]);
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

if length(all_axes)>1
    linkaxes(all_axes, 'x');    % link all x-axes
end
xlabel('Time(s)')
xlim([t1,t2])
end