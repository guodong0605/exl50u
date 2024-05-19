function vuvData=downloadVUVsif(shotnum)

VUVPath='\\192.168.20.30\data\diagnostic platform\EXL-50U\VUV';
fileList = searchFiles(VUVPath, '.sif');
filename=[];
for i = 1:length(fileList)
    temp=fileList{i};
    [~,filename]= fileparts(temp);
    try
        sifnumber=str2double(filename);
    catch
        sifnumber=0;
    end
    if shotnum==sifnumber
        filepath=temp;
        break;
    end
end
    [data_arr, sif_properties, xaxis, yaxis, zaxis] =sifread(filepath);
    vuvData.value=data_arr;
    vuvData.Xaxis=xaxis;
    vuvData.XaxisUnit='nm';
    vuvData.Yaxis=yaxis;
    vuvData.YaxisUnit='Count';
    vuvData.Zaxis=zaxis;
    vuvData.ZaxisUnit='Frame';
    vuvData.harwareInfo=sif_properties;
    vuvData.description='VUV diagnostics to mesure the';

end