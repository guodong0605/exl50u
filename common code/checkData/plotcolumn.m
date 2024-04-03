function plotcolumn(shotnum,datatime,chnName)
if nargin<3
    chnName={
        {'ip'},{'hcn_ne001'},{'GAS_OUT01'},{'cce0-4'},
        {'i_cs'},{'i_tf'},{'GAS_PRES01'},{'rp,zp'},
        {'loopv'},{'mir021,mir028,mir076,mir084'},{'ha001-2,ha008-10'},{'imp01,imp02,imp04'},
         {'axuv024,axuv025'},{'hxr009-10'},{'sxr005-6'},{'coil03-6'}};
end
chnName=chnName';
for i=1:numel(chnName)
    inputStr=string(chnName{i});
    datachn=extractMultipleStrings(inputStr);
    [y,t,~,unit]=downloaddata(shotnum,datachn,datatime,0,1);
    data{i}={[t,y],[string(datachn),unit]};
end
f=figure('Color',[1 1 1]);
set(f, 'Units', 'normalized', 'Position', [0 0 1 1]);
colomnPlot(data,4)
sgtitle([num2str(shotnum),'Parameter']);
text(-0.1,-0.3, 'Time(s)', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Units', 'normalized','FontSize',15,'FontWeight','bold');
text(0,4, 'shotnum', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Units', 'normalized','FontSize',15,'FontWeight','bold');

filepath=['C:\Users\Administrator\Desktop\实验日志\',num2str(shotnum),'.jpg'];
exportgraphics(f, filepath, 'Resolution', 300);
end