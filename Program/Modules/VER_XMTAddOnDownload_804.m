function varargout = VER_XMTAddOnDownload_804(varargin)
% VER_XMTADDONDOWNLOAD_804 MATLAB code for VER_XMTAddOnDownload_804.fig
%      VER_XMTADDONDOWNLOAD_804, by itself, creates a new VER_XMTADDONDOWNLOAD_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTADDONDOWNLOAD_804 returns the handle to a new VER_XMTADDONDOWNLOAD_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTADDONDOWNLOAD_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTADDONDOWNLOAD_804.M with the given input arguments.
%
%      VER_XMTADDONDOWNLOAD_804('Property','Value',...) creates a new VER_XMTADDONDOWNLOAD_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTAddOnDownload_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTAddOnDownload_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTAddOnDownload_804

% Last Modified by GUIDE v2.5 03-Dec-2019 16:36:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTAddOnDownload_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTAddOnDownload_804_OutputFcn, ...
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


% --- Executes just before VER_XMTAddOnDownload_804 is made visible.
function VER_XMTAddOnDownload_804_OpeningFcn(hObject, eventdata, handles, varargin)
%

handles.OLAddOns = varargin{1};
handles.LocBase = varargin{2};

PositionXMapTools = varargin{3}; 

axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

% axes(handles.LOGO);
% img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
% image(img), axis image
% set(gca,'visible','off');


PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.7,0.5]);

set(gcf,'Position',PositionGui);


%
OLAddOns = handles.OLAddOns;
for i = 1:length(OLAddOns)
    Names{i} = OLAddOns(i).Name;
end
set(handles.AddOnList,'String',Names,'Value',1);

guidata(hObject, handles);
UpdateGUI(hObject, eventdata, handles);

% Choose default command line output for VER_XMTAddOnDownload_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTAddOnDownload_804 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function [] = UpdateGUI(hObject, eventdata, handles)
%
Selected = get(handles.AddOnList,'Value');

OLAddOns = handles.OLAddOns;


set(handles.AddOnName,'String',[OLAddOns(Selected).Name,' ',OLAddOns(Selected).Version]);

set(handles.DispRelease,'String',OLAddOns(Selected).Date);
set(handles.DispPackage,'String',OLAddOns(Selected).Package);
set(handles.DispDev,'String',OLAddOns(Selected).Developers);
set(handles.DispInfo,'String',OLAddOns(Selected).Comment);

if OLAddOns(Selected).IsInstalled
    set(handles.ButtonDownload,'Visible','off');
    set(handles.ButtonUpdate,'Visible','on');
    set(handles.DispStatut,'String',[OLAddOns(Selected).Name,' already installed'],'ForegroundColor',[0,0,1]);
else
    set(handles.ButtonDownload,'Visible','on');
    set(handles.ButtonUpdate,'Visible','off');
    set(handles.DispStatut,'String',[OLAddOns(Selected).Name,' not yet installed'],'ForegroundColor',[1,0,0]);  
end


guidata(hObject, handles);
return




function [] = APPLY(Delete,Download,hObject,handles);
%
Selected = get(handles.AddOnList,'Value');
OLAddOns = handles.OLAddOns;
AddOnName = OLAddOns(Selected).Name;

LocBase = handles.LocBase;

LocBaseAddOn = [LocBase(1:end-7),'Addons/'];

WhereWeAre = cd;

if Delete
    Answer = questdlg({['Add-on: ',AddOnName],'This operation will delete the existing files before','downloading the last package from the server ...','Continue?'},'XMapTools','Yes');
    if ~isequal(Answer,'Yes')
        return
    end
end

h = waitbar(0,'Add-on download & installation - Please wait...');
waitbar(0.2,h);

cd(LocBaseAddOn); 

if Delete
    rmpath([cd,'/',AddOnName]);
    rmdir(AddOnName,'s');
end

waitbar(0.4,h);

if Download
    WebAdress = ['http://www.xmaptools.com/FTP_addons/',AddOnName,'/',char(OLAddOns(Selected).Package)];
    unzip(WebAdress);
    
    % Cleaning:
    if isdir('__MACOSX')
        [status,msg,msgID] = rmdir('__MACOSX', 's');
    end
    
end

waitbar(0.8,h);

cd(WhereWeAre);

OLAddOns(Selected).IsInstalled = 1;
handles.OLAddOns = OLAddOns;

guidata(hObject, handles);

waitbar(1,h);
close(h);

uiwait(msgbox(['Success - the add-on ',AddOnName,' is now available in XMapTools'],'XMapTools','modal'));
UpdateGUI(hObject, 1, handles);
return

% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTAddOnDownload_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in AddOnList.
function AddOnList_Callback(hObject, eventdata, handles)
% 
UpdateGUI(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function AddOnList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AddOnList (see GCBO)
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
APPLY(0,1,hObject,handles);



% --- Executes on button press in ButtonUpdate.
function ButtonUpdate_Callback(hObject, eventdata, handles)
% 
APPLY(1,1,hObject,handles);
