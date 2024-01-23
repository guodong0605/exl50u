function filtered_signal = applyFilter(X, Fs, filterType, fre)
    % applyFilter 对时间序列数据应用不同类型和设计的滤波
    % 输入:
    %   X - 时间序列数据
    %   Fs - 采样频率
    %   filterType - 滤波器类型 ('lp', 'hp', 'bp', 'bs')
    %   fre - 截止频率或频带

    filterDesign = 'butter'; % 设定默认的滤波器设计方法为巴特沃斯

    % 设计滤波器
    n = 4; % 滤波器阶数
    if strcmp(filterType, 'lp') || strcmp(filterType, 'hp')
        Wn = fre / (Fs/2); % 归一化截止频率
        filterTypeMap = containers.Map({'lp', 'hp'}, {'low', 'high'});
    elseif strcmp(filterType, 'bp') || strcmp(filterType, 'bs')
        Wn = fre / (Fs/2); % 归一化频带
        filterTypeMap = containers.Map({'bp', 'bs'}, {'bandpass', 'stop'});
    else
        error('无效的滤波器类型。请输入 ''lp'', ''hp'', ''bp'', 或 ''bs''。');
    end

    % 转换 filterType 到 MATLAB 滤波器函数所需的格式
    matlabFilterType = filterTypeMap(filterType);

    % 根据设计方法选择滤波器
    switch filterDesign
        case 'butter'
            [b, a] = butter(n, Wn, matlabFilterType);
        case 'cheby1'
            Rp = 0.5; % 通带波纹
            [b, a] = cheby1(n, Rp, Wn, matlabFilterType);
        case 'ellip'
            Rp = 0.5; % 通带波纹
            Rs = 20; % 阻带衰减
            [b, a] = ellip(n, Rp, Rs, Wn, matlabFilterType);
        otherwise
            error('无效的滤波器设计方法。请输入 ''butter'', ''cheby1'', 或 ''ellip''。');
    end

    % 应用滤波器
    filtered_signal = filter(b, a, X);
end
