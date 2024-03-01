% 查看线圈电流参数
parameter(1700,-2,5,{{'ps1_exp','ipf02','ipf03','ipf04','ipf05','ipf06','ipf07','ipf08','ipf09','ipf10'},{'itf01'},{'cs_exp'},{'ip'}},1e3);
mpProfile(1706,1.65,1.7)  
downloaddata(1706,'mp001-9n','-3:5:1e-2',2,0);
downloaddata(1704,'mp001-9n','-3:5:1e-2',2,0);
downloaddata(1706,'ps1-10_exp','-3:5:1e-2',2,0);
downloaddata(1704,'mp010-20t','-3:5:1e-2',2,0);











