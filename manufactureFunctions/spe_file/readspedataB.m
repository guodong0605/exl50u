function readspedataB(shot)
% close all;clear all;clc;
%  shot=03359;
%  [data, header] = readSPE([cd,'\rawdata\','shot-  ',num2str(shot),'.spe']);
sp = loadSPE(['Y:\','0',num2str(shot),'.spe']);%
% sp = loadSPE(['C:\readspe(PIπ‚∆◊ ˝æ›¥¶¿Ì)(∏ƒ¡º∞Ê)\rawdata\','0',num2str(shot),'.spe']);%
data=sp.int;
[ax,bx,cx]=size(data);
% expo=43.649/1000;%%readout time;
expo=43.649/1000;%%readout time;
% keyboard
if sp.expo_time<expo
    sp.expo_time=expo;
end
% exposure=-0.678+(sp.expo_time)*([0:cx-1]);%1.2288ms
exposure=-1.7+(sp.expo_time)*([0:cx-1]);%1.2288ms
% keyboard
spedata(1:ax,1:bx,1:cx)=0;
for i=1:cx
    spedata(:,:,i)=data(:,:,i);
end 
frame=30;
figure(1);
image(spedata(:,:,frame),'CDataMapping','scaled');
colormap(lines);
% keyboard
figure(20);%%sp.wavelength
plot(1:1024,spedata(11,:,frame),'LineWidth',2);
 xlabel('Wavelength(nm)','FontSize',16,'FontName','Times New Roman')
%  ylabel('BIV Intensity(cts)','FontSize',16,'FontName','Times New Roman')
 ylabel('BII Intensity(cts)','FontSize',16,'FontName','Times New Roman')
 title(['#',num2str(shot),' BIV line @ 282nm'])
%  title(['#',num2str(shot),' BII line @ 494nm'])
 set(gca,'FontSize',16,'FontName','Times New Roman')
BG=mean(mean(spedata(:,:,1)));
% keyboard
global CIII
global Range
amu=10.81;%%Ë¥®ÈáèÊï∞ÔºõH:1;B:10.;C:12
x0=[282.181 282.45361 282.58298]-0.3230;% BIV:282.181;Ha:656
% x0=[494]-0.3230
[temp,pixel0]=min(abs(sp.wavelength-x0(1)));
% Dis=sp.wavelength(2)-sp.wavelength(1);%0.009;%%nm/pixel;3600:0.009;1800:0.016;
Dis=0.009;
% FWHM=0.0572;%%nm     3600:0.0572;1800Ôº?0.0844
FWHM=0.0335;
doppw=FWHM/sqrt(4*log(2));
doppw=doppw/Dis;
Range=pixel0-30:pixel0+20;
Range1=pixel0-30:pixel0+25;
% keyboard
Ti0=1000/1000;%%keV
[Dop] = TikeV2Doppler(Ti0,amu,x0(1))/Dis;
%jkdata=medfilt2(data(i,:,k),[6 2],'indexed')
% for k=20
%      jkdata1=medfilt2(data(:,:,k),[4 4],'indexed');
%      jkdata=smoothdata(jkdata1,'gaussian');
% keyboard

rms1=10;
rms2=600;

 for i=1:ax
     for k=1:cx
%       for i=1:52
%           spe=spikedel(spedata(i,:,k));
          spe1=spedata(i,:,k);
%           spe=spe1;
          tpspe=spedata(i,:,k);   
          spe = rmspark2023June(tpspe,rms1,rms2);
                             
%              spe=jkdata(i,:);
%             fdata=rmspark2023Mar(spedata(i,:,k),300);
%             spe=fdata;
%              spe1=spedata(i,:,k);
%            figure(100);
%             plot(pixel0-50:pixel0+100,spe(pixel0-50:pixel0+100),'r-',...
%                 pixel0-50:pixel0+100,spe1(pixel0-50:pixel0+100),'bo','LineWidth',2);    
%             legend;
%             keyboard
%             spe=spe1;
%             figure(100);%subplot(2,1,1)
%             plot(pixel0-50:pixel0+100,spe(pixel0-50:pixel0+100),'r-',...
%                 pixel0-50:pixel0+100,spe1(pixel0-50:pixel0+100),'bo','LineWidth',2);
%             legend('w/filter','w/o')
 %           pause(0.5)
%             subplot(2,1,2)
%             plot(pixel0-50:pixel0+100,spe1(pixel0-50:pixel0+100)-spe(pixel0-50:pixel0+100),'b-','LineWidth',2)
%             legend('Spike')
% figure(100);plot(1:1024,spe,1:1024,spe1)
% keyboard
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
%                 figure(100);plot(1:1024,spe,'o',1:1024,spe1,'-')
%                 xlim([480 580])
%                 pause(2);
                index=index+pixel0-5-1;
%                 figure(2);plot(1:1024,spe);hold on;
                b0=[max(spe) index doppw BG];
                bl=[0 index-5 doppw/4 0];
                bu=[max(spe)*2 index+5 Dop BG*1.5];
                b0=double(b0); bl=double(bl);bu=double(bu);
                options   = optimset('Display','off','FinDiffType','central','FinDiffRelStep',1e-7);%% ,'MaxIter',100
            [params,~,residual,exitflag,output,lambda,jacobian] = ...
                    lsqnonlin(@multifit,b0,bl,bu,options);
             betab=params;
         %%residual:ÊÆãÂ∑Æ„ÄÇ„?Ç„?Çresidual=yfit-CIII;
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
              Intensity(i,k)=sqrt(pi)*betab(1)*betab(3);%TikeV2Doppler(betab(3),amu,x0(1))/Dis;
              yfit=gaussspectra(betab,Range1);
%               if width(i,k)>doppw
             if width(i,k)>doppw/4
%                 Ti01 = Doppler2TikeV(sqrt(width(i,k)^2-doppw^2)*Dis,amu,x0(1))*1000;
                Ti01 = Doppler2TikeV(sqrt(width(i,k)^2-doppw^2)*Dis,amu,x0(1))*1000;
                TiF= Doppler2TikeV(doppw*Dis,amu,x0(1))*1000;
              else 
                Ti01=0;
             end
              
              %             figure(2);plot(pixel0-50:pixel0+100,spe(pixel0-50:pixel0+100),'o',Range1,yfit,'LineWidth',2);
%               title([num2str(i),'ÈÅ?; ',num2str(k),'Â∏?; ',num2str(exposure(k)),'s','; Ti:',num2str(roundn(Ti01,-2)),'eV'],'fontsize',16)...
%                'FWHM=',num2str(roundn(betab(3)*sqrt(4*log(2)),-2)),'Pix.' ,'; Ti:',num2str(roundn(Ti,-2)),'eV','; TiF:',num2str(roundn(TiF,-2)),'eV'...

%             if Ti01>150
%            pause(0.5)
%              figure(2);
%              plot(pixel0-50:pixel0+100,spe(pixel0-50:pixel0+100),'o',pixel0-50:pixel0+100,spe1(pixel0-50:pixel0+100),'--',Range1,yfit,'-^','LineWidth',2);
%              xlim([440 540])
%              FWHM = roundn(betab(3)*sqrt(4*log(2)),-2);
%              Ti_rounded = roundn(Ti01,-2);
%              TiF_rounded = roundn(TiF,-2);
% %              title_str = [num2str(i), 'ÈÅ?; ', num2str(k), 'Â∏?; ',
% %              num2str(exposure(k)), 's; Ti:', num2str(roundn(Ti01,-2)),
% %              'eV; FWHM=', num2str(FWHM), 'Pix.; Ti:',
% %              num2str(Ti_rounded), 'eV; TiF:', num2str(TiF_rounded),
% %              'eV'];
%             title_str = ['CH:',num2str(i), 'Frame:', num2str(k), ' ', num2str(exposure(k)), 's; Ti:', num2str(roundn(Ti01,-2)), 'eV; FWHM=', num2str(FWHM), 'Pix.; Ti:', num2str(Ti_rounded), 'eV;'];
%              title(title_str, 'fontsize', 16);
%               if Ti01>150
%                     pause(2)
%               end
        end
     end
 end
%keyboard
for k=1:cx
    for i=1:ax
        if width(i,k)==0||width(i,k)<doppw/4
               Ti(i,k)=0;
               Tierr(i,k)=0;
               Intensity(i,k)=0;
        else
               width1(i,k)=sqrt(width(i,k)^2-doppw^2);
               varw(i,k)=sqrt(varw(i,k)^2-doppw^2);
               [IFTi] = Doppler2TikeV(doppw*Dis,amu,x0(1));
               [TikeV] = Doppler2TikeV(width1(i,k)*Dis,amu,x0(1));
               [TikeVu] = Doppler2TikeV(varw(i,k)*Dis,amu,x0(1));
               Ti(i,k)=TikeV*1000;%eV
               Tierr(i,k)=(TikeVu-TikeV)*1000;
%             if Ti(i,k)<5||Tierr(i,k)>Ti0*1000
%               Ti(i,k)=0;%eV
%               Tierr(i,k)=0;   
%               Intensity(i,k)=0;
        end        
    end
end

%%
if shot<22700
    R=xlsread([cd,'\R.xlsx'],['Sheet1']);
    R(2,:)=[];
    % R=flip(R,1);
    [Rx,index]=sort(R(:,3),'ascend');
    % RR=R(index,1);
    R(:,1)=R(index,1);
    % R(:,3)=Rx;
    [Ry,index]=sort(R(:,1),'ascend');
    R(:,1)=Ry;R(:,3)=R(index,3);
    Intensity=Intensity(index,:);Ti=Ti(index,:);Tierr=Tierr(index,:);
    RR=R(:,1);
elseif shot<25060&&shot>22700
     R=xlsread([cd,'\RR.xlsx'],['Sheet1']);   
     [Rx,index]=sort(R(:,7),'descend');
    R(:,6)=R(index,6);
    [Ry,index]=sort(R(:,6),'ascend');
    R(:,6)=Ry;R(:,7)=R(index,7);
    Intensity=Intensity(index,:);Ti=Ti(index,:);Tierr=Tierr(index,:);
    RR=R(:,6);
else
    R=xlsread([cd,'\RRm.xlsx'],['Sheet2']);   
    [Rx,index]=sort(R(:,2),'ascend');
    R(:,3)=R(index,3);
%     Intensity=Intensity(index,:);Ti=Ti(index,:);Tierr=Tierr(index,:);
    RR=R(:,3); 
end

% keyboard
%%%time evolution
channel=[340 400 480 500 600 700];%mm
Frame=exposure;%1:cx;
for i=1:length(channel)
    [temp,index]=min(abs(R(:,1)-channel(i)));
    Rin(i)=R(index,1);
    [temp,xx]=find(Ti(index,:)~=0);
%     figure(4)
%     subplot(1,2,1)
%     plot(Frame(xx),Intensity(index,xx),'-o','LineWidth',2);hold on;
%     ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
%     xlabel('time(s)','FontSize',16,'FontName','Times New Roman');
%     legend;
%     subplot(1,2,2)
%     errorbar(Frame(xx),Ti(index,xx),Tierr(index,xx),'-o','LineWidth',2);hold on
%      keyboard
end
%  unit='mm';
%  name='R';
%  legend_str=legend_upgrs(Rin,unit,name);
%  legend(legend_str);
%  xlabel('time(s)','FontSize',16,'FontName','Times New Roman')
%  ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman')
%  title(['#',num2str(shot),' BIV line @ 282nm'])
%   set(gca,'FontSize',16,'FontName','Times New Roman')
%% %time evolution
% time=[2 2.1 2.2 2.5 2.7 2.9 3.1 3.3];
% for i=1:length(time)
%     [temp,index]=min(abs(exposure-time(i)));
%     Fra(i)=index;
%     [temp,xx]=find(Ti(:,Fra(i))~=0);
%     xx=temp;
%     figure(7)
%     plot(R(1:12,1),Intensity(1:12,Fra(i)),'-o',R(13:52,1),Intensity(13:52,Fra(i)),'-o','LineWidth',2);hold on;
%     ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
%     xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
%     figure(5)
%     subplot(1,2,1)
%     plot(R(xx,1),Intensity(xx,Fra(i)),'-o','LineWidth',2);hold on;
%     ylabel('BVI Intensity(cts)','FontSize',16,'FontName','Times New Roman');
%      xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
%      legend;
%     subplot(1,2,2)
%     errorbar(R(xx,1),Ti(xx,Fra(i)),Tierr(xx,Fra(i)),'-o','LineWidth',2);hold on
% end
%  unit='s';
%  name='time';
%  legend_str=legend_upgrs(time,unit,name);
%  legend(legend_str);
%  xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
%  ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman');
%  title(['#',num2str(shot),' BIV line @ 282nm']);
%  set(gca,'FontSize',16,'FontName','Times New Roman');
 %% Ê∏©Â∫¶ÂâñÈù¢
% keyboard
% ind1=10;
% Ti_0=Ti(13:52,ind1);
% Ti_0err=Tierr(13:52,ind1);
% R_0=R(13:52,1);
% figure(555);hold off
% errorbar(R_0,Ti_0,Ti_0err,'-o','LineWidth',2)
% xlim([300 1100])
% grid on
% xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
% ylabel('Ti(eV)','FontSize',16,'FontName','Times New Roman');
% title(['#',num2str(shot),' Ti @ #',num2str(ind1),' frame']);
% set(gca,'FontSize',16,'FontName','Times New Roman');
% keyboard
clear R
R=RR;
time=exposure;
save([cd,'\results\',num2str(shot),'.mat'],'R','time','Ti','Tierr','Intensity','IFTi')
%% Âº∫Â∫¶ÂâñÈù¢
% time=[1 1.5 2.0 2.5 3 3.5 4];
% figure(666);hold off
% for i=1:length(time)
% [temp,ind(i)]=min(abs(exposure-time(i)));
% Int=Intensity(1:12,ind(i));
% % Ti_0err=Tierr(13:52,time);
% R_0=R(1:12,1);
% plot(R_0,Int,'-o','LineWidth',2);hold on
% % legend([num2str(time(i)),'s']);hold on
% end
% % xlim([300 1100])
% grid on
% xlabel('R(mm)','FontSize',16,'FontName','Times New Roman');
% ylabel('Int/counts','FontSize',16,'FontName','Times New Roman');
% % title(['#',num2str(shot),' H\alpha Intensity @ ',num2str(time),' s']);
% set(gca,'FontSize',16,'FontName','Times New Roman');
% legend(num2str(time(1)),num2str(time(2)),num2str(time(3)),num2str(time(4)),...
%         num2str(time(5)),num2str(time(6)),num2str(time(7)))







