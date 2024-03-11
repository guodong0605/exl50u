function [X,Y]=getProbePoint(probeParam, Nx, Ny)
        % 根据中心点、宽度、高度、倾斜角度、以及Nx和Ny生成探测点坐标
        % 输入:
        % XCenter, YCenter - 线圈中心点坐标
        % W, H - 线圈的宽度和高度
        % Angle - 线圈的倾斜角度，单位为度
        % Nx, Ny - 网格点的数量，应为奇数
        % 将输入参数转换为行向量，以便进行批处理操作
        %getProbePoint(XCenter, YCenter, W, H, Angle, Nx, Ny)

        XCenter=table2array(probeParam(:,2))/1e3;
        YCenter=table2array(probeParam(:,3))/1e3;
        Angle=table2array(probeParam(:,4));
        W=table2array(probeParam(:,6))/1e3;
        H=table2array(probeParam(:,7))/1e3;
        %转变为列向量
        Numcoils=numel(XCenter);
        XCenter=reshape(XCenter,[1 Numcoils]);
        YCenter=reshape(YCenter,[1 Numcoils]);
        W=reshape(W,[1 Numcoils]);
        H=reshape(H,[1 Numcoils]);
        Angle=reshape(Angle,[1 Numcoils]);
        theta = Angle * pi / 180;
        % 生成x和y方向的向量，确保中心点为(0,0)
        xVec = (-(Nx - 1):2:(Nx - 1)) / (2 * Nx);
        yVec = ((Ny - 1):-2:-(Ny - 1)) / (2 * Ny);
        % 生成网格点，表示探测点的相对位置
        [X1, Y1] = meshgrid(xVec, yVec);
        % 将网格点扁平化为列向量
        gridNum = numel(X1);
        X1 = reshape(X1, [gridNum, 1]);
        Y1 = reshape(Y1, [gridNum, 1]);

        % 对每个线圈重复网格点，准备应用变换
        dX = repmat(X1, [1, Numcoils]);
        dY = repmat(Y1, [1, Numcoils]);
        X = repmat(XCenter,[gridNum 1]);
        Y = repmat(YCenter,[gridNum 1]);
        W = repmat(W,[gridNum 1]);
        H = repmat(H,[gridNum 1]);
        % 重复线圈参数以匹配网格点扩展

        % 应用线圈大小调整到网格点
        dX = dX .* W;
        dY = dY .* H;

        % 应用旋转变换
        dX_rotated = dX .* cos(theta) - dY .* sin(theta);
        dY_rotated = dX .* sin(theta) + dY .* cos(theta);

        % 计算最终探测点坐标
        X = XCenter + dX_rotated;
        Y = YCenter + dY_rotated;

        % 将结果重新组织为行向量
        X = reshape(X, [1, numel(X)]);
        Y = reshape(Y, [1, numel(Y)]);
    end