function  Chnl=chnscan(shotnum)
% This function is used to  edited by lijia 20240116
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
