function varargout = pcgui(varargin)
% PCGUI M-file for pcgui.fig
%      PCGUI, by itself, creates a new PCGUI or raises the existing
%      singleton*.
%
%      H = PCGUI returns the handle to a new PCGUI or the handle to
%      the existing singleton*.
%
%      PCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCGUI.M with the given input arguments.
%
%      PCGUI('Property','Value',...) creates a new PCGUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcgui

% Last Modified by GUIDE v2.5 10-Jun-2013 11:24:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcgui_OpeningFcn, ...
                   'gui_OutputFcn',  @pcgui_OutputFcn, ...
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

% --- Executes just before pcgui is made visible.
function pcgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcgui (see VARARGIN)

% Choose default command line output for pcgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes pcgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.


handles.port = 41234;
handles.shotpath = '/home/det/images/50Uimage/';
handles.shotno = 4888;
handles.expo = 9;
handles.expp = 1;
handles.nimages = 400;
handles.iplength = 10;
handles.threshhold = 2200;
handles.threshhold1 = handles.threshhold;
handles.exthreshhold = handles.threshhold;
handles.countthreshold = 1;
set(handles.ShotPath,'String',handles.shotpath);
%set(handles.Ni,'String',handles.nimages);
set(handles.Ni,'String',handles.iplength);
set(handles.EXPO,'String',handles.expo);
set(handles.EXPP,'String',handles.expp);
set(handles.THRESH,'String',handles.threshhold);
set(handles.SHOTNO,'String',handles.shotno);
handles.dec038ip = '172.17.102.114'; 
handles.dec039ip =  '172.17.102.149';
handles.dec119ip = '172.17.102.108';


% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in DEC038.
function DEC038_Callback(hObject, eventdata, handles)
% hObject    handle to DEC038 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DEC038


% --- Executes on button press in DEC039.
function DEC039_Callback(hObject, eventdata, handles)
% hObject    handle to DEC039 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DEC039


% --- Executes on button press in DEC119.
function DEC119_Callback(hObject, eventdata, handles)
% hObject    handle to DEC119 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DEC119


% --- Executes on button press in TRIG038.
function TRIG038_Callback(hObject, eventdata, handles)
% hObject    handle to TRIG038 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TRIG038


% --- Executes on button press in TRIG039.
function TRIG039_Callback(hObject, eventdata, handles)
% hObject    handle to TRIG039 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TRIG039


% --- Executes on button press in TRIG119.
function TRIG119_Callback(hObject, eventdata, handles)
% hObject    handle to TRIG119 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TRIG119



function ShotPath_Callback(hObject, eventdata, handles)
% hObject    handle to ShotPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShotPath as text
%        str2double(get(hObject,'String')) returns contents of ShotPath as a double


% --- Executes during object creation, after setting all properties.
function ShotPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShotPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ni_Callback(hObject, eventdata, handles)
% hObject    handle to Ni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(hObject, 'String'));
if isnan(temp)
    set(hObject, 'String', handles.nimages);
    errordlg('Ni Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of Ni as text
%        str2double(get(hObject,'String')) returns contents of Ni as a double


% --- Executes during object creation, after setting all properties.
function Ni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EXPP_Callback(hObject, eventdata, handles)
% hObject    handle to EXPP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(hObject, 'String'));
if isnan(temp)
    set(hObject, 'String', handles.expp);
    errordlg('EXPP Input must be a number','Error');
else
    temp2 = str2double(get(handles.EXPO,'String'));
    if temp-temp2 <1
        warndlg('EXPP-EXPO<1ms');
        set(hObject,'String',temp2+1);
    end
end
% Hints: get(hObject,'String') returns contents of EXPP as text
%        str2double(get(hObject,'String')) returns contents of EXPP as a double


% --- Executes during object creation, after setting all properties.
function EXPP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EXPP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EXPO_Callback(hObject, eventdata, handles)
% hObject    handle to EXPO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(hObject, 'String'));
if isnan(temp)
    set(hObject, 'String', handles.expo);
    errordlg('EXPO Input must be a number','Error');
else
    temp2 = str2double(get(handles.EXPP,'String'));
    if temp2-temp <1
        %warndlg('EXPP-EXPO<1ms');
        set(handles.EXPP,'String',temp+1);        
    end
end
% Hints: get(hObject,'String') returns contents of EXPO as text
%        str2double(get(hObject,'String')) returns contents of EXPO as a double


% --- Executes during object creation, after setting all properties.
function EXPO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EXPO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function THRESH_Callback(hObject, eventdata, handles)
% hObject    handle to THRESH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(hObject, 'String'));
if isnan(temp)
    set(hObject, 'String', handles.threshhold);
    errordlg('THRESH Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of THRESH as text
%        str2double(get(hObject,'String')) returns contents of THRESH as a double


% --- Executes during object creation, after setting all properties.
function THRESH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THRESH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SHOTNO_Callback(hObject, eventdata, handles)
% hObject    handle to SHOTNO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SHOTNO as text
%        str2double(get(hObject,'String')) returns contents of SHOTNO as a double


% --- Executes during object creation, after setting all properties.
function SHOTNO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SHOTNO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ARMING.
function ARMING_Callback(hObject, eventdata, handles)
% hObject    handle to ARMING (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PVSN = 'CCS_SHOT_NUMBER';
PVST = 'CCS_SHOTSEQ_START';
PVCD = 'TSS_CTU_SOFT_START';
autoflag = get(handles.AUTOMATIC,'Value');
while autoflag > 0.5
set(hObject,'Enable','off');
set(hObject,'BackgroundColor','yellow');
set(hObject,'ForegroundColor','blue');
set(hObject,'String','WaitingShot');

countthreshold = handles.countthreshold;
port = handles.port;
%dec038ip = handles.dec038ip; 
dec038ip = get(handles.IP038,'String');
dec039ip = handles.dec039ip;
dec119ip = handles.dec119ip;
dec038ch = get(handles.DEC038,'Value');
dec039ch = get(handles.DEC039,'Value');
dec119ch = get(handles.DEC119,'Value');
dec038md = get(handles.TRIG038,'Value');
dec039md = get(handles.TRIG039,'Value');
dec119md = get(handles.TRIG119,'Value');
shotpath = get(handles.ShotPath,'String');
%     PSN = mcaopen(PVSN);
%     shotno = mcaget(PSN);
%     mcaclose(PSN);
%     set(handles.SHOTNO,'String',shotno);

shotno = str2double(get(handles.SHOTNO,'String'));
%nimages = str2double(get(handles.Ni,'String'));    
IPpulse = str2double(get(handles.Ni,'String'));
expo = str2double(get(handles.EXPO,'String'))/1000;
expp = str2double(get(handles.EXPP,'String'))/1000;
nimages = ceil(IPpulse/expp);
threshhold = str2double(get(handles.THRESH,'String'));

stflag = 0;
% while stflag < 0.5
%     PST = mcaopen(PVST);
%     if mcaisopen(PVST);
%         stflag = mcaget(PST);
%         mcaclose(PST);
%     end
%     if stflag < 0.5
%         pause(0.5);
%     end
%     autoflag = get(handles.AUTOMATIC,'Value');
%     if autoflag < 0.5
%         stflag = 1;
%     end
% end

IPpulse = str2double(get(handles.Ni,'String'));
expo = str2double(get(handles.EXPO,'String'))/1000;
expp = str2double(get(handles.EXPP,'String'))/1000;
nimages = ceil(IPpulse/expp);
threshhold = str2double(get(handles.THRESH,'String'));
dec038ch = get(handles.DEC038,'Value');
dec039ch = get(handles.DEC039,'Value');
dec119ch = get(handles.DEC119,'Value');
dec038md = get(handles.TRIG038,'Value');
dec039md = get(handles.TRIG039,'Value');
dec119md = get(handles.TRIG119,'Value');
shotpath = get(handles.ShotPath,'String');
initime = str2double(get(handles.INITIME,'String'));


if stflag > 0.5 && autoflag > 0.5
set(handles.Ni, 'Enable', 'off');
set(handles.EXPP, 'Enable', 'off');
set(handles.THRESH, 'Enable', 'off');
set(handles.EXPO, 'Enable', 'off');
set(handles.DEC038, 'Enable', 'off');
set(handles.DEC039, 'Enable', 'off');
set(handles.DEC119, 'Enable', 'off');
set(handles.TRIG038, 'Enable', 'off');
set(handles.TRIG039, 'Enable', 'off');
set(handles.TRIG119, 'Enable', 'off');
set(handles.ShotPath, 'Enable', 'off');
set(handles.INITIME,'Enable','off');
end

firsttrig = -76;
countdownflag = 1;
clock1 = clock;
while countdownflag
    clock2 = clock;
    diffclock = clock2-clock1;
    difftime = diffclock(4)*3600+diffclock(5)*60+round(diffclock(6));
    delaytime = firsttrig+difftime;
    if delaytime > initime
        countdownflag = 0;
    end
    tempstr = cat(2,'Time:',int2str(delaytime));
    if stflag > 0.5 && autoflag > 0.5
       % set(hObject,'String','ShotStart');
       % set(hObject,'BackgroundColor','m');
       % pause(initime-firsttrig);
       set(hObject,'String',tempstr);
       pause(0.33);
    end
    clear tempstr;
end
flag100k = 0;
if flag100k
%     if stflag > 0.5 && autoflag > 0.5
%         set(hObject,'String','DCB_Init');
%         set(hObject,'BackgroundColor','green');
%     end
end

if stflag >0.5 && autoflag >0.5
if dec038ch >0.5
    dec038 = tcpip(dec038ip,port);
    fopen(dec038);
    %fprintf('038 is open\n');
end
if dec039ch >0.5
    dec039 = tcpip(dec039ip,port);
    fopen(dec039);
    %fprintf('039 is open\n');
end
if dec119ch >0.5
    dec119 = tcpip(dec119ip,port);
    fopen(dec119);
    %fprintf('119 is open\n');
end

%The following is for old 100K detector
flag100k = 0;
if flag100k
    command = cat(2,'dcb_init',char(10));
    if dec038ch > 0.5
        fwrite(dec038,command);
    end
    if dec039ch > 0.5
        fwrite(dec039,command);
    end
    if dec119ch > 0.5
        fwrite(dec119,command);
    end
    clear command;
    pause(10);
end

clock1 = clock;
clockflag = 1; 
clockdelay = 50;
if autoflag > 0.5
%pcd = 0; %for kstar
pcd=1; % for J-TEXT
    flagkstar = 0;
    if flagkstar
    while pcd < 0.5
        PCD = mcaopen(PVCD);
        if mcaisopen(PVCD)
            pcd = mcaget(PCD);
            if pcd < 0.5
                pause(0.5);
            end
            mcaclose(PCD);
        end
        autoflag = get(handles.AUTOMATIC,'Value');
        clock2 = clock;
        if autoflag < 0.5
            pcd = 1;
        end
        clockdiff = clock2-clock1;
        
        if clockdiff(4)*3600+clockdiff(5)*60+clockdiff(6) > clockdelay
            pcd = 1;
            clockflag = 0;
        end
    end
    end
    
    if pcd > 0.5 && autoflag > 0.5 && clockflag > 0.5
        set(hObject,'String','DataAcq');
        set(hObject,'BackgroundColor','red');
    end
    if clockflag <0.5
        set(hObject,'String','Lost-16sTrig');
        set(hObject,'BackgroundColor','red');
        warndlg('DataLostMissiing-16s Trig')
    end

if clockflag > 0.5    
if expp-expo < 0.001
    expp = expo+0.001;
    warndlg('EXPP-EXPO<0.001')
    set(handles.EXPP,'String',expp);
end

%The following is for old 100K detector
flag100k = 0;
if flag100k
    if  abs(round(handles.countthreshold/2)*2-handles.countthreshold) > 0.1
        exthreshold = threshhold+70;
    else
        exthreshold = threshhold;
    end
    set(handles.RTHRESH,'String',exthreshold); 
    command = cat(2,'setthreshold uhighg ',int2str(exthreshold), char(10));
    if dec038ch > 0.5
        fwrite(dec038,command);
    end
    if dec039ch > 0.5
        fwrite(dec039,command);
    end
    if dec119ch > 0.5
        fwrite(dec119,command);
    end
    clear command;
    handles.countthreshold = handles.countthreshold + 1;
    %pause(2) % 3 seconds for normal operation
    pause(9); % 10 seconds for the first time initializtion
end

command = cat(2,'nimages ',int2str(nimages),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
command = cat(2,'expperiod ',num2str(expp),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
command = cat(2,'exptime ',num2str(expo),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
%command = cat(2,'thread',char(10));
%fwrite(dec038,command);
%clear command;
command = cat(2,'imgpath ',shotpath,int2str(shotno),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
pause(0.5);

command1 = cat(2,'exposure ', int2str(shotno),'_.tif',char(10));
command2 = cat(2,'extt ',int2str(shotno),'_.tif',char(10));
if dec038ch > 0.5
    if dec038md >0.5
        fwrite(dec038,command2);
    else
        fwrite(dec038,command1);
    end
end
if dec039ch > 0.5
    if dec039md >0.5
        fwrite(dec039,command2);
    else
        fwrite(dec039,command1);
    end
end
if dec119ch > 0.5
     if dec119md >0.5
        fwrite(dec119,command2);
    else
        fwrite(dec119,command1);
    end
end
clear command1;
clear command2;
end

if dec038ch > 0.5
    fclose(dec038);
end
if dec039ch > 0.5
    fclose(dec039);
end
if dec119ch > 0.5
    fclose(dec119);
end

pause(5+nimages*expp);
shotno = shotno+1;
set(handles.SHOTNO,'String',shotno);

end

set(handles.Ni, 'Enable', 'on');
set(handles.EXPP, 'Enable', 'on');
set(handles.THRESH, 'Enable', 'on');
set(handles.EXPO, 'Enable', 'on');
set(handles.DEC038, 'Enable', 'on');
set(handles.DEC039, 'Enable', 'on');
set(handles.DEC119, 'Enable', 'on');
set(handles.TRIG038, 'Enable', 'on');
set(handles.TRIG039, 'Enable', 'on');
set(handles.TRIG119, 'Enable', 'on');
set(handles.ShotPath, 'Enable', 'on');
set(handles.INITIME,'Enable','on');
%disp('on')
set(hObject,'Enable','off');
set(hObject,'BackgroundColor','Black');
%set(hObject,'BackgroundColor','green');
set(hObject,'ForegroundColor','white');
set(hObject,'String','DeadTime');
autoflag  = get(handles.AUTOMATIC,'Value');
if autoflag > 0.5
    %deadtime = 100;
    deadtime = str2double(get(handles.DEADTime,'String'));
   while deadtime > 0.5
       pause(0.95);
       deadtime = deadtime-1;
       autoflag  = get(handles.AUTOMATIC,'Value');
       if autoflag < 0.5
           deadtime = 0;
       end
       string01 = cat(2,'DeadTime:',int2str(deadtime));
       set(hObject,'String',string01);
       clear string01;
   end   
    
end
end
autoflag = get(handles.AUTOMATIC,'Value');
if autoflag < 0.5
    set(hObject,'Enable','on');
    set(hObject,'BackgroundColor','green');
    set(hObject,'ForegroundColor','red');
    set(hObject,'String','ARM');
end
end

manualflag = get(handles.MANUAL,'Value');
if autoflag < 0.5 && manualflag > 0.5
set(hObject,'Enable','off');
set(hObject,'BackgroundColor','yellow');
set(hObject,'ForegroundColor','blue');
set(hObject,'String','DataAcq!');

port = handles.port;
%dec038ip = handles.dec038ip; 
dec038ip = get(handles.IP038,'String');
dec039ip = handles.dec039ip;
dec119ip = handles.dec119ip;
dec038ch = get(handles.DEC038,'Value');
dec039ch = get(handles.DEC039,'Value');
dec119ch = get(handles.DEC119,'Value');
dec038md = get(handles.TRIG038,'Value');
dec039md = get(handles.TRIG039,'Value');
dec119md = get(handles.TRIG119,'Value');
shotpath = get(handles.ShotPath,'String');

shotno = str2double(get(handles.SHOTNO,'String'));

%nimages = str2double(get(handles.Ni,'String'));    
IPpulse = str2double(get(handles.Ni,'String'));
expo = str2double(get(handles.EXPO,'String'))/1000;
expp = str2double(get(handles.EXPP,'String'))/1000;
nimages = ceil(IPpulse/expp);


if expp-expo < 0.001
    expp = expo+0.001;
    warndlg('EXPP-EXPO<0.001')
    set(handles.EXPP,'String',expp);
end

if dec038ch >0.5
    dec038 = tcpip(dec038ip,port);
    fopen(dec038);
    %fprintf('038 is open\n');
end
if dec039ch >0.5
    dec039 = tcpip(dec039ip,port);
    fopen(dec039);
    %fprintf('039 is open\n');
end
if dec119ch >0.5
    dec119 = tcpip(dec119ip,port);
    fopen(dec119);
    %fprintf('119 is open\n');
end

%The following is for old 100K detector
flag100k = 0;
if flag100k
    command = cat(2,'dcb_init',char(10));
    if dec038ch > 0.5
        fwrite(dec038,command);
    end
    if dec039ch > 0.5
        fwrite(dec039,command);
    end
    if dec119ch > 0.5
        fwrite(dec119,command);
    end
    clear command;
    pause(10);

    command = cat(2,'setthreshold uhighg ',int2str(threshhold), char(10));
    if dec038ch > 0.5
     fwrite(dec038,command);
    end
    if dec039ch > 0.5
        fwrite(dec039,command);
    end
    if dec119ch > 0.5
        fwrite(dec119,command);
    end
    clear command;
%pause(2) % 3 seconds for normal operation
    pause(10); % 10 seconds for the first time initializtion
end
    
command = cat(2,'nimages ',int2str(nimages),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
command = cat(2,'expperiod ',num2str(expp),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
command = cat(2,'exptime ',num2str(expo),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
%command = cat(2,'thread',char(10));
%fwrite(dec038,command);
%clear command;
command = cat(2,'imgpath ',shotpath,int2str(shotno),char(10));
if dec038ch > 0.5
    fwrite(dec038,command);
end
if dec039ch > 0.5
    fwrite(dec039,command);
end
if dec119ch > 0.5
    fwrite(dec119,command);
end
clear command;
pause(0.5);

command1 = cat(2,'exposure ', int2str(shotno),'_.tif',char(10));
command2 = cat(2,'extt ',int2str(shotno),'_.tif',char(10));
if dec038ch > 0.5
    if dec038md >0.5
        fwrite(dec038,command2);
    else
        fwrite(dec038,command1);
    end
end
if dec039ch > 0.5
    if dec039md >0.5
        fwrite(dec039,command2);
    else
        fwrite(dec039,command1);
    end
end
if dec119ch > 0.5
     if dec119md >0.5
        fwrite(dec119,command2);
    else
        fwrite(dec119,command1);
    end
end
clear command1;
clear command2;

if dec038ch > 0.5
    fclose(dec038);
end
if dec039ch > 0.5
    fclose(dec039);
end
if dec119ch > 0.5
    fclose(dec119);
end

pause(5+nimages*expp);
shotno = shotno+1;
set(handles.SHOTNO,'String',shotno);
set(hObject,'Enable','on');
set(hObject,'BackgroundColor','green');
set(hObject,'ForegroundColor','red');
set(hObject,'String','Arm');
end


guidata(hObject, handles); 


% --- Executes on button press in MANUAL.
function MANUAL_Callback(hObject, eventdata, handles)
% hObject    handle to MANUAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = get(hObject,'Value');
if temp > 0.5
    set(handles.AUTOMATIC, 'Value', 0);
else
    set(handles.AUTOMATIC, 'Value', 1);
end
guidata(hObject, handles); 

% Hint: get(hObject,'Value') returns toggle state of MANUAL


% --- Executes on button press in AUTOMATIC.
function AUTOMATIC_Callback(hObject, eventdata, handles)
% hObject    handle to AUTOMATIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = get(hObject,'Value');
if temp > 0.5
    set(handles.MANUAL, 'Value', 0);
else
    set(handles.MANUAL, 'Value', 1);
end
guidata(hObject, handles); 
% Hint: get(hObject,'Value') returns toggle state of AUTOMATIC



function RTHRESH_Callback(hObject, eventdata, handles)
% hObject    handle to RTHRESH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RTHRESH as text
%        str2double(get(hObject,'String')) returns contents of RTHRESH as a double


% --- Executes during object creation, after setting all properties.
function RTHRESH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RTHRESH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INITIME_Callback(hObject, eventdata, handles)
% hObject    handle to INITIME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INITIME as text
%        str2double(get(hObject,'String')) returns contents of INITIME as a double


% --- Executes during object creation, after setting all properties.
function INITIME_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INITIME (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IP038_Callback(hObject, eventdata, handles)
% hObject    handle to IP038 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IP038 as text
%        str2double(get(hObject,'String')) returns contents of IP038 as a double


% --- Executes during object creation, after setting all properties.
function IP038_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IP038 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DEADTime_Callback(hObject, eventdata, handles)
% hObject    handle to DEADTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(hObject, 'String'));
if isnan(temp)
    set(hObject, 'String', handles.nimages);
    errordlg('DeadTime must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of DEADTime as text
%        str2double(get(hObject,'String')) returns contents of DEADTime as a double


% --- Executes during object creation, after setting all properties.
function DEADTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DEADTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
