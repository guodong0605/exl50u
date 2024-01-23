function shotsVector = parsenums(inputShots)
        % 解析输入的shots，返回一个数字向量
        % 输入可以是一个字符串，例如 '1:3,6,7:9'
        % 或者是一个数字数组，例如 [1 2 3 6 7 8 9]

        if ischar(inputShots) || isstring(inputShots)
            % 输入是字符串，解析字符串
            parts = split(inputShots, ','); % 按逗号分割
            shotsVector = [];
            for i = 1:length(parts)
                if contains(parts(i), ':')
                    % 解析范围
                    range = str2num(char(parts(i))); % 将范围字符串转换为数字
                    shotsVector = [shotsVector, range(1):range(end)]; % 添加到向量中
                else
                    % 单个数字
                    shotsVector = [shotsVector, str2double(parts(i))]; % 添加到向量中
                end
            end
        elseif isnumeric(inputShots)
            % 输入已经是数字数组
            shotsVector = inputShots;
        else
            error('输入必须是字符串或数字数组。');
        end
    end