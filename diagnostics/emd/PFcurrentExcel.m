function PFcurrentExcel(shotnum1,shotnum2)
currentFile = mfilename('fullpath');
folderPath=fileparts(currentFile);
folderpath=[folderPath,'\data\'];
excelFile=[folderpath,'PFcurrentRecord.xlsx'];
 dataTable = readtable(excelFile, 'Sheet', 'Sheet1');
 startRow=size(dataTable,1)+1;
try
    [shots,PFcurrent]=pfscan(shotnum1,shotnum2);
    rows=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q'];
    disp('data ready!')
    for i=1:size(PFcurrent,2)+1
        if i==1
            writematrix(shots', excelFile, 'Sheet', 'Sheet1', 'Range', [rows(i),num2str(startRow)]);
        else
            writematrix(PFcurrent(:,i-1), excelFile, 'Sheet', 'Sheet1', 'Range', [rows(i),num2str(startRow)]);
        end
    end
end
end
