# EXL50U Diagnostics code collabration

该项目用于在诊断组之间进行代码协作和互检，从而提高整体处理数据的效率。代码一共分为两个大文件夹，分别是common code，用于存放通用的程序代码，第二部分的diagnostics用于存放不同诊断系统的专用代码，可能不适用于所有诊断类型。

## **common code 存储通用的程序**

- checkData **检查数据常用函数**
  - changedata [函数说明](#changedatam-使用说明) 选中figure中的曲线，直接进行更改，包括smooth.加减乘除等操作
  - comparedata [函数说明](#comparedata-使用说明) 对比不同炮号，不同通道的数据
  - parameter [函数说明](#parameter-使用说明) 对一炮当中的多个通道数据进行绘制，可以绘制多个subplot,每个subplot可以绘制多条曲线。
- **downloaddata**
  - downloaddata 主函数，下载mdsplus数据库中对应通道的数据，包括时间，值，单位字符串，时间信息等，可以同时下载多个通道的数据。
  - extractMultipleStrings 下载数据子函数，用于从一堆字符串中解析通道名称
  - chnscan 扫描当前放电炮号下，所有存储在mdsplus数据库中的通道名称，并把通道名称数据存储在该目录的data文件夹下。
  - mds** mdsplus 官方程序
- **filter**
  - applyFilter 对时间序列数据应用不同类型的滤波，包括低通，高通，带通，带阻；
  - filterexample, 样本数据，说明如何应用滤波程序和实际的效果展示
  - autoSpectroscopy 对时间序列数据进行自功率谱的计算和绘图
  - autospectrum 计算时间序列的自功率谱
- **plotFunctions**
  - drawprofile 直接从数据库下载数据并绘制多通道阵列数据，可以绘制一维，二维，三维,并截取其中一个时间段进行剖面绘制。
  - fillall 在figure中两个横坐标中进行阴影填充
  - lineall 在figure中，绘制多条参考线
  - liney   在figure中两个纵坐标中进行阴影填充
  - manyplot 对多个炮号的通用
- **Strings**
  - parsenums 用于解析字符串中的数字
  - extractMultipleStrings 返回字符串中的数据库通道名称
- **ViewPathDrawing** 绘制50U诊断光路的函数,GUI显示

***

## diagnostics

- visibleCamera 可见光相机数据处理
- IRcamera      红外相机数据处理
- emd           电磁测量数据处理
**

## Documentation

### changedata.m 使用说明

#### 功能描述

`changedata.m`是一个MATLAB函数，用于选中MATLAB figure中的曲线并对其数据进行运算操作。

#### 使用方法

- 基础用法：`changedata('y*10')`  
  选中figure中的曲线后，该命令会将曲线中的y数据乘以10。

- 使用smooth操作：`changedata('smooth', 10)`  
  选中figure中的曲线后，该命令会对曲线数据执行一个10点的平滑操作。

#### 参数说明

- `str`: 字符串，指定要对y数据进行的操作。
- `num`: （可选）整数，当使用`smooth`操作时，此参数指定平滑的点数。

#### 详细说明

1. 函数首先获取当前选中的对象。如果没有找到线对象，会显示"No line selected or found."并退出。
2. 函数获取线对象的数据（X和Y坐标）。
3. 根据提供的参数，计算新的y值：
   - 如果没有提供`num`参数，会直接根据`str`参数对y数据进行计算。
   - 如果提供了`num`参数，会使用平滑函数对y数据进行平滑处理。
4. 最后，用计算或平滑后的数据替换原有的数据y坐标。

#### 注意事项

- 确保在使用`changedata`函数前，已经在MATLAB中选中了一个曲线对象。
- 本函数仅适用于MATLAB环境。

### comparedata.m 使用说明

#### 使用方法

- 基础语法： 
- comparedata(t1,t2,chn,shots) t1开始时间，t2结束时间，chns绘图通道，引号分开，几个引号表示有几个subplot,一组引号内有两个通道，表示一个subplot内绘制两条曲线
- `comparedata(-1,8,{'i_cs','loopv','ip'},{1201,1204,1205})`  三个subplot
- `comparedata(-1,8,{'i_cs,loopv','ip'},{1201,1204,1205})` 两个subplot

### parameter.m 使用说明

### manyshots.m 使用说明
