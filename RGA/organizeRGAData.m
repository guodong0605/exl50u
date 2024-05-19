function organizeRGAData(folderPath)
    % 获取指定路径及其所有子目录中的所有.txt文件
    if nargin<1
        folderPath='E:\RGA\pvst';
    end
    TargetFolder='E:\RGAdata';
    
    files = dir(fullfile(folderPath, '**', '*.txt'));
    
    % 检查文件列表是否为空
    if isempty(files)
        warning('No .txt files found in the directory.');
        return;
    end

    % 循环遍历所有文件
    for i = 1:length(files)
        filePath = fullfile(files(i).folder, files(i).name);
        try
            % 导入文件
            [data, info] = importRGAfile(filePath, 1);

            % 解析日期信息
            dt = datetime(info.date, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
            yearMonthFolder = sprintf('%04d年%02d月', year(dt), month(dt));
            dayFolder = datestr(dt, 'yyyymmdd');

            % 创建目录路径
            targetBasePath = fullfile(TargetFolder, yearMonthFolder, dayFolder);
            if ~exist(targetBasePath, 'dir')
                mkdir(targetBasePath);
            end

            % 定义新文件名
            baseFileName = datestr(dt, 'yyyymmdd');
            % 保存数据和图形
            save(fullfile(targetBasePath, [baseFileName, '.mat']), 'data', 'info');         
            
            saveas(gca, fullfile(targetBasePath, [baseFileName, '.jpg']));
            close all;
            %%
            % 复制并重命名原始.txt文件到新目录
            newTxtFilePath = fullfile(targetBasePath, [baseFileName, '.txt']);
            copyfile(filePath, newTxtFilePath);
        catch ME
            warning('Failed to process file %s due to error: %s', filePath, ME.message);
        end
    end

