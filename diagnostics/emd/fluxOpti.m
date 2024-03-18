shotnum=1705;
filepath='E:\git\exl50u\diagnostics\emd\data\EXL50UProbeFluxLoop.xlsx';
FluxParameter=readtable(filepath,'Sheet','flux','VariableNamingRule','preserve');

fluxs='flux001-47';
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
    X=table2array(FluxParameter(:,2))/1e3;
    Z=table2array(FluxParameter(:,3))/1e3;
    K=table2array(FluxParameter(:,4));
figure;stackplot({{1:47,X,OutputParam(:,1),'PositionX'},{1:47,Z,OutputParam(:,2),'PositionZ'},{1:47,K,OutputParam(:,3),'K1,K2'}},'Calibration','No',1)

figure;stackplot({{X,Z,'meas'},{OutputParam(:,1),OutputParam(:,2),'fit'}},'Calibration','No',1)












