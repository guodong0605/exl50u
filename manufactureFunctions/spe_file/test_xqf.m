% 生成示例数据
imgArrIn =  [3, 2, 3; 50, 5, 4; 3, 2, 3]; % 假设 imgArrIn 是一个 100x50 的二维数组

% 调用函数处理数据
[imgArr, indNoise] = delSpikes2DSpec(imgArrIn);
figure;
imagesc(imgArrIn);
figure;
imagesc(imgArr);
% 处理后的图像数组 imgArr 可以用于后续分析
% 尖峰噪声的索引 indNoise 可以用于识别和分析噪声的位置