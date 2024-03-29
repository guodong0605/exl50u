function imgout=edgedetect(shotnum,t1,showfig)
% This Function is used to compute the plasma surface LCSF, In this
% function, the camera lens distortion and position is considered, And the
% coordinate transforma from  Cartesian to cylindrical is computed.
% CAUTION！！！ The calibration file should be put in right path
show_ellipse=1;
[info,frame,~]=downloadcine(shotnum,t1,t1);
img=reshape(frame,info.Height,info.Width); 
img=img/max(max(img));
img=imadjust(img);
%-----Use the Calibration parameters to correct the image distortion------
M120_cal_path='G:\matlab code\ENN\M120_Calibration.mat'; %You should correct it depending on your own path
load(M120_cal_path);
img2=undistortImage(img,cameraParams);
img3=img_process(img2);
threshold=find_threshold(img3,1);
% threshold=0.08;
% temp=multithresh(img4,2);threshold=temp(1);    %Otsu threshold
%%
ref_color=0;                                  % the background lightness is 67
bin_mask = zeros(info.Height,info.Width);
bin_mask = bin_mask | (img3 - ref_color).^2 <= threshold^2; % MagicWand method
   
Blobs=bwconncomp(~bin_mask);                   % Find the connected blobs in 2-D image
numPixels=cellfun(@numel,Blobs.PixelIdxList);  % Get the pixel numbers of each blob
[~,idx]=max(numPixels);                        % The index of the biggest Blob
biggest_Blob=zeros(info.Height,info.Width);
biggest_Blob(Blobs.PixelIdxList{idx})=1;       % biggest_Blob is the selection of biggest blob
se=strel('disk',5);img5=imerode(biggest_Blob,se);
boundaries = bwboundaries(img5);       % Get the boundary of biggest blob

for k=1:length(boundaries)
    num(k)=length(boundaries{k});
end
firstBoundary = boundaries{num==max(num)};
x = firstBoundary(:, 2); 
y = firstBoundary(:, 1); 
%%
windowWidth = 199;
polynomialOrder = 3;
overlap=100;
x(end+1:end+overlap)=x(1:overlap);
y(end+1:end+overlap)=y(1:overlap);
x1 = sgolayfilt(x, polynomialOrder, windowWidth); % Curvefit of the discrete points in Img
y1 = sgolayfilt(y, polynomialOrder, windowWidth);
boundx=x1(1+overlap/2:end-overlap/2);
boundy=y1(1+overlap/2:end-overlap/2);

%%
cx=642;                  % Horizontal pixel center
%--------------------      % Use polyfit to find the center
% x400=560:700;
% y400=img3(400,560:700);
% p=polyfit(x400,y400,2);
% y400_2=polyval(p,x400);
% cx=x400(y400_2==min(y400_2));
%----------------------
cy=391;                  % Vertical pixel center
ratio=4.1/1e3;           % unit mm/pixel;
focalLength=14.7;        % unit mm
distance=2.020;          % unit mm
px=(boundx-cx)*ratio;    % Image x axis in meter unit
py=(boundy-cy)*ratio;    % Image x axis in meter unit
%%
center_width=0.7;        % Select part of the Curve to avoid the Center Rod
ue=px(px>center_width);
ve=py(px>center_width);
uc=0;                    % World coordinate of camera
vc=0;
wc=2.02;
%---------Coordinate transform From Cartesian to cylindrical------------
duedve=diff(ue)./diff(ve);
duedve=[duedve;duedve(end)];
phie=atan(((ue-uc)-(ve-vc).*duedve)./wc);
Re=ue.*wc./(wc*cos(phie)+(ue-uc).*sin(phie));
Ze=ve-(ve-vc).*(Re.*sin(phie))./wc;

Re2=Re(round(0.3*length(Re)):round(0.7*length(Re)));
sort_re=sort(Re2,'descend');
ze_max=mean(sort_re(1:5));
%--------------------------------------------
temp1=0.85*max(ue);
temp2=0.85*max(Re);
ue3=ue(ue>temp1);ve3=ve(ue>temp1);
ue3(end+1:end+100)=0.2*ones(100,1);ve3(end+1:end+100)=linspace(-0.2,0.2,100);
Re3=Re(Re>temp2);Ze3=Ze(Re>temp2);
Re3(end+1:end+100)=0.2*ones(100,1);Ze3(end+1:end+100)=linspace(-0.2,0.2,100);
ellipse_fit1 = fit_ellipse(ue3,ve3);
ellipse_fit2 = fit_ellipse(Re3,Ze3);
%----------------------------------------------------
imgout=struct;
imgout.img=img;
imgout.threshold=threshold;
imgout.o1=[ellipse_fit1.X0,ellipse_fit1.Y0];
imgout.o2=[ellipse_fit2.X0,ellipse_fit2.Y0];
imgout.o1a=ellipse_fit1.a;
imgout.o1b=ellipse_fit1.b;
imgout.o2a=ellipse_fit2.a;
imgout.o2b=ellipse_fit2.b;
imgout.r1=ellipse_fit1.X0+ellipse_fit1.a;
imgout.r2=ellipse_fit2.X0+ellipse_fit2.a;
imgout.ellipse1=[ellipse_fit1.ex;ellipse_fit1.ey];
imgout.ellipse2=[ellipse_fit2.ex;ellipse_fit2.ey];
%%
if showfig
R1=linspace(-cx*ratio,(info.Width-cx)*ratio,info.Width);
Z1=linspace(-cy*ratio,(info.Height-cy)*ratio,info.Height);
[RR,ZZ]=meshgrid(R1,Z1);
figure('unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',2,'position',[0.1,0.1,0.6,0.6]);
pcolor(RR,ZZ,img2);shading interp; colormap('Gray')
hold on;plot(px,py,'.r');
if show_ellipse   
    hold on;plot(ellipse_fit1.ex,ellipse_fit1.ey,'--y','LineWidth',2.5)
    hold on;plot(ellipse_fit2.ex,ellipse_fit2.ey,'m','LineWidth',2.5)
    %----------------------- ellipse fitting of plasma edge-------------------------------
    o1=[ellipse_fit1.X0,ellipse_fit1.Y0];
    o2=[ellipse_fit2.X0,ellipse_fit2.Y0];
    o1a=[ellipse_fit1.X0+ellipse_fit1.a,ellipse_fit1.Y0];
    o1b=[ellipse_fit1.X0,ellipse_fit1.Y0+ellipse_fit1.b];
    o2a=[ellipse_fit2.X0+ellipse_fit2.a,ellipse_fit2.Y0];
    o2b=[ellipse_fit2.X0,ellipse_fit2.Y0+ellipse_fit2.b];
    hold on;plot([o2(1),o2a(1)],[o2(2),o2a(2)],'g','Linewidth',1.5);
    hold on;plot([o2(1),o2b(1)],[o2(2),o2b(2)],'b','Linewidth',1.5);
    t0=text(-2,1.3,['shot:',num2str(shotnum),'@',num2str(t1),'s']);
    set(t0,'Interpreter','latex','color','w','fontsize',20)
    tt1=text(max(px),0,['o','(',char(vpa(o2(1),2)),',',char(vpa(o2(2),2)),')']);
    set(tt1,'Interpreter','latex','color','w','fontsize',20)
    tt2=text(max(px),-0.2,['a=',char(vpa(ellipse_fit2.a,2))]);
    set(tt2,'Interpreter','latex','color','w','fontsize',20)
    tt3=text(max(px),-0.4,['b=',char(vpa(ellipse_fit2.b,2))]);
    set(tt3,'Interpreter','latex','color','w','fontsize',20)
    tt4=text(max(px),-0.6,['R=',char(vpa(ellipse_fit2.X0+ellipse_fit2.a,2))]);
    set(tt4,'Interpreter','latex','color','w','fontsize',20)
    l1=legend('Img data','Edge Detection','Ellipse fitting','Cord Transform','a','b');
    set(l1,'Interpreter','latex','fontsize',14)
end
%%
%----------plot the background and selection of edge------------------
%------The center Rod-----------------
rod_y=linspace(-1.5,1.5,10);
rod_x=linspace(0.176,0.176,10);
[rod_z,rod_phi]=meshgrid(rod_y,-pi:pi/50:pi);
rod_r=repmat(rod_x,size(rod_z,1),1);
X1=rod_r.*cos(rod_phi);
Y1=rod_r.*sin(rod_phi);

figure('unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.73,0.6])
subplot(1,3,1:2)
S1=surf(X1,Y1,rod_z,'EdgeColor','none'); 
[ZZ,phi]=meshgrid(Ze',-pi:0.05:pi);   %py‘
RR=repmat(Re',size(Re',1),1);          %px'
X=RR.*cos(phi);
Y=RR.*sin(phi);
hold on;
S2=surf(X,Y,ZZ,'EdgeColor','none'); alpha(0.5);%colormap summer;

xlim([-1.5,1.5])
ylim([-2.2,1.5])
zlim([-1.5,1.5])
[x2,z2]=meshgrid([-1.5:0.1:1.5],[-1.5:0.1:1.5]);
y2=zeros(length(x2),1);
hold on;
S3=surf(x2,y2,z2,'EdgeColor','none');alpha(0.4);


axis equal; axis tight; %axis off; hidden off;
xlabel('X'); ylabel('Y'); zlabel('Z'); box on;

S1.FaceColor=[0.7 0.7 0.7];
% S1.FaceAlpha=1;

S2.FaceAlpha=0.7;
S3.FaceColor=[0 0.4471 0.7412];
S3.FaceAlpha=0.5;
%----------Plot the shadow of tangantial------------------
YY=zeros(length(Re),1);
plot3(-Re,YY,Ze,'k','Linewidth',5.5)
plot3(-ue,YY,ve,'r','Linewidth',5.5)

%---------Plot the eyesight of camera-----------
for j=1:floor(length(Re)/10):length(Re)
    plot3([0,-ue(j)],[-wc,0],[0,ve(j)],'m','Linewidth',1.5,'handlevisibility','off');hold on;
end
plot3([0,-ue(j)],[-wc,0],[0,ve(j)],'m','Linewidth',1.5);
R = [1 0 0;0 0 -1;0 1 0];
cam = plotCamera('Location',[0 -wc 0],'Orientation',R,'Opacity',0,'Size',0.1);
l1=legend('Center post','Plasma surface','Mid-plane','Tangential','Projection','Viewsight');
set(l1,'Fontsize',8,'FontWeight','normal','Location','east')
%----------Plot the shadow of tangantial------------------
subplot(1,3,3)
plot(ue,ve,'r','Linewidth',2.5);
hold on;plot(Re,Ze,'k','Linewidth',2.5)

hold on;plot([ze_max,ze_max],[get(gca,'Ylim')],'--m')
xlabel('R(m)');
ylabel('Z(m)');
text(0.45,0,['R_{LCFS}=',num2str(ze_max)])

end
end


%%