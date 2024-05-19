function fdata=rmspark2023Mar(rdata,rms)
%Author: Prof. Dr. Yuejiang Shi yjshi@ipp.ac.cn 
%badch=[5];
%rdata(badch,:)=(rdata(badch-1,:)+rdata(badch+1,:))/2;

%rms: for gradient

%rdata = rdata'; % rdata should be 1*N array

maxd=max(rdata,[],1);
meand=mean(rdata,1);
[ia ib]=find(meand<=0);
meand(ib)=mean(meand);
clear ia;
clear ib;

sz=size(rdata);
sz1=sz(1);
sz2=sz(2);
datas=rdata./meand;
wv=1:sz2;


% [ia ib]=find(datas>rms);
% fdata=rdata;
% fdata(ia,ib)=(rdata(ia-1,ib)+rdata(ia+1,ib))/2;


% tp1=ones([sz1,1]);
% gmeand = meshgrid(meand,tp1);
% fdata(ia,ib)=gmeand(ia,ib);

%gdata = gradient(rdata);
gdata = rdata(2:sz2)-rdata(1:sz2-1);

[ia ib]=find(gdata<rms);
[iax,ibx]=find(gdata>=rms);

tp = ib(1:length(ib)-1)+1;
tpx= ibx(1:length(ibx)-1)+1;


nwv = wv(tp);
ndata = rdata(tp);
 
%fdata = spline(iae,rdata(iae),wv);
% keyboard

% fdata =  interp1(iae,rdata(iae),wv);
fdata =  interp1(nwv,ndata,wv);

%fdata = fdata';

plot(wv,rdata,wv(tpx),rdata(tpx),'o',wv(tp),rdata(tp)','*',wv,fdata)

keyboard



% fdata=rdata;
% fdata(ia,ib)=(rdata(ia-1,ib)+rdata(ia+1,ib))/2;





