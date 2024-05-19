function [s,e,n]=findwhichframe(shotnb,signal1,level1,signal2,level2)
%example:[s,e,n]=findwhichframe(46975,'vjhpev4',0.5,'cxrs1',3)
%signal1 ��EASTϵͳ������ 'nbi1lhv' 'nbi1rhv'���ߵ��Ӳ� 'plhi1' 'plhi2'���� ���ע��?'vjhpev4'���ź���
%level1 �Ǹ��źŴ���ĳ��ֵΪ��Чֵ���ó���ȡ���ڸ�level�ĵ�һ��ֵ��Ϊ��ʼ�����һ��ֵ��Ϊ��������ѡȡ��ֵһ��Ҫע�⣬��ݾ���
%NBI���Ӳ�����ȡ10 ���? ����ȡ0.5
%signal2 ����ϵ��ź���? ��cxrs1' cxrs2 cxrs3 erd level2 һ��ȡ3
% keyboard
% mdsconnect( '202.127.204.12');

% mdsopen('east',shotnb);  
[exit3,starttime3,endtime3,frame,cycle]=Readparams( signal2 , level2);%cxrs1-3
if exit3==0
    s=0;
    e=0;
else
TStr      = ['dim_of(\', signal1,')'];
Str       = ['\', signal1];
Time      = mdsvalue(TStr); %%�������?
Val       = mdsvalue(Str);
% keyboard
if ischar(Time)
    if ~isempty(contains(Time,'%TREE-E-NODATA, No data available for this node'))
        Time=0;
        Val=0;
        s=0;
        e=0;
        n=0;
        return;
    end    
end

Val=smooth(Val);
Val=smooth(Val);
Val=abs(min(Val))+Val;

figure(54)
plot(Time,Val/10000);
hold off;

Flag      = find(Val >level1);
a=length(Flag);

if a==0 
    s=0;
    e=0;
    n=0;    
elseif strcmp(Val(Flag(1)),'%')==1
     s=0;
    e=0;
    n=0;
else
exit=1;
starttime=Time(Flag(1));
endtime=Time(Flag(end));
b=Flag(2:end)-Flag(1:end-1);
b=[2; b];
c=find(b>1);
c=[c; a(end)+1];
n=length(c)-1;
for i=1:n
    s(i)=(Time(Flag(c(i)))-starttime3)/cycle;
    e(i)=(Time(Flag(c(i+1)-1))-starttime3)/cycle;
end
if n>1
    deta=s(2:end)-s(1:end-1);
    pos=find(deta<mean(deta)/10 &deta<1);
    if isempty(pos)==0
        truepos=[find(deta>mean(deta)/10), n];
        n=n-length(pos);
        
        s=s(truepos);
        e=e(truepos);
    else
    end
end

end

%�ж�cxrs�ӵڼ���ʼ�ɼ�nbi�����?

end
% mdsclose;
% mdsdisconnect;
end
%%
function [exit,starttime,endtime,frame,cycle] = Readparams(signal , Level)

TStr      = ['dim_of(\', signal,')'];
Str       = ['\', signal];
Time      = mdsvalue(TStr); %%�������?
Val       = mdsvalue(Str);
Val=smooth(Val);
Val=smooth(Val);
Flag      = find(Val > Level);
a=length(Flag);

if a==0 
    exit=0;
    starttime=0;
    frame=0;
    endtime=0;
elseif strcmp(Val(Flag(1)),'%')==1
     exit=0;
    starttime=0;
    frame=0;
    endtime=0;
else
exit=1;
starttime=Time(Flag(1));
endtime=Time(Flag(end));
b=Flag(2:end)-Flag(1:end-1);
c=find(b>1);
cycle=(Time(Flag(c(end)+1))-starttime)/length(c);
frame=length(c)+1;
end
end
%%
%%
function [exit,starttime,endtime,runtime] = Readnbiparams(signal , Level)
    TStr      = ['dim_of(\', signal,')'];
Str       = ['\', signal];
Time      = mdsvalue(TStr); %%�������?
Val       = mdsvalue(Str);

Flag      = find(Val > Level);
a=length(Flag);

if a==0 
    exit=0;
    starttime=0;
    endtime=0;
    runtime=0;
elseif strcmp(Val(Flag(1)),'%')==1
    exit=0;
    starttime=0;
    endtime=0;
    runtime=0;
    elseif strcmp(Time(Flag(1)),'T')==1
    exit=0;
    starttime=0;
    endtime=0;
    runtime=0;
else
exit=1;
starttime=Time(Flag(1));
endtime=Time(Flag(end));
runtime=endtime-starttime;
end
end
%%
