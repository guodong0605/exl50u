function threshold=find_threshold(img,showfig)
img=medfilt2(img);
[counts,x]=imhist(img);
x=x(3:end);
counts=counts(3:end);
ft1 = fittype( 'gauss2' );
opts_g = fitoptions( 'Method', 'NonlinearLeastSquares' );
[fitresult_g, ~] = fit(x, counts, ft1);
b1=fitresult_g.b1;b2=fitresult_g.b2;
g_fit = feval(fitresult_g,x);
if max(b1,b2)<0.1
    thres=max(b1,b2);
else
    thres=min(b1,b2);
    threshold=0.5*(b1+b2);
    return;
end
x2=x(x>thres);
counts2=counts(x>thres);
%---------polyfit of the light erea---------------
ft2 = fittype( 'poly1' );
opts_p = fitoptions( 'Method', 'LinearLeastSquares' );
opts_p.Normalize = 'on';
opts_p.Robust = 'Bisquare';
[fitresult_p, ~] = fit(x2, counts2, ft2, opts_p);
p_fit = feval(fitresult_p,x2);
%--------Exponential fit of the background--------------
ft3 = fittype( 'exp1' );
opts_e = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts_e.Normalize = 'on';
opts_e.StartPoint = [680.917268177929 -1.4450527287455];
[fitresult_e, ~] = fit( x2, counts2, ft3, opts_e );
e_fit = feval(fitresult_e,x2);
%%
new=abs(e_fit-p_fit);
new=new(1:100);
threshold=x2(new==min(new));

%%
if showfig
figure('unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','normal','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.6,0.6]);
plot(x,counts,':o','MarkerSize',5,'Linewidth',2,'MarkerFace',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
hold on;plot(x,g_fit,'k',x2,e_fit,'r',x2,p_fit,'g','Linewidth',2.5);
legend('Hist','Gaussian Fitting','Linear Fitting','Exponential fitting')
hold on;plot([b1,b1],[0,1e5],'--k','linewidth',1)
xlim([0,1])
ylim([0,0.6e5])
legend('Hist','Double Gaussian Fitting','Linear Fitting','Exponential fitting')
end

end