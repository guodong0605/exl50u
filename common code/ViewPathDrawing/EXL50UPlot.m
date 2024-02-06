function varargout = EXL50UPlot(varargin)
% EXL50UPLOT MATLAB code for EXL50UPlot.fig
%      EXL50UPLOT, by itself, creates a new EXL50UPLOT or raises the existing
%      singleton*.
%
%      H = EXL50UPLOT returns the handle to a new EXL50UPLOT or the handle to
%      the existing singleton*.
%
%      EXL50UPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXL50UPLOT.M with the given input arguments.
%
%      EXL50UPLOT('Property','Value',...) creates a new EXL50UPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EXL50UPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EXL50UPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EXL50UPlot

% Last Modified by GUIDE v2.5 29-Jul-2023 11:32:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EXL50UPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @EXL50UPlot_OutputFcn, ...
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


% --- Executes just before EXL50UPlot is made visible.
function EXL50UPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EXL50UPlot (see VARARGIN)

% Choose default command line output for EXL50UPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EXL50UPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global  plotParam
guidata(hObject, handles);
filepath = mfilename('fullpath');
filename=mfilename;
thisfilefolder=filepath(1:end-length(filename));
addpath(thisfilefolder)
plotParam.filefolder=thisfilefolder;
addpath(plotParam.filefolder);
ha=axes('units','pixels','pos',[0 0 460 500]);
ii=imread([thisfilefolder,'background.jpg']);
imagesc(ii); %OFIT 背景图片设置
plotParam.havedraw=0;
plotParam.degree=0;
plotParam.window='S2';
plotParam.dr=100;
plotParam.dz=0;
plotParam.dx=0;
plotParam.plasmaShape=2;
plotParam.lineR=250;
plotParam.ptheta1=-35;
plotParam.ptheta2=35;
plotParam.plinenum=10;
plotParam.ttheta1=-30;
plotParam.ttheta2=30;
plotParam.tlinenum=5;
plotParam.linewidth=2;
plotParam.linecolor=[1,1,1];
plotParam.pointsize=8;
plotParam.pointcolor=[0,1,0];
plotParam.protate=0;
plotParam.trotate=0;
plotParam.vv_plot=1;
plotParam.flange_plot=1;
plotParam.tf_plot=1;
plotParam.pf_plot=1;
plotParam.plasma_plot=1;
plotParam.probe_plot=0;
plotParam.filepath1=[thisfilefolder,'EXL-50U plasma .xlsx'];
plotParam.filepath2=[thisfilefolder,'EXL50U magnetic data.xlsx'];
plotParam.infopath=[plotParam.filefolder,'info'];
plotParam.plasmaShape=2;
plotParam.currentAxes=1;
plotParam.ismodify=0;
% --- Outputs from this function are returned to the command line.
function varargout = EXL50UPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in window.
function window_Callback(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns window contents as cell array
%        contents{get(hObject,'Value')} returns selected item from window
global plotParam
temp=get(hObject,'Value');
switch temp
    case 1
        plotParam.window='S1';
    case 2
        plotParam.window='S2';
    case 3
        plotParam.window='S3';
    case 4
        plotParam.window='U1';
    case 5
        plotParam.window='U2';
    case 6
        plotParam.window='L1';
    case 7
        plotParam.window='L2';
end


% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',2)


function dr_Callback(hObject, eventdata, handles)
% hObject    handle to dr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dr as text
%        str2double(get(hObject,'String')) returns contents of dr as a double
global plotParam
plotParam.dr=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function dr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in diaglist.
function diaglist_Callback(hObject, eventdata, handles)
% hObject    handle to diaglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diaglist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diaglist


% --- Executes during object creation, after setting all properties.
function diaglist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diaglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
global plotParam
filepath = mfilename('fullpath');
filename=mfilename;
thisfilefolder=filepath(1:end-length(filename));
addpath(thisfilefolder)
plotParam.filefolder=thisfilefolder;
plotParam.infopath=[plotParam.filefolder,'info'];

mat_files = dir(fullfile(plotParam.infopath, '*.mat'));
namelist={mat_files.name};
set(hObject, 'String', namelist);






% --- Executes on selection change in degree.
function degree_Callback(hObject, eventdata, handles)
% hObject    handle to degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns degree contents as cell array
%        contents{get(hObject,'Value')} returns selected item from degree
global plotParam
temp=get(hObject,'Value');
plotParam.degree=temp*30;

% --- Executes during object creation, after setting all properties.
function degree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ptheta1_Callback(hObject, eventdata, handles)
% hObject    handle to ptheta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ptheta1 as text
%        str2double(get(hObject,'String')) returns contents of ptheta1 as a double
global plotParam
plotParam.ptheta1=str2double(get(hObject,'String'));

if plotParam.havedraw && ~plotParam.ismodify
    axes(plotParam.a1)
    for i=1:length(plotParam.lines)
        patches = plotParam.lines{i};
        delete(patches);
    end

    crossPoints= viewlines(plotParam.window,[plotParam.x,plotParam.z],plotParam.ptheta1,plotParam.ptheta2,plotParam.plinenum,plotParam.lineR);
    clear plotParam.lines
    for i=1:size(crossPoints,1)
        hold on;
        plotParam.lines{i}=plot([plotParam.x/1e3,crossPoints(i,1)/1e3],[plotParam.z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g') ;
    end
    plotParam.px_handle.String=['(',num2str(round(plotParam.ptheta1,1)),'$^\circ$',' ',num2str(round(plotParam.ptheta2,1)),'$^\circ$',')'];
    plotParam.poloidalPoints=crossPoints;
end




% --- Executes during object creation, after setting all properties.
function ptheta1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ptheta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plinenum_Callback(hObject, eventdata, handles)
% hObject    handle to plinenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plinenum as text
%        str2double(get(hObject,'String')) returns contents of plinenum as a double
global plotParam
plotParam.plinenum=str2double(get(hObject,'String'));
if plotParam.havedraw && ~plotParam.ismodify
    axes(plotParam.a1)
    for i=1:length(plotParam.lines)
        patches = plotParam.lines{i};
        delete(patches);
    end

    crossPoints= viewlines(plotParam.window,[plotParam.x,plotParam.z],plotParam.ptheta1,plotParam.ptheta2,plotParam.plinenum,plotParam.lineR);
    clear plotParam.lines
    for i=1:size(crossPoints,1)
        hold on;
        plotParam.lines{i}=plot([plotParam.x/1e3,crossPoints(i,1)/1e3],[plotParam.z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g') ;
    end
    plotParam.poloidalPoints=crossPoints;
end

% --- Executes during object creation, after setting all properties.
function plinenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plinenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ptheta2_Callback(hObject, eventdata, handles)
% hObject    handle to ptheta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ptheta2 as text
%        str2double(get(hObject,'String')) returns contents of ptheta2 as a double

global plotParam
plotParam.ptheta2=str2double(get(hObject,'String'));
if plotParam.havedraw && ~plotParam.ismodify
    axes(plotParam.a1)
    for i=1:length(plotParam.lines)
        patches = plotParam.lines{i};
        delete(patches);
    end

    crossPoints= viewlines(plotParam.window,[plotParam.x,plotParam.z],plotParam.ptheta1,plotParam.ptheta2,plotParam.plinenum,plotParam.lineR);
    clear plotParam.lines
    for i=1:size(crossPoints,1)
        hold on;
        plotParam.lines{i}=plot([plotParam.x/1e3,crossPoints(i,1)/1e3],[plotParam.z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g') ;
    end
    plotParam.px_handle.String=['(',num2str(round(plotParam.ptheta1,1)),'$^\circ$',' ',num2str(round(plotParam.ptheta2,1)),'$^\circ$',')'];
    plotParam.poloidalPoints=crossPoints;

end


% --- Executes during object creation, after setting all properties.
function ptheta2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ptheta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tlinenum_Callback(hObject, eventdata, handles)
% hObject    handle to tlinenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tlinenum as text
%        str2double(get(hObject,'String')) returns contents of tlinenum as a double
global plotParam
plotParam.tlinenum=str2double(get(hObject,'String'));
if plotParam.havedraw && ~plotParam.ismodify
    for i=1:length(plotParam.toroidalLine)
        patches = plotParam.toroidalLine{i};
        delete(patches);
    end
    txt=plotParam.torodialtext;
    delete(txt);
    axes(plotParam.a2)
    [plotParam.toroidalLine,plotParam.torodialtext,toroidalPoints]=drawToroidalLine(plotParam.x,plotParam.angle,plotParam.ttheta1,plotParam.ttheta2,plotParam.tlinenum);
    plotParam.toroidalPoints=toroidalPoints;
end




% --- Executes during object creation, after setting all properties.
function tlinenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tlinenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function trotate_Callback(hObject, eventdata, handles)
% hObject    handle to trotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global plotParam
plotParam.trotate=(get(hObject,'Value')-0.5)*90;

for i=1:length(plotParam.toroidalLine)
    patches = plotParam.toroidalLine{i};
    delete(patches);
end
txt=plotParam.torodialtext;
delete(txt);
axes(plotParam.a2)
[plotParam.toroidalLine,plotParam.torodialtext,toroidalPoints]=drawToroidalLine(plotParam.x,plotParam.angle,plotParam.ttheta1+plotParam.trotate,plotParam.ttheta2+plotParam.trotate,plotParam.tlinenum);
plotParam.toroidalPoints=toroidalPoints;




% --- Executes during object creation, after setting all properties.
function trotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',0.5)

% --- Executes on slider movement.
function protate_Callback(hObject, eventdata, handles)
% hObject    handle to protate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global plotParam
plotParam.protate=(get(hObject,'Value')-0.5)*90;

axes(plotParam.a1)
for i=1:length(plotParam.lines)
    patches = plotParam.lines{i};
    delete(patches);
end

crossPoints= viewlines(plotParam.window,[plotParam.x,plotParam.z],plotParam.ptheta1+plotParam.protate,plotParam.ptheta2+plotParam.protate,plotParam.plinenum,plotParam.lineR);
clear plotParam.lines
for i=1:size(crossPoints,1)
    hold on;    
    plotParam.lines{i}=plot([plotParam.x/1e3,crossPoints(i,1)/1e3],[plotParam.z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g') ;  
end
plotParam.px_handle.String=['(',num2str(round(plotParam.ptheta1+plotParam.protate,1)),'$^\circ$',' ',num2str(round(plotParam.ptheta2+plotParam.protate,1)),'$^\circ$',')'];
plotParam.poloidalPoints=crossPoints;


% --- Executes during object creation, after setting all properties.
function protate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',0.5)

% --- Executes on button press in loadParam.
function loadParam_Callback(hObject, eventdata, handles)
% hObject    handle to loadParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotParam
file_names = get(handles.diaglist, 'String');
index = get(handles.diaglist, 'Value');
file_name = file_names{index};
file_path = fullfile(plotParam.infopath, file_name);

% 加载.mat文件中的数据
load(file_path);
handles.degree.Value=plotParam.degree/30+1;
temp=strfind(handles.window.String,plotParam.window);
nonempty_cells = temp(~cellfun(@isempty, temp));
handles.window.Value=cell2num(nonempty_cells);
handles.dr.String=plotParam.dr;
handles.dz.String=plotParam.dz;
handles.dx.String=plotParam.dx;
handles.ptheta1.String=plotParam.ptheta1;
handles.ptheta2.String=plotParam.ptheta2;
handles.plinenum.String=plotParam.plinenum;
handles.ttheta1.String=plotParam.ttheta1;
handles.ttheta2.String=plotParam.ttheta2;
handles.tlinenum.String=plotParam.tlinenum;
handles.lineR.String=plotParam.lineR;
handles.plasmaShape.String=plotParam.plasmaShape;









% --- Executes on button press in saveParam.
function saveParam_Callback(hObject, eventdata, handles)
% hObject    handle to saveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotParam
[file_name, path_name] = uiputfile('*.mat', 'Save data as', plotParam.infopath);

% 如果用户取消了保存操作，则返回
if isequal(file_name, 0) || isequal(path_name, 0)
    return;
end

% 构造完整的文件路径
file_path = fullfile(path_name, file_name);

% 保存数据到文件中
save(file_path, "plotParam")

mat_files = dir(fullfile(plotParam.infopath, '*.mat'));
namelist={mat_files.name};
set(handles.diaglist, 'String', namelist);






function dz_Callback(hObject, eventdata, handles)
% hObject    handle to dz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dz as text
%        str2double(get(hObject,'String')) returns contents of dz as a double
global plotParam
plotParam.dz=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function dz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dx_Callback(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx as text
%        str2double(get(hObject,'String')) returns contents of dx as a double
global plotParam
plotParam.dx=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drawvv.
function drawvv_Callback(hObject, eventdata, handles)
% hObject    handle to drawvv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawvv
global plotParam

if plotParam.havedraw
    if get(hObject,'Value')
        if ~plotParam.vv_plot
            axes(plotParam.a1)
            plotParam.vv_handle=drawVacuumVessel;

            for i=1:length(plotParam.vv_handle)
                patches = plotParam.vv_handle{end-i+1};
                setlayer(patches,inf);
            end

            plotParam.vv_plot=1;
        end
    else
        axes(plotParam.a1)
        for i=1:length(plotParam.vv_handle)
            patches = plotParam.vv_handle{i};
            delete(patches);
        end
        plotParam.vv_plot=0;
    end
else
    plotParam.vv_plot=get(hObject,'Value');
end

% --- Executes on button press in drawflange.
function drawflange_Callback(hObject, eventdata, handles)
% hObject    handle to drawflange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawflange
global plotParam

if plotParam.havedraw
    if get(hObject,'Value')
        if ~plotParam.flange_plot
            axes(plotParam.a1)
            plotParam.flange_handle=DrawFlange(plotParam.filepath2,plotParam.degree);
            plotParam.flange_plot=1;
        end
    else
        axes(plotParam.a1)
        for i=1:length(plotParam.flange_handle)
            patches = plotParam.flange_handle{i};
            delete(patches);
        end
        plotParam.flange_plot=0;
    end
else
    plotParam.flange_plot=get(hObject,'Value');
end
% --- Executes on button press in drawtf.
function drawtf_Callback(hObject, eventdata, handles)
% hObject    handle to drawtf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawtf
global plotParam

if plotParam.havedraw
    if get(hObject,'Value')
        if ~plotParam.tf_plot
            axes(plotParam.a1)
            plotParam.tf_handle=DrawTF(plotParam.filepath2);
            setlayer(plotParam.tf_handle,inf)
            plotParam.tf_plot=1;
        end
    else
        axes(plotParam.a1)
        for i=1:length(plotParam.tf_handle)
            patches = plotParam.tf_handle;
            delete(patches);
        end
        plotParam.tf_plot=0;
    end
else
    plotParam.tf_plot=get(hObject,'Value');
end
% --- Executes on button press in drawpf.
function drawpf_Callback(hObject, eventdata, handles)
% hObject    handle to drawpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawpf
global plotParam

if plotParam.havedraw
    if get(hObject,'Value')
        if ~plotParam.pf_plot
            axes(plotParam.a1)
            [plotParam.pf_handle,plotParam.PFtext_handle]=DrawPF(plotParam.filepath2);
            plotParam.pf_plot=1;
        end
    else
        axes(plotParam.a1)
        for i=1:length(plotParam.pf_handle)
            patches = plotParam.pf_handle{i};
            delete(patches);
            temp = plotParam.PFtext_handle{i};
            delete(temp);

        end
        plotParam.pf_plot=0;
    end
else
    plotParam.pf_plot=get(hObject,'Value');
end
% --- Executes on button press in drawmp.
function drawmp_Callback(hObject, eventdata, handles)
% hObject    handle to drawmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawmp

global plotParam
if plotParam.havedraw
    if get(hObject,'Value')  %按下选择按钮
        if ~plotParam.probe_plot   %如果a1上面没有磁探针的绘图，那么开始画
            axes(plotParam.a1)
            plotParam.probe_handle=DrawMagneticProbe(plotParam.filepath2);
            plotParam.probe_plot=1;
        end
    else
        axes(plotParam.a1)
        for i=1:length(plotParam.probe_handle)
            patches = plotParam.probe_handle{i};
            delete(patches);
        end
        plotParam.probe_plot=0;
    end
else
    plotParam.probe_plot=get(hObject,'Value');
end

function ttheta1_Callback(hObject, eventdata, handles)
% hObject    handle to ttheta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttheta1 as text
%        str2double(get(hObject,'String')) returns contents of ttheta1 as a double
global plotParam
plotParam.ttheta1=str2double(get(hObject,'String'));
if plotParam.havedraw && ~plotParam.ismodify
    for i=1:length(plotParam.toroidalLine)
        patches = plotParam.toroidalLine{i};
        delete(patches);
    end
    txt=plotParam.torodialtext;
    delete(txt);
    axes(plotParam.a2)
    [plotParam.toroidalLine,plotParam.torodialtext,toroidalPoints]=drawToroidalLine(plotParam.x,plotParam.angle,plotParam.ttheta1,plotParam.ttheta2,plotParam.tlinenum);
    plotParam.toroidalPoints=toroidalPoints;
end

% --- Executes during object creation, after setting all properties.
function ttheta1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttheta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ttheta2_Callback(hObject, eventdata, handles)
% hObject    handle to ttheta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttheta2 as text
%        str2double(get(hObject,'String')) returns contents of ttheta2 as a double
global plotParam
plotParam.ttheta2=str2double(get(hObject,'String'));
if plotParam.havedraw && ~plotParam.ismodify
    for i=1:length(plotParam.toroidalLine)
        patches = plotParam.toroidalLine{i};
        delete(patches);
    end
    txt=plotParam.torodialtext;
    delete(txt);
    axes(plotParam.a2)
    [plotParam.toroidalLine,plotParam.torodialtext,toroidalPoints]=drawToroidalLine(plotParam.x,plotParam.angle,plotParam.ttheta1,plotParam.ttheta2,plotParam.tlinenum);
    plotParam.toroidalPoints=toroidalPoints;
end



% --- Executes during object creation, after setting all properties.
function ttheta2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttheta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outputdata.
function outputdata_Callback(hObject, eventdata, handles)
% hObject    handle to outputdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotParam
toroidal_points = plotParam.toroidalPoints;
poloidal_points = plotParam.poloidalPoints;

% 将数据输出到工作空间中
assignin('base', 'toroidal_points', toroidal_points);
assignin('base', 'poloidal_points', poloidal_points);

% --- Executes on button press in confirm.
function confirm_Callback(hObject, eventdata, handles)
% hObject    handle to confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotParam
figure('color',[1,1,1],'unit','normalized','DefaultAxesFontSize',14,'DefaultAxesFontWeight','bold','DefaultAxesLineWidth',1.5,'position',[0.1,0.1,0.5,0.6])
plotParam.a1=subplot(1,2,1,'Box','on');
if plotParam.vv_plot
    plotParam.vv_handle=drawVacuumVessel;
end
if plotParam.tf_plot
    plotParam.tf_handle=DrawTF(plotParam.filepath2);
end
if plotParam.pf_plot
    [plotParam.pf_handle,plotParam.PFtext_handle]=DrawPF(plotParam.filepath2);
end
if plotParam.plasma_plot
    [plotParam.plasma_handle,plotParam.plasmaR]=drawPlasma(plotParam.filepath1,'EXL-50U',plotParam.plasmaShape);
end
if plotParam.flange_plot
    plotParam.flange_handle=DrawFlange(plotParam.filepath2,plotParam.degree);
end
if plotParam.probe_plot
    plotParam.probe_handle=DrawMagneticProbe(plotParam.filepath2);
end
title('Poloidal View' );
axis equal;
xlim([-0.1,2.5]);
ylim([-2.5,2.5])
%----------------------------------------------------
[x,z,dtheta]=viewpoint(plotParam.window,plotParam.dr,plotParam.dz,plotParam.dx);
plotParam.x=x;
plotParam.z=z;
plotParam.dtheta=dtheta;

crossPoints= viewlines(plotParam.window,[x,z],plotParam.ptheta1,plotParam.ptheta2,plotParam.plinenum,plotParam.lineR);
for i=1:size(crossPoints,1)
    hold on;    
    plotParam.lines{i}=plot([x/1e3,crossPoints(i,1)/1e3],[z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g') ;  
end
plotParam.px_handle=text(x/1e3+0.04,z/1e3,['(',num2str(plotParam.ptheta1),'$^\circ$',' ',num2str(plotParam.ptheta2),'$^\circ$',')']);
set(plotParam.px_handle,'interpreter','Latex','FontSize',14,'Color','b','FontWeight','bold')

plotParam.havedraw=1; %表明已经生成了坐标，已经画图了
%-----------------------------toroidal Plot------------------------
plotParam.a2=subplot(1,2,2,'Box','on');
plotParam.angle=plotParam.degree+dtheta;
exl50uToroidalPlot(x,plotParam.angle)
title('Toloidal View') ;
cneteriod_radii=0.25;
plotParam.plasma_handle2=rectangle('position',[-plotParam.plasmaR,-plotParam.plasmaR,plotParam.plasmaR*2,plotParam.plasmaR*2], 'Curvature',[1,1], 'FaceColor',[0.65	0.035	0.96	0.1]) ;      % 画出中心柱圆形框，填充黑色
rectangle('position',[-cneteriod_radii,-cneteriod_radii,(cneteriod_radii)*2,(cneteriod_radii)*2],...
   'Curvature',[1,1], 'FaceColor',[0.7 0.7 0.7],'EdgeColor','k','LineWidth',2)       % 画出中心柱圆形框，填充黑色
[plotParam.toroidalLine,plotParam.torodialtext,toroidalPoints]=drawToroidalLine(plotParam.x,plotParam.angle,plotParam.ttheta1,plotParam.ttheta2,plotParam.tlinenum);

plotParam.toroidalPoints=toroidalPoints;
plotParam.poloidalPoints=crossPoints;

% --- Executes on button press in addnew.
function addnew_Callback(hObject, eventdata, handles)
% hObject    handle to addnew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotParam
if plotParam.havedraw && plotParam.ismodify
    [x,z,dtheta]=viewpoint(plotParam.window,plotParam.dr,plotParam.dz,plotParam.dx);
    plotParam.x=x;
    plotParam.z=z;
    plotParam.dtheta=dtheta;
    if plotParam.currentAxes==1
        axes(plotParam.a1)
        crossPoints= viewlines(plotParam.window,[x,z],plotParam.ptheta1,plotParam.ptheta2,plotParam.plinenum,plotParam.lineR);
        %-------------------------------------------------
        for i=1:size(crossPoints,1)
            hold on;
            plotParam.lines{i}=plot([x/1e3,crossPoints(i,1)/1e3],[z/1e3,crossPoints(i,2)/1e3],'--ko','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g') ;
        end
    else
        axes(plotParam.a2)
        [plotParam.toroidalLine,plotParam.torodialtext]=drawToroidalLine(plotParam.x,plotParam.angle,plotParam.ttheta1,plotParam.ttheta2,plotParam.tlinenum);
    end

end

% --- Executes on button press in ismodify.
function ismodify_Callback(hObject, eventdata, handles)
% hObject    handle to ismodify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns tog
gle state of ismodify
global plotParam
plotParam.ismodify=get(hObject,'Value');


% --- Executes on selection change in linewidth.
function linewidth_Callback(hObject, eventdata, handles)
% hObject    handle to linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns linewidth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from linewidth
global plotParam
contents = cellstr(get(hObject,'String'));
linewidth=str2double(contents{get(hObject,'Value')});

if plotParam.currentAxes==1
    for i=1:length(plotParam.lines)
        try
        line=plotParam.lines{i};
        line.LineWidth=linewidth;
        end
    end
else
    for i=1:length(plotParam.toroidalLine)
        try
        line=plotParam.toroidalLine{i};
        line.LineWidth=linewidth;
        end
    end
end




% --- Executes during object creation, after setting all properties.
function linewidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',4)

% --- Executes on selection change in linecolor.
function linecolor_Callback(hObject, eventdata, handles)
% hObject    handle to linecolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns linecolor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from linecolor
global plotParam
contents = cellstr(get(hObject,'String'));
linecolor=contents{get(hObject,'Value')};

if plotParam.currentAxes==1
    for i=1:length(plotParam.lines)
        try
        line=plotParam.lines{i};
        set(line,'Color',linecolor)
        end
    end
else
    for i=1:length(plotParam.toroidalLine)
        try
        line=plotParam.toroidalLine{i};
        set(line,'Color',linecolor)
        end
    end
end




% --- Executes during object creation, after setting all properties.
function linecolor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linecolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pointsize.
function pointsize_Callback(hObject, eventdata, handles)
% hObject    handle to pointsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pointsize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pointsize

global plotParam
contents = cellstr(get(hObject,'String'));
pointSize=str2double(contents{get(hObject,'Value')});

if plotParam.currentAxes==1
    for i=1:length(plotParam.lines)
        line=plotParam.lines{i};
        set(line,'MarkerSize',pointSize)
    end
else
    for i=1:length(plotParam.toroidalLine)
        line=plotParam.toroidalLine{i};
        set(line,'MarkerSize',pointSize)
    end
end


% --- Executes during object creation, after setting all properties.
function pointsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',4)

% --- Executes on selection change in pointcolor.
function pointcolor_Callback(hObject, eventdata, handles)
% hObject    handle to pointcolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pointcolor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pointcolor
global plotParam
contents = cellstr(get(hObject,'String'));
pointcolor=contents{get(hObject,'Value')};

if plotParam.currentAxes==1
    for i=1:length(plotParam.lines)
        line=plotParam.lines{i};
        set(line,'MarkerFaceColor',pointcolor)
        set(line,'MarkerEdgeColor',pointcolor)
    end
else
    for i=1:length(plotParam.toroidalLine)
        line=plotParam.toroidalLine{i};
        set(line,'MarkerFaceColor',pointcolor)
        set(line,'MarkerEdgeColor',pointcolor)
    end
end



% --- Executes during object creation, after setting all properties.
function pointcolor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointcolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plasmaShape_Callback(hObject, eventdata, handles)
% hObject    handle to plasmaShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plasmaShape as text
%        str2double(get(hObject,'String')) returns contents of plasmaShape as a double
global plotParam
plotParam.plasmaShape=str2double(get(hObject,'String'));



% --- Executes during object creation, after setting all properties.
function plasmaShape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plasmaShape (see GCBO)
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



function lineR_Callback(hObject, eventdata, handles)
% hObject    handle to lineR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lineR as text
%        str2double(get(hObject,'String')) returns contents of lineR as a double
global plotParam
plotParam.lineR=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function lineR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lineR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plasmaShpe.
function plasmaShpe_Callback(hObject, eventdata, handles)
% hObject    handle to plasmaShpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plasmaShpe contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plasmaShpe

global plotParam
plotParam.plasmaShape=get(hObject,'Value');
if plotParam.havedraw
    try
        patches = plotParam.plasma_handle;
        delete(patches);
    end
    axes(plotParam.a1)
    [plotParam.plasma_handle,plotParam.plasmaR]=drawPlasma(plotParam.filepath1,'EXL-50U',plotParam.plasmaShape);
    plotParam.plasma_plot=1;

    try
        patches = plotParam.plasma_handle2;
        delete(patches);
    end 
    axes(plotParam.a2)
    plotParam.plasma_handle2=rectangle('position',[-plotParam.plasmaR,-plotParam.plasmaR,plotParam.plasmaR*2,plotParam.plasmaR*2], 'Curvature',[1,1], 'FaceColor',[0.65	0.035	0.96	0.1]) ;      % 画出中心柱圆形框，填充黑色


end









% --- Executes during object creation, after setting all properties.
function plasmaShpe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plasmaShpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pstyle.
function pstyle_Callback(hObject, eventdata, handles)
% hObject    handle to pstyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pstyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pstyle
global plotParam
contents = cellstr(get(hObject,'String'));
pointstyle= contents{get(hObject,'Value')};

if plotParam.currentAxes==1
    for i=1:length(plotParam.lines)
        line=plotParam.lines{i};
        set(line,'Marker',pointstyle)
    end
else
    for i=1:length(plotParam.toroidalLine)
        line=plotParam.toroidalLine{i};
        set(line,'Marker',pointstyle)
    end
end



% --- Executes during object creation, after setting all properties.
function pstyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pstyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function drawvv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawvv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1)


% --- Executes during object creation, after setting all properties.
function drawflange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawflange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1)


% --- Executes during object creation, after setting all properties.
function drawtf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawtf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1)


% --- Executes during object creation, after setting all properties.
function drawpf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1)


% --- Executes during object creation, after setting all properties.
function drawmp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',0)


% --- Executes during object creation, after setting all properties.
function confirm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9
global plotParam
contents = cellstr(get(hObject,'String'));
linestyle= contents{get(hObject,'Value')};
if plotParam.currentAxes==1
    for i=1:length(plotParam.lines)
        try
        line=plotParam.lines{i};
        line.LineStyle=linestyle;
        end
    end
else
    for i=1:length(plotParam.toroidalLine)
        try
        line=plotParam.toroidalLine{i};
        line.LineStyle=linestyle;
        end
    end
end


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drawplasma.
function drawplasma_Callback(hObject, eventdata, handles)
% hObject    handle to drawplasma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawplasma
global plotParam

if plotParam.havedraw
    if get(hObject,'Value')
        if ~plotParam.plasma_plot
            axes(plotParam.a1)
            plotParam.plasma_handle=drawPlasma(plotParam.filepath1,'EXL-50U',plotParam.plasmaShape);
            plotParam.plasma_plot=1;
        end
    else
        axes(plotParam.a1)
        for i=1:length(plotParam.plasma_handle)
            patches = plotParam.plasma_handle;
            delete(patches);
        end
        plotParam.plasma_plot=0;
    end
else
    plotParam.plasma_plot=get(hObject,'Value');
end


% --- Executes on selection change in axes.
function axes_Callback(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns axes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from axes
global plotParam
plotParam.currentAxes=get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function drawplasma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawplasma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1)


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
global plotParam
plotParam.ismodify=get(hObject,'Value');
