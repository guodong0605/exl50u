function f1=Prad_AXUV_1(shotnum,xmin,xmax,ymin,matdata)
%function f1=AXUV_Ver06(shotnum,xmin,xmax,ymin,matdata)
%AXUV_Ver06(10820,-0.25,6.25,-250)

getaxuvdata(shotnum,matdata)

if matdata == 0
clear
clear all
end

pi=3.1415926;                                                               %������
%һ.AXUV�źź�����򣨼����������ķ��书�ʣ�2~6keV)
Number=16;                                                                 %̽�������е���Ŀ��
%��һ���ּ��㣺̽�������������
A_SP=7.2e-6;                                                                    %̽����ǰ��С�׵����(ƽ��mm��
A_det=10e-6;                                                                   %����̽����������������ƽ�����ף�
%d1=[66.82 65.47 64.12 62.77 61.42 60.07 58.72 57.31 56.02 54.67 53.32 51.97 50.62 49.27 47.92 46.57];
%d2=[35.49 37.10 38.71 40.32 41.93 43.53 45.14 46.75 48.36 49.97 51.18 53.19 54.80 56.40 58.01 59.62];
%d1=[72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02 72.02];
%d2=[15.75 13.65 11.55 9.45 7.35 5.25 3.15 1.05 1.05 3.15 5.25 7.35 9.45 11.55 13.65 15.75];
d1=[73.71,73.3,72.9,72.49,72.09,71.68,71.27,70.87,70.46,70.06,69.65,69.25,68.84,68.44,68.03,67.63];
d2=[1.56,0.5,2.56,4.62,6.69,8.75,10.81,12.87,14.93,16.99,19.05,20.63,23.17,25.23,27.29,29.34];
for i=1:Number                                                        
d1(i)=d1(i)*0.001;                                                                   %��i��̽������С�׵Ĵ�ֱ����
d2(i)=d2(i)*0.001;                                                                   %��i��̽������С�׵�ˮƽ����
cos_theta(i)=d1(i)./sqrt(d1(i)^2+d2(i)^2);                                  %��i��̽������С�׼нǵ�����ֵ
S(i)=1./(A_SP.*A_det.*cos_theta(i)^2./(4.*pi.*d1(i)^2));                       %��i��̽�������ҵ��������ǣ�ÿƽ�����ף�
end  
%�ڶ����ּ��㣺��Ч���һ����ź�
g=10^7;                                                                       %̽�����ķŴ����棨V/A)
gama=0.4;                                                                  %̽��������Ӧ��(A/W)

%Y@20210605 +
%V1=load('C:\My files\DataProc\axuv9911.mat');
        %shotnum=10785;     %9912;   %9974;  
%V1=load('C:\DataProc\axuv9976.mat');
%V1=load(['C:\DataProc\axuv',num2str(shotnum),'.mat']);
V1=load(['C:\DataProc\axuv',num2str(shotnum),'.mat']);
%xmin=-0.25; %-0.5;
%xmax=5.75;   %5.75;  %6.0;   %4.5;   %6.0;
%Y@20210605 -

t=V1.t01;
V=V1.y16;
leng_t=length(t);
V=ones(Number,leng_t);
V(1,:)=V1.y01;
V(2,:)=V1.y02;
V(3,:)=V1.y03;
V(4,:)=V1.y04;
V(5,:)=V1.y05;
V(6,:)=V1.y06;
V(7,:)=V1.y07;
V(8,:)=V1.y08;
V(9,:)=V1.y09;
V(10,:)=V1.y10;
V(11,:)=V1.y11;
V(12,:)=V1.y12;
V(13,:)=V1.y13;
V(14,:)=V1.y14;
V(15,:)=V1.y15;
V(16,:)=V1.y16;

%Y@20210605 +
V(4,:)=( V(3,:) + V(5,:) )/2;
%Y@20210605 -

p=ones(Number,leng_t);
for i=1:Number
    p(i,:)=V(i,:).*S(i)./g./gama;                                               %��i��̽������Ч���һ����ź�  
end
%}
%�������ּ��㣺��������ķ��书�ʣ�2~6keV);
R=0.673; %1;    %0.637;                                                                       %��������Ĵ�뾶�����ף�
r1=[-1.5 44.45 90.8 137.46 184.29 231.18 278 323.57 367.26 410.57 453.37 495.6 537.14 577.92 617.86 656.89];
r2=[-63.71 -21.08 22.06 65.62 109.5 153.6 197.81 242.04 286.18 331.66 377.88 423.63 468.79 513.25 556.91 599.68];
derta_r=zeros(1,Number);% delta r  
temp=ones(Number,leng_t);
for i=1:Number 
    derta_r(i)=(r1(i)-r2(i))*10^-3;                                                %��i�������i+1���ҵ�ƽ�����루���ף�
    temp(i,:)=2*pi*R*derta_r(i).*p(i,:);
end
P_total=sum(temp);

%Y@20210605 +
P_total=smooth(P_total,5000)-mean(P_total(1:1000*10));
%max(P_total)

plotlinewidth=1.8;
figure
subplot(2,1,1)
set(gcf,'position',[150 150 600 600])   %��������Χ�ɷֱ�������
%���崰�ڵ���Ļ��ߵľ�����150������Ļ�·��ľ�����150��ͼƬwidth = 150 ,height = 150(�����ڣ�����width)
%subplot(2,1,1)
set(gca,'position',[0.1 0.55 0.7 0.35])
plot(t,P_total,'r','linewidth',plotlinewidth);
xlim([xmin,xmax]);
%ylim( [-300, max(P_total(1e5:1e6)*1.2) ]);
ylim( [ymin, max(P_total(1e5:1e6)*1.2) ]);
ylabel('Prad (W)');
title(['EXL-50 #', num2str(shotnum)])
set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on');
grid on;
hold on;

subplot(2,1,2)
set(gca,'position',[0.1 0.18 0.7 0.35])
%subplot(2,1,2)
[yip,tip]=exl50db(shotnum,'IP','-1:6:0.001');
yip=smooth(yip,20)-mean(yip(1:20*10));
[yne,tne]=exl50db(shotnum,'ne','-1:6:0.001');
yne=smooth(yne,20)-mean(yne(1:20*10));
[yec,tec]=exl50db(shotnum,'G2_IA_F','-1:6:0.001');
yec=smooth(yec,20)-mean(yec(1:20*10));

plot(tip,yip,'r','linewidth',plotlinewidth);
hold on;
plot(tne,yne*1,'k','linewidth',plotlinewidth);
hold on;
plot(tec,yec*10,'g','linewidth',plotlinewidth);
hold on;
legend('Ip (kA)','Ne  (1e17m-2)','ECW');
xlim([xmin, xmax]);
xlabel('Time(s)');
ylabel('IP & Ne');

grid on;
%Y@20210605 -

set(gca,'fontname', 'Times New Roman', 'FontWeight', 'normal', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on');
grid on;

if 1 == 2
%���������������ˮƽ�Ĺ��㣨��˹��λ�ƣ�
ne=10^12;                                                                  %��������ĵ����ܶ�
e=1.6*10^-19*3*10^9;                                                       %���ӵ�Ԫ���
ni=ne;                                                                     %���ӵ��ܶ�
c=3*10^10;                                                                  %����
Te=100000*1.6*10^-12;                                                         %�����¶� eV
me=9.10*10^-28;                                                            %��������
h=6.62607015*10^-34./2./pi*10^7;                                                %���ʿ˳���
ve=sqrt(2*Te/me);                                                          %�������ٶ�
A=32*pi*e^6*ne*ni/(3*sqrt(6*pi)*c^3*me^2*ve);                              %��λ����ĵ����������·����ϵ��
A1=32*pi*e^6*ni/(3*sqrt(6*pi)*c^3*me^2*ve); 
vloume=200*100*2*pi*100;                                                  %������������
EMIN=3*1.6*10^-12;                                                      %���ӵ��������
wmin=EMIN./h;
EMAX=6000*1.6*10^-12;                                                      %���ӵ��������
wmax=EMAX./h;
ac=@(x)A*exp(-h*x/Te);                                                      %���·���ı�������  
s0=quadl(ac,wmin,wmax)*vloume;                                             %��������ķ�����ǿ��
ac1=@(x,y,z)A1*exp(-h*x/Te)*ne*(1-(y/100)^2)*(1-((z-50)./50)^2)*2*pi*100; 
s1=triplequad(ac1,wmin,wmax,-100,100,0,100); 
s0w=s0*10^-7;
s1w=s1*10^-7

%Y@20210605 +
s2=triplequad(ac1,wmin/30,wmax/6*200,-100,100,0,100);     %0.1eV ~ 200keV
s2w=s2*10^-7

s3=triplequad(ac1,wmin/3*2e5,wmax/6*1e7,-100,100,0,100);     %200keV ~ 10MeV
s3w=s3*10^-7
%Y@20210605 -
end
end
