% 定义文件路径和工作表名
function writeData(filepath,sheetName,newData,column)

try
    % 尝试读取指定工作表的现有数据
    existingData = readtable(filepath, 'Sheet', sheetName);
    % 获取现有数据的行数
    numRows = size(existingData, 1);
catch e
    % 如果读取失败（可能是因为文件或工作表不存在），从第一行开始
    disp(['Warning: ' e.message]);
    numRows = 0;
end

% 计算新数据应该开始写入的单元格位置
% 假设新数据始终从第一列开始，行号是现有行数加1
startRow = numRows + 1;
startCell = [column num2str(startRow)];

% 写入新数据到指定的 Excel 文件、工作表和起始单元格
writematrix(newData, filepath, 'Sheet', sheetName, 'Range', startCell);
end
