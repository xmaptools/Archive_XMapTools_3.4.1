function varargout = VER_XMTFunctionsInfos_804(varargin)
% VER_XMTFUNCTIONSINFOS_804 MATLAB code for VER_XMTFunctionsInfos_804.fig
%      VER_XMTFUNCTIONSINFOS_804, by itself, creates a new VER_XMTFUNCTIONSINFOS_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTFUNCTIONSINFOS_804 returns the handle to a new VER_XMTFUNCTIONSINFOS_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTFUNCTIONSINFOS_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTFUNCTIONSINFOS_804.M with the given input arguments.
%
%      VER_XMTFUNCTIONSINFOS_804('Property','Value',...) creates a new VER_XMTFUNCTIONSINFOS_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTFunctionsInfos_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTFunctionsInfos_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTFunctionsInfos_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:32:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTFunctionsInfos_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTFunctionsInfos_804_OutputFcn, ...
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


% --- Executes just before VER_XMTFunctionsInfos_804 is made visible.
function VER_XMTFunctionsInfos_804_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VER_XMTFunctionsInfos_804 (see VARARGIN)


handles.externalFunctions = varargin{1};

handles.weAreType = varargin{2};
handles.minRef = varargin{3};
handles.methRef = varargin{4};

PositionXMapTools = varargin{5}; 

%############################
handles.textSizeMax = 22;
%############################

LocBase4Logo = which('XMapTools');
LocBase4Logo = LocBase4Logo (1:end-11);

axes(handles.LOGO);
img = imread([LocBase4Logo,'Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.6,0.9]);

set(gcf,'Position',PositionGui);


% Choose default command line output for VER_XMTFunctionsInfos_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% PLOT ALL 
plotTheFunction(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTFunctionsInfos_804 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
return

% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTFunctionsInfos_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function plotTheFunction(hObject, eventdata, handles) 

set(handles.MenuType,'Value',handles.weAreType);
set(handles.MenuMin,'String',handles.externalFunctions(handles.weAreType).listMin);
set(handles.MenuMin,'Value',handles.minRef);

set(handles.MenuMethod,'String',handles.externalFunctions(handles.weAreType).minerals(handles.minRef).listMeth);
set(handles.MenuMethod,'Value',handles.methRef);

% Text display and for scroll bar !!!
nameSelectedFunction = handles.externalFunctions(handles.weAreType).minerals(handles.minRef).method(handles.methRef).file;
text2Display = help(char(nameSelectedFunction));

set(handles.HelpWindow,'String',text2Display);

displayText = get(handles.HelpWindow,'String');
set(handles.HelpWindow,'UserData',displayText);

if size(get(handles.HelpWindow,'UserData'),1) <= handles.textSizeMax
    set(handles.slider1,'enable','off');
else
    set(handles.HelpWindow,'String',char(displayText(1:handles.textSizeMax,:)));
    set(handles.slider1,'Value',1);
end

% Infos
set(handles.DispFunctionName,'String', ...
    [char(handles.externalFunctions(handles.weAreType).minerals(handles.minRef).method(handles.methRef).file),'.m']);
set(handles.DispDirectory,'String', ...
    which([char(handles.externalFunctions(handles.weAreType).minerals(handles.minRef).method(handles.methRef).file),'.m']))

lesData = handles.externalFunctions(handles.weAreType).minerals(handles.minRef).method(handles.methRef).input;
strDisp = '';
for i=1:length(lesData)
    strDisp = [strDisp,char(lesData{i}),' '];
end
set(handles.DispInput,'String', strDisp);

lesData = handles.externalFunctions(handles.weAreType).minerals(handles.minRef).method(handles.methRef).output;
strDisp = '';
for i=1:length(lesData)
    strDisp = [strDisp,char(lesData{i}),' '];
end
set(handles.DispOutput,'String',strDisp);


guidata(hObject, handles);
return






% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
keyboard
return


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

diffMax = size(get(handles.HelpWindow,'UserData'),1) - handles.textSizeMax;

linesDecal = (1-get(handles.slider1,'value'))*diffMax;
linesDecal = round(linesDecal);

displayText = get(handles.HelpWindow,'UserData');

if linesDecal
    set(handles.HelpWindow,'String',displayText(linesDecal:linesDecal+handles.textSizeMax,:));
else
    set(handles.HelpWindow,'String',displayText(1:handles.textSizeMax,:));
end
guidata(hObject, handles);

return


% --- Executes on selection change in MenuType.
function MenuType_Callback(hObject, eventdata, handles)
handles.weAreType = get(handles.MenuType,'Value');
handles.minRef = 1;
handles.methRef = 1;
plotTheFunction(hObject, eventdata, handles); 
guidata(hObject, handles);
return

% --- Executes on selection change in MenuMin.
function MenuMin_Callback(hObject, eventdata, handles)
handles.minRef = get(handles.MenuMin,'Value');
handles.methRef = 1;
plotTheFunction(hObject, eventdata, handles); 
guidata(hObject, handles);
return

% --- Executes on selection change in MenuMethod.
function MenuMethod_Callback(hObject, eventdata, handles)
handles.methRef = get(handles.MenuMethod,'Value');
plotTheFunction(hObject, eventdata, handles); 
guidata(hObject, handles);
return



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function MenuType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MenuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function MenuMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MenuMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function MenuMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MenuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
