function manyplots(shotnums, chns, t1, t2, fs)
    datatime = [num2str(t1), ':', num2str(t2), ':', num2str(fs)];

    % 解析 shotnums 输入
    if ischar(shotnums)
        % 将字符串按逗号分割
        split_shotnums = strsplit(shotnums, ',');
        shotnum_list = [];
        for i = 1:length(split_shotnums)
            % 检查是否有范围（如 '110-113'）
            if contains(split_shotnums{i}, '-')
                range = strsplit(split_shotnums{i}, '-');
                shotnum_list = [shotnum_list, str2double(range{1}):str2double(range{2})];
            else
                shotnum_list = [shotnum_list, str2double(split_shotnums{i})];
            end
        end
    elseif isnumeric(shotnums)
        shotnum_list = shotnums;
    else
        error('Invalid input for shotnums');
    end

    % 假设 chns 是一个字符串数组或单一字符串
    if ischar(chns)
        waveform = {chns};  % 如果 chns 是单一字符串，则转换为单元素的 cell 数组
    else
        waveform = chns;    % 否则直接使用 chns
    end

    % 对每个 shotnum 进行循环
    for s = 1:length(shotnum_list)
        shotnum = shotnum_list(s);

        % 对每个通道进行数据下载
        for c = 1:length(waveform)

            position = [0 0 0 0];
            position(1) = 0.18; % position is defined as [left bottom width height].
            position(2) = 0.95 - i*0.85/wavenum;
            position(3) = 0.72;
            position(4) = 0.85/wavenum - div;
            if wavenum ~= 1
                subplot('Position', position);
            end
            temp_chn = waveform{i};

            [y,t]=downloaddata(shotnum,temp_chn,datatime);

            hg{i} = plot(t,y,'linewidth',plotlinewidth,'Color',colors(1,:));
            tt=legend(temp_chn);
            set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
            allaxes(i) = gca;
            ax = gca;

            unit=units(find(strcmp(temp_chn,units_name)));
            if isempty(unit)  unit={'V'}; end
            ylabel([temp_chn,'(',unit{1},')']);
            set(gca, 'FontAngle',  'normal', 'FontName','Times New Roman', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
            set(tt,'FontSize',legend_fontsize,'box',legend_box);
            if i ~= wavenum
                set(gca, 'XTickLabel',[])
            end



            % 绘图设置
            figure;
            set(gcf, 'Units', 'normalized', 'color', 'w');
            color_cell = mycolor(length(CurrentChannel));
            hold on;
            plot(t, y, 'LineWidth', 1.5, 'Color', color_cell(c, :));
            hold off;
            % 设置图表样式
            set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on', 'ticklength', [0.02 0.02], 'Xgrid', 'on', 'Ygrid', 'on', 'Box', 'on');
            xlabel('Time(s)');
            ylabel('data(V)');
            title(['Shot ', num2str(shotnum), ' - Channel: ', channel]);
            legend(channel, 'fontSize', 10);
        end
    end
end
