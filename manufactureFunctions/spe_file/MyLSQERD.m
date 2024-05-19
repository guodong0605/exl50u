function F= MyLSQERD(beta)
%
global CIII
global Range
global Dispersion
global amu
global x0
y=0;
for i=1:floor(length(beta)/3)
LD= TikeV2Doppler(beta(i*3),amu,x0);
LD1=LD/Dispersion;
temp=beta(i*3-2)*exp(-(Range-beta(i*3-1)).^2/LD1^2);
y=y+temp;
end
y=y+beta(end);
F     = CIII-y;%-beta(end-1)*Range-beta(end);
% figure(66);plot(Range,CIII,Range,y);
% legend
% keyboard