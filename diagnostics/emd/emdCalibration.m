function [k,flux,mpt,mpn,pfCoilMean]=emdCalibration(shotnum,t1,t2,num)
acq_start=-7;        %采集开始时间，用于去除信号的偏置和漂移
fs=1e-3;
data_shift=1;
data_start=round((t1-acq_start)/fs+1);
data_end=round((t2-acq_start)/fs);
currentFile = mfilename('fullpath');
folderpath=[currentFile(1:end-10),'\data\'];
filepath=[folderpath,'EXL50U coefficient.xlsx'];
datatime=[num2str(acq_start),':5:',num2str(fs)];
%%
[mptdata,~,~]=downloaddata(shotnum,'mp001-052t',datatime,0,data_shift); %下载数据
for i=1:size(mptdata,2)
    mpt(i)=mean(mptdata(data_start:data_end,i));
end
%%
[mpndata1,~,~]=downloaddata(shotnum,'mp085-096n',datatime,0,data_shift); %下载数据
[mpndata2,~,~]=downloaddata(shotnum,'mp001-036n',datatime,0,data_shift); %下载数据
mpndata=[mpndata1,mpndata2];
for i=1:size(mpndata,2)
    mpn(i)=mean(mpndata(data_start:data_end,i));
end

%%
[fluxdata,~,~]=downloaddata(shotnum,'flux001-047',datatime,0,data_shift); %下载数据
for i=1:size(fluxdata,2)
    flux(i)=mean(fluxdata(data_start:data_end,i));
end
%%
pfdata= downloaddata(shotnum,'ps1-10_exp,ps1-2_exp,cs_exp,i_tf',datatime,0,0);
for i=1:size(pfdata,2)
    pfCoilMean(i)=mean(pfdata(data_start:data_end,i));
end

    k.flux=flux./pfCoilMean(num);
    k.mpt=mpt./pfCoilMean(num);
    k.mpn=mpn./pfCoilMean(num);

end