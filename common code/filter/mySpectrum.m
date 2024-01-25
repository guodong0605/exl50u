function mySpectrum(shotnum,t1,t2,waveform)
% This Fuction is used to simply draw the EXl50 discharge parameters as you Want
% shotnum is the shot you are interested
% t1 is the start time of data sequence
% t2 is the end time of data sequence
% waveform is  the Channels you want to draw,
% parameter(4485,-1,4,{'ip',{'ne','ha001'},{'ipf1','ipf2','ipf3','ipf4','ipf5','ipf6'},'loopv','G1_IK_F'})
% in this example,'IP' will draw in the top subplot,The next will be {'ne','ha001'} which means that Ha and ne will be plotted
% in the same subplot,If you want to draw more contents in single subplot just put more channels in the same bracket{};

Fs=1e5;        % the default Sample rate
div=0.000;      % the default space between two  subplots, if div=0, there is no space between two subplots.
datatime=[num2str(t1),':',num2str(t2),':',num2str(1/Fs)];
wavenum=length(waveform)+1;
fig=figure('Color',[1 1 1]);set (gcf,'Units','normalized','color','w'); % figure 1
title(['Shot',num2str(shotnum)])
colors=[0,0,0;0,0,1;0,1,0;1,0.00787401574803150,0;1,0,0.761904761904762;0,0,0;0.0793650793650794,0.582677165354331,1;0,0.582677165354331,0.349206349206349;0.523809523809524,0.149606299212598,0;0,0,0.412698412698413;0.253968253968254,0.527559055118110,0.603174603174603;0,1,0.984126984126984;0.698412698412698,1,0.492063492063492;1,0.653543307086614,0.936507936507937;0.634920634920635,0.385826771653543,1;0.444444444444444,0,0.269841269841270;1,0.173228346456693,0.428571428571429;1,0.574803149606299,0.0476190476190476;0.746031746031746,0.669291338582677,0.380952380952381;0.190476190476190,0.212598425196850,0;0,0.0708661417322835,0.158730158730159];
figure_line_width=2;
plotlinewidth=2.5;
titlefontsize=16;
legend_fontsize=10;
legend_box='off';
SPParam.resolutiontype='kHz';
SPParam.resolutiontype=1;
for i = 1:wavenum
    position = [0 0 0 0];
    position(1) = 0.18; % position is defined as [left bottom width height].
    position(2) = 0.95 - i*0.85/wavenum;
    position(3) = 0.72;
    position(4) = 0.85/wavenum - div;
    if i<wavenum
        temp_chn = waveform{i};
        nplot=length(temp_chn);
        for j=1:nplot
            [y,t,~,unit]=downloaddata(shotnum,temp_chn{j},datatime);
            if j == 1
                hg{i} = plot(t,y,'linewidth',plotlinewidth,'Color',colors(j,:));
            else
                hold on; plot(t,y,'linewidth',plotlinewidth,'Color',colors(j,:));
            end
            if j==nplot
                tt=legend(temp_chn);
            end
            warning off;
            set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
            
            temp_ylabel=temp_chn{1};
            
           ylabel(temp_ylabel);
            set(gca, 'FontAngle',  'normal', 'FontName',   'Times New Roman', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
            try
                set(tt,'FontSize',legend_fontsize,'box',legend_box);
            end
            if i ~= wavenum
                set(gca, 'XTickLabel',[])
            end
        end
        %%
    else
        temp_chn = waveform{i-1};
        temp_chn2=temp_chn{1};
        [y,t,~,unit]=downloaddata(shotnum,temp_chn2,datatime);
        S=timetable(seconds(t),y);

       [pow,freq,time]=pspectrum(S,'spectrogram', 'FrequencyResolution',resolutionnum*1e3,'OverlapPercent',overlap*100);

        figure('Color',[1 1 1]);
        t=datevec(time);
        t=t(:,6);
        h=pcolor (t,freq/1000, log(pow)); shading interp;
        %     title(inputname(1),'fontsize',14)
        xlabel('$\rm t(s)$',  'fontname','Times New Roman','fontsize',12, 'fontweight','bold','interpreter','LaTex');
        ylabel('$\rm f(kHz)$', 'fontname','Times New Roman','fontsize',12, 'fontweight','bold','Interpreter','LaTex');
        set(gca, 'FontWeight', 'normal', 'FontSize', 15, 'LineWidth', 3, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on')
        c = colorbar;
        colormap('Jet');
        c.Label.String = 'Log(Pow)';
        
    end
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