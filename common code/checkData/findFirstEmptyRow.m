function firstEmptyRow = findFirstEmptyRow(excelFile, sheetName)
    % findFirstEmptyRow - 找出 Excel 文件中指定列的第一个空行
    %
    % 输入:
    %   excelFile - Excel 文件的路径
    %   sheetName - Excel 文件中的工作表名称
    %   column - 要检查的列（例如，'A'）
    %
    % 输出:
    %   firstEmptyRow - 第一个空行的行号；如果没有空行，则返回0

    % 读取指定工作表的数据
    try
        dataTable = readtable(excelFile, 'Sheet', sheetName);
    catch
        error('无法读取 Excel 文件。请检查文件路径和工作表名称。');
    end
    

