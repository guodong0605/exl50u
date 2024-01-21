 # EXL50U Diagnostics code collabration
该项目用于在诊断组之间进行代码协作和互检，从而提高整体处理数据的效率。代码一共分为两个大文件夹，分别是common code，用于存放通用的程序代码，第二部分的diagnostics用于存放不同诊断系统的专用代码，可能不适用于所有诊断类型。

common code 存储通用的程序
- <span style="color: blue;">checkData  </span> 检查数据常用函数
  - <span style="color: green;">changedata</span> 
  - <span style="color: green;">comparedata</span> 
  - <span style="color: green;">parameter</span> 
- <span style="color: blue;"> downloaddata </span> 下载mdsplus数据库数据
  - <span style="color: green;">downloaddata </span> 主函数
  - <span style="color: green;">extractMultipleStrings </span> 下载数据子函数，用于从一堆字符串中解析通道名称
  - <span style="color: green;">chnscan </span> 扫描当前放电炮号下，所有存储在mdsplus数据库中的通道名称
  - <span style="color: green;">mds** </span> mdsplus 官方程序
- plotFunctions 绘图的常用函数
  - drawprofile 绘制多通道阵列数据的contour,并截取其中一个时间段进行剖面绘制
  - fillall 在figure中两个横坐标中进行阴影填充
  - lineall 在figure中，绘制多条参考线
  - liney   在figure中两个纵坐标中进行阴影填充
  - manyplot 对多个炮号的通用
- ViewPathDrawing 绘制50U诊断光路的函数,GUI显示
  
diagnostics



