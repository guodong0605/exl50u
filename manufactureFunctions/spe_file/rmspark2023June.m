function fdata=rmspark2023June(rdata,rms1,rms2)
%Author: Prof. Dr. Yuejiang Shi yjshi@ipp.ac.cn 
%badch=[5];
%rdata(badch,:)=(rdata(badch-1,:)+rdata(badch+1,:))/2;

%rms1: for height
%rms2: for gradient

%rdata = rdata'; % rdata should be 1*N array

maxd=max(rdata,[],1);
meand=mean(rdata,1);
[ia ib]=find(meand<=0);
meand(ib)=mean(meand);
clear ia;
clear ib;

md = mean(rdata);

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

[ia1 ib1]=find(rdata<md*rms1);
[iax1 ibx1]=find(rdata>=md*rms1);
nwv=wv(ib1);
ndata=rdata(ib1);


% gdata = gradient(ndata);
gdata = ndata(2:length(ndata))-ndata(1:length(ndata)-1); 

[ia2 ib2]=find(gdata<rms2);
[iax2,ibx2]=find(gdata>=rms2);

tp = ib2(1:length(ib2)-1)+1;
tpx = ibx2(1:length(ibx2)-1)+1;

nwv2 = nwv(tp);
ndata2 = ndata(tp);
 
%fdata = spline(iae,rdata(iae),wv);

% fdata =  interp1(iae,rdata(iae),wv);
fdata =  interp1(nwv2,ndata2,wv);
% figure(3);
% plot(wv,rdata,wv(ibx1),rdata(ibx1),'o',nwv(tpx),ndata(tpx),'*',wv,fdata)

%fdata = fdata';

%keyboard




% fdata=rdata;
% fdata(ia,ib)=(rdata(ia-1,ib)+rdata(ia+1,ib))/2;





