% 2024-03-01 磁测量诊断标定   查看线圈电流参数
parameter(1700,-2,5,{{'ps1_exp','ipf02','ipf03','ipf04','ipf05','ipf06','ipf07','ipf08','ipf09','ipf10'},{'itf01'},{'cs_exp'},{'ip'}},1e3);
mpProfile(1706,1.65,1.7)
downloaddata(1706,'mp001-9n','-3:5:1e-2',2,0);
downloaddata(1704,'mp001-9n','-3:5:1e-2',2,0);
downloaddata(1706,'ps1-10_exp','-3:5:1e-2',2,0);
downloaddata(1704,'mp010-20t','-3:5:1e-2',2,0);
%%
for shotnum=1366:1565
    try
        downloaddata(shotnum,'cs_exp,itf01,ps1-10_exp','-3:5:1e-2',2,0);
        fig=gcf;
        filename=num2str(shotnum);
        print(fig, fullfile('E:\01 磁测量诊断\实验记录\CS电流\', filename), '-djpeg');
        close all
    end
end
%%
shotnum=1705;
filepath='E:\git\exl50u\diagnostics\emd\data\EXL50UProbeFluxLoop.xlsx';
FluxParameter=readtable(filepath,'Sheet','flux','VariableNamingRule','preserve');

fluxs='ps1-10_exp';
fluxNames = extractMultipleStrings(fluxs);
OutputParam=zeros(numel(fluxNames),3);
for i=1:numel(fluxNames)
    fluxCoilName=fluxNames{i};
    matches = regexp(fluxCoilName, '\d+', 'match');
    numbers = str2double(matches);
    fluxParam.X=table2array(FluxParameter(numbers,2))/1e3;
    fluxParam.Z=table2array(FluxParameter(numbers,3))/1e3;
    fluxParam.K=table2array(FluxParameter(numbers,4));
    initialParams = [fluxParam.X, fluxParam.Z, fluxParam.K];
    lb = [fluxParam.X-0.05, fluxParam.Z-0.05, fluxParam.K-0.02]; % 注意这里的减号修正
    ub = [fluxParam.X+0.05, fluxParam.Z+0.05, fluxParam.K+0.02];

    % 调用fmincon
    options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
    [optimalParams, fval] = fmincon(@(params)FluxError(shotnum, fluxCoilName,params, 1.8), initialParams, [], [], [], [], lb, ub, [], options);
    OutputParam(i,:)=optimalParams;
    % 输出优化结果
    fprintf('优化后的探测器位置和角度：X = %f, Z = %f, Theta = %f\n', optimalParams(1), optimalParams(2), optimalParams(3));
end

%%
coils='cs,pf1-14';
coilNames = extractMultipleStrings(coils);
Flux=zeros(numel(coilNames),47);
Bt=zeros(numel(coilNames),52);
Br=zeros(numel(coilNames),48);
for i=1:numel(coilNames)
    [flux,bt,br]=PfCoilFlux(coilNames{i},0);
    Flux(i,:)=flux;
    Bt(i,:)=bt;
    Br(i,:)=br;
end
coilData.flux=Flux;
coilData.bt=Bt;
coilData.br=Br;
save("diagnostics\emd\data\coilData.mat","coilData")
%%
filename='C:\Users\Administrator\Desktop\calibration\cal.xlsx';
shotnum=1654;
Ratio=mpProfile(shotnum,1.9,2);
writeData(filename,'flux',[shotnum,Ratio.flux],'A')
writeData(filename,'br',[shotnum,Ratio.br],'A')
writeData(filename,'bt',[shotnum,Ratio.bt],'A')
%%
fluxData=readtable(filename,'Sheet','br','ReadRowNames',true);
seprateData=fluxData(2:11,2:49);
fluxdata2=table2array(seprateData);
%%
filename='C:\Users\Administrator\Desktop\calibration\cal.xlsx';
fluxData=readtable(filename,'Sheet','br','ReadRowNames',true);
seprateData=fluxData(2:11,2:49);
fluxdata2=table2array(seprateData);


for i=1:size(fluxdata2,2)-1
    % temp=fluxdata2(:,i+1);
    % coef(i)=mean(temp);
    if i==1
        figure;stackplot({{1:10,fluxdata2(:,i+1),'Flux001'}},'Calibration','No',1)
    else
        hold on;
        plot(1:10,fluxdata2(:,i+1),'-o','LineWidth',2,'MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:));
    end
end
%%
downloaddata(1704,'itf01,ps1-10_exp','-3:5:1e-2',2,0);
downloaddata(shotnum,'flux001-47','-3:5:1e-2',2,1);
mpProfile(1813,1.85,1.9)










%%
drawprofile(1883,'flux001-47',1,3,1.5,1,1)

