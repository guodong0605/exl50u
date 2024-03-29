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
shotnum=2101;
Ratio=mpProfile(shotnum,0,0.05);
writeData(filename,'flux',[shotnum,Ratio.flux],'A')
writeData(filename,'br',[shotnum,Ratio.br],'A')
writeData(filename,'bt',[shotnum,Ratio.bt],'A')
%%
fluxData=readtable(filename,'Sheet','br','ReadRowNames',true);
seprateData=fluxData(2:11,2:49);
fluxdata2=table2array(seprateData);
%%
filename='C:\Users\Administrator\Desktop\calibration\cal.xlsx';
fluxData=readtable(filename,'Sheet','flux','ReadRowNames',true);
seprateData=fluxData(2:11,2:49);
fluxdata2=table2array(seprateData);

num=size(fluxdata2,2)-1;
for i=1:size(fluxdata2,1)
    if i==1
        figure;stackplot({{1:num,fluxdata2(i,2:end),'Flux001'}},'Calibration','No',1)
    else
        hold on;
        plot(1:num,fluxdata2(i,2:end),'-o','LineWidth',2,'MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:));
    end
end
legend({'PF05','PF09','PF06','PF09','PF09','PF01','PF07','PF08','PF03','PF04'})
%%
[y,t,data]=downloaddata(2101,'itf01,ps1-10_exp','-3:5:1e-2',2,0);
%%
DataChns='IP,LoopV,ITF01,CS_EXP,AXUV004,AXUV006,SXR002,SXR004,IMP01,IMP02,IMP04,Ha001,HA002,HXR001,HXR002,mp006t';
[y,t,data]=downloaddata(2276,DataChns,'-1:5:1e-3',0,0);
fieldNames = fieldnames(data);
t=t(1:end-1);
data1={[t,y(:,1)],[t,y(:,2)],'IP(kA),LoopV(V)'};
data2={[t,y(:,3),y(:,4)],'ITF(kA),CS(kA)'};
data3={[t,y(:,5),y(:,6)],'AXUV04,AXUV06'};
data4={[t,y(:,7),y(:,8)],'SXR02,SXR04'};
data5={[t,y(:,9),y(:,10),y(:,11)],'CII,HEII,OII'};
data6={[t,y(:,12),y(:,13)],'HA001,HA002'};
data7={[t,y(:,14),y(:,15)],'HXR01,HXR02'};
data8={[t,y(:,16)],'MP006T'};

dataset={data1,data2,data3,data4,data5,data6,data7,data8};

colomnPlot(dataset,3)
%%
B_X=comsol(:,2);
B_Y=comsol(:,1);
theta_br=comsol(:,3)/180*pi;
figure;stackplot({{1:48,B_X,B_Y,'B_X,B_Y'}},'','',1)

Br=B_Y.*cos(theta_br)-B_X.*sin(theta_br); % PF contribution
figure;stackplot({{1:48,Br,''}},'','',1)
%%
%%
filename='C:\Users\Administrator\Desktop\calibration\cal.xlsx';
fluxData=readtable(filename,'Sheet','flux','ReadRowNames',true);
seprateData=fluxData(2:9,3:49);

fluxdata2=table2array(seprateData);

num=size(fluxdata2,1);
for i=1:size(fluxdata2,2)
    if i==1
        figure;stackplot({{1:num,fluxdata2(:,i),'Flux001'}},'Calibration','No',1)
    else
        hold on;
        plot(1:num,fluxdata2(:,i),'-o','LineWidth',2,'MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:));
    end
end
 
xticks([1:num]);
textContent=table2cell(fluxData(2:9,1));
 
 xticklabels(textContent);
 %%
 f1=parameter(2530,-7,5,{{'ip'},{'i_cs','i_tf'},{'i_PF7','I_PF8'},{'mp029t','mp040t'}});
autoYLim(f1)
%%
parameter(2530,-7,5,{{'ip'},{'i_cs,i_tf','ICS(kA),ITF(kA)'}})
manyshots('2486:2495', 'ip01,i_tf,i_cs,i_pf7',-3,5)
%%
% 用线圈电流测量的电流值和磁探针等输出的电压值进行标定输出
clear
filepath='E:\git\exl50u\diagnostics\emd\data\emdCalibration.xlsx';
shotnum=2607;
num=14;
[k,flux,mpt,mpn]=emdCalibration(shotnum,0.2,0.4,num);
[fluxData,t]=downloaddata(shotnum,'flux033','-7:5:1e-3',1,1);
pfData=downloaddata(shotnum,'itf01','-7:5:1e-3',1,1);
figure('Color',[1 1 1]);stackplot({{t,fluxData,pfData*k.flux(33),'Flux033,PF1'},{t,fluxData-pfData*k.flux(33),'Flux-PF*k'}},num2str(shotnum),'Time(s)',0)
%%
fluxRows=['B',num2str(num+1),':AV',num2str(num+1)];
mptRows=['B',num2str(num+1),':BA',num2str(num+1)];
mpnRows=['B',num2str(num+1),':AW',num2str(num+1)];
writematrix(k.flux, filepath, 'Sheet', 'flux', 'Range', fluxRows);
writematrix(k.mpt, filepath, 'Sheet', 'mpt', 'Range', mptRows);
writematrix(k.mpn, filepath, 'Sheet', 'mpn', 'Range', mpnRows);
%%









