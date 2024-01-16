function  Chnl=chnscan(shotnum)
% 该函数用于从mdsplus数据库下载所有该炮号对应的数据通道，并到数据通道的名称下载到子目录/data文件夹下
IpAddress='192.168.20.11';
treeNames={'exl50u'};
fullPath = mfilename('fullpath');
[currentPath, ~, ~] = fileparts(fullPath);
datapath=[currentPath,'\data\exl50u.mat'];
if exist(datapath, 'file')
        delete(datapath)
end
 myChnlString='';    
    for i=1:length(treeNames)
        cmd=['Chnl= getChannelsInTree(''' treeNames{i} ''',' num2str(shotnum) ');'];
        eval(cmd)
        Chnl=unique(Chnl);        
        myChnlString=[myChnlString ':' treeNames{i} ':;'];       
        cmd='for i=1:length(Chnl); myChnlString=[myChnlString  Chnl{i} '';'' ]; end'; 
        eval(cmd)
    end      
    % save(datapath,'myChnlString')
    save(datapath,'Chnl')
end
