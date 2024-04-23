function clickMouseEvent()
global    CurrentShotNum
[newshot,statue]=readTCN();  %刷新炮号
if newshot > CurrentShotNum && statue==2
    CurrentShotNum=newshot;
    a=cameraIR;
    [IRdata,time,info,datapath] = a.downloadhcc(newshot);    
    Matpath=[fileparts(datapath),'\',num2str(CurrentShotNum),'.mat'];
    save(Matpath,'IRdata','time','info');
    mp4path=fileparts(datapath);
    a.makeMovie(CurrentShotNum,0,5,2,[15,45],'telops',10,mp4path);
end
disp(['Shot——',num2str(CurrentShotNum),';Statu=',num2str(statue),';please,wait...'])
end