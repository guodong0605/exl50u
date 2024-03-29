function drawMag(figtype,isVV,isPF)
if nargin<2   isVV=1; end
if nargin<2   isPF=1; end
% axis equal; % 设置轴比例相等，以便矩形看起来正确
fullPath = mfilename('fullpath');
[fileDir, ~, ~] = fileparts(fileparts(fileparts(fullPath)));
filename=fullfile (fileDir,'diagnostics','emd','data','EXL50UProbeFluxLoop.xlsx');
filename2=fullfile (fileDir,'common code\ViewPathDrawing/EXL50U magnetic data.xlsx');

%--------------
FluxParameter=readtable(filename,'Sheet','flux','VariableNamingRule','preserve',Range='A2:D48');
MBTParameter=readtable(filename,'Sheet','probeBt','VariableNamingRule','preserve',Range='A1:I53');
MBrParameter=readtable(filename,'Sheet','probeBr','VariableNamingRule','preserve');
%---------prepare the Flux paramete  X and Z—————————
Flux_X=table2array(FluxParameter(:,2))/1e3;
Flux_Z=table2array(FluxParameter(:,3))/1e3;
%---------prepare the radial Probe  X and Z—————————
Br_X=table2array(MBrParameter(:,2))/1e3;
Br_Z=table2array(MBrParameter(:,3))/1e3;
BR_W=table2array(MBrParameter(:,5))/1e3;
BR_H=table2array(MBrParameter(:,6))/1e3;
BR_theta=table2array(MBrParameter(:,4))+90;
%---------prepare the radial Probe  X and Z—————————
Bt_X=table2array(MBTParameter(:,2))/1e3;
Bt_Z=table2array(MBTParameter(:,3))/1e3;
Bt_W=table2array(MBTParameter(:,6))/1e3;
Bt_H=table2array(MBTParameter(:,7))/1e3;
Bt_theta=table2array(MBTParameter(:,4))+90;

if isVV
    figure('Color',[1 1 1]);
    drawVacuumVessel;
    xlim([-0.1,2.4])
    % axis equal
    set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
end
if isPF
    DrawPF(filename2)
end
switch figtype
    case 'flux'
        plot(Flux_X,Flux_Z,'o','MarkerSize',5,'MarkerFace','r','MarkerEdgeColor','r');
        title('EXL-50U Flux Position')
        for i=1:47
            text(Flux_X(i), Flux_Z(i), num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','Color','m');
        end
    case 'br'
        drawRotatedRectangles(Br_X,Br_Z,BR_W,BR_H,BR_theta,'red');
        title('EXL-50U Radial Probe')
    case 'bt'
        drawRotatedRectangles(Bt_X,Bt_Z,Bt_W,Bt_H,Bt_theta,'green');
        title('EXL-50U Tangantial Probe')
end

    function drawRotatedRectangles(X, Z, W, H, theta,patchColor)

        % 检查输入长度是否一致
        if ~(length(X) == length(Z) && length(X) == length(W) && length(X) == length(H) && length(X) == length(theta))
            error('所有输入向量的长度必须相等。');
        end
        hold on; % 保持图形，以便可以在同一图上画多个形状
        % 遍历每个点
        for i = 1:length(X)
            centerX = X(i);
            centerY = Z(i);
            W1 = W(i);
            H1 = H(i);
            theta1 = deg2rad(theta(i));
            % 矩形的四个角的原始坐标（未旋转之前）
            rectCorners = [W1/2, H1/2; -W1/2, H1/2; -W1/2, -H1/2; W1/2, -H1/2];
            % 创建旋转矩阵
            R = [cos(theta1), -sin(theta1); sin(theta1), cos(theta1)];
            % 旋转矩形的角并平移到正确的位置
            rotatedCorners = (R * rectCorners')' + [centerX, centerY];
            % 画出旋转后的矩形
            patch(rotatedCorners(:,1), rotatedCorners(:,2), patchColor, 'FaceAlpha', 0.8);

            textOffset = max(W1, H1) * 0.5; % 文本偏移量，根据矩形大小调整
            textPosition = [centerX + textOffset, centerY + textOffset];
            text(textPosition(1), textPosition(2), num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','Color','m');
        end
    end

end