function ydf=filter_band(yd,f1,f2)
f1=f1*1e3;
f2=f2*1e3;%����ͨ��Ƶ��(Hz)
f1l=f1-0.5e3;%�±ߴ���ֹƵ��
f2h=f2+0.5e3;%�ϱߴ���ֹƵ��
fs=1e6;

h = fdesign.bandpass(f1l,f1,f2,f2h,200,0.1,200,fs);
d = design(h,'ellip');
ydf=filter(d,yd);
cr=isstable(d); % returns 1 : indicate a stable design

% [t,f,P]=spectrum_T_f((ydf)',ts',fs,nfft,shift) ;

%%����  yd:�źţ�ts��ʱ�䣬fs�������ʣ�nfft:FFT������shift����ϵ��֮���ƶ�����
%%����� t��ʱƵ�׵�ʱ�䣬f��Ƶ�ʣ�P������
% figure;pcolor(t,f,log(P));shading interp
% xlabel('t(ms)');ylabel('f(kHz)')
end