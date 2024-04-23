function manysubplots(shotnum, timeRange,channelnames,plotLayout,isshift,dshiftTime)
timeRange_default='-2:4:1e-2';
DataChns_default={'IP','LoopV','hcn_ne001','ecrh0_uk','gas_pres01','gas_out01','i_cs','zp,rp','IMP01,IMP02,IMP04','Ha001,HA002','axuv015','hxr004'};
plotLayout_default=ceil(length(DataChns_default)/4);
dshift_default=0;
dshiftTime_default=0.1;

if (nargin <2)  timeRange = timeRange_default; end
if (nargin <3) channelnames = DataChns_default; end
if (nargin <4)  plotLayout = plotLayout_default; end
if (nargin <5)  isshift = dshift_default; end
if (nargin <6)  dshiftTime = dshiftTime_default; end
% Preallocate dataset cell array
dataset = cell(length(channelnames), 1);

for idx = 1:length(channelnames)
    % Parse current channel set
    currentChannels = strsplit(channelnames{idx}, ',');
    % Download data for the current set of channels
    [y, t, ~,unit] = downloaddata(shotnum, currentChannels, timeRange, 0,isshift,dshiftTime);
    if max(abs(y))>1e3
        y=y/1e3;
        unit=['k',unit];
    end
    % Create data pair with time and data values, and labels
    dataset{idx} = {[t, y], [channelnames{idx},'(',unit,')']};
end

% Call the plotting function
figure;
colomnPlot(dataset, plotLayout);
end
