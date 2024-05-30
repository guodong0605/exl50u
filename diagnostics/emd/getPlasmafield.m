function [mpt2,mpn2,flux2]=getPlasmafield(shotnum,datatime)
currentFile = mfilename('fullpath');

folderpath=[fileparts(currentFile),'\data\'];
filepath=[folderpath,'EXL50U coefficient.xlsx'];
temp=readtable(filepath,'Sheet','mpt_coil');
mpt=table2array(temp(1:11,2:53));

temp=readtable(filepath,'Sheet','mpn_coil','Range','A1:BW11');
mpn=table2array(temp(1:11,2:49));

temp=readtable(filepath,'Sheet','flux_coil','Range','A1:BW11');
flux=table2array(temp(1:11,2:48));
%% 下载MPT  数据
mptdata=downloaddata(shotnum,'mp001-052t',datatime,0,1); %下载数据
% if shotnum<4365
%   index_mpt15=15;
%   index_mpt16=16;
%   temp=mptdata(:, index_mpt15);
%   mptdata(:, index_mpt15)=mptdata(:, index_mpt16);
%   mptdata(:, index_mpt16)=temp;
% end
%% 下载MPN  数据
mpndata1=downloaddata(shotnum,'mp085-096n',datatime,0,1); %下载数据  中心柱部分
mpndata2=downloaddata(shotnum,'mp001-036n',datatime,0,1); %下载数据
mpndata=[mpndata1,mpndata2];

 if shotnum<4365
  index_mpn41=41;
  index_mpn42=42;
  temp=mpndata(:, index_mpn41);
  mpndata(:, index_mpn41)=mpndata(:, index_mpn42);
  mpndata(:, index_mpn42)=temp;
 end
%% 下载Flux  数据
[fluxdata,time]=downloaddata(shotnum,'flux001-047',datatime,0,1); %下载数据
pfData= downloaddata(shotnum,'i_pf1-10,i_tf',datatime,0,0);  %下载对应的PF线圈电流，单位为 kA;
if shotnum<4365
  index_flux033=33;
  index_flux034=34;
    temp=fluxdata(:, index_flux033);
   fluxdata(:, index_flux033)=fluxdata(:, index_flux034);
   fluxdata(:, index_flux034)=temp;
end

mpt2=pfData*mpt;
mpn2=pfData*mpn;
flux2=pfData*flux;

%% 画图
oddnumber=1:48;
k=1;
for idx = 1:length(oddnumber)
    data1=mpndata(:,oddnumber(idx));
    data2=mpn2(:,oddnumber(idx));
    chnname=['mpn',num2str(oddnumber(idx))];
    dataset{k}={[time,data1,data2],chnname};
    k=k+1;
end
figure;colomnPlot(dataset, 4);
%%
oddnumber=1:52;
k=1;
 for idx = 1:length(oddnumber)
    data1=mptdata(:,oddnumber(idx));
    data2=mpt2(:,oddnumber(idx));
    chnname=['mpt',num2str(oddnumber(idx))];
    dataset{k}={[time,data1,data2],chnname};
    k=k+1;
 end
figure;colomnPlot(dataset, 4);
%%
oddnumber=1:47;
evennumber=2:2:47;
k=1;
for idx = 1:length(oddnumber)
    data1=fluxdata(:,oddnumber(idx));
    data2=flux2(:,oddnumber(idx));
    chnname=['flux',num2str(oddnumber(idx))];
    dataset{k}={[time,data1,data2],chnname};
    k=k+1;
end
figure;colomnPlot(dataset, 4);

% for idx = 1:length(evennumber)
%     data1=fluxdata(:,evennumber(idx));
%     data2=flux2(:,evennumber(idx));
%     chnname=['flux',num2str(evennumber(idx))];
%     dataset{k}={[time,data1,data2],chnname};
%     k=k+1;
% end
% figure;colomnPlot(dataset, 4);
end