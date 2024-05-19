function fileList = searchFiles(startPath, filetype)
% 查找指定目录及其子目录下所有特定类型的文件
% 输入:
% - startPath: 要搜索的目录路径
% - filetype: 搜索的文件类型（如 '.wei.cine'）
% 输出:
% - fileList: 符合条件的文件列表

% 初始化文件列表
fileList = {};

% 检查开始路径是否存在
if ~exist(startPath, 'dir')
    error('指定的路径不存在');
end

% 递归搜索符合条件的文件
fileList = recursiveSearch(startPath, fileList, filetype);

    function fileList = recursiveSearch(currentPath, fileList, filetype)
    % 递归搜索函数
    % 输入:
    % - currentPath: 当前搜索的目录路径
    % - fileList: 到目前为止找到的文件列表
    % - filetype: 搜索的文件类型
    % 输出:
    % - fileList: 更新后的文件列表
    
    % 获取当前目录下所有项
    items = dir(currentPath);
    
    % 遍历所有项
    for i = 1:length(items)
        if items(i).isdir
            % 如果是目录且不是'.'或'..'，则递归搜索
            if ~strcmp(items(i).name, '.') && ~strcmp(items(i).name, '..')
                fileList = recursiveSearch(fullfile(currentPath, items(i).name), fileList, filetype);
            end
        else
            % 如果是文件且后缀匹配，则添加到列表
            [~, ~, ext] = fileparts(items(i).name);
            if strcmp(ext, filetype)
                fileList{end+1} = fullfile(currentPath, items(i).name);
            end
        end
    end
    end

end
