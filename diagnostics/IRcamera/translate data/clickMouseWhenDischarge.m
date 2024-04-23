newshot=readTCN();  %刷新炮号
global    CurrentShotNum matlabfile mp4file
CurrentShotNum=readTCN();  %刷新炮号
matlabfile=0;
mp4file=1;
t = timer('TimerFcn',"clickMouseEvent;", 'Period', 15, 'ExecutionMode', 'fixedSpacing', 'TasksToExecute',inf );
start(t)
