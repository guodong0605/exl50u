function mpProfile(shotnum,t1,t2)
step=0.001;          %采样数据间隔
acq_start=-3;        %采集开始时间，用于去除信号的偏置和漂移
fs=1e-3;
data_start=(t1-acq_start)/fs+1;
data_end=(t2-acq_start)/fs;
currentFile = mfilename('fullpath');
folderpath=[currentFile,'\data\'];
filepath=[folderpath,'EXL50U coefficient.xlsx'];
GFcoefficent=[folderpath,'coilData.mat'];
datatime=[num2str(acq_start),':5:',num2str(step)];
%%
[mptdata,~,~]=downloaddata(shotnum,'mp001-052t',datatime,0,1); %下载数据
mpt_k=xlsread(filepath,'mpt','D2:D53');
for i=1:size(mptdata,2)
    mpt(i)=mean(mptdata(data_start:data_end,i));
end
Bt=mpt.*mpt_k';
%%
[mpndata1,~,~]=downloaddata(shotnum,'mp085-096n',datatime,0,1); %下载数据
[mpndata2,~,~]=downloaddata(shotnum,'mp001-036n',datatime,0,1); %下载数据
mpndata=[mpndata1,mpndata2];
mpn_k=xlsread(filepath,'mpn','D2:D49');
for i=1:size(mpndata,2)
    mpn(i)=mean(mpndata(data_start:data_end,i));
end
Br=mpn.*mpn_k';

%%
[fluxdata,~,~]=downloaddata(shotnum,'flux001-047',datatime,0,1); %下载数据
Flux_k=xlsread(filepath,'flux','C2:C48');
for i=1:size(fluxdata,2)
    flux(i)=mean(fluxdata(data_start:data_end,i));
end
flux=flux.*Flux_k';
%%
% download the data of from IPF and multiply the coefficient computed ny SE
load(GFcoefficent)
flux_k=coilData.flux;
bt_k=coilData.bt;

br_k=coilData.br;
pfdata= downloaddata(shotnum,'cs_exp,ps1-10_exp',datatime,0,0);
for i=1:size(pfdata,2)
    IPF(i)=mean(pfdata(data_start:data_end,i));
end
IPF(12:15)=0; % 先不考虑真空室内的主动线圈和被动线圈
Flux_compute=flux_k.*repmat(IPF,size(flux_k,1),1);
Bt_compute=bt_k.*repmat(IPF,size(bt_k,1),1);
Br_compute=br_k.*repmat(IPF,size(br_k,1),1);
flux2=sum(Flux_compute,2);
Bt2=sum(Bt_compute,2);
Br2=sum(Br_compute,2);

%%
%-----------------画图------------------------------
num1=1:52;
figure;plot(num1,Bt*1000,':o','Color','k','LineWidth',1.5,'MarkerSize',6,'MarkerFace','b','MarkerEdgeColor','b');
hold on;plot(num1,Bt2*1000,':s','Color','k','LineWidth',1.5,'MarkerSize',6,'MarkerFace','r','MarkerEdgeColor','r');
fillall(1,16,'[1,0,0]');
fillall(17,25,'[0,1,0]');
fillall(26,28,'[0,0,1]');
fillall(29,40,'[0,1,1]');
fillall(41,43,'[0,0,1]');
fillall(44,52,'[0,1,0]');
% fillall(22,32,'[0,0,1]');
xlabel('$MPT-No$','interpreter','Latex');
ylabel('$\rm\phi (Gs)$','interpreter','Latex');
title('Magnetic Probe');
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','off');
%%
%-----------------画图------------------------------
num2=1:48;
figure;plot(num2,Br*1000,':o','Color','k','LineWidth',1.5,'MarkerSize',6,'MarkerFace','b','MarkerEdgeColor','b');
hold on;plot(num2,Br2*1000,':s','Color','k','LineWidth',1.5,'MarkerSize',6,'MarkerFace','r','MarkerEdgeColor','r');
fillall(1,12,'[1,0,0]');
fillall(13,21,'[0,1,0]');
fillall(22,24,'[0,0,1]');
fillall(25,36,'[0,1,1]');
fillall(37,39,'[0,0,1]');
fillall(40,48,'[0,1,0]');
% fillall(22,32,'[0,0,1]');
xlabel('$MPN-No$','interpreter','Latex');
ylabel('$\rm\phi (Gs)$','interpreter','Latex');
title('Magnetic Probe')
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','off');

%%
%-----------------画图------------------------------
num3=1:47;
figure;plot(num3,flux*1000,':o','Color','k','LineWidth',1.5,'MarkerSize',6,'MarkerFace','b','MarkerEdgeColor','b');
hold on;plot(num3,flux2*1000,':s','Color','k','LineWidth',1.5,'MarkerSize',6,'MarkerFace','r','MarkerEdgeColor','r');
fillall(1,19,'[1,0,0]');
fillall(20,28,'[0,1,0]');
fillall(29,38,'[0,1,1]');
fillall(39,47,'[0,1,0]');
% fillall(22,32,'[0,0,1]');
xlabel('$FLUX-No$','interpreter','Latex');
ylabel('$\rm\phi (Wb)$','interpreter','Latex');
title('Flux Loop')
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','off');

%%