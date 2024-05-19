% 创建时间向量
sampling_rate = 1000;         % 采样率（每秒采样点数
t = 0:1/sampling_rate:duration;
% 定义信号参数
frequencies = [10, 20, 30];  % 三个信号的频率（Hz）
%frequencies = [10, 20, 30];  % 三个信号的频率（Hz）
amplitudes = [1, 0.5, 0.8];   % 三个信号的振幅
duration = 2;                 % 信号的持续时间（秒）




% 创建每个信号
signals = zeros(size(t));
for i = 1:length(frequencies)
    signals = signals + amplitudes(i) * sin(2 * pi * frequencies(i) * t);
end

% 绘制叠加后的信号
figure();
plot(t, signals);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sum of Sinusoidal Signals');

% 进行 FFT
N = length(signals);                    % 信号长度
Y = fft(signals) / N;                   % FFT 并进行归一化

% 计算频谱

f = sampling_rate * (0:(N/2))/N;        % 计算频率
P = 2 * abs(Y(1:N/2+1));                % 计算频谱的幅度

% 绘制频谱图
figure;
plot(f, P);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Spectrum');