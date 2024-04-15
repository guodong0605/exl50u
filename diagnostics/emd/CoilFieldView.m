function CoilFieldView(coilInfo)
pointNum=100;
dGamma1=10e-3;
Xgrid=41;
Ygrid=21;
xmin=0;
xmax=2;
ymin=-2;
ymax=2;
Zposition=0;
Rposition=0;

theta = linspace(0, 2*pi, pointNum);
% BSmag = BSmag_init(); % Initialize BSmag analysis
BSmag.Nfilament = 0;
a=coilField;
a.drawVV;
for i=1:numel(coilInfo)
    coilName=coilInfo{i}{1};
    coilCurrent=coilInfo{i}{2};
    coilNum=str2double(regexp(coilName, '\d+','match'));
    coilType = regexp(coilName, '[a-zA-Z]+', 'match');
    switch coilType{1}
        case 'pf'
            points = zeros(pointNum, 3); % 100行3列的矩阵，对应100个点的X,Y,Z坐标

            a.drawPF(coilNum)
            R=a.PFcoil.XCenter(coilNum+1);
            Z=a.PFcoil.ZCenter(coilNum+1);
            N=a.PFcoil.N(coilNum+1);
            % 计算每个点的X,Y坐标
            points(:, 1) = R * cos(theta); % X = R*cos(θ)
            points(:, 3) = R * sin(theta); % Y = R*sin(θ)
            points(:, 2) = Z;
            [BSmag] = BSmag_add_filament(BSmag,points,coilCurrent*1e3*N,dGamma1);
            if coilCurrent<0
                hold on;plot(R,Z,'X','MarkerSize',20,'MarkerFaceColor','k','MarkerEdgeColor','k')
            else
                hold on;plot(R,Z,'o','MarkerSize',10,'MarkerFaceColor','k','MarkerEdgeColor','k')
            end
        case 'tf'
            points = []; % 100行3列的矩阵，对应100个点的X,Y,Z坐标
            a.drawTF;
            R=(a.TFcoil.TFin_X+a.TFcoil.TFout_X)/2;
            Z=(a.TFcoil.TFin_Z+a.TFcoil.TFout_Z)/2;
            points(:, 1) = R; % X = R*cos(θ)
            points(:, 2) = Z; % Y = R*sin(θ)
            points(:, 3) = 0;
            rotatedPoints = cell(1, 12);
            % 对于每个旋转角度
            for k = 1:12
                theta = deg2rad(30 * (k-1)); % 旋转角度，从0°到330°，每次增加30°
                % 定义绕y轴旋转的旋转矩阵
                Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
                % 初始化旋转后的点集
                rotatedPoints_k = zeros(size(points));
                % 应用旋转矩阵到每个点
                for i = 1:size(points, 1)
                    rotatedPoints_k(i, :) = (Ry * points(i, :)')';
                end
                % 存储旋转后的点集
                rotatedPoints{k} = rotatedPoints_k;
                [BSmag] = BSmag_add_filament(BSmag,rotatedPoints_k,-coilCurrent*2e3,dGamma1);
            end
            % [BSmag] = BSmag_add_filament(BSmag,points,coilCurrent*2e3,dGamma1);% every turn has 2 coils with same current
        case 'cs'
            a.drawCS;
            [BSmag] = BSmag_add_filament(BSmag,a.CScoil.points,coilCurrent*1e3,dGamma1);
    end
end
x_M = linspace(xmin, xmax, Xgrid); % x [m]
y_M = linspace(ymin, ymax, Ygrid); % y [m]
[X_M,Y_M] = ndgrid(x_M,y_M);
Z_M = zeros(Xgrid,Ygrid); % z [m]
BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % shows the field points plane
[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);

normB=sqrt(BX.^2+BY.^2+BZ.^2);
quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'g')
% Plot By on the plane
switch coilType{1}
    case 'tf'
        [~,index]=findNearestPoint(y_M,Zposition);
        BZprofile=BZ(:,index);
        figure('Color',[1 1 1]); stackplot({{x_M,BZprofile','\Bt profile(T)'}},['B field @ TF=',num2str(coilCurrent),'kA (T)'])
        xlim([0.3,1.65]);
        figure('Color',[1 1 1]);
        contourf(X, Y, BZ*1e4,105,"ShowText",true,"LabelFormat","%0.1f G", "FaceAlpha",0.9),
        colorbar
        xlabel ('x [m]'), ylabel ('y [m]'), title ('Bz [Gauss]')
        set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
end

end