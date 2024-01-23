% 创建测试数据
Fs = 1000; % 采样频率 1000 Hz
t = 0:1/Fs:1-1/Fs; % 时间向量
X = sin(2*pi*50*t) + sin(2*pi*120*t); % 合成信号，包含50 Hz和120 Hz成分

% 应用不同的滤波器
X_lp = applyFilter(X, Fs, 'lp', 60); % 低通，截止频率80 Hz
X_hp = applyFilter(X, Fs, 'hp', 100); % 高通，截止频率100 Hz
X_bp = applyFilter(X, Fs, 'bp', [40, 60]); % 带通，40-100 Hz
X_bs = applyFilter(X, Fs, 'bs', [1, 60]); % 带阻，60-130 Hz
figure('Color',[1 1 1]) ;stackplot({{t,X,'Original'},{t,X_lp,'LowPass'},{t,X_hp,'HighPass'},{t,X_bp,'bandPass'},{t,X_bs,'BandStop'}})

