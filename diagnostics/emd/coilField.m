classdef coilField<coilParam
    properties

    end

    methods
        function obj = coilField()

        end

        function fluxPF = getPFflux(obj,pfName)
            % attention   该函数计算的是单位电流 1kA 时产生的磁通
            number = regexp(pfName, '\d+', 'match');
            number=str2double(number{1});
            [pfX,pfZ]=obj.grid(pfName);
            NX=obj.PFcoil.NX(number+1);
            NY=obj.PFcoil.NY(number+1);
            N=obj.PFcoil.N(number+1);
            Flux_X=obj.fluxPosition.X;
            Flux_Z=obj.fluxPosition.Y;
            filament=ones(numel(pfX),1)*N/(NX*NY)*1e3;
            fluxPF=MMutInductance(Flux_X,Flux_Z,pfX,pfZ,filament);
        end
        function [Bt,flag1,flag2]=getPFbt(obj,pfCoil,coilcurrent,xgridNum,ygridNum,isFig)
            % attention   该函数计算的是单位电流 1kA 时产生的磁场
            if nargin<3  current=1;   end
            if nargin<4  xgridNum=9;   end
            if nargin<5  ygridNum=9;   end
            if nargin<6  isFig=1;   end
            pfNames = extractMultipleStrings(pfCoil);               %解析输入的字符串中的PF线圈通道名称
            B_X=zeros(size(obj.mptGeometry.XCenter,1),1)';          %预先分配计算后的磁场的大小
            B_Y=B_X;
            if isFig  %如果绘图，先把真空室及磁探针绘制到figure中，接下来随着循环进行PF线圈的绘制
                figure('Color',[1 1 1])
                obj.drawVV;
                obj.drawbt;
            end
            for i=1:numel(pfNames)
                pfName=pfNames{i};
                current=-coilcurrent(i)*1e3;  % unit is kA ,and clockwise direction is positive
                number = regexp(pfName, '\d+', 'match');%判断是第几个线圈
                number=str2double(number{1});
                [pfX,pfZ]=obj.grid(pfName);
                R=obj.PFcoil.XCenter(number+1);  %+1是因为第1个线圈是CS线圈
                Z=obj.PFcoil.ZCenter(number+1);
                NX=obj.PFcoil.NX(number+1);
                NY=obj.PFcoil.NY(number+1);
                N=obj.PFcoil.N(number+1);
                FilamentCurrent=ones(numel(pfX),1)*N/(NX*NY)*current; % 网格化后每个点电流丝的电流大小
                [probe_x,probe_y]=obj.grid('bt',xgridNum,ygridNum);   % 对tangetial probe进行网格化
                [BX,BY]=MMagneticField(probe_x,probe_y,pfX,pfZ,FilamentCurrent);  %计算网格化的磁探针位置处的磁场大小，单位T
                BX2=reshape(BX,[(xgridNum*ygridNum),numel(BX)/(xgridNum*ygridNum)]); %重新按照网格化参数进行磁场大小线性叠加
                BY2=reshape(BY,[(xgridNum*ygridNum),numel(BY)/(xgridNum*ygridNum)]);
                B_X=B_X+sum(BX2,1)/(xgridNum*ygridNum);  % BX  unit Gauss  水平方向磁场
                B_Y=B_Y+sum(BY2,1)/(xgridNum*ygridNum);  % 垂直方向磁场

                if isFig
                    obj.drawPF(number);
                    if current>0
                        hold on;plot(R,Z,'X','MarkerSize',20,'MarkerFaceColor','k','MarkerEdgeColor','k')
                    else
                        hold on;plot(R,Z,'o','MarkerSize',10,'MarkerFaceColor','k','MarkerEdgeColor','k')
                    end
                end
            end
            theta_bt=deg2rad(obj.mptGeometry.Angle);
            Bt=-B_X.*cos(theta_bt')-B_Y.*sin(theta_bt');  % PF contribution

            if isFig
                normB=sqrt(B_X.^2+B_Y.^2);
                X=obj.mptGeometry.XCenter;
                Y=obj.mptGeometry.ZCenter;
                U=B_X./normB;
                V=B_Y./normB;
                quiver(X',Y',U,V,'b')
                [flag1,flag2]=obj.vectorDirection(0.8, 0, X, Y, U, V);
                figure;stackplot({{1:numel(Bt),Bt,'$B_{\theta}(Gauss)$'}},'Green Function computation','No',1)
            end
        end
        function [Br,flag1,flag2]=getPFbr(obj,pfCoil,coilcurrent,xgridNum,ygridNum,isFig)
            % attention   该函数计算的是单位电流 1kA 时产生的磁场
            if nargin<3  current=1;   end
            if nargin<4  xgridNum=9;   end
            if nargin<5  ygridNum=9;   end
            if nargin<6  isFig=1;   end
            pfNames = extractMultipleStrings(pfCoil);               %解析输入的字符串中的PF线圈通道名称
            B_X=zeros(size(obj.mprGeometry.XCenter,1),1)';          %预先分配计算后的磁场的大小
            B_Y=B_X;
            if isFig  %如果绘图，先把真空室及磁探针绘制到figure中，接下来随着循环进行PF线圈的绘制
                figure('Color',[1 1 1])
                obj.drawVV;
                obj.drawbr;
            end
            for i=1:numel(pfNames)
                pfName=pfNames{i};
                current=-coilcurrent(i)*1e3;  % unit is kA ,and clockwise direction is positive
                number = regexp(pfName, '\d+', 'match');%判断是第几个线圈
                number=str2double(number{1});
                [pfX,pfZ]=obj.grid(pfName);
                R=obj.PFcoil.XCenter(number+1);  %+1是因为第1个线圈是CS线圈
                Z=obj.PFcoil.ZCenter(number+1);
                NX=obj.PFcoil.NX(number+1);
                NY=obj.PFcoil.NY(number+1);
                N=obj.PFcoil.N(number+1);
                FilamentCurrent=ones(numel(pfX),1)*N/(NX*NY)*current; % 网格化后每个点电流丝的电流大小
                [probe_x,probe_y]=obj.grid('br',xgridNum,ygridNum);   % 对tangetial probe进行网格化
                [BX,BY]=MMagneticField(probe_x,probe_y,pfX,pfZ,FilamentCurrent);  %计算网格化的磁探针位置处的磁场大小，单位T
                BX2=reshape(BX,[(xgridNum*ygridNum),numel(BX)/(xgridNum*ygridNum)]); %重新按照网格化参数进行磁场大小线性叠加
                BY2=reshape(BY,[(xgridNum*ygridNum),numel(BY)/(xgridNum*ygridNum)]);
                B_X=B_X+sum(BX2,1)/(xgridNum*ygridNum);  % BX  unit Gauss  水平方向磁场
                B_Y=B_Y+sum(BY2,1)/(xgridNum*ygridNum);  % 垂直方向磁场

                if isFig
                    obj.drawPF(number);
                    if current>0
                        hold on;plot(R,Z,'X','MarkerSize',20,'MarkerFaceColor','k','MarkerEdgeColor','k')
                    else
                        hold on;plot(R,Z,'o','MarkerSize',10,'MarkerFaceColor','k','MarkerEdgeColor','k')
                    end
                end
            end
            theta_br=deg2rad(obj.mprGeometry.Angle);
            Br=B_Y.*cos(theta_br')-B_X.*sin(theta_br'); % PF contribution

            if isFig
                normB=sqrt(B_X.^2+B_Y.^2);
                X=obj.mprGeometry.XCenter;
                Y=obj.mprGeometry.ZCenter;
                U=B_X./normB;
                V=B_Y./normB;
                quiver(X',Y',U,V,'b')
                [flag1,flag2]=obj.vectorDirection(0.8, 0, X, Y, U, V);
                figure;stackplot({{1:numel(Br),Br,'$B_r(Gauss)$'}},'Green Function computation','No',1)
            end
        end
    end
    methods(Access=private)
        function [flag1, flags2] = vectorDirection(obj,x0, y0, x1, y1, U, V)
            % 初始化flags和flags2数组
            flag1 = zeros(size(x1));  %判断（x1,y1）处的矢量（U,V）是顺时针还是逆时针
            flags2 = zeros(size(x1)); %判断（x1,y1）处的矢量（U,V）径向向内还是向外

            % 遍历所有点
            for i = 1:length(x1)
                % 计算从原点到位置点的向量A
                A_X = x1(i) - x0;
                A_Y = y1(i) - y0;

                % 位置点的矢量方向B
                B_X = U(i);
                B_Y = V(i);

                % 计算点积和叉积
                dot_product_AB = A_X * B_X + A_Y * B_Y;
                cross_product_AB = A_X * B_Y - A_Y * B_X;

                % 根据叉积的符号判断旋转方向
                if cross_product_AB > 0
                    flag1(i) = -1; % 逆时针
                elseif cross_product_AB < 0
                    flag1(i) = 1; % 顺时针
                else
                    flag1(i) = 0; % 向量方向与x轴正方向一致或反方向一致
                end

                % 判断（U,V）与径向方向的夹角
                if dot_product_AB > 0
                    flags2(i) = 1; % 夹角小于90度
                else
                    flags2(i) = -1; % 夹角大于90度
                end
            end
        end

    end
end