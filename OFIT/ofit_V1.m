function varargout = ofit_V1(varargin)
% OFIT_V1 MATLAB code for ofit_V1.fig
%      OFIT_V1, by itself, creates a new OFIT_V1 or raises the existing
%      singleton*.
%
%      H = OFIT_V1 returns the handle to a new OFIT_V1 or the handle to
%      the existing singleton*.
%
%      OFIT_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OFIT_V1.M with the given input arguments.
%
%      OFIT_V1('Property','Value',...) creates a new OFIT_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ofit_V1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ofit_V1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ofit_V1

% Last Modified by GUIDE v2.5 08-May-2024 16:25:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ofit_V1_OpeningFcn, ...
                   'gui_OutputFcn',  @ofit_V1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ofit_V1 is made visible.
function ofit_V1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ofit_V1 (see VARARGIN)

% Choose default command line output for ofit_V1
set(handles.figure1,'Position',[0,0,477,636])
handles.output = hObject;

%-----------  1 把子路径中的资源添加到matlab路径-----------
global filefolder movie_param
guidata(hObject, handles);
filepath = mfilename('fullpath');
filename=mfilename;
filefolder=filepath(1:end-length(filename));
addpath(filefolder);

ii=imread([filefolder,'icon\background.jpg']);
ii2=imread([filefolder,'icon\movieplot.jpg']);
axes(handles.axes1);
imagesc(ii); % Display the image using imagesc

axes(handles.axes_movie);
set(handles.axes_movie,'XLim',[0.5000  size(ii,2)]);
set(handles.axes_movie,'YLim',[0.5000  size(ii,1)]);
imagesc(ii2); %Movie 背景图片设置
drawnow; % 强制 MATLAB 立即更新图形窗口

colormap_folder=[filefolder,'mycolormap']; %添加colormap资源
addpath(colormap_folder);
%----------初始化movie页面得参数，把所有和绘图相关参数放再movie_params中--------------------------
movie_param.camera='M150';
movie_param.shotnum=3390;
movie_param.contrast=0;
movie_param.cmin=0;
movie_param.cmax=1;
movie_param.xmin=-1.9;
movie_param.xmax=1.9;
movie_param.ymin=-1.25;
movie_param.ymax=1.25;
movie_param.start=0;
movie_param.end=0;
movie_param.isframe=1;
movie_param.dframe=1;
movie_param.style='gray';
movie_param.isadjust=0;
movie_param.denoise=0;
movie_param.RR=0;
movie_param.ZZ=0;
movie_param.playspeed=10;
movie_param.flipud=1;

%-----------设置各个面板相互独立--------------------------
% set(ha,'handlevisibility','off','visible','off');
handles.panel_ofit.Parent=gcf;
handles.panel_movie.Parent=gcf;
handles.panel_plot.Parent=gcf;
%-----------matlab版本检查，是否包含需要的包------------
product_info = ver;
tool_names=[];
for i=1:length(product_info)
    tool_names=[tool_names,',',product_info(i).Name];
end
global fitting_flag vision_flag image_flag
fitting_flag=contains(tool_names,'Curve Fitting Toolbox');
vision_flag=contains(tool_names,'Computer Vision Toolbox');
image_flag=contains(tool_names,'Image Processing Toolbox');
% UIWAIT makes ofit_V1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
if ~fitting_flag
   handles.Info_text.String='您的matlab 没有包含曲线拟合工具箱！';
   handles.Info_text.FontSize=21; 
end
if ~fitting_flag
   temp=handles.Info_text.String;
   handles.Info_text.String={temp,'您的matlab 没有包含计算机视觉工具箱！'};
   handles.Info_text.FontSize=15; 
end
%------------------OFIT初始化-------------
global img1 img2 img3 img4 threshold_value mystep inner_x;
img1=[];
img2=[];
img3=[];
img4=[];
threshold_value=0;
mystep=0;
inner_x=0.265;
fig1=[];
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
set(handles.slide1,'Value',0);
%--------------Movie Plot 初始化----------------------------------------------
set(handles.movie_contrast,'Value',0);
set(handles.movie_cmin,'Value',0);
set(handles.movie_cmin_edit,'Value',0);
set(handles.movie_cmax,'Value',1);
set(handles.movie_cmax_edit,'Value',1);

set(handles.movie_denoise,'Value',0);
set(handles.movie_ali,'Value',0);
set(handles.movie_time,'Value',0);
set(handles.movie_frame,'Value',1);



savename=[getenv('UserProfile') '\Desktop'];
movie_param.savename=savename;
% desktop_folder=ls(savename);
% temp='EXL50_Camera';
% if ~strcmp(desktop_folder,temp)
%     mkdir(savename,temp)
% end
% outputfolder=[savename,'\EXL50_Camera'];
handles.movie_savename.String=savename;
handles.movie_savename.FontSize=12;

% --- Outputs from this function are returned to the command line.
function varargout = ofit_V1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in download.
function download_Callback(hObject, eventdata, handles)
%----------------------------------------
    global img1 img2 img3 img4 threshold_value mystep fig1;
    img1=[];
    img2=[];
    img3=[];
    img4=[];
    threshold_value=0;
    mystep=0;
    fig1=[];
    set(handles.radiobutton1,'Value',0);
    set(handles.radiobutton2,'Value',0);
    set(handles.radiobutton3,'Value',0);
    set(handles.slide1,'Value',0);
%=------------------------------------------
   warning off
    global RR ZZ fig1 info  current_fig_num shotnum mystep undistort_flag time filefolder param_path;

    current_fig_num=1;
    mystep=1;
    undistort_flag=0;
    camera=handles.pushbutton8.String(handles.pushbutton8.Value);
    camera=camera{1};
    shotnum=str2double(handles.shot_edit.String);
    time=str2double(handles.time_edit.String);
    try
        handles.Info_text.String='数据下载中!';
        handles.Info_text.FontSize=20;
        [info,picture]=downloadcine(shotnum,time,time,1,camera,0);
        global img1;
        img1=reshape(picture,info.Height,info.Width); 
        img1=img1/max(max(img1));

        handles.Info_text.String='数据已经下载完成!';
    catch
        handles.Info_text.String='数据库中没有相关数据，请检查后重试！';
        handles.Info_text.FontSize=15;
        return;
    end
    %------------------------------
    param_path=[filefolder,'params.mat'];
    load(param_path);
    cx=params.cx(shotnum);
    cy=params.cy;
    ratio=params.ratio2/1e3;
    R1=linspace(-cx*ratio,(info.Width-cx)*ratio,info.Width);
    Z1=linspace(-cy*ratio,(info.Height-cy)*ratio,info.Height);
    [RR,ZZ]=meshgrid(R1,Z1);
%---------------------------
    fig1=figure;
    set(fig1,'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',2,'position',[0,0.02,0.5,0.5]);
    if camera==2
     pcolor(RR,ZZ,img1);shading interp; colormap('Gray')
     t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
     set(t0,'Interpreter','latex','color','w','fontsize',20)
    else
     pcolor(RR,ZZ,img1);shading interp; colormap('Gray')
    t0=text(min(RR(:,1))+0.2,1.2,['shot:',num2str(shotnum),'@',num2str(time),'s']);
     set(t0,'Interpreter','latex','color','w','fontsize',20)
    end
    handles.info_text.String='数据已经下载完成！';
% --- Executes on slider movement.
function slide1_Callback(hObject, eventdata, handles)
% hObject    handle to slide1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global current_fig_num img1 img2 img3 img4 fig1 RR ZZ shotnum time mystep;
m1=min(handles.slide1.Value,0.95);
m2=max(0.01,m1);
switch current_fig_num
    case 1 
        img2=imadjust(img1,[0,1-m2]);
        figure(fig1);
        mypcolor(fig1,RR,ZZ,img2)
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        current_fig_num=2;  
    case  2
        img2=imadjust(img1,[0,1-m2]);
        figure(fig1);
        mypcolor(fig1,RR,ZZ,img2);
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        current_fig_num=2;  
    case 3
        img2=imadjust(img3,[0,1-m2]);
        figure(fig1);
        mypcolor(fig1,RR,ZZ,img2)
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        current_fig_num=2;  
     case 4
        img2=imadjust(img4,[0,1-m2]);
        figure(fig1);
        mypcolor(fig1,RR,ZZ,img2);
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        current_fig_num=2;  
end
current_fig_num=2;

% --- Executes during object creation, after setting all properties.
function slide1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function shot_edit_Callback(hObject, eventdata, handles)
% hObject    handle to shot_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shot_edit as text
%        str2double(get(hObject,'String')) returns contents of shot_edit as a double


% --- Executes during object creation, after setting all properties.
function shot_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shot_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_edit as text
%        str2double(get(hObject,'String')) returns contents of time_edit as a double


% --- Executes during object creation, after setting all properties.
function time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
shotnum=str2double(handles.shot_edit.String);
time=str2double(handles.time_edit.String);
try
edgedetect(shotnum,time,1); 
catch
    handles.Info_text.String='自动识别边界失败，请尝试分步操作！';
    handles.Info_text.FontSize=20;
end
function radiobutton1_Callback(hObject, eventdata, handles)
global RR ZZ shotnum time current_fig_num img1 img2 img3 img4 fig1 mystep ;
if mystep
m2=get(hObject,'Value');
if m2
    temp=eval(['img',num2str(current_fig_num)]);
    img3=img_process(temp);
    figure(fig1) ;
    set(fig1,'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',2,'position',[0,0.02,0.5,0.5]);
    mypcolor(fig1,RR,ZZ,img3)
    if mystep<3
     t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
     set(t0,'Interpreter','latex','color','w','fontsize',20)   
    end
    current_fig_num=3;
    handles.Info_text.String='已完成对数据进行最小值滤波！';
    handles.Info_text.FontSize=20;
else
    if ~isempty(img2)
        figure(fig1);
%         pcolor(RR,ZZ,img2);shading interp; colormap('Gray');
        mypcolor(fig1,RR,ZZ,img2)
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        handles.Info_text.String='已恢复降噪之前的数据！';
        handles.Info_text.FontSize=20;
        current_fig_num=2;
    else
        figure(fig1);
%         pcolor(RR,ZZ,img1);shading interp; colormap('Gray')
        mypcolor(fig1,RR,ZZ,img1)
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        handles.Info_text.String='已恢复降噪之前的数据！';
        handles.Info_text.FontSize=20;
        current_fig_num=1;        
    end
end
else
 handles.Info_text.String={'请先下载数据！'};
 handles.Info_text.FontSize=18;   
end
  


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_fig_num img1 img2 img3 img4 fig1 threshold_value mystep;
if mystep>=1
method = handles.popupmenu1.Value;
temp=eval(['img',num2str(current_fig_num)]);
 switch method
     case 1
         threshold_value=find_threshold(temp,0);
         handles.threshold.String=num2str(threshold_value);
         handles.Info_text.String={'已完图像分割的阈值计算！',['Threshold=',num2str(threshold_value)]};
         handles.Info_text.FontSize=15;
     case 2
         threshold_value=multithresh(temp,2);threshold=threshold_value(1);    %Otsu threshold
         handles.threshold.String=num2str(threshold);
         handles.Info_text.String={'已完图像分割的阈值计算！',['Threshold=',num2str(threshold)]};
         handles.Info_text.FontSize=15;
     case 3
         threshold_value=multithresh(temp,3);threshold=threshold_value(2);    %Otsu threshold
         handles.threshold.String=num2str(threshold);
         handles.Info_text.String={'已完图像分割的阈值计算！',['Threshold=',num2str(threshold)]};
         handles.Info_text.FontSize=15;
 end
 mystep=2;
else
    handles.Info_text.String={'请确认已完成下载数据操作再进行计算！'};
    handles.Info_text.FontSize=15;
    return;
end
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in magicwand.
function magicwand_Callback(hObject, eventdata, handles)
% hObject    handle to magicwand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_fig_num img1 img2 img3 img4 fig1  info params px py mystep RR ZZ shotnum time issplit;
if mystep>=2
    temp=eval(['img',num2str(current_fig_num)]);
    %-------------------------Magic Wand--------------------
    threshold_value=str2num(handles.threshold.String);
    if threshold_value>0 && threshold_value<1
        [px,py]=img_split(temp,threshold_value,params,info);
        figure(fig1);
        if issplit
            clf;
            pcolor(RR,ZZ,temp);shading interp; colormap('Gray')
            t0=text(min(RR(:,1))+0.2,1.2,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        
        hold on;plot(px,py,'r','LineWidth',2)
        handles.Info_text.String='已完成对图像的分割';
        handles.Info_text.FontSize=18;
    else
        handles.Info_text.String='请确认图像分割的阈值！ 阈值应0<x<1';
        handles.Info_text.FontSize=18;
        return;
    end
    mystep=3;
    issplit=1;
else
    handles.Info_text.String='请确认已完成上一步操作！';
    handles.Info_text.FontSize=18;
    return;
end
%---------------------------------------




% --- Executes on button press in trans_button.
function trans_button_Callback(hObject, eventdata, handles)
% hObject    handle to trans_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global px py Re Ze fig1 ue ve wc mystep center_width
if mystep==3
    center_width=str2double(handles.trans_edit.String);
    if center_width<0
        ue=-px(px<center_width);
        ve=py(px<center_width);
    else
        ue=px(px>center_width);
        ve=py(px>center_width);
    end
    uc=0;                    % World coordinate of camera
vc=0;
wc=2.02;
%---------Coordinate transform From Cartesian to cylindrical------------
duedve=diff(ue)./diff(ve);
duedve=[duedve;duedve(end)];
phie=atan(((ue-uc)-(ve-vc).*duedve)./wc);
Re=ue.*wc./(wc*cos(phie)+(ue-uc).*sin(phie));
Ze=ve-(ve-vc).*(Re.*sin(phie))./wc;
figure(fig1);
if center_width>0
 hold on;plot(Re,Ze,'--','color',[0.06,1.00,1.00],'LineWidth',2.5);
else
    hold on;plot(-Re,Ze,'--','color',[0.06,1.00,1.00],'LineWidth',2.5);
end
handles.Info_text.String='已完成对坐标的变换';
handles.Info_text.FontSize=18;
mystep=4;
else
  handles.Info_text.String='请确认已完成上一步操作！';
handles.Info_text.FontSize=18;  
end

function trans_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trans_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trans_edit as text
%        str2double(get(hObject,'String')) returns contents of trans_edit as a double


% --- Executes during object creation, after setting all properties.
function trans_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trans_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
global current_fig_num img1 img2 img3 img4 fig1  rect image_flag mystep shotnum;
if mystep
    m2=get(hObject,'Value');
    if m2
        temp=eval(['img',num2str(current_fig_num)]);
        default_position=[-0.2064 -1.6031 0.3709 3.2800];
        figure(fig1);
        if image_flag
            rect = drawrectangle('Position',default_position,'StripeColor','r','FaceAlpha',0.1,'Label','Center Post');
            handles.Info_text.String='请用鼠标拖动矩形框置中心柱区域！，并按回车键结束';
            handles.Info_text.FontSize=20;
            % set(fig1, 'KeyPressFcn', {@replotfigure,fig1,rect.Position})
            set(fig1,'KeyPressFcn',{@replotfigure,handles})
        else
            global RR  ZZ rect fig1 params param_path current_fig_num shotnum time img1 img2 img3
            figure(fig1);
            handles.Info_text.String='请用鼠标点击中心柱区域的两个边界';
            handles.Info_text.FontSize=15;
            [temp_x,~]=ginput(2);
            dshift=(temp_x(1)+temp_x(2))/2;
            RR=RR-dshift;
            params.cx(shotnum)=params.cx(shotnum)+dshift/params.ratio;
            save(param_path,'params');
            temp=eval(['img',num2str(current_fig_num)]);
            mypcolor(fig1,RR,ZZ,img1)
            if mystep<3
                t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
                set(t0,'Interpreter','latex','color','w','fontsize',20)
            end
        end
    else        
        return;
    end
else
    handles.Info_text.String='请先下载数据！';
    handles.Info_text.FontSize=18;
end

function replotfigure(h,~,~)
c=get(h,'CurrentKey');
if strcmp(c, 'return')
    global RR  ZZ rect fig1 params param_path mystep current_fig_num shotnum time img1 img2 img3
    figure(fig1);
    dshift=rect.Position(1)+rect.Position(3)/2;
    RR=RR-dshift;
    ax=fig1.Children;
    if length(ax)>1
        ax=ax(2);
    end
    types=get(ax.Children,'Type');
    temp=strcmpi(types, 'images.roi.rectangle');
    delete(ax.Children(find(temp)));
    params.cx(shotnum)=params.cx(shotnum)+dshift/params.ratio;
    save(param_path,'params');
    temp=eval(['img',num2str(current_fig_num)]);
    %     pcolor(RR,ZZ,img1);shading interp; colormap('Gray')
    mypcolor(fig1,RR,ZZ,temp)
    if mystep<3
        t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
        set(t0,'Interpreter','latex','color','w','fontsize',20)
    end
else
    return;
end

function radiobutton3_Callback(hObject, eventdata, handles)
m4=get(hObject,'Value');
global undistort_flag mystep
if mystep
if m4
    if ~undistort_flag
    try
        global current_fig_num img1 img2 img3 img4  fig1 cameraParams RR  ZZ shotnum time undistort_flag ;
        temp=eval(['img',num2str(current_fig_num)]);
        img4=undistortImage(temp,cameraParams);
        figure(fig1);
        %         pcolor(RR,ZZ,img4);shading interp; colormap('Gray')
        mypcolor(fig1,RR,ZZ,img4)
        if mystep<3
            t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
            set(t0,'Interpreter','latex','color','w','fontsize',20)
        end
        current_fig_num=4;
        undistort_flag=1;
        handles.Info_text.String='已完成图像的畸变矫正';
        handles.Info_text.FontSize=20;
    catch
        handles.Info_text.String='Matlab 未安装Computer Vision toolbox工具箱';
        handles.Info_text.FontSize=20;
    end
    end
else
    return;
end
else
handles.Info_text.String='请先下载数据！';
handles.Info_text.FontSize=18; 
end


function ellipse_fitting_Callback(hObject, eventdata, handles)
%-------------椭圆拟合边界---------------------
global ue ve Re Ze shotnum time fig1 px ellipse_fit1  ellipse_fit2 mystep o2 o2a o2b center_width inner_x ellipse_fit1  ellipse_fit2
inner_x=str2double(handles.inner_x.String);
if mystep==4
    addPoint=1000;
temp1=0.85*max(ue);
temp2=0.85*max(Re);
ue3=ue(ue>temp1);ve3=ve(ue>temp1);  mid_y=(ve3(1)+ve3(end))/2;
ue3(end+1:end+addPoint)=inner_x*ones(addPoint,1);ve3(end+1:end+addPoint)=linspace(0.2,-0.2,addPoint)+mid_y;
Re3=Re(Re>temp2); Ze3=Ze(Re>temp2);
Re3(end+1:end+addPoint)=inner_x*ones(addPoint,1);Ze3(end+1:end+addPoint)=linspace(0.2,-0.2,addPoint)+mid_y;
ellipse_fit1 = fit_ellipse(ue3,ve3);
ellipse_fit2 = fit_ellipse(Re3,Ze3);
%%
figure(fig1);
    if center_width>0
    hold on;plot(ellipse_fit1.ex,ellipse_fit1.ey,'--y','LineWidth',2.5)
    hold on;plot(ellipse_fit2.ex,ellipse_fit2.ey,'m','LineWidth',2.5)
    else
    hold on;plot(-ellipse_fit1.ex,ellipse_fit1.ey,'--y','LineWidth',2.5)
    hold on;plot(-ellipse_fit2.ex,ellipse_fit2.ey,'m','LineWidth',2.5)
    end
    %----------------------- ellipse fitting of plasma edge-------------------------------
    o1=[ellipse_fit1.X0,ellipse_fit1.Y0];
    o2=[ellipse_fit2.X0,ellipse_fit2.Y0];
    o1a=[ellipse_fit1.X0+ellipse_fit1.a,ellipse_fit1.Y0];
    o1b=[ellipse_fit1.X0,ellipse_fit1.Y0+ellipse_fit1.b];
    o2a=[ellipse_fit2.X0+ellipse_fit2.a,ellipse_fit2.Y0];
    o2b=[ellipse_fit2.X0,ellipse_fit2.Y0+ellipse_fit2.b];
     if center_width>0
    hold on;plot([o2(1),o2a(1)],[o2(2),o2a(2)],'g','Linewidth',1.5);
    hold on;plot([o2(1),o2b(1)],[o2(2),o2b(2)],'b','Linewidth',1.5);
     else
         hold on;plot([-o2(1),-o2a(1)],[o2(2),o2a(2)],'g','Linewidth',1.5);
    hold on;plot([-o2(1),-o2b(1)],[o2(2),o2b(2)],'b','Linewidth',1.5);
     end
    tt1=text(max(px),0,['o','(',char(vpa(o2(1),2)),',',char(vpa(o2(2),2)),')']);
    set(tt1,'Interpreter','latex','color','w','fontsize',20)
    tt2=text(max(px),-0.2,['a=',char(vpa(ellipse_fit2.a,2))]);
    set(tt2,'Interpreter','latex','color','w','fontsize',20)
    tt3=text(max(px),-0.4,['b=',char(vpa(ellipse_fit2.b,2))]);
    set(tt3,'Interpreter','latex','color','w','fontsize',20)
    tt4=text(max(px),-0.6,['R=',char(vpa(ellipse_fit2.X0+ellipse_fit2.a,2))]);
    set(tt4,'Interpreter','latex','color','w','fontsize',20)
    l1=legend('Img data','Edge Detection','Cord Transform','Ell-fitting 1','Ell-fitting 2','a','b');
    set(l1,'Interpreter','latex','fontsize',14)
handles.Info_text.String='已完成对等离子体边界的椭圆拟合！';
handles.Info_text.FontSize=18;
else
    handles.Info_text.String='请确认已完成上一步操作！';
handles.Info_text.FontSize=18;
end
%%
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Re Ze ue ve wc ze_max mystep vision_flag
if mystep==4
Re2=Re(round(0.3*length(Re)):round(0.7*length(Re)));
sort_re=sort(Re2,'descend');
ze_max=mean(sort_re(1:5));

%%
rod_y=linspace(-1.5,1.5,10);
rod_x=linspace(0.176,0.176,10);
[rod_z,rod_phi]=meshgrid(rod_y,-pi:pi/50:pi);
rod_r=repmat(rod_x,size(rod_z,1),1);
X1=rod_r.*cos(rod_phi);
Y1=rod_r.*sin(rod_phi);

figure('unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0,0.02,0.5,0.5])
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
if vision_flag
cam = plotCamera('Location',[0 -wc 0],'Orientation',R,'Opacity',0,'Size',0.1);
end
l1=legend('Center post','Plasma surface','Mid-plane','Tangential','Projection','Viewsight');
set(l1,'Fontsize',8,'FontWeight','normal','Location','east')
%----------Plot the shadow of tangantial------------------
subplot(1,3,3)
plot(ue,ve,'r','Linewidth',2.5);
hold on;plot(Re,Ze,'k','Linewidth',2.5)

hold on;plot([ze_max,ze_max],[get(gca,'Ylim')],'--m')
xlabel('R(m)');
ylabel('Z(m)');
text(ze_max,0,['R_{LCFS}=',num2str(ze_max)])
else
handles.Info_text.String='请确认已完成坐标变换！';
handles.Info_text.FontSize=18;
    
end
%%
% --- Executes on button press in savedata.
function savedata_Callback(hObject, eventdata, handles)
% hObject    handle to savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_fig_num img1 img2 img3 img4 px py Re Ze ze_max mystep o2 o2a o2b ellipse_fit1 ellipse_fit2;
if mystep>=1
temp=eval(['img',num2str(current_fig_num)]);
ofit.img=temp;
ofit.edge_px=px;
ofit.edge_py=py;
ofit.Re=Re;
ofit.Ze=Ze;
ofit.lcfs=ze_max;
ofit.o=o2;
ofit.a=o2a;
ofit.b=o2b;
ofit.ellipse1=ellipse_fit1;
ofit.ellipse2=ellipse_fit2;
assignin('base','ofit',ofit) 
handles.Info_text.String='数据已保存到工作空间ofit_output';
handles.Info_text.FontSize=16;
else
handles.Info_text.String='请确认已完成下载数据的操作！';
handles.Info_text.FontSize=18;
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
global fig1 current_fig_num img1 img2 img3 img4 RR ZZ shotnum time mystep;
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if mystep
temp=eval(['img',num2str(current_fig_num)]);
temp1=flipud(temp);
eval(['img',num2str(current_fig_num),'=temp1;']);
figure(fig1);
mypcolor(fig1,RR,ZZ,temp1);
if mystep<3
    t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
    set(t0,'Interpreter','latex','color','w','fontsize',20)
end
handles.Info_text.String='已对图像进行上下翻转！';
handles.Info_text.FontSize=18;
else
handles.Info_text.String='请先下载数据！';
handles.Info_text.FontSize=18;
end


% --------------------------------------------------------------------
function menu_ofit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ofit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_ofit,'Visible','on');
set(handles.panel_movie,'Visible','off');
set(handles.panel_ofit,'Position',[0,0,477,636])

% --------------------------------------------------------------------
function menu_movie_Callback(hObject, eventdata, handles)
% hObject    handle to menu_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panel_ofit,'Visible','off');
set(handles.panel_movie,'Visible','on');
set(handles.panel_movie,'Position',[0,0,477,636])

% --- Executes during object creation, after setting all properties.
function menu_ofit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_ofit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function movie_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to movie_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global  movie_img1 movie_img2  fig2 movie_param  t0;
m1=min(handles.movie_contrast.Value,0.95);
m2=max(0.01,m1);
movie_img2=imadjust(movie_img1,[0,1-m2]);
movie_param.adjustvalue=1-m2;
movie_param.isadjust=1;
figure(fig2);
pcolor(movie_param.RR,movie_param.ZZ,movie_img2);shading interp; 
colormap(movie_param.style);
xlim([movie_param.xmin,movie_param.xmax]);
ylim([movie_param.ymin,movie_param.ymax]);
caxis([movie_param.cmin,movie_param.cmax]);
handles.movie_info.String='数据增强操作已完成';
handles.movie_info.FontSize=15;
if movie_param.isframe
    t0=text(movie_param.xmin+0.3,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(movie_param.currentnum),'f']);
else
    t0=text(movie_param.xmin+0.3,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(movie_param.currentnum),'s']);
end
set(t0,'Interpreter','latex','color','w','fontsize',20)


% t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
%  set(t0,'Interpreter','latex','color','w','fontsize',20)

% --- Executes during object creation, after setting all properties.
function movie_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in camera_select2.
function camera_select2_Callback(hObject, eventdata, handles)
% hObject    handle to camera_select2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns camera_select2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from camera_select2
global movie_param
movie_param.camera=handles.camera_select2.Value;

% --- Executes during object creation, after setting all properties.
function camera_select2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to camera_select2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
function downandplot(handles,shotnum,t1,dt)
 global movie_img1 movie_img2 fig2  movie_param t0;
      try  
        handles.movie_info.String='数据正在下载中...!';
        handles.movie_info.FontSize=20;
        if movie_param.isframe 
            [info,picture]=downloadcine(movie_param.shotnum,t1+dt,t1+dt,1,movie_param.camera,movie_param.isframe);
        else
            
            [info,picture]=downloadcine(movie_param.shotnum,t1+dt,t1+dt,1,movie_param.camera);
        end
        movie_img1=reshape(picture,info.Height,info.Width);
        movie_img1=movie_img1/max(max(movie_img1));
        
    catch
        handles.movie_info.String='数据库中没有相关数据，请检查后重试！';
        handles.movie_info.FontSize=20;
        return;
      end
    if movie_param.isadjust
        movie_img1=imadjust(movie_img1,[0,movie_param.adjustvalue]);
    end
    if movie_param.flipud
        movie_img1=flipud(movie_img1);
    end
    if movie_param.denoise
        movie_img1=img_process(movie_img1);
    end
    figure(fig2);
    pcolor(movie_param.RR,movie_param.ZZ,movie_img1);shading interp; 
   
    colormap(movie_param.style);
    xlim([movie_param.xmin,movie_param.xmax]);
    ylim([movie_param.ymin,movie_param.ymax]);
    caxis([movie_param.cmin,movie_param.cmax]);
    if movie_param.isframe
        t0=text(movie_param.xmin+0.3,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(movie_param.currentnum),'f']);
        handles.movie_info.String=['当前图像为',num2str(movie_param.currentnum),'帧'];
        handles.movie_info.FontSize=20;
    else
        t0=text(movie_param.xmin+0.3,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(movie_param.currentnum),'s']);
        handles.movie_info.String=['当前图像为',num2str(movie_param.currentnum),'s'];
        handles.movie_info.FontSize=15;
    end
    set(t0,'Interpreter','latex','color','w','fontsize',20)

% --- Executes on button press in movie_download.
function movie_download_Callback(hObject, eventdata, handles)
% hObject    handle to movie_download (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%=------------------------------------------
global  fig2 movie_param
shotnum=str2double(handles.movie_shotnum.String);
t1=str2double(handles.movie_start.String);
t2=str2double(handles.movie_end.String);
isframe=handles.movie_frame.Value;
movie_param.shotnum=shotnum;
movie_param.isframe=isframe;
movie_param.start=t1;
movie_param.end=t2;
movie_param.currentnum=movie_param.start;

%-------------------------------------------
global  filefolder
try
shotinfo=cineinfo(movie_param.camera,movie_param.shotnum);
catch
    handles.movie_info.String='数据库中没有当前炮号数据或相机选择错误!';
    handles.movie_info.FontSize=15;
    return;
end
param_path=[filefolder,'params.mat'];
load(param_path);
cx=params.cx(movie_param.shotnum);
cy=params.cy;
ratio=params.ratio2/1e3;


R1=linspace(-cx*ratio,(shotinfo.Width-cx)*ratio,shotinfo.Width);
Z1=linspace(-cy*ratio,(shotinfo.Height-cy)*ratio,shotinfo.Height);
[RR,ZZ]=meshgrid(R1,Z1);
movie_param.RR=RR;
movie_param.ZZ=ZZ;
movie_param.name=shotinfo.name;
movie_param.info=shotinfo;
%---------------------------------------------------------------
fig2=figure;
set(fig2,'color',[1,1,1],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',2,'position',[0,0.02,0.5,0.5]);
downandplot(handles,movie_param.name,movie_param.start,0);

function movie_shotnum_Callback(hObject, eventdata, handles)
% hObject    handle to movie_shotnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_shotnum as text
%        str2double(get(hObject,'String')) returns contents of movie_shotnum as a double
global movie_param
movie_param.shotnum=str2double(handles.movie_shotnum.String);
handles.movie_info.String=['已设置新的炮号',handles.movie_shotnum.String];
handles.movie_info.FontSize=20;

% --- Executes during object creation, after setting all properties.
function movie_shotnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_shotnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in movie_time.
function movie_time_Callback(hObject, eventdata, handles)
% hObject    handle to movie_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movie_time
global movie_param
movie_param.isframe=0;
handles.movie_frame.Value=0;
handles.movie_info.String='已切换为按时间浏览模式！';
handles.movie_info.FontSize=20;
% --- Executes on button press in movie_frame.
function movie_frame_Callback(hObject, eventdata, handles)
% hObject    handle to movie_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of movie_frame
global movie_param;
movie_param.isframe=1;
handles.movie_time.Value=0;
handles.movie_info.String='已切换为按帧数浏览模式！';
handles.movie_info.FontSize=20;

function movie_start_Callback(hObject, eventdata, handles)
% hObject    handle to movie_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_start as text
%        str2double(get(hObject,'String')) returns contents of movie_start as a double
global movie_param
movie_param.t1=str2double(handles.movie_start.String);
handles.movie_info.String=['已设置新的开始时间',handles.movie_start.String];
handles.movie_info.FontSize=20;
% --- Executes during object creation, after setting all properties.
function movie_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in movie_banck10.
function movie_banck10_Callback(hObject, eventdata, handles)
% hObject    handle to movie_banck10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig2 movie_param
if movie_param.isframe
     movie_param.currentnum=movie_param.currentnum-10;
else
    fs=movie_param.info.FrameRate;
    movie_param.currentnum=movie_param.currentnum-10/fs;
end
figure(fig2);
downandplot(handles,movie_param.shotnum,movie_param.currentnum,0);

% --- Executes on button press in movie_back1.
function movie_back1_Callback(hObject, eventdata, handles)
% hObject    handle to movie_back1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig2 movie_param
if movie_param.isframe
     movie_param.currentnum=movie_param.currentnum-1;
else
    fs=movie_param.info.FrameRate;
    movie_param.currentnum=movie_param.currentnum-1/fs;
end
figure(fig2);
downandplot(handles,movie_param.shotnum,movie_param.currentnum,0);

% --- Executes on button press in movie_forward1.
function movie_forward1_Callback(hObject, eventdata, handles)
% hObject    handle to movie_forward1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig2 movie_param
if movie_param.isframe
     movie_param.currentnum=movie_param.currentnum+1;
else
    fs=movie_param.info.FrameRate;
    movie_param.currentnum=movie_param.currentnum+1/fs;
end
figure(fig2);
downandplot(handles,movie_param.shotnum,movie_param.currentnum,0);

% --- Executes on button press in movie_forward10.
function movie_forward10_Callback(hObject, eventdata, handles)
% hObject    handle to movie_forward10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fig2 movie_param
if movie_param.isframe
     movie_param.currentnum=movie_param.currentnum+10;
else
    fs=movie_param.info.FrameRate;
    movie_param.currentnum=movie_param.currentnum+10/fs;
end
figure(fig2);
downandplot(handles,movie_param.shotnum,movie_param.currentnum,0);

% --- Executes on button press in movie_denoise.
function movie_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to movie_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movie_denoise
global fig2 movie_img1 movie_img2 movie_img3  movie_fig_num movie_param
m2=get(hObject,'Value');
if m2
    if movie_param.isadjust
        movie_img3=img_process(movie_img2);
    end
    figure(fig2) ;
    pcolor(movie_param.RR,movie_param.ZZ,movie_img3);shading interp;
    movie_param.denoise=1;
else
     figure(fig2) ;
    if movie_param.isadjust
       pcolor(movie_param.RR,movie_param.ZZ,movie_img2);shading interp;
    else
       pcolor(movie_param.RR,movie_param.ZZ,movie_img1);shading interp;
    end
    movie_param.denoise=0;
end
colormap(movie_param.style);
xlim([movie_param.xmin,movie_param.xmax]);
ylim([movie_param.ymin,movie_param.ymax]);
caxis([movie_param.cmin,movie_param.cmax]);
handles.movie_info.String='已恢复降噪之前的数据！';
handles.movie_info.FontSize=20;

if movie_param.isframe
    t0=text(movie_param.xmin+0.3,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(movie_param.currentnum),'f']);
else
    t0=text(movie_param.xmin+0.3,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(movie_param.currentnum),'s']);
end
set(t0,'Interpreter','latex','color','w','fontsize',20)

% --- Executes on button press in movie_ali.
function movie_ali_Callback(hObject, eventdata, handles)
% hObject    handle to movie_ali (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movie_ali
global fig2 movie_param movie_rect;
if exist('fig2')
    m2=get(hObject,'Value');
    if m2
        default_position=[-0.2064 -1.6031 0.3709 3.2800];
        figure(fig2);
        movie_rect = drawrectangle('Position',default_position,'StripeColor','r','FaceAlpha',0.1,'Label','Center Post');
        handles.movie_info.String='请用鼠标拖动矩形框置中心柱区域！，并按回车键结束';
        handles.movie_info.FontSize=20;
        set(fig2,'KeyPressFcn',{@movie_replotfigure,handles})
    else
        return;
    end
else
    handles.Info_text.String='请先下载数据！';
    handles.Info_text.FontSize=18;
end

function movie_replotfigure(h,~,~)
c=get(h,'CurrentKey');
if strcmp(c, 'return')
    global fig2  filefolder movie_param movie_img1 movie_img2 movie_img3 movie_rect
    figure(fig2);
    dshift=movie_rect.Position(1)+movie_rect.Position(3)/2;
    movie_param.RR=movie_param.RR-dshift;
    ax=fig2.Children;
    if length(ax)>1
        ax=ax(2);
    end
    types=get(ax.Children,'Type');
    temp=strcmpi(types, 'images.roi.rectangle');
    delete(ax.Children(find(temp)));
    
    param_path=[filefolder,'params.mat'];
    load(param_path);
    params.cx(movie_param.shotnum)=params.cx(movie_param.shotnum)+dshift/params.ratio;
    save(param_path,'params');
    
    figure(fig2);
    pcolor(movie_param.RR,movie_param.ZZ,movie_img1);shading interp; 
    colormap(movie_param.style);
    xlim([movie_param.xmin,movie_param.xmax]);
    ylim([movie_param.ymin,movie_param.ymax]);
    caxis([movie_param.cmin,movie_param.cmax]);
    handles.movie_info.String='已恢复降噪之前的数据！';
    handles.movie_info.FontSize=20;

else
    return;
end



% --- Executes on slider movement.
function movie_cmin_Callback(hObject, eventdata, handles)
% hObject    handle to movie_cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global fig2 movie_param
cmin_value=handles.movie_cmin.Value;
cmax_value=str2num(handles.movie_cmax_edit.String);
m1=min(cmin_value,cmax_value-0.05);
figure(fig2);
caxis([m1,cmax_value]);
handles.movie_info.FontSize=20;
handles.movie_cmin_edit.String=num2str(m1);
movie_param.cmin=m1;
handles.movie_info.String='caxis最小值操作已完成';
handles.movie_info.FontSize=20;

% --- Executes during object creation, after setting all properties.
function movie_cmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function movie_cmax_Callback(hObject, eventdata, handles)
% hObject    handle to movie_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global fig2 movie_param
cmin_value=str2num(handles.movie_cmin_edit.String);
cmax_value=handles.movie_cmax.Value;
m2=max(cmax_value,cmin_value+0.1);
figure(fig2);
caxis([cmin_value,m2]);
handles.movie_cmax_edit.String=num2str(m2);
movie_param.cmax=m2;
handles.movie_info.String='caxis最大值操作已完成';
handles.movie_info.FontSize=20;


% --- Executes during object creation, after setting all properties.
function movie_cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function movie_cmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to movie_cmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_cmin_edit as text
%        str2double(get(hObject,'String')) returns contents of movie_cmin_edit as a double


% --- Executes during object creation, after setting all properties.
function movie_cmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_cmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function movie_cmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to movie_cmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_cmax_edit as text
%        str2double(get(hObject,'String')) returns contents of movie_cmax_edit as a double


% --- Executes during object creation, after setting all properties.
function movie_cmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_cmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in style_select.
function style_select_Callback(hObject, eventdata, handles)
% hObject    handle to style_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns style_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from style_select
global fig2 movie_param
temp=handles.style_select.Value;
temp2=handles.style_select.String{temp};
movie_param.style=temp2;
try
figure(fig2);
colormap(movie_param.style);
handles.movie_info.String=['图像风格已切换为',temp2];
handles.movie_info.FontSize=20;
end


% --- Executes during object creation, after setting all properties.
function style_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to style_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in movie_isplot.
function movie_isplot_Callback(hObject, eventdata, handles)
% hObject    handle to movie_isplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movie_isplot
if handles.movie_isplot.Value
movie_param.isplot=1;
movie_param.fs=num2double(handles.movie_fs.String);
movie_param.chn=handles.movie_chanel.String;
end


function movie_chanel_Callback(hObject, eventdata, handles)
% hObject    handle to movie_chanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_chanel as text
%        str2double(get(hObject,'String')) returns contents of movie_chanel as a double


% --- Executes during object creation, after setting all properties.
function movie_chanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_chanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in movie_confirm.
function movie_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to movie_confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global movie_param filefolder fig2
movie_param.t1=str2double(handles.movie_start.String);
movie_param.t2=str2double(handles.movie_end.String);
%---------如果没有运行download button --------------------
if ~movie_param.RR
    shotinfo=cineinfo(movie_param.camera,movie_param.shotnum);
    param_path=[filefolder,'params.mat'];
    load(param_path);
    cx=params.cx(movie_param.shotnum);
    cy=params.cy;
    
    if movie_param.shotnum>12458
        ratio=params.ratio2;
    else
        ratio=params.ratio;
    end
    
    R1=linspace(-cx*ratio,(shotinfo.Width-cx)*ratio,shotinfo.Width);
    Z1=linspace(-cy*ratio,(shotinfo.Height-cy)*ratio,shotinfo.Height);
    [RR,ZZ]=meshgrid(R1,Z1);
    movie_param.RR=RR;
    movie_param.ZZ=ZZ;
    movie_param.name=shotinfo.name;
end
%-------------------------------------------------------------
if movie_param.isframe
[~,frame,time]=downloadcine(movie_param.shotnum,movie_param.t1,movie_param.t2,movie_param.dframe,movie_param.camera,1);
else
 [~,frame,time]=downloadcine(movie_param.shotnum,movie_param.t1,movie_param.t2,movie_param.dframe,movie_param.camera);   
end
mp4filename=[movie_param.savename,'\',num2str(movie_param.shotnum)];
v = VideoWriter(mp4filename,'MPEG-4');
v.FrameRate=movie_param.playspeed;
open (v)
fig3=figure;
warning off;
try
    movie_position=fig2.Position;
catch
     movie_position=[0,0,0.7,0.6];
end

set(gcf,'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',2,'position',movie_position);

for i=1:size(frame,1)
    figure(fig3);
    temp=reshape(double(frame(i,:,:)),size(frame,2),size(frame,3));
    img1=temp/max(max(temp));
    if movie_param.isadjust
    img1=imadjust(img1,[0,movie_param.adjustvalue]);
    end
    if movie_param.flipud
    img1=flipud(img1);
    end
    if movie_param.denoise
    img1=img_process(img1);
    end
    pcolor(movie_param.RR,movie_param.ZZ,img1);shading interp;
    colormap(movie_param.style);
    xlim([movie_param.xmin,movie_param.xmax]);
    ylim([movie_param.ymin,movie_param.ymax]);
    caxis([movie_param.cmin,movie_param.cmax])
    if movie_param.isframe
        t0=text(movie_param.xmin+0.2,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(time(i)),'f']);
    else
        t0=text(movie_param.xmin+0.2,movie_param.ymax-0.3,['shot:',num2str(movie_param.shotnum),'@',num2str(time(i)),'s']);
    end
    set(t0,'Interpreter','latex','color','w','fontsize',20)
    ylabel('Camera','interpreter','Latex');
    colorbar off;
%     set(gca, 'FontWeight', 'normal', 'FontSize', 12, 'LineWidth', 1.1, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.005 0.005],'Xgrid','off','Box','on')
    current_frame = getframe(gcf);
    writeVideo(v,current_frame)
end
close(v)






function movie_savename_Callback(hObject, eventdata, handles)
% hObject    handle to movie_savename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_savename as text
%        str2double(get(hObject,'String')) returns contents of movie_savename as a double
global movie_param
temp=handles.movie_savename.String;
if exist(temp)
movie_param.savename=temp;
else
    handles.movie_info.String='错误的输出路径，请确认后再试';
    handles.movie_info.FontSize=20;
end



% --- Executes during object creation, after setting all properties.
function movie_savename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_savename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  



function movie_end_Callback(hObject, eventdata, handles)
% hObject    handle to movie_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_end as text
%        str2double(get(hObject,'String')) returns contents of movie_end as a double
global movie_param
movie_param.end=str2double(handles.movie_end.String);
handles.movie_info.String=['已设置新的开始时间',handles.movie_end.String];
handles.movie_info.FontSize=20;

% --- Executes during object creation, after setting all properties.
function movie_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlim_max_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_max as text
%        str2double(get(hObject,'String')) returns contents of xlim_max as a double
global fig2 movie_param

xlim_min_value=str2double(handles.xlim_min.String);
xlim_max_value=str2double(handles.xlim_max.String);
if xlim_min_value<xlim_max_value
movie_param.xmax=xlim_max_value;
else
    return;
end
if~isempty(fig2)
figure(fig2);
fig2.CurrentAxes.XLim(1)=xlim_min_value;
fig2.CurrentAxes.XLim(2)=xlim_max_value;
end
handles.movie_info.String=['X坐标轴最大值已调整为',handles.xlim_max.String];
handles.movie_info.FontSize=20;

% --- Executes during object creation, after setting all properties.
function xlim_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlim_min_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_min as text
%        str2double(get(hObject,'String')) returns contents of xlim_min as a double
global fig2  movie_param t0
xlim_min_value=str2double(handles.xlim_min.String);
xlim_max_value=str2double(handles.xlim_max.String);
if xlim_min_value<xlim_max_value
movie_param.xmin=xlim_min_value;
else
    return;
end
if~isempty(fig2)
figure(fig2);
fig2.CurrentAxes.XLim(1)=xlim_min_value;
fig2.CurrentAxes.XLim(2)=xlim_max_value;
end
t0.Position(1)=movie_param.xmin+0.2;
handles.movie_info.String=['X坐标轴最小值已调整为',handles.xlim_min.String];
handles.movie_info.FontSize=20;


% --- Executes during object creation, after setting all properties.
function xlim_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylim_min_Callback(hObject, eventdata, handles)
% hObject    handle to ylim_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim_min as text
%        str2double(get(hObject,'String')) returns contents of ylim_min as a double
global fig2 movie_param
ylim_min_value=str2double(handles.ylim_min.String);
ylim_max_value=str2double(handles.ylim_max.String);
if ylim_min_value<ylim_max_value
movie_param.ymin=ylim_min_value;
else
    return;
end
if~isempty(fig2)
figure(fig2);
fig2.CurrentAxes.YLim(1)=movie_param.ymin;
end
handles.movie_info.String=['Y坐标轴最小值已调整为',handles.ylim_min.String];
handles.movie_info.FontSize=20;
% --- Executes during object creation, after setting all properties.
function ylim_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylim_max_Callback(hObject, eventdata, handles)
% hObject    handle to ylim_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim_max as text
%        str2double(get(hObject,'String')) returns contents of ylim_max as a double
global fig2 movie_param t0
ylim_min_value=str2double(handles.ylim_min.String);
ylim_max_value=str2double(handles.ylim_max.String);
if ylim_min_value<ylim_max_value
movie_param.ymax=ylim_max_value;
else
    return;
end
if~isempty(fig2)
figure(fig2);
fig2.CurrentAxes.YLim(2)=movie_param.ymax;
end
t0.Position(2)=movie_param.ymax-0.2;
handles.movie_info.String=['Y坐标轴最大值已调整为',handles.ylim_max.String];
handles.movie_info.FontSize=20;
% --- Executes during object creation, after setting all properties.
function ylim_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dframe_Callback(hObject, eventdata, handles)
% hObject    handle to dframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dframe as text
%        str2double(get(hObject,'String')) returns contents of dframe as a double
global movie_param
movie_param.dframe=str2double(handles.dframe.String);
% --- Executes during object creation, after setting all properties.
function dframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function movie_banck10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_banck10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global filefolder 
back10_img = imread([filefolder,'icon\back10.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;

function movie_back1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_banck10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global filefolder 
back10_img = imread([filefolder,'icon\back1.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;

function movie_forward1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_banck10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global filefolder 
back10_img = imread([filefolder,'icon\forward1.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;

function movie_forward10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_banck10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global filefolder 
back10_img = imread([filefolder,'icon\forward10.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;



function playspeed_Callback(hObject, eventdata, handles)
% hObject    handle to playspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of playspeed as text
%        str2double(get(hObject,'String')) returns contents of playspeed as a double
global movie_param
movie_param.playspeed=str2double(handles.playspeed.String);

% --- Executes during object creation, after setting all properties.
function playspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Info.
function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Info
global fig2  movie_param
m2=get(hObject,'Value');
if m2
    figure(fig2);
    t0=text(movie_param.xmin+0.3,movie_param.ymin+0.4,[num2str(1000/movie_param.info.FrameRate),'ms/F']);
    set(t0,'Interpreter','latex','color','y','fontsize',15)
    t0=text(movie_param.xmin+0.3,movie_param.ymin+0.6,['Exposure:',num2str(movie_param.info.exposure),'us']);
    set(t0,'Interpreter','latex','color','y','fontsize',15)
    handles.movie_info.String='已在图片上显示图像信息';  
else
end


% --- Executes on button press in flipud.
function flipud_Callback(hObject, eventdata, handles)
% hObject    handle to flipud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flipud
global fig2  movie_param
m2=get(hObject,'Value');
movie_param.flipud=m2;
downandplot(handles,movie_param.shotnum,movie_param.currentnum,0);


% --- Executes during object creation, after setting all properties.
function axes_movie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_movie


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --------------------------------------------------------------------
function panel_ofit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to panel_ofit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function inner_x_Callback(hObject, eventdata, handles)
% hObject    handle to inner_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inner_x as text
%        str2double(get(hObject,'String')) returns contents of inner_x as a double


% --- Executes during object creation, after setting all properties.
function inner_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inner_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
global fig1 current_fig_num img1 img2 img3 img4 RR ZZ shotnum time mystep;
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if mystep
    temp=eval(['img',num2str(current_fig_num)]);
    temp1=flipud(temp);
    eval(['img',num2str(current_fig_num),'=temp1;']);
    figure(fig1);
    mypcolor(fig1,RR,ZZ,temp1);
    if mystep<3
        t0=text(min(RR(:,1))+0.2,1.5,['shot:',num2str(shotnum),'@',num2str(time),'s']);
        set(t0,'Interpreter','latex','color','w','fontsize',20)
    end
    handles.Info_text.String='已对图像进行上下翻转！';
    handles.Info_text.FontSize=18;
else
    handles.Info_text.String='请先下载数据！';
    handles.Info_text.FontSize=18;
end


% --- Executes during object creation, after setting all properties.
function movie_download_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_download (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
