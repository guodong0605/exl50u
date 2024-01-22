function ydf=filter_band(yd,f1,f2)
f1=f1*1e3;
f2=f2*1e3;%上下通带频率(Hz)
f1l=f1-0.5e3;%下边带截止频率
f2h=f2+0.5e3;%上边带截止频率
fs=1e6;

h = fdesign.bandpass(f1l,f1,f2,f2h,200,0.1,200,fs);
d = design(h,'ellip');
ydf=filter(d,yd);
cr=isstable(d); % returns 1 : indicate a stable design

% [t,f,P]=spectrum_T_f((ydf)',ts',fs,nfft,shift) ;

%%输入  yd:信号，ts：时间，fs：采样率；nfft:FFT点数，shift：两系纵之间移动点数
%%输出： t：时频谱的时间，f：频率，P：功率
% figure;pcolor(t,f,log(P));shading interp
% xlabel('t(ms)');ylabel('f(kHz)')
end