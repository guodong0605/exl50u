function readspedata()
close all;clear all;clc;
shot=03095;
% [data, header] = readSPE([cd,'\rawdata\','shot-  ',num2str(shot),'.spe']);
sp = loadSPE([cd,'C:\readspe(PI光谱数据处理)(改良版)\rawdata\','shot-  ',num2str(shot),'.spe']);
data=sp.int;
ext=(sp.expo_time+1.2288);%1.2288s
[ax,bx,cx]=size(data);
spedata(1:ax,1:bx,1:cx)=0;
for i=1:cx
    spedata(:,:,i)=data(:,:,i);
end 
frame=10;
figure(1);
image(spedata(:,:,frame),'CDataMapping','scaled');
colormap(lines);
keyboard
figure(20);
plot(sp.wavelength,spedata(40,:,frame),'LineWidth',2);
 xlabel('Wavelength(nm)','FontSize',16,'FontName','Times New Roman')
 ylabel('BIV Intensity(cts)','FontSize',16,'FontName','Times New Roman')
 title(['#',num2str(shot),' BIV line @ 282nm'])
 set(gca,'FontSize',16,'FontName','Times New Roman')
BG=600;
global CIII
global Range
amu=10.9;%%璐ㄩ噺鏁帮紱
x0=[282.16296 282.45361 282.58298];
[temp,pixel0]=min(abs(sp.wavelength-x0(1)));
Dis=0.009;%%nm/pixel
FWHM=0.0572;%%nm
doppw=FWHM/sqrt(4*log(2));
doppw=doppw/Dis;
Range=495:530;
Range1=490:530;
% keyboard
Ti0=300/1000;%%keV
[Dop] = TikeV2Doppler(Ti0,amu,x0(1))/Dis;

for k=1:cx
    for i=1:ax
            spe=spedata(i,:,k);
            CIII=spe(Range);
%             spe=smooth(spe,'sgolay');
            [temp,index]=max(spe(pixel0-5:pixel0+5));
            if temp<BG+50
              varpos(i,k) =0;
              varTi(i,k) = 0;
              width(i,k)=0;
              amp(i,k)=0;
              Intensity(i,k)=0;
            else
                index=index+pixel0-5-1;
%                 figure(2);plot(1:1024,spe);hold on;
                b0=[max(spe) index doppw BG];
                bl=[0 index-5 doppw/2 BG/2];
                bu=[max(spe) index+5 Dop BG*1.5];
                b0=double(b0); bl=double(bl);bu=double(bu);
                       options   = optimset('Display','off','FinDiffType','central','FinDiffRelStep',1e-7);%% ,'MaxIter',100
            [params,~,residual,exitflag,output,lambda,jacobian] = ...
                    lsqnonlin(@multifit,b0,bl,bu,options);
             betab=params;
         %%residual:娈嬪樊銆傘?傘?俽esidual=yfit-CIII;
             alpha=0.05;
               if ~isempty(jacobian)
                   ci =nlparci(betab,residual,jacobian,alpha);%%%nlparci(...,'alpha',ALPHA) returns 100(1-ALPHA) percent confidence intervals.    
                   if isnan(ci)
                    ci=[betab;betab]';
                   end
                else
                   ci=[betab;betab]';disp('The fit is too bad!!!!!!!');%%
               end
              varpos(i,k) = 0.5*abs(ci(2,2)-ci(2,1));
              varw(i,k) = ci(3,2);%0.5*abs(ci(3,2)-ci(3,1));
              width(i,k)=betab(3);
              amp(i,k)=betab(1);
              Intensity(i,k)=sqrt(pi)*betab(1)*TikeV2Doppler(betab(3),amu,x0(1))/Dis;
              yfit=gaussspectra(betab,Range1);
              figure(2);plot(490:600,spe(490:600),'o',Range1,yfit,'LineWidth',2);
%               pause(1)
%               keyboard
            end
    end
end

for k=1:cx
    for i=1:ax
        if width(i,k)==0||width(i,k)<doppw
               Ti(i,k)=0;
               Tierr(i,k)=0;
               Intensity(i,k)=0;
        else
               width1(i,k)=sqrt(width(i,k)^2-doppw^2);
               varw(i,k)=sqrt(varw(i,k)^2-doppw^2);
               [TikeV] = Doppler2TikeV(width1(i,k)*Dis,amu,x0(1));
               [TikeVu] = Doppler2TikeV(varw(i,k)*Dis,amu,x0(1));
               Ti(i,k)=TikeV*1000;%eV
               Tierr(i,k)=(TikeVu-TikeV)*1000;
            if Ti(i,k)<5||Tierr(i,k)>Ti0*1000
              Ti(i,k)=0;%eV
              Tierr(i,k)=0;   
              Intensity(i,k)=0;
            end
        end
    end
end

R=xlsread([cd,'\R.xlsx'],['Toroidal']);
R=flip(R,1);
% keyboard
%%%time evolution
channel=[34 39 49];
Frame=1:cx;
for i=1:length(channel)
    [temp,index]=min(abs(R(:,3)-channel(i)));
    Rin(i)=R(index,1);
    [temp,xx]=find(Ti(channel(i),:)~=0);
    figure(4)
    plot(Frame(xx),Intensity(channel(i),xx),'-o','LineWidth',2);hold on;
    ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
    xlabel('Frame','FontSize',16,'FontName','Times New Roman');
    legend;
    figure(3);
    errorbar(Frame(xx),Ti(channel(i),xx),Tierr(channel(i),xx),'-o','LineWidth',2);hold on
%     keyboard
end
 unit='mm';
 name='R';
 legend_str=legend_upgrs(Rin,unit,name);
 legend(legend_str);
 xlabel('Frame','FontSize',16,'FontName','Times New Roman')
 ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman')
 title(['#',num2str(shot),' BIV line @ 282nm'])
  set(gca,'FontSize',16,'FontName','Times New Roman')
%%%time evolution
Fra=[4 6 10];
for i=1:length(Fra)
%     [temp,index]=min(abs(R(:,3)-channel(i)));
%     Rin(i)=R(index,1);
    [temp,xx]=find(Ti(:,Fra(i))~=0);
    xx=temp;
    figure(7)
    plot(R(1:12,1),Intensity(1:12,Fra(i)),'-o',R(13:end,1),Intensity(13:end,Fra(i)),'-o','LineWidth',2);hold on;
    ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
    xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
    figure(5)
    plot(R(xx,1),Intensity(xx,Fra(i)),'-o','LineWidth',2);hold on;
    ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
     xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
     legend;
    figure(6);
    errorbar(R(xx,1),Ti(xx,Fra(i)),Tierr(xx,Fra(i)),'-o','LineWidth',2);hold on
end
 unit='';
 name='Frame';
 legend_str=legend_upgrs(Fra,unit,name);
 legend(legend_str);
 xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
 ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman');
 title(['#',num2str(shot),' BIV line @ 282nm']);
 set(gca,'FontSize',16,'FontName','Times New Roman');
keyboard







