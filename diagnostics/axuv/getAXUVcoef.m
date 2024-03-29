function axuvParam=getAXUVcoef()
filepath='\\192.168.20.30\data\diagnostic platform\EXL-50U\AXUV\calibration\EXL50U辐射量热诊断（AXUV&SXR）光路视野实测参数.xlsx';
axuv_z800=readtable(filepath,"Sheet","观察弦Z坐标","Range",'C2:C33');
sxr_z800=readtable(filepath,"Sheet","观察弦Z坐标","Range",'H2:H33');
axuv_z0=readtable(filepath,"Sheet","观察弦Z坐标","Range",'C46:C77');
sxr_z0=readtable(filepath,"Sheet","观察弦Z坐标","Range",'H46:H77');
axuvParam.axuv_z800=table2array(axuv_z800);
axuvParam.sxr_z800=table2array(sxr_z800);
axuvParam.axuv_z0=table2array(axuv_z0);
axuvParam.sxr_z0=table2array(sxr_z0);
end