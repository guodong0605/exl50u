function CoilFieldView(coilInfo)
pointNum=100;
dGamma1=10e-3;
Xgrid=21;
Ygrid=21;
fullPath = mfilename('fullpath');
[fileDir, ~, ~] = fileparts(fileparts(fileparts(fullPath)));
filename=fullfile (fileDir,'diagnostics','emd','data','EXL50UProbeFluxLoop.xlsx');
filename2=fullfile (fileDir,'common code\ViewPathDrawing/EXL50U magnetic data.xlsx');
figure('Color',[1 1 1]);
drawVacuumVessel;
DrawPF(filename2);
xlim([-0.1,2.4])
% axis equal
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
PFcenter_R=xlsread(filename2,4,'K3:K17');  PFcenter_R=PFcenter_R';
PFcenter_Z=xlsread(filename2,4,'L3:L17');  PFcenter_Z=PFcenter_Z';
PF_N=xlsread(filename2,4,'H3:H17');  PFcenter_Z=PFcenter_Z'; % 线圈匝数

theta = linspace(0, 2*pi, pointNum);
points = zeros(pointNum, 3); % 100行3列的矩阵，对应100个点的X,Y,Z坐标
% BSmag = BSmag_init(); % Initialize BSmag analysis
BSmag.Nfilament = 0;
for i=1:numel(coilInfo)
    coilName=coilInfo{i}{1};
    coilCurrent=coilInfo{i}{2};
    coilNum=str2double(regexp(coilName, '\d+','match'));
    coilType = regexp(coilName, '[a-zA-Z]+', 'match');
    switch coilType{1}
        case 'pf'
            R=PFcenter_R(coilNum+1);
            Z=PFcenter_Z(coilNum+1);
            N=PF_N(coilNum+1);
            % 计算每个点的X,Y坐标
            points(:, 1) = R * cos(theta); % X = R*cos(θ)
            points(:, 3) = R * sin(theta); % Y = R*sin(θ)
            points(:, 2) = Z;
            [BSmag] = BSmag_add_filament(BSmag,points,coilCurrent*1e3*N,dGamma1);

    end
end
x_M = linspace(0, 2, Xgrid); % x [m]
y_M = linspace(-2, 2, Ygrid); % y [m]
[X_M,Y_M] = ndgrid(x_M,y_M);
Z_M = zeros(Xgrid,Ygrid); % z [m]
BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % shows the field points plane

[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);
figure(1)
    normB=sqrt(BX.^2+BY.^2+BZ.^2);
    quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'m')

% Plot By on the plane
figure('Color',[1 1 1]);
contourf(X, Y, BY*1e4,15,"ShowText",true,"LabelFormat","%0.1f G", "FaceAlpha",0.9),
colorbar
xlabel ('x [m]'), ylabel ('y [m]'), title ('By [Gauss]')
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
end