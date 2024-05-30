A=3.75;
B=99;
% alpha=A*p0*exp(-B*p0./E);
p0=linspace(0,0.5,100000);
L=2*pi*0.6;
E1=0.1/L;
E2=0.3/L;
E3=0.5/L;
E4=1/L;
E5=2/L;
E6=5/L;
a1=A.*p0.*exp(-B.*p0./E1);
a2=A.*p0.*exp(-B.*p0./E2);
a3=A.*p0.*exp(-B.*p0./E3);
a4=A.*p0.*exp(-B.*p0./E4);
a5=A.*p0.*exp(-B.*p0./E5);
a6=A.*p0.*exp(-B.*p0./E6);
figure('Color',[1 1 1]);stackplot({{p0,a1,a2,a3,a4,a5,a6,'$LoopV=0.1V$,$LoopV=0.2V$,$LoopV=0.5V$,$LoopV=0.1V$,$LoopV=2V$,$E=5V$'}},'plasma discharge','Pressure(Pa)')
ylabel('\alpha[/m]')
set(gca,'XScale','log')
text(1e-3,0.01,'$\alpha=Ap_0\exp\left(-Bp_0/E\right)$','Interpreter','latex')
%---------------ECRH rosonant -----------

%% w=e*B/me 
p=1;
w=28;
me=9.11e-31;
e=1.6e-19;
bt_ecrh1=2*p*w*1e9*me/e;
[~,index]=findNearestPoint(BT/3.75,bt_ecrh1/4);
hold on;fillall(R(index)-0.01,R(index)+0.01,'r') 
%%
R=linspace(0.3,1.65,100);
BT=0.75./(R+0.016);
hold on;plot(R,BT,'LineWidth',2.5,'Color','r') 
legend('Bt profile@150kA','curve fitting','Bt profile@40kA')
text(1,1,'$B_2=\frac{\omega/2* m_e}e$','FontSize',30,'Interpreter','latex')
text(1,1,'$B_2=\frac{\omega/2* m_e}e$','FontSize',30,'Interpreter','latex')

text(1,1,'$Bt\left\lbrack T\right\rbrack=\frac{ITF[kA]/150*0.75}{R+0.016}$','FontSize',30,'Interpreter','latex')
