shotnum=1800;
fluxCoilName='flux023';
coilNamesStr='pf1-10';
acq_start=-3;        %采集开始时间，用于去除信号的偏置和漂移
flatTime=1.5;
dt=0.1;
fs=1e-2;
data_shift=1;
data_start=flatTime-dt/2;
data_end=flatTime+dt/2;
datatime=[num2str(data_start),':',num2str(data_end),':',num2str(fs),];
fullPath = mfilename('fullpath');
[fileDir, ~, ~] = fileparts(fullPath);
folderpath=[fileDir,'\data\'];
filepath=[folderpath,'EXL50UProbeFluxLoop.xlsx'];
FluxParameter=readtable(filepath,'Sheet','flux','VariableNamingRule','preserve');
fluxParam.X=table2array(FluxParameter(:,2))/1e3;
fluxParam.Z=table2array(FluxParameter(:,3))/1e3;
fluxParam.K=table2array(FluxParameter(:,4));
%%
CoilParameter=readtable(filepath,'Sheet','coils','VariableNamingRule','preserve');
coilNames=extractMultipleStrings(coilNamesStr);
totalError = 0;
TotalFlux=zeros(47,1);
for i=1:numel(coilNames)
    [X2,Y2,FilamentCurrent,GapX]=sourcePrepare(CoilParameter,coilNames{i});    %单个线圈网格化后的一维数据点
    fluxPF=MMutInductance(fluxParam.X,fluxParam.Z,X2,Y2,FilamentCurrent,GapX);
    currentName=['i_',coilNames{i}];                                                                        %PF线圈电流通道
    ipf_data=downloaddata(shotnum,currentName,datatime,0,0);                          %下载PF线圈电流数据
    pf_flat=mean(ipf_data);                                                                                        %获得PF线圈电流的平均值大小
    if max(abs(pf_flat))<100
        flux_compute=zeros(size(TotalFlux,1),size(TotalFlux,2));
    else
        flux_compute=fluxPF.*pf_flat;
    end    
    TotalFlux(:,i)=TotalFlux+flux_compute;
end
matches = regexp(fluxCoilName, '\d+', 'match');
numbers = str2double(matches);
coilName_Flux=TotalFlux(:,numbers);
%%
Flux_data=downloaddata(shotnum,fluxCoilName,datatime,0,0);                          %下载磁通环数据
fluxPF_measure=mean(Flux_data)*fluxParam.K;                                                     %测量得到的磁通数据

error = (fluxPF_measure -TotalFlux).^2;





















