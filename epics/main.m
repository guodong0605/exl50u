%% M文件连接EPICS
   if not(exist('java_classpath_set'))
		javaaddpath('ca-1.3.2-all.jar')
		java_classpath_set = 1;
    end
channels1=channel_connect('CCS-TCN-CTDW');% 调用channel_connect函数实现通道连接，函数的输入：通道名
channels2=channel_connect('CCS-CCS-SHOT');% 调用channel_connect函数实现通道连接，函数的输入：通道名

%设置判断条件实时打印读取的通道数据
a=1;%设置判断条件
value1 = channels1.get()% value：通道数据
value2 = channels2.get()% value：通道数据
channels1.close()%完成工作内容后关闭通道
%任务完成关闭通道
channels2.close();
