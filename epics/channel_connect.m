function channel = channel_connect(name)
%% 功能：M文件创建连接epics的通道
%% --------------------------------------
%添加下载的java文件路径
warning off
javaaddpath('ca-1.3.2-all.jar')
%配置环境变量-利用Properties方法配置环境变量
import org.epics.ca.*
properties = java.util.Properties();
properties.setProperty('EPICS_CA_ADDR_LIST', ...
    '192.168.0.110');
context = Context(properties);
%利用"通道"工具类的创建功能创建通道，函数的参数要么是通道名称，要么是所谓的ChannelDescriptor
channel = Channels.create(context, name);
end

