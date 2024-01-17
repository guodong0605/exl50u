function comparedata(t1,t2,chn,shots)
% This Fuction is used to simply draw the EXl50 discharge parameters as you
% Want and put different shotnums to one figure
% t1 is the start time of data sequence 
% t2 is the end time of data sequence 
% chn  the Channels you want to draw,
% comparedata(-1,4,{'ip','ne','loopv','G1_IK_F'},{4444,4455,4478})
parameter(shots{1},t1,t2,chn);
title('');
l1=findall(gcf,'type','Legend'); set(l1,'String',num2str(shots{1}));         % �ѵ�һ��ͼ��������legend ��Ϊshotnum
newcolor=mycolor(length(shots)*2);   % ��ͬ��ɫ����plot ��ͬ���ں�
hg1= findall(gcf,'type','axes');   % ��õ�һ��ͼ�ľ������
    if length(shots)>1           % ���shotnum>1 ,�ѵڶ���ͼ�����ݸ��Ƶ���һ��
        for i=2:length(shots)
            f2=parameter(shots{i},t1,t2,chn);       % plot the second figure
            l2=findall(gcf,'type','Legend'); set(l2,'String',num2str(shots{i})); 
            hg2= findall(gcf,'type','axes');       % ���ÿһ��subplot�ľ������
                for j=1:length(hg2)                % ��ʼ��ÿһ��subplot�����߽��и���
                current_line= get(hg2(j), 'Children');set(current_line, 'Color', newcolor(i,:));
                copyobj( current_line, hg1(j));
                end
            close(f2);
        end
    end
end