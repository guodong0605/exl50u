function RelativeError=mpProfile(shotnum,t1,t2)
acq_start=-3;        %采集开始时间，用于去除信号的偏置和漂移
fs=1e-3;
data_shift=1;
data_start=round((t1-acq_start)/fs+1);
data_end=round((t2-acq_start)/fs);
currentFile = mfilename('fullpath');
folderpath=[currentFile(1:end-10),'\data\'];
filepath=[folderpath,'EXL50U coefficient.xlsx'];
GFcoefficent=[folderpath,'coilData.mat'];
datatime=[num2str(acq_start),':5:',num2str(fs)];
%%
[mptdata,~,~]=downloaddata(shotnum,'mp001-052t',datatime,0,data_shift); %下载数据
mpt_k=xlsread(filepath,'mpt','D2:D53');
for i=1:size(mptdata,2)
    mpt(i)=mean(mptdata(data_start:data_end,i));
end
Bt=mpt.*mpt_k';
%%
[mpndata1,~,~]=downloaddata(shotnum,'mp085-096n',datatime,0,data_shift); %下载数据
[mpndata2,~,~]=downloaddata(shotnum,'mp001-036n',datatime,0,data_shift); %下载数据
mpndata=[mpndata1,mpndata2];
mpn_k=xlsread(filepath,'mpn','D2:D49');
for i=1:size(mpndata,2)
    mpn(i)=mean(mpndata(data_start:data_end,i));
end
Br=mpn.*mpn_k';

%%
[fluxdata,~,~]=downloaddata(shotnum,'flux001-047',datatime,0,data_shift); %下载数据
% temp=fluxdata(:,24);
% fluxdata(:,24)=fluxdata(:,23);
% fluxdata(:,23)=temp;
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
    temp=mean(pfdata(data_start:data_end,i));
    if abs(temp)<100
        IPF(i)=0;
    else
        IPF(i)=temp;
    end
end

IPF(12:15)=0; % 先不考虑真空室内的主动线圈和被动线圈
Flux_compute=flux_k.*repmat(IPF',1,size(flux_k,2));
Bt_compute=bt_k.*repmat(IPF',1,size(bt_k,2));
Br_compute=br_k.*repmat(IPF',1,size(br_k,2));
flux2=sum(Flux_compute,1);
Bt2=sum(Bt_compute,1);
Br2=sum(Br_compute,1);

%%
%-----------------画图------------------------------
num1=1:52;
figure('Color',[1 1 1]);plot(num1,Bt*10000,':o','Color','k','LineWidth',1.5,'MarkerSize',8,'MarkerFace','b','MarkerEdgeColor','b');
hold on;plot(num1,Bt2,':s','Color','k','LineWidth',1.5,'MarkerSize',8,'MarkerFace','r','MarkerEdgeColor','r');
fillall(1,16,'[1,0,0]');
fillall(17,25,'[0,1,0]');
fillall(26,28,'[0,0,1]');
fillall(29,40,'[0,1,1]');
fillall(41,43,'[0,0,1]');
fillall(44,52,'[0,1,0]');
% fillall(22,32,'[0,0,1]');
xlabel('$MPT-No$','interpreter','Latex');
ylabel('$\rm B_{\theta} (G)$','interpreter','Latex');
title([num2str(shotnum),'-Magnetic Probe'])
legend('Experiment','Compute')
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 22, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','off');
%%
%-----------------画图------------------------------
num2=1:48;
figure('Color',[1 1 1]);plot(num2,Br*10000,':o','Color','k','LineWidth',1.5,'MarkerSize',8,'MarkerFace','b','MarkerEdgeColor','b');
hold on;plot(num2,Br2,':s','Color','k','LineWidth',1.5,'MarkerSize',8,'MarkerFace','r','MarkerEdgeColor','r');
fillall(1,12,'[1,0,0]');
fillall(13,21,'[0,1,0]');
fillall(22,24,'[0,0,1]');
fillall(25,36,'[0,1,1]');
fillall(37,39,'[0,0,1]');
fillall(40,48,'[0,1,0]');
% fillall(22,32,'[0,0,1]');
xlabel('$MPN-No$','interpreter','Latex');
ylabel('$\rm B_R (G)$','interpreter','Latex');
legend('Experiment','Compute')
title([num2str(shotnum),'Magnetic Probe'])
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 22, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','off');

%%
%-----------------画图------------------------------
num3=1:47;
figure('Color',[1 1 1]);plot(num3,flux*1000,':o','Color','k','LineWidth',1.5,'MarkerSize',8,'MarkerFace','b','MarkerEdgeColor','b');
hold on;plot(num3,flux2*1000,':s','Color','k','LineWidth',1.5,'MarkerSize',8,'MarkerFace','r','MarkerEdgeColor','r');
fillall(1,19,'[1,0,0]');
fillall(20,28,'[0,1,0]');
fillall(29,38,'[0,1,1]');
fillall(39,47,'[0,1,0]');
% fillall(22,32,'[0,0,1]');
xlabel('$FLUX-No$','interpreter','Latex');
ylabel('$\rm \phi (mWb)$','interpreter','Latex');
title([num2str(shotnum),'-Flux Loop'])
legend('Experiment','Compute')
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 22, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','off');

%%
bt_err=abs(Bt*1e4-Bt2)./Bt2*100;
bn_err=abs(Br*1e4-Br2)./Br2*100;
flux_err=abs(flux-flux2)./flux2*100;
figure('Color',[1 1 1]);stackplot({{num1,bt_err,'B_{\theta}'},{num2,bn_err,'B_R'},{num3,flux_err,'Flux'}},'Relative Error','No.',1)
RelativeError.bt=Bt*1e4./Bt2;
RelativeError.br=Br*1e4./Br2;
RelativeError.flux=flux./flux2;
%%