function [mpt_ratio,mpn_ratio,flux_ratio]=coilcalibration(shotnum,t1,t2,coilname)

isExcelData=1;
acq_start=-3;        %采集开始时间，用于去除信号的偏置和漂移
fs=1e-3;
data_shift=1;

mpt_threshold=0.5; %设置一个阈值，统计绝对值大于该阈值的数据的相对误差
mpn_threshold=0.5;
flux_threshold=0.3;

data_start=round((t1-acq_start)/fs+1);
data_end=round((t2-acq_start)/fs);
currentFile = mfilename('fullpath');
folderpath=[currentFile(1:end-10),'\data\'];
filepath=[folderpath,'EXL50U coefficient.xlsx'];
datatime=[num2str(acq_start),':7:',num2str(fs)];
%%  下载MPT数据
mptdata=downloaddata(shotnum,'mp001-052t',datatime,0,data_shift,1); %下载数据
for i=1:size(mptdata,2)
    mpt(i)=mean(mptdata(data_start:data_end,i));  %现在的原始信号
end
if shotnum<4365
    temp=mpt(16);
    mpt(16)=mpt(15);
    mpt(15)=temp;
end
%% 下载MPN  数据
mpndata1=downloaddata(shotnum,'mp085-096n',datatime,0,data_shift,1); %下载数据  中心柱部分
mpndata2=downloaddata(shotnum,'mp001-036n',datatime,0,data_shift,1); %下载数据
mpndata=[mpndata1,mpndata2];
for i=1:size(mpndata,2)
    mpn(i)=mean(mpndata(data_start:data_end,i));        %取出给定时刻的平均值数据
end
mpn_index=abs(mpn)>mpn_threshold;
if shotnum<4365
    temp=mpn(42);
    mpn(42)=mpn(41);
    mpn(41)=temp;
end
%% 下载Flux  数据
fluxdata=downloaddata(shotnum,'flux001-047',datatime,0,data_shift,1); %下载数据
for i=1:size(fluxdata,2)
    flux(i)=mean(fluxdata(data_start:data_end,i));   %取出 给定时刻的磁通环的电压信号平均值
end
flux_index=abs(flux)>flux_threshold;
if shotnum<4365
    temp=flux(34);
    flux(34)=flux(33);
    flux(33)=temp;
end
%% 下载线圈电流
pfdata= downloaddata(shotnum,coilname,datatime,0,0);  %下载对应的PF线圈电流，单位为 kA
IPF=mean(pfdata(data_start:data_end));

mpt_ratio=mpt/IPF; 
mpn_ratio=mpn/IPF;    
flux_ratio=flux/IPF;  

figure('Color',[1 1 1]);stackplot({{1:52,mpt_ratio,'MPT/ITF'},{1:48,mpn_ratio,'MPT/ITF'},{1:47,flux_ratio,'flux/ITF'}},'calibration','No.',1)
%%
end