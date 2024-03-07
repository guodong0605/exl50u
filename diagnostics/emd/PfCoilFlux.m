function PfCoilFlux(coilname)
% PF coil parameter
currentFile = mfilename('fullpath');
folderpath=[currentFile(1:end-10),'\data\'];
filepath=[folderpath,'EXL50UProbeFluxLoop.xlsx'];
CoilParameter=readtable(filepath,'Sheet','coils','VariableNamingRule','preserve');
FluxParameter=readtable(filepath,'Sheet','flux','VariableNamingRule','preserve');
MBTParameter=readtable(filepath,'Sheet','probeBt','VariableNamingRule','preserve',Range='A1:I53');
MBrParameter=readtable(filepath,'Sheet','probeBr','VariableNamingRule','preserve');
[X2,Y2,FilamentCurrent]=sourcePrepare(CoilParameter,coilname);%单个线圈网格化后的一维数据点
[X1,Y1]=getProbePoint(MBTParameter, 10, 10);

[DX,DY]=MMagneticField(X1,Y1,X2,Y2,FilamentCurrent);




fluxPF=MMutInductance(X1,Y1,X2,Y2,FilamentCurrent);  % gap of grid ready before



    function [X2,Y2,FilamentCurrent,GapX]=sourcePrepare(coilParam,CoilName)
        rowNames=coilParam(:,1);
        rowIndex = ismember(rowNames.Variables, upper(CoilName));
        selectedRows = coilParam(rowIndex, :);
        XCenter=table2array(selectedRows(1,2))/1e3;
        YCenter=table2array(selectedRows(1,3))/1e3;
        W=table2array(selectedRows(1,4))/1e3;
        H=table2array(selectedRows(1,5))/1e3;
        NX=table2array(selectedRows(1,6));
        NY=table2array(selectedRows(1,7));
        N=table2array(selectedRows(1,8));
        Angle=table2array(selectedRows(1,9));


        % 考虑到线圈实际绕制，实际匝数N=Nx*Ny-2； 线圈电流均匀化
        AmperTurn = ones(1, NX * NY) * N/ (NX * NY);
        % 计算在X和Y方向上的步长
        StepX = W / NX/ 2;
        StepY = H / NY / 2;
        % 定义gapX，考虑到因子、NX、NY和步长
        factor = 0.23; % 调节因子
        GapX = ones(1, NX * NY) * 2 * StepX * factor;


        % 生成源点的网格坐标，考虑倾斜调整
        [X2, Y2] = meshgrid(-W/2 + StepX : 2 * StepX : W/2 - StepX, ...
            -H/2 + StepY : 2 * StepY : H/2 - StepY);

        % 应用倾斜角度调整和中心位置调整
        X2 = X2 + Y2 .* cot(Angle * pi / 180) + XCenter;
        Y2 = Y2 + YCenter;

        % 重塑源点坐标和安匝数数组为一维数组，以便进行计算
        numElements = numel(X2);
        X2 = reshape(X2, 1, numElements);
        Y2 = reshape(Y2, 1, numElements);
        FilamentCurrent = reshape(AmperTurn, 1, numElements);

    end
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

end


