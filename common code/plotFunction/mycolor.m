function colorsOutput=mycolor(n)
currentFilePath = mfilename('fullpath');
[pathOfMFile, ~, ~] = fileparts(currentFilePath);
colorpath = fullfile(pathOfMFile, 'mycolors.mat');
load(colorpath)
colorsOutput=colors(1:n,:);

end