function varargout = Menu_XMT(varargin)
% MENU_XMT MATLAB code for Menu_XMT.fig
%      MENU_XMT, by itself, creates a new MENU_XMT or raises the existing
%      singleton*.
%
%      H = MENU_XMT returns the handle to a new MENU_XMT or the handle to
%      the existing singleton*.
%
%      MENU_XMT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU_XMT.M with the given input arguments.
%
%      MENU_XMT('Property','Value',...) creates a new MENU_XMT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Menu_XMT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Menu_XMT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Menu_XMT

% Last Modified by GUIDE v2.5 06-Jul-2017 10:57:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Menu_XMT_OpeningFcn, ...
                   'gui_OutputFcn',  @Menu_XMT_OutputFcn, ...
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


% --- Executes just before Menu_XMT is made visible.
function Menu_XMT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Menu_XMT (see VARARGIN)

% Menu_XMT_OpeningFcn(handles.LocBase, 'TITLE', handles, varargin)

movegui(gcf,'center');
 
Question = varargin{1};
Options = varargin{2};

if length(varargin) > 2
    LocBase = varargin{3};
    axes(handles.LOGO);
    img = imread([LocBase,'/Dev/logo/logo_xmap_final.png']);
    image(img);
    set(gca,'Visible','Off');
else
    set(handles.LOGO,'Visible','Off');
end

set(handles.Text,'String',Question);


for i=1:length(Options)
    eval(['set(handles.ButtonCase',num2str(i),',''Visible'',''On'',''String'',Options{',num2str(i),'});']);
end

% Choose default command line output for Menu_XMT
handles.output = [0];

handles.Question = Question;
handles.Options = Options;

handles.gcf = gcf;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Menu_XMT wait for user response (see UIRESUME)
uiwait(hObject);
return


% --- Outputs from this function are returned to the command line.
function varargout = Menu_XMT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

delete(hObject)
return

% --- Executes when user attempts to close Menu_XMT.
function Menu_XMT_CloseRequestFcn(hObject, eventdata, handles)
%

if isequal(get(hObject, 'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end

return


function UserPressedAnyButton(Button, hObject, eventdata, handles)
%

handles.output = Button;
guidata(hObject, handles);

close(handles.gcf);
return




% --- Executes on button press in ButtonCase1.
function ButtonCase1_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(1, hObject, eventdata, handles);

return

% --- Executes on button press in ButtonCase2.
function ButtonCase2_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(2, hObject, eventdata, handles);

return


% --- Executes on button press in ButtonCase3.
function ButtonCase3_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(3, hObject, eventdata, handles);

return


% --- Executes on button press in ButtonCase4.
function ButtonCase4_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(4, hObject, eventdata, handles);

return


% --- Executes on button press in ButtonCase5.
function ButtonCase5_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(5, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase6.
function ButtonCase6_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(6, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase7.
function ButtonCase7_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(7, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase8.
function ButtonCase8_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(8, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase9.
function ButtonCase9_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(9, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase10.
function ButtonCase10_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(10, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase11.
function ButtonCase11_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(11, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase12.
function ButtonCase12_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(12, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase13.
function ButtonCase13_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(13, hObject, eventdata, handles);

return



% --- Executes on button press in ButtonCase14.
function ButtonCase14_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCase14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserPressedAnyButton(14, hObject, eventdata, handles);

return
