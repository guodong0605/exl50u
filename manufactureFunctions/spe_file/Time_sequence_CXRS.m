function [intialframe,lastframe]=Time_sequence_CXRS(ShotNum,sig)
% global ShotNum
% ShotNum=60206;
% keyboard
% sig='oma02';
% mdsconnect('202.127.204.42');        %ע���ġ������� 
% mdsconnect('202.127.204.12');        %ע���ġ������� mdsconnect('202.127.204.42');     mdsconnect('202.127.204.12');  
% mdsopen('east',ShotNum);
% keyboard
lev=2.8*1000;
[s1,e1]=findwhichframe(ShotNum,'IS1_V_ACC',lev,sig ,3);
% [s1,e1]=findwhichframe(ShotNum,'pnbi1',lev,sig ,3);
% [s2,e2]=findwhichframe(ShotNum,'nbi1rhv',lev,sig ,3);
s2=0;e2=0;
% keyboard
   
  if length(s1)>1&s2==0
        intialframe=ceil(s1);
        lastframe=ceil(e1);
%         inbi=ones(intialframe:lastframe);
  elseif length(s1)>1&length(s2)>1
         intialframe=ceil([s1 s2]);
         intialframe=sort(intialframe);
         lastframe=ceil([e1 e2]);
         lastframe=sort(lastframe);
  elseif length(s2)>1&s1==0
         intialframe=ceil(s2);
         lastframe=ceil(e2);
%          inbi=2*ones(intialframe:lastframe);
  elseif (length(s1)>1&length(s2)==1)|(length(s2)>1&length(s1)==1)
%       if s1<=s2(1)&e1>=e2(end)
         intialframe=ceil(min([s1 s2]));
         lastframe=ceil(max([e1 e2])); 
%       else
%          intialframe=floor(s2(1));
%          lastframe=ceil(e2(end));
%       end   
%       keyboard
  elseif length(s1)==1&length(s2)==1
     if s1==0
        s=s2;e=e2;
        intialframe=ceil(s);
        lastframe=ceil(e);
%         inbi=2*ones(intialframe:lastframe);
     elseif s2==0
        s=s1;e=e1;
        intialframe=ceil(s);
        lastframe=ceil(e);
%         inbi=ones(intialframe:lastframe);
%      elseif e1>s2|e2>s1
%         intialframe=floor([s1 s2]);
%         lastframe=ceil([e1 e2]);
     else
%         if s1<s2|s1==s2
%             s=s1; 
%         else
%             s=s2; 
%         end 
%         if e1<e2|e1==e2
%             e=e2;
%         else
%             e=e1;
%         end
        intialframe=ceil(min([s1 s2]));
        lastframe=ceil(max([e1 e2]));
     end
  elseif s1==0&s2==0
        s=0;e=0;
        intialframe=0;
        lastframe=0;
        inbi=0;
        disp('no nbi injection!!!')
        return;  
  end

 
% keyboard








