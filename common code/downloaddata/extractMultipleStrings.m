function output = extractMultipleStrings(inputStr)
    % 使用逗号分割输入字符串
    substrings = strsplit(inputStr, ',');
    
    % 初始化输出数组
    output = {};

    % 遍历每个子字符串
    for i = 1:length(substrings)
        currentStr = strtrim(substrings{i});
        
        % 更新正则表达式用于识别字符串的不同部分
        pattern = '([a-zA-Z_]+)(\d+)-(\d+)([a-zA-Z_]*)';
        tokens = regexp(currentStr, pattern, 'tokens');
        
        if ~isempty(tokens)
            tokens = tokens{1};

            % 提取前缀、数字范围和后缀
            prefix = tokens{1};
            startNum = str2double(tokens{2});
            endNum = str2double(tokens{3});
            suffix = tokens{4};

            % 生成数字范围内的所有字符串
            for j = startNum:endNum
                numberStr = num2str(j, ['%0', num2str(length(tokens{2})), 'd']);
                output{end + 1} = [prefix, numberStr, suffix];
            end
        else
            % 对于不符合模式的字符串直接添加
            output{end + 1} = currentStr;
        end
    end
end
