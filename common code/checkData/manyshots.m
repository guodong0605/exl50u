function manyshots(shotnums, chn,Tstart,Tend)

% This function downloads and plots multiple shots of data for multiple channels.
%
% Inputs:
%   - Tstart: Start time of the data (default: -1)
%   - Tend: End time of the data (default: 5)
%   - Fs: Sampling frequency of the data (default: 1e-3)
%   - isShift: Flag indicating whether to shift the data (default: 0)
%   - chn: Cell array of channel names
%   - shotnums: Array of shot numbers
%
% Outputs:
%   - None
%
% Example usage:
%   Tstart = -1;
%   Tend = 5;
%   Fs = 1e-3;
%   isShift = 0;
%   chn = {'channel1', 'channel2'};
%   shotnums = [1, 2, 3];
%   manyshots(Tstart, Tend, Fs, isShift, chn, shotnums);
%
% Author: GitHub Copilot
Tstart_default=-1;
Tend_default=5;
Fs_default=1e-3;
isShift_default=0;
div=0;
ylabelfontsize=16;
figure_line_width=2;
plotlinewidth=2.5;
titlefontsize=16;
legend_fontsize=10;
legend_box='off';


if (nargin <3) || isempty(Tstart), Tstart = Tstart_default; end
if (nargin <4) || isempty(Tend), Tend = Tend_default; end
if (nargin <5) || isempty(Fs), Fs = Fs_default; end
% if (nargin <6) || isempty(isShift), isShift = isShift_default; end

chns=extractMultipleStrings(chn);
shots=parsenums(shotnums);

datatime=[num2str(Tstart),':',num2str(Tend),':',num2str(Fs)];

shotnum = length(shots); % shots的数量
chnnum = length(chns); % chns中通道的数量

% 假设我们先获取第一个shot的第一个通道数据来确定M的大小
[firstData,time] = downloaddata(shots(1), chns{1},datatime,0,isShift_default);
datalength = length(firstData); % 每个通道的时间序列长度

% 初始化三维数组
allData = zeros(shotnum, chnnum, datalength);

% 循环下载数据并填充到三维数组中
for k = 1:shotnum
    for n = 1:chnnum
        [channelData,~,~,unit] = downloaddata(shots(k), chns{n},datatime,0,isShift_default);
        try
            allData(k, n, :) = channelData;
            unitStr{n}=unit;
        catch
            unitStr{n}='nodata';
        end
    end
end

    % 绘制数据

    figure;set (gcf,'Units','normalized','color','w'); % figure 1
    colors=[1,0,0;0,0,1;0,1,0;1,0.00787401574803150,0;1,0,0.761904761904762;0,0,0;0.0793650793650794,0.582677165354331,1;0,0.582677165354331,0.349206349206349;0.523809523809524,0.149606299212598,0;0,0,0.412698412698413;0.253968253968254,0.527559055118110,0.603174603174603;0,1,0.984126984126984;0.698412698412698,1,0.492063492063492;1,0.653543307086614,0.936507936507937;0.634920634920635,0.385826771653543,1;0.444444444444444,0,0.269841269841270;1,0.173228346456693,0.428571428571429;1,0.574803149606299,0.0476190476190476;0.746031746031746,0.669291338582677,0.380952380952381;0.190476190476190,0.212598425196850,0;0,0.0708661417322835,0.158730158730159];

    for i = 1:chnnum   %根据通道的数量进行确定subplot的数量
        position = [0 0 0 0];
        position(1) = 0.18; % position is defined as [left bottom width height].
        position(2) = 0.95 - i*0.85/chnnum;
        position(3) = 0.72;
        position(4) = 0.85/chnnum - div;

        if chnnum ~= 1
            subplot('Position', position);
        end

        for j = 1:shotnum
            temp=reshape(allData(j, i, :),1,size(allData,3));
            hold on; hg{i}=plot(time,temp','linewidth',plotlinewidth,'Color',colors(j,:));
            set(gca, 'FontWeight', 'normal', 'FontSize', titlefontsize, 'LineWidth', figure_line_width, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.01 0.01],'Xgrid','on','Ygrid','on','Box','on','GridLineStyle',':')
            set(gca, 'FontAngle',  'normal', 'FontName',   'Times New Roman', 'FontUnits',  'points','FontSize',  titlefontsize, 'FontWeight', 'bold');
            legendname{j}=[num2str(shots(j)),'/',chns{i}];
            if j==shotnum
                legend(legendname,'FontSize',legend_fontsize,'box',legend_box)
                ylabel(unitStr{i},'Interpreter','none','fontSize',ylabelfontsize)
            end
        end

        %设置最下面的xtick不显示
        if i ~= chnnum
            set(gca, 'XTickLabel',[])
        end

    end
    %  subplot link axes X
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
    xlabel('Time(s)')
    xlim([Tstart,Tend])

end

