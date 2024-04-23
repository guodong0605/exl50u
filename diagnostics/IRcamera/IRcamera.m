function varargout = IRcamera(varargin)
% IRCAMERA MATLAB code for IRcamera.fig
%      IRCAMERA, by itself, creates a new IRCAMERA or raises the existing
%      singleton*.
%
%      H = IRCAMERA returns the handle to a new IRCAMERA or the handle to
%      the existing singleton*.
%
%      IRCAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IRCAMERA.M with the given input arguments.
%
%      IRCAMERA('Property','Value',...) creates a new IRCAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IRcamera_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IRcamera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IRcamera

% Last Modified by GUIDE v2.5 23-Nov-2021 09:02:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IRcamera_OpeningFcn, ...
                   'gui_OutputFcn',  @IRcamera_OutputFcn, ...
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


% --- Executes just before IRcamera is made visible.
function IRcamera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IRcamera (see VARARGIN)

%----------设置界面显示----------------------------------
global  myparam
guidata(hObject, handles);
filepath = mfilename('fullpath');
filename=mfilename;
IRfilefolder=filepath(1:end-length(filename));
myparam.IRfilefolder=IRfilefolder;
addpath(myparam.IRfilefolder);
ha=axes('units','pixels','pos',[0 0 477 636]);
ii=imread([IRfilefolder,'icon\background.jpg']);
axes(handles.axes1);
imagesc(ii); %OFIT 背景图片设置
colormap_folder=[IRfilefolder,'mycolormap']; %添加colormap资源
addpath(colormap_folder);
Xpixel=186/(93/2);
Ypixel=187/41;

centerX=342;
centerY=240;

myparam.shotnum=3390;
myparam.select_mode='frame';
myparam.position=200;
myparam.disk='\\192.168.20.29\EXL50-Camera\IRC-S2-120';
myparam.Xpixel=Xpixel;
myparam.Ypixel=Ypixel;
myparam.centerX=centerX;
myparam.centerY=centerY;
myparam.t0x=0.1;
myparam.t0y=-0.9;
myparam.isfliph=0;
myparam.default_position=[-0.6 0.8 1.1676 0.4379];
myparam.iscropx=0;
myparam.movie_speed=10;
myparam.movie_start=1;
myparam.movie_end=500;
myparam.movie_dframe=1;
myparam.iscrop=0;
myparam.Isfolder=0;
myparam.style=telops;

myparam.Istimeseries=0;
myparam.selpath=[getenv('UserProfile') '\Desktop'];

% Choose default command line output for IRcamera
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IRcamera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IRcamera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global myparam
myparam.shotnum=str2double(get(hObject,'String')) ;
handles.info_text.String=['已设置当前炮为:',num2str(myparam.shotnum)];
handles.info_text.FontSize=15;
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_time.
function select_time_Callback(hObject, eventdata, handles)
% hObject    handle to select_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_time
global myparam
temp=get(hObject,'Value');
if temp==1
    myparam.select_mode='time';
    set(handles.select_frame,'Value',0);
    handles.info_text.String=['数据选择模式已切换为：Time'];
    handles.info_text.FontSize=15;
else
    myparam.select_mode='frame';
    set(handles.select_frame,'Value',1);  
    handles.info_text.String=['数据选择模式已切换为：Frame'];
    handles.info_text.FontSize=15;
end



% --- Executes on button press in select_frame.
function select_frame_Callback(hObject, eventdata, handles)
% hObject    handle to select_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_frame

global myparam
temp=get(hObject,'Value');
if temp==1
    myparam.select_mode='frame';    
    set(handles.select_time,'Value',0);
    handles.info_text.String=['数据选择模式已切换为：Frame'];
    handles.info_text.FontSize=15;
else
    myparam.select_mode='time';
    set(handles.select_time,'Value',1); 
    handles.info_text.String=['数据选择模式已切换为：Time'];
    handles.info_text.FontSize=15;
end

% --- Executes on button press in back10.
function back10_Callback(hObject, eventdata, handles)
% hObject    handle to back10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam

figure(myparam.fig1);
if myparam.position>=11
myparam.position=myparam.position-10;
temp_data=myparam.IRdata(:,:,myparam.position);
if myparam.isfliph
    temp_data=flip(temp_data,2);
end
fig1=myparam.fig1;
fig1.Children(end).Children(end).CData=temp_data;
myparam.t0.String=['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F'];
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam;

if isempty(myparam.shotnum)
    msgbox('请确保输入正确的路径或炮号');
end

if myparam.Isfolder              %判断是否通过文件夹打开文件
        datafilename=myparam.filepath;
        handles.info_text.String=['正在加载数据，并转换格式中……'];
        handles.info_text.FontSize=15;
        [data, header] = readIRCam(datafilename);
        IRdata = formImage(header(1), data);
        IRdata=IRdata-273.15;
        IRdata=IRdata/0.675;
        time(1)=1/header(1).AcquisitionFrameRate;
        for j=1:size(header,1)
            if j==1
                time(j)=1/header(1).AcquisitionFrameRate;
            else
                time(j)=double((header(j).FrameID-header(1).FrameID))*(1/header(1).AcquisitionFrameRate)+time(1);
            end
        end
        myparam.IRdata=IRdata;
        myparam.time=time;
        myparam.Isfolder=0;    
else

    shotnum_name=[num2str(myparam.shotnum),'.hcc'];
    shotnum_name2=[num2str(myparam.shotnum),'.mat'];    
    cameraPath1='\\192.168.20.29\EXL50-Camera\exl50u\IRC-S2-150';
    shotDate=shotdate(myparam.shotnum);
    cameraPath2=[cameraPath1,'\',num2str(shotDate)];
    if myparam.shotnum<1e4
        shotname=['\0',num2str(myparam.shotnum),'\','0',num2str(myparam.shotnum),'.hcc'];
    else
        shotname=['\',num2str(myparam.shotnum),'\',num2str(myparam.shotnum),'.hcc'];
    end
    cameraPath3=[cameraPath2,shotname];
    try
        handles.info_text.String='数据库中没有.mat格式数据或错误，正在加载hcc格式数据';
        handles.info_text.FontSize=15;
        [data, header] = readIRCam(cameraPath3);
        IRdata = formImage(header(1), data);
        IRdata=IRdata-273.15;
        IRdata=IRdata/0.675;
        time(1)=1/header(1).AcquisitionFrameRate;
        for j=1:size(header,1)
            if j==1
                time(j)=1/header(1).AcquisitionFrameRate;
            else
                time(j)=double((header(j).FrameID-header(1).FrameID))*(1/header(1).AcquisitionFrameRate)+time(1);
            end
        end
        myparam.IRdata=IRdata;
        myparam.time=time;
    catch
        msg=['There is No such a shotnum in database：',num2str(myparam.shotnum)];
        error(msg)
        handles.info_text.String='数据库中没有相关数据，请检查后重试！';
        handles.info_text.FontSize=15;
    end
 

        % datafilename=[temp(index,:).folder,'\',num2str(myparam.shotnum),'.mat'];
        % 
        %  handles.info_text.String=['数据库中有.mat格式数据，正在加载中……'];
        %  handles.info_text.FontSize=15;
        % load(datafilename);
        % myparam.IRdata=IRdata;
        % myparam.time=time;
        % clear IRdata;
  
end
switch myparam.select_mode
    case 'frame'
        if myparam.position>size(myparam.IRdata,3)
            myparam.position=size(myparam.IRdata,3);
            handles.info_text.String=['超出数据限长度，已设置为最大帧数'];
        end
        current_frame=myparam.IRdata(:,:,myparam.position);
    case 'time'
        temp1=abs(myparam.time-myparam.position);
        myparam.position=find(temp1==min(temp1));
        current_frame=myparam.IRdata(:,:,myparam.position);
end
load([myparam.IRfilefolder,'params.mat']);
% xWorldLimits = [-myparam.centerX*myparam.Xpixel/1e3 (size(current_frame,2)-myparam.centerX)*myparam.Xpixel/1e3];
yWorldLimits = [-myparam.centerY*myparam.Ypixel/1e3 (size(current_frame,1)-myparam.centerY)*myparam.Ypixel/1e3];
RA = imref2d(size(current_frame),xWorldLimits,yWorldLimits);
myparam.RA=RA;
fig1=figure;
myparam.fig1=fig1;
set(fig1,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
imshow(current_frame,RA,'DisplayRange',[25 max(max(current_frame))*0.8])
c1=colorbar;
c1.Label.String ='EXL-50 Vacuum Vessel (℃)';
c1.Label.EdgeColor=[1 0 0];
colormap(myparam.style);
myparam.t0=text(RA.XWorldLimits(1)+0.2,RA.YWorldLimits(1)+0.2,['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F']);
set(myparam.t0,'color','w','fontsize',15)
handles.info_text.String=['数据已导入完成'];
handles.info_text.FontSize=15;
myparam.min_value=round(min(min(current_frame)));
myparam.max_value=round(max(max(current_frame)));
handles.min_edit.String=num2str(myparam.min_value);
handles.max_edit.String=num2str(myparam.max_value);



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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam
[file,path] = uigetfile({'*.hcc';'*.mat';},'File Selector');
myparam.filepath=[path,file];
myparam.Isfolder=1;
myparam.shotnum=str2double(path(end-5:end-1));
handles.edit2.String=num2str(myparam.shotnum);
handles.info_text.String=['已设置当前炮为:',num2str(myparam.shotnum)];
handles.info_text.FontSize=15;

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global myparam ;
temp2=cellstr(get(hObject,'String'));
value=get(hObject,'Value') ;
myparam.style=temp2{value};
figure(myparam.fig1);
colormap(myparam.style);
handles.info_text.String=['图像风格已切换为',myparam.style];
handles.info_text.FontSize=20;


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


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in draw_line.
function draw_line_Callback(hObject, eventdata, handles)
% hObject    handle to draw_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam
figure(myparam.fig1);
mydraw = drawline('color','black','SelectedColor','yellow');
myparam.drawposition=mydraw.Position;
myparam.drawtype='line';
addlistener(mydraw,'MovingROI',@allevents2);
addlistener(mydraw,'ROIMoved',@allevents2);


function allevents2(src,evt)
global myparam
myparam.drawposition=src.Position;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function movie_start_Callback(hObject, eventdata, handles)
% hObject    handle to movie_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_start as text
%        str2double(get(hObject,'String')) returns contents of movie_start as a double

global myparam;
switch myparam.select_mode
    case 'frame'
        myparam.movie_start=str2double(get(hObject,'String'));
        handles.info_text.String=['movie 开始帧率已设置为',num2str(myparam.movie_start),'F'];
        handles.info_text.FontSize=15;
    case 'time'
        temp=str2double(get(hObject,'String'));
        dt=myparam.time(2)-myparam.time(1);
        myparam.movie_start=round(temp/dt);
        handles.info_text.String=['movie 开始时间已设置为',num2str(myparam.movie_start),'s'];
        handles.info_text.FontSize=15;
end

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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
global myparam

switch myparam.select_mode
    case 'frame'
        myparam.position=str2double(get(hObject,'String')) ;
        handles.info_text.String=['当前数据帧为:',get(hObject,'String'),'F'];
        handles.info_text.FontSize=15;
    case 'time'
        myparam.position=str2double(get(hObject,'String')) ;
        handles.info_text.String=['已设置当前时刻点:',get(hObject,'String'),'s'];
        handles.info_text.FontSize=15;
end




% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in isfliph.
function isfliph_Callback(hObject, eventdata, handles)
% hObject    handle to isfliph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isfliph
global myparam
myparam.isfliph=get(hObject,'Value');

fig1=myparam.fig1;
temp_data=fig1.Children(2).Children(end).CData;
temp_data_flip=flip(temp_data,2);
fig1.Children(2).Children(end).CData=temp_data_flip;



% --- Executes on button press in ali.
function ali_Callback(hObject, eventdata, handles)
% hObject    handle to ali (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ali
if get(hObject,'Value')
    global myparam
    default_position=[-0.1831 -1.0946 0.3276 2.0094];
    figure(myparam.fig1);
    rect = drawrectangle('Position',default_position,'StripeColor','y','FaceAlpha',0.1,'Label','Center Post');
    myparam.post_rect=rect;
    handles.Info_text.String='请用鼠标拖动矩形框置中心柱区域！，并按回车键结束';
    set(myparam.fig1,'KeyPressFcn',{@replotfigure,handles})
end
function replotfigure(h,~,~)
c=get(h,'CurrentKey');
global myparam
if strcmp(c, 'return')    
    figure(myparam.fig1);
    dshift=myparam.post_rect.Position(1)+myparam.post_rect.Position(3)/2;
   
    ax=myparam.fig1.Children;
    if length(ax)>1
        ax=ax(2);
    end

    switch myparam.select_mode
        case 'frame'
            current_frame=myparam.IRdata(:,:,myparam.position);
        case 'time'
            temp1=abs(myparam.time-myparam.position);
            myparam.position=find(temp1==min(temp1));
            current_frame=myparam.IRdata(:,:,myparam.position);
    end
    
    xWorldLimits = myparam.RA.XWorldLimits-dshift;
    RA = imref2d(size(current_frame),xWorldLimits,myparam.RA.YWorldLimits);
    myparam.RA=RA;
    param_path=[myparam.IRfilefolder,'params.mat'];
    save(param_path,'xWorldLimits');    
    figure(myparam.fig1);
    imshow(current_frame,RA,'DisplayRange',[myparam.min_value myparam.max_value]);
    colormap(myparam.style);
    c1=colorbar;
    c1.Label.String ='EXL-50 Vacuum Vessel (℃)';
    c1.Label.EdgeColor=[1 0 0];
    
    myparam.t0=text(myparam.t0x,myparam.t0y,['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F']);
    set(myparam.t0,'color','w','fontsize',15)
    handles.info_text.String=['数据已导入完成'];
    handles.info_text.FontSize=15;


   
else
    return;
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam
if myparam.Istimeseries            %判断是否是时间序列
    global myparam;
    frm_dframe=str2double(get(handles.edit17,'String'));
    switch myparam.select_mode     %根据时间/帧 定位图像的位置
        case 'frame'
        frm_start=str2double(get(handles.edit16,'String'));
        frm_end=str2double(get(handles.edit20,'String'));        
        case 'time'
        t1=str2double(get(handles.edit16,'String'));
        temp1=abs(myparam.time-t1);
        frm_start=find(temp1==min(temp1));
        t2=str2double(get(handles.edit20,'String'));
        temp2=abs(myparam.time-t2);
        frm_end=find(temp2==min(temp2));
    end
    switch myparam.drawtype
        case 'line'
            lineposition=myparam.drawposition;
            linedata=[];
            jj=1;
            for ff=frm_start:frm_dframe:frm_end
                imgdata=myparam.IRdata(:,:,ff); 
                p1=[lineposition(1,2)  lineposition(2,2)]; p2=[lineposition(1,1)  lineposition(2,1)];
                [cx,cy,linedata(:,jj)]=improfile(myparam.RA.XWorldLimits, myparam.RA.YWorldLimits,imgdata,p2,p1);
                jj=jj+1;
            end
            if myparam.Isplot
                time=myparam.time(frm_start:frm_dframe:frm_end);
                figure;set(gcf,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
                pcolor(time,cx,linedata);shading interp;
                title('Temperature Evolution'); xlabel('Time(s)');ylabel('Position(m)'); colorbar;
                
                figure;set(gcf,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
             
                for i=1:size(linedata,2)
%                     hold on;plot3(time(i)*ones(size(linedata,1),1),cx,smooth(linedata(:,i),3),':o','Color','k','MarkerSize',5,'MarkerFaceColor','red');
                    hold on;plot3(time(i)*ones(size(linedata,1),1),cx,smooth(linedata(:,i),3),'color','k','LineWidth',2.5);
                end
                view(106,20);
                title('Temperature Profile'); xlabel('Time(s)');ylabel('Position(m)');zlabel('Temperature(℃)'); grid on;
            end
            if myparam.Issavedata
                linedata_output=struct;
                linedata_output.position=cx;
                linedata_output.time=time;
                linedata_output.temerature=linedata;
                assignin('base','LineData',linedata_output) ;
            end
            ax=myparam.fig1.Children(end);
            types=get(ax.Children,'Type');
            temp=strcmpi(types, 'images.roi.line');
            delete(ax.Children(find(temp)));
        case 'rect'
            p=myparam.drawposition;
            px1=round((p(1)-myparam.RA.XWorldLimits(1))*1000./myparam.Xpixel);
            px2=round((p(3)+p(1)-myparam.RA.XWorldLimits(1))*1000./myparam.Xpixel);
            py1=round((p(2)-myparam.RA.YWorldLimits(1))*1000./myparam.Ypixel);
            py2=round((p(4)+p(2)-myparam.RA.YWorldLimits(1))*1000./myparam.Ypixel);
            rectdata=myparam.IRdata(py1:py2,px1:px2,frm_start:frm_end);
            if myparam.Isplot
                time=myparam.time(frm_start:frm_dframe:frm_end);
                figure;set(gcf,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
                for i=1:size(rectdata,3)
                    polymax(i)=max(max(rectdata(:,:,i)));
                    polymin(i)=min(min(rectdata(:,:,i)));
                    polymean(i)=mean(mean(rectdata(:,:,i)));
                end
                stackplot({{time,polymax,'Max T(℃)'},{time,polymin,'Min T(℃)'},{time,polymean,'Mean T(℃)'}})
            end
            if myparam.Issavedata
                time=myparam.time(frm_start:frm_dframe:frm_end);
                recrdata_output=struct;
                recrdata_output.position=myparam.drawposition;
                recrdata_output.time=time;
                recrdata_output.temerature=rectdata;
                assignin('base','RectData',recrdata_output) ;
            end
            ax=myparam.fig1.Children(end);
            types=get(ax.Children,'Type');
            temp=strcmpi(types, 'images.roi.rectangle');
            delete(ax.Children(find(temp)));
        case 'poly'
            bw=myparam.bw;
            polydata=myparam.IRdata(:,:,frm_start:frm_end);
            if myparam.Isplot
                time=myparam.time(frm_start:frm_dframe:frm_end);
                figure;set(gcf,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
                for i=1:size(polydata,3)
                    polymax(i)=max(max(polydata(:,:,i).*bw));
                    polymin(i)=min(min(polydata(:,:,i).*bw));
                    polymean(i)=mean(mean(polydata(:,:,i).*bw));
                end
                stackplot({{time,polymax,'Max T(℃)'},{time,polymin,'Min T(℃)'},{time,polymean,'Mean T(℃)'}})
            end
            if myparam.Issavedata
                time=myparam.time(frm_start:frm_dframe:frm_end);
                polydata_output=struct;
                polydata_output.bw=bw;
                polydata_output.time=time;
                polydata_output.temerature=polydata;
                assignin('base','PolytData',polydata_output) ;
            end
            ax=myparam.fig1.Children(end);
            types=get(ax.Children,'Type');
            temp=strcmpi(types, 'images.roi.polygon');
            delete(ax.Children(find(temp)));
        case 'none'

    end

else
    switch myparam.drawtype
        case 'line'
           imgdata=myparam.IRdata(:,:,myparam.position); 
           lineposition=myparam.drawposition;
           p1=[lineposition(1,2)  lineposition(2,2)]; p2=[lineposition(1,1)  lineposition(2,1)];
           [cx,cy,temdata]=improfile(myparam.RA.XWorldLimits, myparam.RA.YWorldLimits,imgdata,p2,p1);
           if myparam.Isplot           
           figure("Color",[1 1 1]);stackplot({{cx,temdata,'T(℃)'}},'LineProfile','Position(m)') 
           end           
           if myparam.Issavedata
           linedata=struct;
           linedata.x=cx;
           linedata.y=cy;
           linedata.temerature=temdata;
           assignin('base','LineData',linedata) ;
           end
            ax=myparam.fig1.Children(end);
            types=get(ax.Children,'Type');
            temp=strcmpi(types, 'images.roi.line');
            delete(ax.Children(find(temp)));
        case 'rect'
            pp=myparam.drawposition;
            crop_x=[pp(1) pp(1)+pp(3)];
            crop_y=[pp(2) pp(2)+pp(4)];
            myparam.cropx=round((crop_x-myparam.RA.XWorldLimits(1))*1000./myparam.Xpixel);
            myparam.cropy=round((crop_y-myparam.RA.YWorldLimits(1))*1000./myparam.Ypixel);
            current_frame=myparam.IRdata(myparam.cropy(1):myparam.cropy(2),myparam.cropx(1):myparam.cropx(2),myparam.position);
            RA2 = imref2d(size(current_frame),crop_x,crop_y);
            if myparam.Isplot
                figure;
                set(gcf,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
                imshow(current_frame,RA2,'DisplayRange',[myparam.min_value myparam.max_value])
                colormap(myparam.style);
                t2=text(RA2.XWorldLimits(1)+0.1,RA2.YWorldLimits(1)+0.1,['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F']);
                set(t2,'color','w','fontsize',10)
                c1=colorbar;
                c1.Label.String ='EXL-50 Vacuum Vessel (℃)';
                c1.Label.EdgeColor=[1 0 0];
            end
            if myparam.Issavedata
                reccdata=struct;
                reccdata.RA=RA2;
                reccdata.temerature=current_frame;
                assignin('base','RectData',reccdata) ;
            end
            ax=myparam.fig1.Children(end);
            types=get(ax.Children,'Type');
            temp=strcmpi(types, 'images.roi.rectangle');
            delete(ax.Children(find(temp)));
        case 'poly'
           current_frame=myparam.IRdata(:,:,myparam.position);
            if myparam.Isplot
                figure;
                set(gcf,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);
                imshow(current_frame.*myparam.bw,myparam.RA,'DisplayRange',[min(min(current_frame)) max(max(current_frame))])
                colormap(myparam.style);
                t2=text(myparam.t0x,myparam.t0y,['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F']);
                set(t2,'color','w','fontsize',15)
                c1=colorbar;
                c1.Label.String ='EXL-50 Vacuum Vessel (℃)';
                c1.Label.EdgeColor=[1 0 0];
            end
            if myparam.Issavedata
                reccdata=struct;
                reccdata.temerature=current_frame.*myparam.bw;
                assignin('base','PolyData',reccdata) ;
            end
            ax=myparam.fig1.Children(end);
            types=get(ax.Children,'Type');
            temp=strcmpi(types, 'images.roi.line');
            delete(ax.Children(find(temp)));


        case 'none'
    end

end


function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function movie_end_Callback(hObject, eventdata, handles)
% hObject    handle to movie_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_end as text
%        str2double(get(hObject,'String')) returns contents of movie_end as a double
global myparam;
switch myparam.select_mode
    case 'frame'
        myparam.movie_end=str2double(get(hObject,'String'));
        
        if myparam.movie_end>size(myparam.IRdata,3)
            myparam.movie_end=size(myparam.IRdata,3);
            handles.info_text.String=['设置的帧数大于总帧数，已自动设置为',num2str(myparam.movie_end),'F'];
        else
            handles.info_text.String=['movie 结束帧率已设置为',num2str(myparam.movie_end),'F'];
        end        
        
    case 'time'
        temp=str2double(get(hObject,'String'));
        temp1=abs(myparam.time-temp);
        myparam.movie_end=find(temp1==min(temp1));
        current_frame=myparam.IRdata(:,:,myparam.position);
        
        dt=myparam.time(2)-myparam.time(1);
        myparam.movie_end=round(temp/dt);
        handles.info_text.String=['movie 结束时间已设置为',num2str(myparam.movie_end),'s'];
end


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


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam;
if ~myparam.iscrop 
    mp4filename=[myparam.selpath,'\',num2str(myparam.shotnum)];
else
    mp4filename=[myparam.selpath,'\',num2str(myparam.shotnum),'_Crop'];
end
v = VideoWriter(mp4filename,'MPEG-4');
v.FrameRate=myparam.movie_speed;
open (v);

fig2=figure;
set(fig2,'color',[1 1 1 ],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.4,0.5]);

if ~myparam.iscrop % 看是否要对图像进行剪切处理
    current_frame=myparam.IRdata(:,:,myparam.position);
    imshow(current_frame,myparam.RA,'DisplayRange',[myparam.min_value myparam.max_value]);
    colormap(myparam.style);
    t1=text(myparam.t0x,myparam.t0y,['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F']);
    
    set(t1,'color','w','fontsize',15)
    c1=colorbar;
    c1.Label.String ='EXL-50 Vacuum Vessel (℃)';
    c1.Label.EdgeColor=[1 0 0];
else
    current_frame=myparam.IRdata(myparam.cropy(1):myparam.cropy(2),myparam.cropx(1):myparam.cropx(2),myparam.position);
    imshow(current_frame,myparam.RA2,'DisplayRange',[myparam.min_value myparam.max_value]);
    c1=colorbar;
    colormap(myparam.style);
    t1=text(myparam.RA2.XWorldLimits(1)+0.1,myparam.RA2.YWorldLimits(1)+0.2,['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F']);
    set(t1,'Interpreter','tex','color','y','fontsize',10)
    c1.Label.String ='T(℃)';
    c1.Label.EdgeColor=[1 0 0];
end

for i=myparam.movie_start:myparam.movie_dframe:myparam.movie_end

    if ~myparam.iscrop
        temp_data=myparam.IRdata(:,:,i);
    else
        temp_data=myparam.IRdata(myparam.cropy(1):myparam.cropy(2),myparam.cropx(1):myparam.cropx(2),i);
    end

    if myparam.isfliph
        temp_data=flip(temp_data,2);
    end
    fig2.Children(2).Children(end).CData=temp_data;
    t1.String=['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(i)),'s','#',num2str(i),'F'];
    
    current_frame = getframe(gcf);
    writeVideo(v,current_frame)
end
figure(myparam.fig1);
ax=myparam.fig1.Children(end);
types=get(ax.Children,'Type');
temp=strcmpi(types, 'images.roi.rectangle');
delete(ax.Children(find(temp)));
myparam.iscrop=0;


% --- Executes on button press in draw_save.
function draw_save_Callback(hObject, eventdata, handles)
% hObject    handle to draw_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of draw_save
global myparam;
myparam.Issavedata=get(hObject,'Value');

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in draw_plot.
function draw_plot_Callback(hObject, eventdata, handles)
% hObject    handle to draw_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of draw_plot
global myparam;
myparam.Isplot=get(hObject,'Value');

% --- Executes on button press in draw_rect.
function draw_rect_Callback(hObject, eventdata, handles)
% hObject    handle to draw_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam
figure(myparam.fig1);
mydraw = drawrectangle('color','black','SelectedColor','yellow');
myparam.drawposition=mydraw.Position;
myparam.drawtype='rect';
addlistener(mydraw,'MovingROI',@allevents3);
addlistener(mydraw,'ROIMoved',@allevents3);


function allevents3(src,evt)
global myparam
myparam.drawposition=src.Position;

% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton24


% --- Executes on button press in back1.
function back1_Callback(hObject, eventdata, handles)
% hObject    handle to back1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam

figure(myparam.fig1);
if myparam.position>=2
myparam.position=myparam.position-1;
temp_data=myparam.IRdata(:,:,myparam.position);
if myparam.isfliph
    temp_data=flip(temp_data,2);
end
fig1=myparam.fig1;
fig1.Children(end).Children(end).CData=temp_data;
myparam.t0.String=['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F'];
else
end

% --- Executes on button press in forward1.
function forward1_Callback(hObject, eventdata, handles)
% hObject    handle to forward1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam

figure(myparam.fig1);
if myparam.position<size(myparam.IRdata,3)
myparam.position=myparam.position+1;
temp_data=myparam.IRdata(:,:,myparam.position);
if myparam.isfliph
    temp_data=flip(temp_data,2);
end
fig1=myparam.fig1;
fig1.Children(end).Children(end).CData=temp_data;
myparam.t0.String=['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F'];
else
end

% --- Executes on button press in forward10.
function forward10_Callback(hObject, eventdata, handles)
% hObject    handle to forward10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam

figure(myparam.fig1);
if myparam.position<size(myparam.IRdata,3)-10
myparam.position=myparam.position+10;
temp_data=myparam.IRdata(:,:,myparam.position);
if myparam.isfliph
    temp_data=flip(temp_data,2);
end
fig1=myparam.fig1;
fig1.Children(end).Children(end).CData=temp_data;
myparam.t0.String=['shot:',num2str(myparam.shotnum),'@',num2str(myparam.time(myparam.position)),'s','#',num2str(myparam.position),'F'];
else
end
% --- Executes on button press in setpath.
function setpath_Callback(hObject, eventdata, handles)
% hObject    handle to setpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam;
myparam.selpath = uigetdir;


% --- Executes on button press in imgcrop.
function imgcrop_Callback(hObject, eventdata, handles)
% hObject    handle to imgcrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myparam;
figure(myparam.fig1);
rect = drawrectangle('StripeColor','r','FaceAlpha',0.1,'Label','Center Post');
crop_x=[rect.Position(1) rect.Position(1)+rect.Position(3)];
crop_y=[rect.Position(2) rect.Position(2)+rect.Position(4)];
myparam.iscrop=1;
myparam.cropx=round((crop_x-myparam.RA.XWorldLimits(1))*1000./myparam.Xpixel);
myparam.cropy=round((crop_y-myparam.RA.YWorldLimits(1))*1000./myparam.Ypixel);
current_frame=myparam.IRdata(myparam.cropy(1):myparam.cropy(2),myparam.cropx(1):myparam.cropx(2),myparam.position);    
RA2 = imref2d(size(current_frame),crop_x,crop_y);
myparam.RA2=RA2;
addlistener(rect,'MovingROI',@allevents1);
addlistener(rect,'ROIMoved',@allevents1);


function allevents1(src,evt)
global myparam
    crop_x=[src.Position(1) src.Position(1)+src.Position(3)];
    crop_y=[src.Position(2) src.Position(2)+src.Position(4)];
    myparam.cropx=round((crop_x-myparam.RA.XWorldLimits(1))*1000./myparam.Xpixel);
    myparam.cropy=round((crop_y-myparam.RA.YWorldLimits(1))*1000./myparam.Ypixel);
    current_frame=myparam.IRdata(myparam.cropy(1):myparam.cropy(2),myparam.cropx(1):myparam.cropx(2),myparam.position);
    RA2 = imref2d(size(current_frame),crop_x,crop_y);
    myparam.RA2=RA2;




% --- Executes on button press in draw_statistic.
function draw_statistic_Callback(hObject, eventdata, handles)
% hObject    handle to draw_statistic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of draw_statistic


% --- Executes on button press in Istimeseries.
function Istimeseries_Callback(hObject, eventdata, handles)
% hObject    handle to Istimeseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Istimeseries
global myparam
myparam.Istimeseries=get(hObject,'Value');
if myparam.Istimeseries
    handles.edit16.ForegroundColor=[1 1 1];
    handles.edit17.ForegroundColor=[1 1 1];
    handles.edit20.ForegroundColor=[1 1 1];
else
    handles.edit16.ForegroundColor=[0.3 0.3 0.3];
    handles.edit17.ForegroundColor=[0.3 0.3 0.3];
    handles.edit20.ForegroundColor=[0.3 0.3 0.3];
end


% --- Executes on button press in draw_poly.
function draw_poly_Callback(hObject, eventdata, handles)
% hObject    handle to draw_poly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  myparam
figure(myparam.fig1);
mydraw = drawpolygon('color','black','SelectedColor','yellow');
myparam.bw=mydraw.createMask();
myparam.drawtype='poly';
addlistener(mydraw,'MovingROI',@allevents4);
addlistener(mydraw,'ROIMoved',@allevents4);


function allevents4(src,evt)
global myparam
myparam.drawposition=src.Position;


function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function back10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\back10.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function back1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\back1.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function forward1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to forward1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\forward1.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function forward10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to forward10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\forward10.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;



function movie_dt_Callback(hObject, eventdata, handles)
% hObject    handle to movie_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_dt as text
%        str2double(get(hObject,'String')) returns contents of movie_dt as a double

global myparam;
myparam.movie_dframe=str2double(get(hObject,'String'));

handles.info_text.String=['制作Movie的帧间隔已设置为',num2str(myparam.movie_dframe),'F'];
handles.info_text.FontSize=15;

% --- Executes during object creation, after setting all properties.
function movie_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function movie_speed_Callback(hObject, eventdata, handles)
% hObject    handle to movie_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_speed as text
%        str2double(get(hObject,'String')) returns contents of movie_speed as a double


global myparam;
myparam.movie_speed=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function movie_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function draw_poly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to draw_poly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\drawpolygon.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function draw_rect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to draw_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\drawrect.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function draw_line_CreateFcn(hObject, eventdata, handles)
% hObject    handle to draw_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\drawline.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function pushbutton6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\openfolder.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function setpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\save.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes during object creation, after setting all properties.
function imgcrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgcrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global IRfilefolder 
back10_img = imread([IRfilefolder,'icon\crop.jpg']);   %读取图片
img_scale=size(back10_img,1)/hObject.Position(4);
temp=imresize(back10_img,1/img_scale);
hObject.CData=temp;


% --- Executes on slider movement.
function slide_max_Callback(hObject, eventdata, handles)
% hObject    handle to slide_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global myparam
cmin_value=handles.slide_min.Value;
cmax_value=handles.slide_max.Value;
m1=max(cmin_value+1,cmax_value);
handles.min_edit_String=num2str(m1);
figure(myparam.fig1);
caxis([cmin_value,m1]);
myparam.cmax=m1;
handles.info_text.String=['图像中温度最大值已设置为:',num2str(m1)];
handles.info_text.FontSize=15;

% --- Executes during object creation, after setting all properties.
function slide_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


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


% --- Executes on button press in radiobutton25.
function radiobutton25_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton25
global myparam
m2=get(hObject,'Value');
if m2
    figure(myparam.fig1);
    t0=text(myparam.RA.XWorldLimits(1)+0.2,myparam.RA.YWorldLimits(2)-0.2,['Total:',num2str(size(myparam.IRdata,3)),'F']);
    set(t0,'Interpreter','tex','color','y','fontsize',15)
    t0=text(myparam.RA.XWorldLimits(1)+0.2,myparam.RA.YWorldLimits(2)-0.3,['Fs=',num2str(1/(myparam.time(3)-myparam.time(2))),'  Frame/s']);
    set(t0,'Interpreter','tex','color','y','fontsize',15)
else
end

% --- Executes on slider movement.
function slide_min_Callback(hObject, eventdata, handles)
% hObject    handle to slide_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global myparam
cmin_value=handles.slide_min.Value;
cmax_value=handles.slide_max.Value;
m1=min(cmin_value,cmax_value);
setmin=(myparam.max_value-myparam.min_value)*m1+myparam.min_value;
handles.min_edit.String=num2str(setmin);

figure(myparam.fig1);
caxis([m1,cmax_value]);
myparam.min_value=setmin;
handles.info_text.String=['图像中温度最小值已设置为:',num2str(setmin)];
handles.info_text.FontSize=15;

% --- Executes during object creation, after setting all properties.
function slide_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_edit as text
%        str2double(get(hObject,'String')) returns contents of min_edit as a double
global myparam
myparam.min_value=str2double(get(hObject,'String'));
figure(myparam.fig1);
caxis([myparam.min_value myparam.max_value]);

% --- Executes during object creation, after setting all properties.
function min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_edit as text
%        str2double(get(hObject,'String')) returns contents of max_edit as a double
global myparam
myparam.max_value=str2double(get(hObject,'String'));
figure(myparam.fig1);
caxis([myparam.min_value myparam.max_value]);


% --- Executes during object creation, after setting all properties.
function max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_edit as text
%        str2double(get(hObject,'String')) returns contents of min_edit as a double
global myparam
cmin_value=handles.slide_min.Value;
cmax_value=handles.slide_max.Value;
m1=min(cmin_value,cmax_value-1);
handles.min_edit_String=num2str(m1);
figure(myparam.fig1);
caxis([m1,cmax_value]);
myparam.cmin=m1;
handles.info_text.String=['图像中温度最小值已设置为:',num2str(m1)];
handles.info_text.FontSize=15;

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_edit as text
%        str2double(get(hObject,'String')) returns contents of max_edit as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
