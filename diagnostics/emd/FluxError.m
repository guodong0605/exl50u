function [error,TotalFlux]=FluxError(shotnum,fluxCoilName,param,flatTime)
coilNamesStr='pf1-10';
coilNames=extractMultipleStrings(coilNamesStr);  %参与优化的源有哪些磁场；
fluxparam.fluxCoilName=fluxCoilName;
fluxparam.X=param(1);
fluxparam.Z=param(2);
fluxparam.K=param(3);

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
CoilParameter=readtable(filepath,'Sheet','coils','VariableNamingRule','preserve');
%%
TotalFlux=zeros(47,1);
for i=1:numel(coilNames)
    [X2,Y2,FilamentCurrent,GapX]=sourcePrepare(CoilParameter,coilNames{i});    %单个线圈网格化后的一维数据点
    fluxPF=MMutInductance(fluxparam.X,fluxparam.Z,X2,Y2,FilamentCurrent,GapX);
    currentName=['i_',coilNames{i}];                                                                        %PF线圈电流通道
    ipf_data=downloaddata(shotnum,currentName,datatime,0,0);                          %下载PF线圈电流数据
    pf_flat=mean(ipf_data);                                                                                        %获得PF线圈电流的平均值大小
    if max(abs(pf_flat))<100
        flux_compute=zeros(size(TotalFlux,1),1);
    else
        flux_compute=fluxPF.*pf_flat;
    end
    TotalFlux(:,i)=flux_compute;
end
matches = regexp(fluxparam.fluxCoilName, '\d+', 'match');
numbers = str2double(matches);
coilName_Flux=TotalFlux(numbers,:);
coilName_computeFlux=sum(coilName_Flux);
%%
Flux_data=downloaddata(shotnum,fluxparam.fluxCoilName,'-3:5:0.01',0,data_shift);                          %下载磁通环数据
fluxPF_measure=mean(Flux_data(round((data_start+3)*1e2+1):round((data_end+3)*1e2)))*fluxparam.K;                                                    %测量得到的磁通数据
error = ((fluxPF_measure -coilName_computeFlux)/coilName_computeFlux*100)^2;
fprintf(['Error=',num2str(error)])
end

