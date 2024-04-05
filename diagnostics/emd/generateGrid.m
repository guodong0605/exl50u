function [gridX, gridY] = generateGrid(xCenter, yCenter, xLength, yLength, xGridNum, yGridNum, theta, isFig)
    if nargin < 8
        isFig = 0;
    end

    nRects = numel(xCenter); % 获取矩形的数量

    % 如果xGridNum和yGridNum是单个数值，则将它们扩展为与xCenter长度相同的向量
    if numel(xGridNum) == 1
        xGridNum = repmat(xGridNum, nRects, 1);
    end
    if numel(yGridNum) == 1
        yGridNum = repmat(yGridNum, nRects, 1);
    end
    
    % 初始化输出数组
    gridX = [];
    gridY = [];
    
    for i = 1:nRects
        % 为当前矩形计算dx和dy
        dx = xLength(i) / xGridNum(i);
        dy = yLength(i) / yGridNum(i);
        
        localGridX = [];
        localGridY = [];
        
        % 生成当前矩形的局部网格点
        for ix = 1:xGridNum(i)
            for iy = 1:yGridNum(i)
                x = (-xLength(i)/2 + (ix-0.5) * dx) + xCenter(i);
                y = (-yLength(i)/2 + (iy-0.5) * dy) + yCenter(i);
                
                % 应用旋转
                R = [cosd(theta(i)), -sind(theta(i)); sind(theta(i)), cosd(theta(i))];
                rotatedPoint = R * [x - xCenter(i); y - yCenter(i)];
                
                % 更新全局网格点数组
                gridX = [gridX; rotatedPoint(1) + xCenter(i)];
                gridY = [gridY; rotatedPoint(2) + yCenter(i)];
            end
        end
    end
    
    if isFig == 1
        hold on;
        
        % 绘制每个旋转的矩形和网格点
        for i = 1:nRects
            rectPoints = calculateRotatedRectanglePoints(xCenter(i), yCenter(i), xLength(i), yLength(i), theta(i));
            patch(rectPoints(:,1), rectPoints(:,2), 'r', 'FaceAlpha', .3, 'EdgeColor', 'r');
        end
        
        scatter(gridX, gridY, 10, 'b', 'filled');
        axis equal;
        grid on;
        xlabel('X');
        ylabel('Y');
        title('Rotated Rectangles and Grid Points');
        hold off;
    end
end

function rectPoints = calculateRotatedRectanglePoints(xCenter, yCenter, xLength, yLength, theta)
    % Calculate the points of the rectangle before rotation
    rectX = [-xLength/2, xLength/2, xLength/2, -xLength/2, -xLength/2];
    rectY = [-yLength/2, -yLength/2, yLength/2, yLength/2, -yLength/2];
    % Apply rotation
    R = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
    rotatedPoints = R * [rectX; rectY];
    % Adjust points relative to the center
    rectPoints = [rotatedPoints(1,:) + xCenter; rotatedPoints(2,:) + yCenter]';
end
