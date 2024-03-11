% 2024-03-01 磁测量诊断标定   查看线圈电流参数
parameter(1700,-2,5,{{'ps1_exp','ipf02','ipf03','ipf04','ipf05','ipf06','ipf07','ipf08','ipf09','ipf10'},{'itf01'},{'cs_exp'},{'ip'}},1e3);
mpProfile(1706,1.65,1.7)  
downloaddata(1706,'mp001-9n','-3:5:1e-2',2,0);
downloaddata(1704,'mp001-9n','-3:5:1e-2',2,0);
downloaddata(1706,'ps1-10_exp','-3:5:1e-2',2,0);
downloaddata(1704,'mp010-20t','-3:5:1e-2',2,0);
%%
for shotnum=1781:1804
    downloaddata(shotnum,'ps1-10_exp','-3:5:1e-2',2,0);
    fig=gcf;
    filename=num2str(shotnum);
    print(fig, fullfile('E:\01 磁测量诊断\实验记录\', filename), '-djpeg');
    close all
end
%%
% 创建包含6个子cell的chnData，每个子cell都有其X和Y数据
chnData = {
    { [0:0.1:10; sin(0:0.1:10); cos(0:0.1:10)]', [0:0.1:10; 2.*sin(0:0.1:10)]' },
    { [0:0.1:10; sin(0:0.1:10).^2; cos(0:0.1:10).^2]', [0:0.1:10; 2.*cos(0:0.1:10)]' },
    { [0:0.1:10; sin(0:0.1:10); cos(0:0.1:10); sin(0:0.1:10).*cos(0:0.1:10)]', [0:0.1:10; 2.*tan(0:0.1:10)]' },
    { [0:0.1:10; sin(0:0.1:10).^2; cos(0:0.1:10).^2]', [0:0.1:10; 2.*tan(0:0.1:10)]' }
};
colomnPlot(chnData,3);









