function manysubplots(shotnum, timeRange,channelnames,plotLayout,isshift,dshiftTime,issave)
timeRange_default='-2:6:1e-2';
% DataChns_default={'IP','LoopV','hcn_ne001','ecrh0_uk','gas_pres01','gas_out01','i_cs','zp,rp','IMP01,IMP02,IMP04','Ha001,HA002','axuv015','hxr004'};
% DataChns_default={'ip','LoopV','hcn_ne001','ecrh0_uk','gas_pres01','gas_out01','i_cs','zp,rp','i_tf','i_pf1,i_pf2','i_pf3,i_pf5','i_pf9,i_pf10','IMP01,IMP04,IMP06','Ha001,ha002','axuv015','hxr004'};
DataChns_default={'i_cs','i_pf1,i_pf2','i_pf3,i_pf4','i_pf5,i_pf6','i_pf7,i_pf8','i_pf9,i_pf10'};

plotLayout_default=ceil(length(DataChns_default)/4);
dshift_default=0;
dshiftTime_default=0.5;
issave_default=0;
if (nargin <2)  timeRange = timeRange_default; end
if (nargin <3) channelnames = DataChns_default; end
if (nargin <4)  plotLayout = plotLayout_default; end
if (nargin <5)  isshift = dshift_default; end
if (nargin <6)  dshiftTime = dshiftTime_default; end
if (nargin <7)  issave = issave_default; end
% Preallocate dataset cell array
dataset = cell(length(channelnames), 1);

for idx = 1:length(channelnames)
    % Parse current channel set
    currentChannels = strsplit(channelnames{idx}, ',');
    % Download data for the current set of channels
    [y, t, unit] = downloaddata(shotnum, currentChannels, timeRange, 0,isshift,dshiftTime);
    if max(abs(y))>1e3
        y=y/1e3;
        unit=['k',unit];
    end
    % Create data pair with time and data values, and labels
    dataset{idx} = {[t, y], [channelnames{idx},'(',unit,')']};
end

% Call the plotting function
figure('Color',[1 1 1],'Units','normalized','Position',[0.01,0.01,0.9,0.9]);
colomnPlot(dataset, plotLayout);
sgtitle(num2str(shotnum),'backgroundColor',[1 1 1]);

if issave == 1
    % 构建保存路径，将图形保存到桌面
    filepath = fullfile(getenv('USERPROFILE'), 'Desktop', [num2str(shotnum), '.png']);
    % 使用 saveas 或 print 函数保存图形
    print('-dpng', filepath)
    % 或使用 print 来保存
    % print('-dpng', filepath);
end
 refLines(gcf);
end
