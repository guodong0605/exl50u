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
units_name={'ip','hcn_ne001','hcn_ne002','loopv','ps1_exp','ps2_exp','ps3_exp','ps4_exp','ps5_exp','ps6_exp','ps7_exp','ps8_exp','ps9_exp','ps10_exp','ps11_exp','ps12_exp','cs_exp','itf'};
units={'kA','10^{17}/m^2','10^{17}/m^2','V',       'A','A','A','A','A','A','A','A','A','A','A','A','A','kA'};
colors=[0,0,0;0,0,1;0,1,0;1,0.00787401574803150,0;1,0,0.761904761904762;0,0,0;0.0793650793650794,0.582677165354331,1;0,0.582677165354331,0.349206349206349;0.523809523809524,0.149606299212598,0;0,0,0.412698412698413;0.253968253968254,0.527559055118110,0.603174603174603;0,1,0.984126984126984;0.698412698412698,1,0.492063492063492;1,0.653543307086614,0.936507936507937;0.634920634920635,0.385826771653543,1;0.444444444444444,0,0.269841269841270;1,0.173228346456693,0.428571428571429;1,0.574803149606299,0.0476190476190476;0.746031746031746,0.669291338582677,0.380952380952381;0.190476190476190,0.212598425196850,0;0,0.0708661417322835,0.158730158730159];
figure_line_width=2;
plotlinewidth=2.5;
titlefontsize=16;
legend_fontsize=10;
legend_box='off';

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
            %                if ~isempty(opts)
            %                     y=y-mean(y(1:10));
            %                end

            hg{i} = plot(t,y,'linewidth',plotlinewidth,'Color',colors(1,:));
            tt=legend(temp_chn);
            set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
            allaxes(i) = gca;
            ax = gca;

            % unit=units(find(strcmp(temp_chn,units_name)));
            % if isempty(unit)  unit={'V'}; end
            ylabel(unitStr);
            set(gca, 'FontAngle',  'normal', 'FontName','Helvetica', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
            set(tt,'FontSize',legend_fontsize,'box',legend_box);
            if i ~= wavenum
                set(gca, 'XTickLabel',[])
            end
        otherwise
            nplot=length(temp_chn);
            for j=1:nplot
                [y,t,~,unitStr,~]=downloaddata(shotnum,temp_chn{j},datatime);
                if sgoalyfilt_flag
                    y= sgolayfilt(y,3,21);
                end
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
                allaxes(i) = gca;
                ax = gca;

                temp_ylabel=temp_chn{1};
                unit=units(find(strcmp(temp_ylabel,units_name)));
                % if isempty(unit)  unit={'V'}; end
                % if strcmp(temp_ylabel,'mwi_ne001') ||strcmp(temp_ylabel,'mwi_ne002')
                %     temp_ylabel='ne';
                % end
                ylabel(unitStr,'Interpreter','none');
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