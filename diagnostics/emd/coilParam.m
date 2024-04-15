classdef coilParam
    properties
        PFcoil;
        CScoil;
        TFcoil;
        mptGeometry;
        mprGeometry;
        fluxPosition;
        VVParam
    end

    methods
        function obj = coilParam()
            % 构造此类的实例
            fullPath = mfilename('fullpath');
            fileDir = fileparts(fileparts(fileparts(fullPath)));
            probeFile = fullfile(fileDir, 'diagnostics', 'emd', 'data', 'EXL50UProbeFluxLoop.xlsx');
            CoilParameter=readtable(probeFile,'Sheet','coils','VariableNamingRule','preserve',Range='A1:K16');
            FluxParameter=readtable(probeFile,'Sheet','flux','VariableNamingRule','preserve',Range='A1:D48');

            MPTParameter=readtable(probeFile,'Sheet','probeBt','VariableNamingRule','preserve',Range='A1:I53');
            MPRParameter=readtable(probeFile,'Sheet','probeBr','VariableNamingRule','preserve',Range='A1:H49');
            TFParameter=readtable(probeFile,'Sheet','machine','VariableNamingRule','preserve',Range='A1:D28');
            VVParameter=readtable(probeFile,'Sheet','machine','VariableNamingRule','preserve',Range='E1:H9');
            PostParameter=readtable(probeFile,'Sheet','machine','VariableNamingRule','preserve',Range='I1:J21');

            %-------------Prepare for the PF coils----------------------------------------------------------------
            %%
            PF.Name=CoilParameter(2:end,1);
            PF.XCenter=table2array(CoilParameter(2:end,2));
            PF.ZCenter=table2array(CoilParameter(2:end,3));
            PF.W=table2array(CoilParameter(2:end,4));
            PF.H=table2array(CoilParameter(2:end,5));
            PF.NX=table2array(CoilParameter(2:end,6));
            PF.NY=table2array(CoilParameter(2:end,7));
            PF.N=table2array(CoilParameter(2:end,8));
            PF.Angle=table2array(CoilParameter(2:end,9));
            obj.PFcoil=PF;
            %%
            %-------------Prepare for the Tangential Probe Position and geometry------------------------
            %%
            MPT.XCenter=table2array(MPTParameter(:,2))/1e3;
            MPT.ZCenter=table2array(MPTParameter(:,3))/1e3;
            MPT.Angle=table2array(MPTParameter(:,4));
            MPT.W=table2array(MPTParameter(:,6))/1e3;
            MPT.H=table2array(MPTParameter(:,7))/1e3;
            obj.mptGeometry=MPT;
            %%
            %-------------Prepare for the Normal Probe Position and geometry------------------------
            %%
            MPR.XCenter=table2array(MPRParameter(:,2))/1e3;
            MPR.ZCenter=table2array(MPRParameter(:,3))/1e3;
            MPR.Angle=table2array(MPRParameter(:,4));
            MPR.W=table2array(MPRParameter(:,5))/1e3;
            MPR.H=table2array(MPRParameter(:,6))/1e3;
            obj.mprGeometry=MPR;
            %%
            %-------------Prepare for the flux Loop Position ------------------------
            %%
            FluxPositon.X=table2array(FluxParameter(:,2))/1e3;
            FluxPositon.Y=table2array(FluxParameter(:,3))/1e3;
            obj.fluxPosition=FluxPositon;
            %%
            %-------------prepare for the TF coils Points-------------------
            %%
            TFcoil.TFin_X=table2array(TFParameter(:,1));
            TFcoil.TFin_Z=table2array(TFParameter(:,2));
            TFcoil.TFout_X=table2array(TFParameter(:,3));
            TFcoil.TFout_Z=table2array(TFParameter(:,4));
            TFcoil.TFPoints=[(TFcoil.TFin_X+TFcoil.TFout_X)/2,(TFcoil.TFin_Z+TFcoil.TFout_Z)/2];
            obj.TFcoil=TFcoil;
            %-------------prepare for the CS coils points----------------
            %%
            CS.R=PF.XCenter(1);
            CS.W=PF.W(1);
            CS.H=PF.H(1);
            CS.NX=PF.NX(1);
            CS.NY=PF.NY(1);
            CS.N=PF.N(1);            
            CS_height=3;
            CS_Z=linspace(-CS_height/2,CS_height/2,5000);
            theta=linspace(0,2*pi*CS.NY,5000);
            CS.points=[CS.R*cos(theta'),CS_Z',CS.R*sin(theta')];
            
            obj.CScoil=CS;
            %%
            VVParam.VVin_X=table2array(VVParameter(:,1))/1e3;
            VVParam.VVin_Z=table2array(VVParameter(:,2))/1e3;
            VVParam.VVout_X=table2array(VVParameter(:,3))/1e3;
            VVParam.VVout_Z=table2array(VVParameter(:,4))/1e3;
            VVParam.post_X=table2array(PostParameter(:,1))/1e3;
            VVParam.post_Z=table2array(PostParameter(:,2))/1e3;
            obj.VVParam=VVParam;
            %%
        end
        function drawVV(obj)
            patch(obj.VVParam.VVout_X,obj.VVParam.VVout_Z,[0,0,0]);
            hold on;patch(obj.VVParam.VVin_X,obj.VVParam.VVin_Z,[1,1,1])
            hold on;patch(obj.VVParam.post_X,obj.VVParam.post_Z,[0.4,0.4,0.4]);
            xlim([-0.1,2.4])
            set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
            xlabel('X(m)')
            ylabel('Z(m)')
        end
        function drawPF(obj,pfnames,pfcolor)
            if nargin<3
                pfcolor=[247 92 47]/255;
            end
            pfnames=string(pfnames);
            pfcoils=parsenums(pfnames);

            for i=1:numel(pfcoils)
                X=obj.PFcoil.XCenter(pfcoils(i)+1);
                Z=obj.PFcoil.ZCenter(pfcoils(i)+1);
                W=obj.PFcoil.W(pfcoils(i)+1);
                H=obj.PFcoil.H(pfcoils(i)+1);
                theta=obj.PFcoil.Angle(pfcoils(i)+1);
                obj.drawRotatedRectangles(X, Z, W, H, theta,pfcolor,0)
                text(X+0.1,Z,['PF',num2str(pfcoils(i))]);
            end
        end
        function drawbr(obj)
            Br_X=obj.mprGeometry.XCenter;
            Br_Z=obj.mprGeometry.ZCenter;
            Br_W=obj.mprGeometry.W;
            Br_H=obj.mprGeometry.H;
            Br_theta=obj.mprGeometry.Angle+90;
            drawRotatedRectangles(obj,Br_X,Br_Z,Br_W,Br_H,Br_theta,'red',1);
        end
        function drawbt(obj)
            Bt_X=obj.mptGeometry.XCenter;
            Bt_Z=obj.mptGeometry.ZCenter;
            Bt_W=obj.mptGeometry.W;
            Bt_H=obj.mptGeometry.H;
            Bt_theta=obj.mptGeometry.Angle+90;
            drawRotatedRectangles(obj,Bt_X,Bt_Z,Bt_W,Bt_H,Bt_theta,'red',1);
        end
        function drawflux(obj)
            plot(obj.fluxPosition.X,obj.fluxPosition.Y,'o','MarkerSize',5,'MarkerFace','r','MarkerEdgeColor','r');
            for i=1:numel(obj.fluxPosition.X)
                text(obj.fluxPosition.X(i),obj.fluxPosition.Y(i), num2str(i),'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','Color','m');
            end
        end
        function drawTF(obj)
            tfcolor=[249 191 69]/255;
            TF_X=[obj.TFcoil.TFin_X;obj.TFcoil.TFout_X];
            TF_Z=[obj.TFcoil.TFin_Z;obj.TFcoil.TFout_Z];
            hold on;patch(TF_X,TF_Z,tfcolor);
        end
        function drawCS(obj)
            cscolor=[249 191 69]/255;
            points=obj.CScoil.points;
            hold on;plot3(points(:,1),points(:,2),points(:,3),'LineWidth',2,'Color',cscolor);
        end
        function [gridX,gridY]=grid(obj,type,xgridNum,ygridNum,isFig)
            if nargin<3  xgridNum=5;   end
            if nargin<4  ygridNum=5;   end
            if nargin<5  isFig=0;   end
            try
            number = regexp(type, '\d+', 'match');
            number=str2double(number{1});
            catch
                number=[];
            end
            str = regexp(type, '\D+', 'match');
            switch str{1}
                case 'br'
                    xCenter = obj.mprGeometry.XCenter; % 中心点X坐标
                    yCenter = obj.mprGeometry.ZCenter; % 中心点Y坐标
                    xLength = obj.mprGeometry.W; % X方向长度
                    yLength = obj.mprGeometry.H; % Y方向长度
                    theta = obj.mprGeometry.Angle+90; % 旋转角度
                case 'bt'
                    xCenter = obj.mptGeometry.XCenter; % 中心点X坐标
                    yCenter = obj.mptGeometry.ZCenter; % 中心点Y坐标
                    xLength = obj.mptGeometry.W; % X方向长度
                    yLength = obj.mptGeometry.H; % Y方向长度
                    theta = obj.mptGeometry.Angle+90; % 旋转角度
                case 'pf'
                    xCenter = obj.PFcoil.XCenter; % 中心点X坐标
                    yCenter = obj.PFcoil.ZCenter; % 中心点Y坐标
                    xLength = obj.PFcoil.W; % X方向长度
                    yLength = obj.PFcoil.H; % Y方向长度
                    theta = obj.PFcoil.Angle; % 旋转角度
                    xgridNum=obj.PFcoil.NX;
                    ygridNum=obj.PFcoil.NY;
            end
            % 调用函数
            if isempty(number)
                [gridX, gridY] = generateGrid(xCenter, yCenter, xLength, yLength, xgridNum, ygridNum, theta, isFig);
            elseif strcmp(str,'pf')
                [gridX, gridY] = generateGrid(xCenter(number+1), yCenter(number+1), xLength(number+1), yLength(number+1), xgridNum(number+1), ygridNum(number+1), theta(number+1), isFig);
            else
                [gridX, gridY] = generateGrid(xCenter(number), yCenter(number), xLength(number), yLength(number), xgridNum, ygridNum, theta(number), isFig);
            end
        end
    end

    methods (Access = private)
        function drawRotatedRectangles(obj, X, Z, W, H, theta,patchColor,istext)
            if nargin<7
                istext=0;
            end
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
                if istext
                    textOffset = max(W1, H1) * 0.5; % 文本偏移量，根据矩形大小调整
                    textPosition = [centerX + textOffset, centerY + textOffset];
                    text(textPosition(1), textPosition(2), num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom','Color','m');
                end
            end
        end
    end
end
