    function [X2,Y2,FilamentCurrent,GapX]=sourcePrepare(coilParam,CoilName)
        rowNames=coilParam(:,1);
        rowIndex = ismember(rowNames.Variables, upper(CoilName));
        selectedRows = coilParam(rowIndex, :);
        XCenter=table2array(selectedRows(1,2));
        YCenter=table2array(selectedRows(1,3));
        W=table2array(selectedRows(1,4));
        H=table2array(selectedRows(1,5));
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
