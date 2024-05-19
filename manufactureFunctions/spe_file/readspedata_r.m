close all;clear all;clc;
shot=20610;
% [data, header] = readSPE([cd,'\rawdata\','shot-  ',num2str(shot),'.spe']);
sp = loadSPE([cd,'\rawdata\',num2str(shot),'.spe']);
data=sp.int;
[ax,bx,cx]=size(data);
exposure=-1+(sp.expo_time)*([1:cx]);%1.2288ms
spedata(1:ax,1:bx,1:cx)=0;
for i=1:cx
    spedata(:,:,i)=data(:,:,i);
end 
frame=10;
figure(1);
image(spedata(:,:,frame),'CDataMapping','scaled');
colormap(lines);
figure(20);
plot(sp.wavelength,spedata(40,:,frame),'LineWidth',2);
 xlabel('Wavelength(nm)','FontSize',16,'FontName','Times New Roman')
 ylabel('BIV Intensity(cts)','FontSize',16,'FontName','Times New Roman')
 title(['#',num2str(shot),' BIV line @ 282nm'])
 set(gca,'FontSize',16,'FontName','Times New Roman')
BG=580;
global CIII
global Range
amu=1;%%质量数；H:1;B:10.;C:12
x0=[656.255 282.181 282.45361 282.58298];% BIV:282.181;Ha:656
[temp,pixel0]=min(abs(sp.wavelength-x0(1)));
Dis=0.016;%%nm/pixel;3600:0.009;1800:0.016;
FWHM=0.0844;%%nm     3600:0.0572;1600：0.0844
doppw=FWHM/sqrt(4*log(2));
doppw=doppw/Dis;
Range=pixel0-30:pixel0+20;
Range1=pixel0-30:pixel0+20;
% keyboard
Ti0=300/1000;%%keV
[Dop] = TikeV2Doppler(Ti0,amu,x0(1))/Dis;

for k=1:cx
    for i=1:ax
            spe=spikedel(spedata(i,:,k));
            spe1=spedata(i,:,k);
%             figure(100);subplot(2,1,1)
%             plot(pixel0-50:pixel0+100,spe(pixel0-50:pixel0+100),'r-',...
%                 pixel0-50:pixel0+100,spe1(pixel0-50:pixel0+100),'bo','LineWidth',2);
%             legend('w/filter','w/o')
%             subplot(2,1,2)
%             plot(pixel0-50:pixel0+100,spe1(pixel0-50:pixel0+100)-spe(pixel0-50:pixel0+100),'b-','LineWidth',2)
%             legend('Spike')
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
                bl=[0 index-5 doppw/2 0];
                bu=[max(spe)*2 index+5 Dop BG*1.5];
                b0=double(b0); bl=double(bl);bu=double(bu);
                options   = optimset('Display','off','FinDiffType','central','FinDiffRelStep',1e-7);%% ,'MaxIter',100
            [params,~,residual,exitflag,output,lambda,jacobian] = ...
                    lsqnonlin(@multifit,b0,bl,bu,options);
             betab=params;
         %%residual:残差。。。residual=yfit-CIII;
             alpha=0.05;
               if ~isempty(jacobian)
                   ci =nlparci(betab,residual,'jacobian',jacobian,'alpha',alpha);%%%nlparci(...,'alpha',ALPHA) returns 100(1-ALPHA) percent confidence intervals.    
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
              figure(2);plot(pixel0-50:pixel0+100,spe(pixel0-50:pixel0+100),'-o',Range1,yfit,'LineWidth',2);
              title([num2str(i),'道，',num2str(k),'帧'],'fontsize',16)
%               pause(2)
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
%             if Ti(i,k)<5||Tierr(i,k)>Ti0*1000
%               Ti(i,k)=0;%eV
%               Tierr(i,k)=0;   
%               Intensity(i,k)=0;
%             end
        end
    end
end
%%
R=xlsread([cd,'\R.xlsx'],['Toroidal']);
R=flip(R,1);
% 
figure(101);image(exposure,R(:,1),Intensity,'CDataMapping','scaled');
figure(102);surf(exposure,R(:,1),Intensity)

% keyboard
%%%time evolution
channel=[36:45];
Frame=exposure;%1:cx;
for i=1:length(channel)
    [temp,index]=min(abs(R(:,3)-channel(i)));
    Rin(i)=R(index,1);
    [temp,xx]=find(Ti(channel(i),:)~=0);
    figure(4)
%     subplot(1,2,1)
    plot(Frame(xx),Intensity(channel(i),xx),'-o','LineWidth',2);hold on;
    ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
    xlabel('time(s)','FontSize',16,'FontName','Times New Roman');
%     legend;
%     subplot(1,2,2)
%     errorbar(Frame(xx),Ti(channel(i),xx),Tierr(channel(i),xx),'-o','LineWidth',2);hold on
%     keyboard
end
 unit='mm';
 name='R';
 legend_str=legend_upgrs(Rin,unit,name);
 legend(legend_str);
 xlabel('time(s)','FontSize',16,'FontName','Times New Roman')
 ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman')
 title(['#',num2str(shot),' BIV line @ 282nm'])
  set(gca,'FontSize',16,'FontName','Times New Roman')
%% %time evolution
time=[0.92 0.935 0.95 1.685 1.7 1.715];% 2.45 2.6 2.75 3.4 3.55 3.7
for i=1:length(time)
    [temp,index]=min(abs(exposure-time(i)));
    Fra(i)=index;
    [temp,xx]=find(Ti(:,Fra(i))~=0);
    xx=temp;
    figure(7)
    plot(R(1:12,1),Intensity(1:12,Fra(i)),'-o',R(13:end,1),Intensity(13:end,Fra(i)),'-o','LineWidth',2);hold on;
    ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
    xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
    figure(5)
%     subplot(1,2,1)
    plot(R(xx,1),Intensity(xx,Fra(i)),'-o','LineWidth',2);hold on;
    ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
     xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
%      legend;
%     subplot(1,2,2)
%     errorbar(R(xx,1),Ti(xx,Fra(i)),Tierr(xx,Fra(i)),'-o','LineWidth',2);hold on
end
 unit='s';
 name='time=';
 legend_str=legend_upgrs(time,unit,name);
 legend(legend_str);
 xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
 ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman');
 title(['#',num2str(shot),' BIV line @ 282nm']);
 set(gca,'FontSize',16,'FontName','Times New Roman');
 %% 温度剖面
% keyboard
time=80;
Ti_0=Ti(13:52,time);
Ti_0err=Tierr(13:52,time);
R_0=R(13:52,1);
figure(555);hold off
errorbar(R_0,Ti_0,Ti_0err,'-o','LineWidth',2)
xlim([300 1100])
grid on
xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman');
title(['#',num2str(shot),' Ti @ #',num2str(time),' frame']);
set(gca,'FontSize',16,'FontName','Times New Roman');
% keyboard
time=exposure;
save([cd,'\results\',num2str(shot),'.mat'],'R','time','Intensity')
%% 强度剖面
time=[1 1.5 2.0 2.5 3 3.5 4];
figure(666);hold off
for i=1:length(time)
[temp,ind(i)]=min(abs(exposure-time(i)));
Int=Intensity(1:12,ind(i));
% Ti_0err=Tierr(13:52,time);
R_0=R(1:12,1);
plot(R_0,Int,'-o','LineWidth',2);hold on
% legend([num2str(time(i)),'s']);hold on
end
% xlim([300 1100])
grid on
xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
ylabel('Int/counts','FontSize',16,'FontName','Times New Roman');
% title(['#',num2str(shot),' H\alpha Intensity @ ',num2str(time),' s']);
set(gca,'FontSize',16,'FontName','Times New Roman');
legend(num2str(time(1)),num2str(time(2)),num2str(time(3)),num2str(time(4)),...
        num2str(time(5)),num2str(time(6)),num2str(time(7)))







