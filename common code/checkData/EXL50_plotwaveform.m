% plotwaveform
% clear all
clear image
shotnum=26010;%请选择炮号
xlims=[-0.5,7];%横轴范围，s
fig_size=[];%图片大小，单位：像素
dt=0.001;%读取数据的时间分辨率,s
fs=20;%字体大小

sig={{'Ip'},                                {'ha001','has01'};...
{'mwi_ne001','hcn_ne001','hcn_ne002'},                  {'CIII_IM_02','OII_IM_02'};...
{'Wdia04','betap02','loopv'},                            {'AXUV007','AXUV015'};...
{'ti01','vt01','BIII'},                       {'sddinten01','sddinten02'};
{'ECRH0_UK','ECRH1_UK','ECRH2_UK','CCE4'},              {'HXR001','HXR015'}};
% {'g1_uk_f','ICRF_Pin1','g2_ia_f'},              {'HXR001','HXR004'}};
plotShotDescr=1;

% shotnum=[11427,11440];
% % [itf1]=exl50db(shotnum(1),'itf');
% % [itf2,t]=exl50db(shotnum(2),'itf');
% handles=guidata(findobj('tag','Gui_SXR'));
% hlines=findobj(handles.axes_group(2).Children,'type','line');
% ind1=arrayfun(@(x)x.UserData.shotnum==shotnum(1)&x.UserData.ch==11,hlines);
% ind2=arrayfun(@(x)x.UserData.shotnum==shotnum(2)&x.UserData.ch==11,hlines);
% ind3=arrayfun(@(x)x.UserData.shotnum==shotnum(1)&x.UserData.ch==13,hlines);
% ind4=arrayfun(@(x)x.UserData.shotnum==shotnum(2)&x.UserData.ch==13,hlines);
% data1={[hlines(ind1).XData',hlines(ind1).YData',hlines(ind2).YData'],'Ch11'};
% data1={[hlines(ind3).XData',hlines(ind3).YData',hlines(ind4).YData'],'Ch13'};
% 
% sig={data1;...
%     data2;
% 'Ip';...
% 'mwi_ne001'};
% plotShotDescr=0;fig_size=[800,900];xlims=[0,5];fs=20;



if plotShotDescr&&length(shotnum)>1
    shotnum=shotnum(1);
    warning('Display the waveforms of the first shot!')
end

if isempty(fig_size)
    scrz=get(groot,'MonitorPositions');
    [~,ind]=min(scrz(:,3));
    fig_size=[scrz(ind,3)*0.9,scrz(ind,4)*0.9];
end

%%
hf_scan=figure('position',[5,5,fig_size],'color','w');

readcontext=['-1:10:',num2str(dt)];
ylabels=sig;


ha = tight_subplot(size(sig,1),size(sig,2),[0.0, 0.04*2000/fig_size(1)], ...
    [0.08*1000/fig_size(2),0.02+plotShotDescr*0.08*1000/fig_size(2)], [0.04*2000/fig_size(1),0.01*2000/fig_size(1)]);
% function ha = tight_subplot(Nh, Nw, gap, marg_h, marg_w)
%%

if plotShotDescr
    
    hlogo=axes('position',[ha(1,1).Position(1),ha(1,1).Position(2)+ha(1,1).Position(4)+0.01,...
        (1-(ha(1,1).Position(2)+ha(1,1).Position(4)+0.02))*fig_size(2)/fig_size(1)*678/584,(1-(ha(1,1).Position(2)+ha(1,1).Position(4)+0.02))]);
    
    [x, map]=imread('logo.jpg');
    image(hlogo,x);
    hlogo.YTickLabel=[];hlogo.XAxis.Visible='off';hlogo.YAxis.Visible='off';
    colormap (map)
    
    
    hshotnum=annotation('textbox', [hlogo.Position(1)+hlogo.Position(3), ...
        hlogo.Position(2),hlogo.Position(3)*2,hlogo.Position(4)], 'string', num2str(shotnum));
    hshotnum.FontSize=60*fig_size(1)/2500;hshotnum.EdgeColor='none';
    hshotnum.FontName='TimesNewRoman';
    hshotnum.VerticalAlignment='middle';hshotnum.FontName='华文中宋';

    %%
    exptopic=exl50db(shotnum,'shottitle','0:1:1');
    htext=annotation('textbox', [hshotnum.Position(1)+hshotnum.Position(3)*1.1, ...
        hshotnum.Position(2), ha(1,end).Position(1)+ha(1,end).Position(3)-hshotnum.Position(1),...
        hshotnum.Position(4)], 'string', '');
    htext.Color='b';htext.FontSize=30*fig_size(1)/2500;htext.VerticalAlignment='middle';htext.HorizontalAlignment='left';
    htext.FontName='华文中宋';htext.EdgeColor='none';
    
    descr_str=['实验主题：',exptopic];
    [itf,titf]=exl50db(shotnum,'itf','0:10:0.01');
%     {'G1_UK_F'}
    
    tflat=Find_flattop(itf,titf);
    if ~isempty(tflat)
        itf_flattop=max(arrayfun(@(x) mean(itf(no(titf,tflat(x,1)):no(titf,tflat(x,end)))),1:size(tflat,1)));
        stradd=['I_{TF}=',num2str(itf_flattop,'%.1f'),'kA  '];
    else
        itf_flattop=max(itf);
        stradd=['Max. I_{TF}=',num2str(itf_flattop,'%.1f'),'kA  '];        
    end    
    
    htext.String={descr_str,stradd};

    
    timestr=['放电时间: ' datestr(datenum(getDateTime(shotnum),...
        'dd-mm-yyyy HH:MM:SS.FFF'),'yyyy-mm-dd HH:MM:SS','local')];
    htext2 =annotation('textbox',[ha(1,end).Position(1)+ha(1,end).Position(3)-ha(1,end).Position(3),...
        htext.Position(2),ha(1,end).Position(3),htext.Position(4)],...
        'string', timestr);
    htext2.Color='b';htext2.FontSize=htext.FontSize;
    htext2.VerticalAlignment='middle';htext2.HorizontalAlignment='left';
    htext2.FontName='华文中宋';htext2.EdgeColor='none';    
    htext2.HorizontalAlignment='right';
end

%%
for ih=1:size(ha,2)
    for iv=1:size(ha,1)
        ha(iv,ih).NextPlot='add';
    if iscell(sig{iv,ih})
        if ischar(sig{iv,ih}{1})
            for j=1:length(sig{iv,ih})
                [y,t]=readdata(shotnum,sig{iv,ih}{j},readcontext);
                plot(ha(iv,ih),t,y,'linewidth',2)
            end
%             labelstr=cell2mat(cellfun(@(x) [x,';'],ylabels{iv,ih}(:)','uni',false));        
        else
            t=sig{iv,ih}{1}(:,1);y=sig{iv,ih}{1}(:,2:end);
            ylabels{iv,ih}=sig{iv,ih}{2};
            plot(ha(iv,ih),t,y,'linewidth',2)
        end
        
    else
        [y,t]=readdata(shotnum,sig{iv,ih},readcontext);
        plot(ha(iv,ih),t,y,'linewidth',2)
    end
    ha(iv,ih).YAxis.Exponent=0;
    if length(shotnum)>1
        legendtmp=ylabel_mod(ylabels{iv,ih});        
        legendcell=arrayfun(@(x) [legendtmp{1},'@',num2str(x)],shotnum,'uni',false);
        legend(ha(iv,ih),legendcell,'location','best')
    else
        legend(ha(iv,ih),ylabel_mod(ylabels{iv,ih}),'location','best')
    end
    
    
    ha(iv,ih).Legend.Box='off';
    set(ha(iv,ih),'box','on','YMinorTick','on','XMinorTick','on')
    set(ha(iv,ih),'xlim',xlims)
    if iv==size(ha,1)
        xlabel(ha(iv,ih),'t(s)')       
    else
        set(ha(iv,ih),'xticklabel',[]);        
    end
%     ylim(ha(iv,ih),'auto')
    hlines=findobj(ha(iv,ih).Children,'type','line');
    ymin=min(arrayfun(@(x)min(x.YData(no(x.XData,xlims(1)):no(x.XData,xlims(2)))),hlines));
    ymax=1.2*max(arrayfun(@(x)prctile(x.YData(no(x.XData,xlims(1)):no(x.XData,xlims(2))),99),hlines));
    if ymax>ymin
        ylim(ha(iv,ih),[ymin-0.05*(ymax-ymin),ymax+0.05*(ymax-ymin)])
    else
        ylim(ha(iv,ih),[ymin-1,ymax+1])
    end
    if iv>1
    ylims=get(ha(iv,ih),'ylim');
    ytks=ha(iv,ih).YTick;
    if abs(ytks(end)-ylims(2))<(ymax-ymin)/10
        set(ha(iv,ih),'ylim',[ylims(1),(-2*ytks(end-1)+5*ytks(end))/3])
%         ha(iv,ih).YTickLabel{length(ytks)}='';
    end
    end
    
    end
    

end

fig_polish(hf_scan,fs)
savedir='D:\诊断硬件工程小组\诊断日常运行记录\ShotPics';
filename=fullfile(savedir,[num2str(shotnum),'_waveforms']);
print(hf_scan,filename,'-dpng')
winopen(savedir)
disp(['放电波形图片路径：',filename,'.png'])
%%
function [yout,t]=readdata(shotnum,ch,readcontext)
yout=[];
for i=1:length(shotnum)
    [y,t]=exl50db(shotnum(i),ch,readcontext);
    if strcmpi(ch,'g2_ia_f')||strcmpi(ch,'g1_uk_f')||...
            strcmpi(ch,'icrf_pin1')||strcmpi(ch,'P_28G50kW')
        y=(y-min(y))/(prctile(y,95)-prctile(y,1));
    end
    if strcmpi(ch,'ha001')||strcmpi(ch,'has01')
%         [y,t]=delspikes_ha(y,t);
    end
    if strcmpi(ch,'ha001')
        y=abs(y);
    end
    yout=[yout,y];
end

end
function ylabels=ylabel_mod(ylabels)
if ischar(ylabels)
    ylabels={ylabels};
end
ylabels(strcmpi(ylabels,'Ip'))={'I_p(kA)'};
ylabels(strcmpi(ylabels,'loopv'))={'V_{loop}(V)'};
ylabels(strcmpi(ylabels,'mwi_ne001'))={'{\int}n_edl[MWI](10^{17}m^{-2})'};
ylabels(strcmpi(ylabels,'hcn_ne001'))={'{\int}n_edl[HCN](10^{17}m^{-2})'};
ylabels(strcmpi(ylabels,'hcn_ne002'))={'{\int}n_edl[HCN](10^{17}m^{-2})'};
ylabels(strcmpi(ylabels,'ha001'))={'H_{\alpha,Vert.}(a.u.)'};
ylabels(strcmpi(ylabels,'has01'))={'H_{\alpha,Horiz.}(a.u.)'};
ylabels(strcmpi(ylabels,'sddinten21'))={'SXR21(a.u.)'};
ylabels(strcmpi(ylabels,'sddinten22'))={'SXR22(a.u.)'};
ylabels(strcmpi(ylabels,'sddinten01'))={'W-M(R=0.44m)'};
ylabels(strcmpi(ylabels,'sddinten02'))={'W-M(R=0.11m)'};
ylabels(strcmpi(ylabels,'OII_IM_02'))={'OII[Imp.Montr.](a.u.)'};
ylabels(strcmpi(ylabels,'CIII_IM_02'))={'CIII[Imp.Montr.](a.u.)'};
ylabels(strcmpi(ylabels,'HeII_IM_02'))={'HeII[Imp.Montr.](a.u.)'};
ylabels(strcmpi(ylabels,'ti01'))={'T_{i,1}[Vis.Spec.](a.u.)'};
ylabels(strcmpi(ylabels,'ti02'))={'T_{i,2}[Vis.Spec.](a.u.)'};
ylabels(strcmpi(ylabels,'vt01'))={'V_{t,1}[Vis.Spect.](a.u.)'};
ylabels(strcmpi(ylabels,'BIII'))={'BIII[Vis.Spect.](a.u.)'};
ylabels(strcmpi(ylabels,'wdia02'))={'W_{dia02}(a.u.)'};
ylabels(strcmpi(ylabels,'betap02'))={'\beta_{P02}(a.u.)'};
ylabels(strcmpi(ylabels,'g2_ia_f'))={'ECRH-400-C(a.u.)'};
ylabels(strcmpi(ylabels,'g1_uk_f'))={'ECRH-50(a.u.)'};
ylabels(strcmpi(ylabels,'icrf_pin1'))={'ICRF_{Pin1}(a.u.)'};
ylabels(strcmpi(ylabels,'P_28G50kW'))={'ECRH-50(a.u.)'};
ylabels(strcmpi(ylabels,'hxr001'))={'HXR001(a.u.)'};
ylabels(strcmpi(ylabels,'hxr024'))={'HXR024(a.u.)'};
ylabels(strcmpi(ylabels,'axuv007'))={'AXUV007(a.u.)'};
ylabels(strcmpi(ylabels,'axuv015'))={'AXUV015(a.u.)'};
ylabels(strcmpi(ylabels,'ECRH0_UK'))={'ECRH0'};
ylabels(strcmpi(ylabels,'ECRH1_UK'))={'ECRH1'};
ylabels(strcmpi(ylabels,'ECRH2_UK'))={'ECRH2'};
end

function ha = tight_subplot(Nh, Nw, gap, marg_h, marg_w)

if nargin<3; gap = .02; end
if nargin<4 || isempty(marg_h); marg_h = .05; end
if nargin<5; marg_w = .05; end

if numel(gap)==1
    gap = [gap gap];
end
if numel(marg_w)==1
    marg_w = [marg_w marg_w];
end
if numel(marg_h)==1
    marg_h = [marg_h marg_h];
end

axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;

py = 1-marg_h(2)-axh; 

ha = gobjects(Nh,Nw);
ii = 0;
for ih = 1:Nh
    px = marg_w(1);

    for ix = 1:Nw
        ii = ii+1;
        ha(ih,ix) = axes('Units','normalized', ...
            'Position',[px py axw axh]);
%             'XTickLabel','', ...
%             'YTickLabel','');
        px = px+axw+gap(2);
    end
    py = py-axh-gap(1);
end

end
function [seg_flat]=Find_flattop(y,t,varargin)
dt=0.1;
delta_y=100*dt*0.2;y_crit=20;
if nargin>2
    delta_y=varargin{1};
end
if nargin>3
    y_crit=varargin{2};
end

if t(end)>1E3
    dt=dt*1e3;
end
tarr=0:dt:t(end)-dt;
seg_flat=[];
i=1;
while i<length(tarr)    
	indrise=find(arrayfun(@(x) max(y(no(t,tarr(i)):no(t,x)))-min(y(no(t,tarr(i)):no(t,x))),tarr(i+1:end))>delta_y,1);
    if ~isempty(indrise)
        if indrise>1
            indseg=no(t,tarr(i)):no(t,tarr(i+indrise-1));
            if mean(y(indseg))>y_crit
%                 p=polyfit(t(indseg),y(indseg),1);
%                 if p(1)<delta_y/(t(indseg(end))-t(indseg(1)))
                seg_flat=[seg_flat;tarr(i),tarr(i+indrise-1)];
                i=i+indrise;                    
%                 end
            end
        end
    else
            if mean(y(no(t,tarr(i)):no(t,tarr(i+indrise-1))))>y_crit
                seg_flat=[seg_flat;tarr(i),tarr(end)];                
            end
            break
    end
    i=i+1;
end
% arrayfun(@(x) no(t,x):no(t,x+dt),tarr)


end