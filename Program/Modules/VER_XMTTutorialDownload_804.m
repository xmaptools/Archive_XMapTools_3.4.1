function varargout = VER_XMTTutorialDownload_804(varargin)
% VER_XMTTUTORIALDOWNLOAD_804 MATLAB code for VER_XMTTutorialDownload_804.fig
%      VER_XMTTUTORIALDOWNLOAD_804, by itself, creates a new VER_XMTTUTORIALDOWNLOAD_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTTUTORIALDOWNLOAD_804 returns the handle to a new VER_XMTTUTORIALDOWNLOAD_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTTUTORIALDOWNLOAD_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTTUTORIALDOWNLOAD_804.M with the given input arguments.
%
%      VER_XMTTUTORIALDOWNLOAD_804('Property','Value',...) creates a new VER_XMTTUTORIALDOWNLOAD_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTTutorialDownload_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTTutorialDownload_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTTutorialDownload_804

% Last Modified by GUIDE v2.5 08-May-2020 09:36:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTTutorialDownload_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTTutorialDownload_804_OutputFcn, ...
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


% --- Executes just before VER_XMTTutorialDownload_804 is made visible.
function VER_XMTTutorialDownload_804_OpeningFcn(hObject, eventdata, handles, varargin)
%

handles.OLTutorial = varargin{1};

handles.LocBase = varargin{2};

PositionXMapTools = varargin{3}; 

axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');


PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.7,0.5]);

set(gcf,'Position',PositionGui);


%
OLTutorial = handles.OLTutorial;
for i = 1:length(OLTutorial)
    Names{i} = OLTutorial(i).Name;
end
set(handles.TutorialList,'String',Names,'Value',1);

guidata(hObject, handles);
UpdateGUI(hObject, eventdata, handles);

% Choose default command line output for VER_XMTTutorialDownload_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTTutorialDownload_804 wait for user response (see UIRESUME)
% uiwait(handles.TutorialDownload);


function [] = UpdateGUI(hObject, eventdata, handles)
%
Selected = get(handles.TutorialList,'Value');

OLTutorial = handles.OLTutorial;


set(handles.AddOnName,'String',[OLTutorial(Selected).Name]);

set(handles.DispRelease,'String',OLTutorial(Selected).Date);
set(handles.DispPackage,'String',OLTutorial(Selected).Package);
set(handles.DispDev,'String',OLTutorial(Selected).Developers);
set(handles.DispInfo,'String',OLTutorial(Selected).Comment);

set(handles.ButtonDownload,'Visible','on');

guidata(hObject, handles);
return




function [] = APPLY(Download,hObject,handles)
%
Selected = get(handles.TutorialList,'Value');
OLTutorial = handles.OLTutorial;
AddOnName = OLTutorial(Selected).Name;

directoryname = uigetdir(cd, 'Select a directory to save the data');

if isequal(directoryname,0)
    return
end

h = waitbar(0,'Tutorial data download - Please wait...');
waitbar(0.2,h);

cd(directoryname); 

waitbar(0.4,h);

if Download
    WebAdress = ['http://www.xmaptools.com/FTP_help/',char(OLTutorial(Selected).Package)];
    unzip(WebAdress);
    
    % Cleaning:
    if isdir('__MACOSX')
        [status,msg,msgID] = rmdir('__MACOSX', 's');
    end
    
end

waitbar(1,h);
close(h);

cd([directoryname,'/',char(OLTutorial(Selected).Package(1:end-4))]); 

uiwait(msgbox(['Success - data for tutorial ',AddOnName,' are now available'],'XMapTools','modal'));

TutorialDownload_CloseRequestFcn(gcf, 1, handles);
return



% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTTutorialDownload_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in TutorialList.
function TutorialList_Callback(hObject, eventdata, handles)
% 
UpdateGUI(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function TutorialList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TutorialList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on buttondownload press in ButtonDownload.
function ButtonDownload_Callback(hObject, eventdata, handles)
%
APPLY(1,hObject,handles);



% --- Executes on button press in ButtonUpdate.
function ButtonUpdate_Callback(hObject, eventdata, handles)
% 
APPLY(1,hObject,handles);


% --- Executes when user attempts to close TutorialDownload.
function TutorialDownload_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to TutorialDownload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
