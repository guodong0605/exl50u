function CoilFieldView(coilInfo)
pointNum=100;
dGamma1=1e-3;
Xgrid=21;
Ygrid=21;
% Get the coil parameter from Excel document
a=coilParam;
%------------------------------------------
figure('Color',[1 1 1]);
a.drawVV;

BSmag.Nfilament = 0;
for i=1:numel(coilInfo)
    coilName=coilInfo{i}{1};
    coilCurrent=coilInfo{i}{2};
    coilNum=str2double(regexp(coilName, '\d+','match'));
    coilType = regexp(coilName, '[a-zA-Z]+', 'match');
    switch coilType{1}
        case 'pf'
            R=a.PFcoil.XCenter(coilNum+1);
            Z=a.PFcoil.ZCenter(coilNum+1);
            N=a.PFcoil.N(coilNum+1);
            % 计算每个点的X,Y坐标
            theta=linspace(0,2*pi,100);
            points(:, 1) = R * cos(theta); % X = R*cos(θ)
            points(:, 3) = R * sin(theta); % Y = R*sin(θ)
            points(:, 2) = Z;
            [BSmag] = BSmag_add_filament(BSmag,points,coilCurrent*1e3*N,dGamma1);
            if coilCurrent>0
                hold on; a.drawPF(coilNum)
                hold on;plot(R,Z,'o','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','k')
            else
                hold on; a.drawPF(coilNum)
                hold on;plot(R,Z,'X','MarkerSize',15,'MarkerFaceColor','w','MarkerEdgeColor','w')
            end
        case 'cs'
            R=a.CScoil.R;
            N=1000;
            height=3;
            NY=a.CScoil.NY;
            theta = linspace(0,2*pi*NY,N);
            Gamma = [R.*cos(theta)',linspace(-height/2,height/2,N)',R.*sin(theta)']; % x,y,z [m,m,m]
            I = 1; % filament current [A]
            dGamma = 1e-3; % filament max discretization step [m]
            [BSmag] = BSmag_add_filament(BSmag,Gamma,I*1e3,dGamma);
            hold on;plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3), 'LineWidth', 2);
        case 'tf'
            x=a.TFcoil.TFPoints(:,1);
            y=a.TFcoil.TFPoints(:,2);
            z = zeros(numel(x),1);
            [BSmag] = BSmag_add_filament(BSmag,[x,y,z],coilCurrent*1e3,dGamma1);
            figure;plot(x,y);
    end
end
x_M = linspace(0, 2, Xgrid); % x [m]
y_M = linspace(-2, 2, Ygrid); % y [m]
[X_M,Y_M] = ndgrid(x_M,y_M);
Z_M = zeros(Xgrid,Ygrid); % z [m]
BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % shows the field points plane

[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);
axis equal
normB=sqrt(BX.^2+BY.^2);
quiver(X,Y,BX./normB,BY./normB,'m')
% quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'m')


% Plot By on the plane
figure('Color',[1 1 1]);
contourf(X, Y, BZ*1e4,15,"ShowText",true,"LabelFormat","%0.1f G", "FaceAlpha",0.9),
colorbar
xlabel ('x [m]'), ylabel ('y [m]'), title ('By [Gauss]')
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
end