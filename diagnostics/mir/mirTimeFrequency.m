function mirTimeFrequency(chnname,t1,t2,Fs,NFFT,overlap)

datatime=[num2str(t1),':',num2str(t2),':',num2str(1/Fs)];
[ip03,t0]=downloaddata(shotnum,'axuv001',[num2str(t1),':',num2str(t2),':0.0001']);
ip=ip03*32.7;
[mir,tt0]=downloaddata(shotnum,chn,datatime);
%%
[S,f,t] =autoSpectroscopy(mir,Fs,1024,t1-t1,t2-t1,0);
ypic=pic_position(3);
figure;set (gcf,'Position',[50,50,680,600]); % figure 1
% set(gcf,'WindowButtonDownFcn',@setytick)
hg1=subplot('position',ypic{3});
plot(t0,ip,'linewidth',2.5);
set(gca, 'XTickLabel',[])
ylabel('$\rm Ip(kA)$', 'fontname','Times New Roman','fontsize',12, 'fontweight','bold','Interpreter','LaTex');
title(['Shot',num2str(shotnum)]);
set(gca, 'FontWeight', 'normal', 'FontSize', 15, 'LineWidth', 1.2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on')
legend('Ip');
xlim([t1,t2]);

hg2=subplot('position',ypic{2});
plot(tt0,mir,'linewidth',1);
set(gca, 'XTickLabel',[])
ylabel(chn, 'fontname','Times New Roman','fontsize',12, 'fontweight','bold','Interpreter','LaTex');
set(gca, 'FontWeight', 'normal', 'FontSize', 15, 'LineWidth', 1.2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on')
legend(chn);

hg3=subplot('position',ypic{1},'linewidth',2.5);
pcolor (t/1000+t1,f/1000, log(S)); shading interp;
ylabel('$\rm f(kHz)$', 'fontname','Times New Roman','fontsize',12, 'fontweight','bold','Interpreter','LaTex');
xlabel('$\rm t(s)$',  'fontname','Times New Roman','fontsize',12, 'fontweight','bold','interpreter','LaTex');

set(gca, 'FontWeight', 'normal', 'FontSize', 15, 'LineWidth', 3, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on')
colormap('JET');
caxis([max(max(log(S))-15), max(max(log(S)))]);
% colorbar4
legend(chn)
linkaxes([hg1,hg2,hg3],'x')
xlim([t1,t2]);
end
