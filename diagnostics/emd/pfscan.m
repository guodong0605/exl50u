function [shots,PFcurrent]=pfscan(shotnum1,shotnum2)
t1=-3;
t2=5;
interval=1e-2;
if nargin<2
    shotnum2=shotnum1;
end
datatime=[num2str(t1),':',num2str(t2),':',num2str(interval)];
PFcurrent=zeros(shotnum2-shotnum1+1,12);
k=1;
for i=shotnum1:shotnum2
    try
    display(['shotnum=',num2str(i)])
    [pfdata,~]= downloaddata(i,'cs_exp,ps1-10_exp,i_tf',datatime,0,0);
    for j=1:12
        temp=pfdata(:,j);
        [sortedData, ~] = sort(abs(temp), 'descend');
        % 选择最大的100个数据点及其索引
        largest10 = sortedData(1:10);
        temp_mean(j)=mean(largest10); 
    end
    shots(k)=i;
    PFcurrent(k,:)= round(temp_mean/1000,1);
    k=k+1;
end
end