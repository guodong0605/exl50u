%==========================================================================
%Input:   
%   shotnum     :   the shot number                 [double]
%   signal      :   the signal name                 [string]
%   Level       :   the square waveform threshold   [double]
%Output:
%   FrameTime   :   the center time for every frame 
%example     :
% FrameTime = ReadFrameTime('202.127.204.12', 'east_1', 38860, 'ERD' , 3.0 )
%--------------------------------------------------------------------------
% function FrameTime = ReadFrameTime(ShutterMDSIp, Shutter_tree, shotnum, signal , Level  )
function FrameTime = ReadFrameTime(shotnum, signal , Level  )

% mdsconnect( ShutterMDSIp);
% mdsopen(Shutter_tree,shotnum);  

TStr      = ['dim_of(\', signal,')'];
Str       = ['\', signal];
Time      = mdsvalue(TStr); %%???????
Val       = mdsvalue(Str);
% figure;plot(Time,Val)
% keyboard
% Val=smooth(Val);
% Val=smooth(Val);

% keyboard
if ischar(Time)
    disp('Shutter signal error')
    FrameTime = [];    
    return; 
end

Flag      = Val > Level;
IndexL    = find( diff(Flag)>0.5 )+1;
IndexR    = find( diff(Flag)<-0.5);

% %%
%  figure(54)
%  plot(Time(2:end),diff(Flag),'r'); hold on;
% plot(Time,Val,'-'); 
% plot(Time(IndexL),Val(IndexL),'r*');
% plot(Time(IndexR),Val(IndexR),'ro');
% keyboard
%%
close all;
rnum = length(IndexR);
lnum = length(IndexL);
maxnum = min(rnum, lnum);
IndexR = IndexR(1:maxnum);
IndexL = IndexL(1:maxnum);

FrameTime = (Time(IndexR)+Time(IndexL))/2;
FrameVal  = (Val (IndexR)+Val (IndexL))/2;

disp(['shot=',num2str(shotnum), '--> Frame Time Read Ok!']);
% mdsclose;
% mdsdisconnect;