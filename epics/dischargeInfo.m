function [currentShot,countDown]=dischargeInfo()
   if not(exist('java_classpath_set'))
		javaaddpath('ca-1.3.2-all.jar')
		java_classpath_set = 1;
    end
channels1=channel_connect('CCS-TCN-CTDW');% 调用channel_connect函数实现通道连接，函数的输入：通道名
channels2=channel_connect('CCS-CCS-SHOT');% 调用channel_connect函数实现通道连接，函数的输入：通道名

%设置判断条件实时打印读取的通道数据
a=1;%设置判断条件
countDown = channels1.get();% value：通道数据
 currentShot= channels2.get();% value：通道数据
channels1.close()%完成工作内容后关闭通道
%任务完成关闭通道
channels2.close();

if str2double(countDown) > 0
    sprintf('当前炮为 %d，放电已结束', currentShot)
else
    sprintf('下一炮为 %d，倒计时为 %s s', currentShot, countDown)
end


function channel = channel_connect(name)
%% 功能：M文件创建连接epics的通道
%% --------------------------------------
%添加下载的java文件路径
warning off
javaaddpath('ca-1.3.2-all.jar')
%配置环境变量-利用Properties方法配置环境变量
import org.epics.ca.*
properties = java.util.Properties();
properties.setProperty('EPICS_CA_ADDR_LIST',  '192.168.0.110');
context = Context(properties);
%利用"通道"工具类的创建功能创建通道，函数的参数要么是通道名称，要么是所谓的ChannelDescriptor
channel = Channels.create(context, name);
end


end