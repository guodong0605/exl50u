function comparedata(t1,t2,chn,shots)
% This Fuction is used to simply draw the EXl50 discharge parameters as you
% Want and put different shotnums to one figure
% t1 is the start time of data sequence 
% t2 is the end time of data sequence 
% chn  the Channels you want to draw,
% comparedata(-1,4,{'ip','ne','loopv','G1_IK_F'},{4444,4455,4478})
parameter(shots{1},t1,t2,chn);
title('');
l1=findall(gcf,'type','Legend'); set(l1,'String',num2str(shots{1}));         % 把第一幅图的所有与legend 换为shotnum
newcolor=mycolor(length(shots)*2);   % 不同颜色用于plot 不同的炮号
hg1= findall(gcf,'type','axes');   % 获得第一张图的句柄对象
    if length(shots)>1           % 如果shotnum>1 ,把第二张图的内容复制到第一张
        for i=2:length(shots)
            f2=parameter(shots{i},t1,t2,chn);       % plot the second figure
            l2=findall(gcf,'type','Legend'); set(l2,'String',num2str(shots{i})); 
            hg2= findall(gcf,'type','axes');       % 获得每一个subplot的句柄对象
                for j=1:length(hg2)                % 开始对每一个subplot的曲线进行复制
                current_line= get(hg2(j), 'Children');set(current_line, 'Color', newcolor(i,:));
                copyobj( current_line, hg1(j));
                end
            close(f2);
        end
    end
end