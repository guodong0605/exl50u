function [totalCurrent,t]=eddycurrent(shotnum,datatime)
pfnames=[1,2,3,4,5,6,7,8];
a=coilParam;
N=a.PFcoil.N(pfnames+1);
k=[-1,-1];
[current1,t]=downloaddata(shotnum,'ip02_h',datatime,0,0);
totalCurrent=current1*80;
for i=1:length(pfnames)
    pfname=['i_pf',num2str(pfnames(i))];
    temp=downloaddata(shotnum,pfname,datatime,0,0);
    totalCurrent=totalCurrent+temp/1e3*N(i);
end
[ics,t]=downloaddata(shotnum,'i_cs',datatime,0,0);
[ip,t]=downloaddata(shotnum,'ip',datatime,0,0);
totalCurrent=totalCurrent+ics/1e3*306+ip;
 figure('Color',[1 1 1]);stackplot({{t,current1*80,totalCurrent,'current,Eddycurrent'}},num2str(shotnum))
end