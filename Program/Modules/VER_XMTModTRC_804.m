function varargout = VER_XMTModTRC_804(varargin)
% VER_XMTMODTRC_804 MATLAB code for VER_XMTModTRC_804.fig
%      VER_XMTMODTRC_804, by itself, creates a new VER_XMTMODTRC_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODTRC_804 returns the handle to a new VER_XMTMODTRC_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODTRC_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODTRC_804.M with the given input arguments.
%
%      VER_XMTMODTRC_804('Property','Value',...) creates a new VER_XMTMODTRC_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModTRC_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModTRC_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModTRC_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:35:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModTRC_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModTRC_804_OutputFcn, ...
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


% --- Executes just before VER_XMTModTRC_804 is made visible.
function VER_XMTModTRC_804_OpeningFcn(hObject, eventdata, handles, varargin)

if ispc
    set(gcf,'Position',[10,6,316,68]);
    handles.FileDirCode = 'file:/';
else
    handles.FileDirCode = 'file://';
end

LocBase4Logo = which('XMapTools');
LocBase4Logo = LocBase4Logo (1:end-11);

axes(handles.LOGO);
img = imread([LocBase4Logo,'Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

Data = varargin{1};
MaskFile = varargin{2};
PositionXMapTools = varargin{3};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.95,0.95]);

set(gcf,'Position',PositionGui);


ListName = '';
for i=1:length(Data)
    ListName{i} = char(Data(i).name);
end

handles.WhereIsTopo = find(ismember(ListName,'TOPO'));

handles.CorrMatrix = zeros(length(ListName),length(MaskFile.NameMinerals));
handles.OrdoMatrix = zeros(length(ListName),length(MaskFile.NameMinerals));

set(handles.PopUpMenu1,'String',ListName,'Value',1);
set(handles.PopUpMenu2,'String',MaskFile.NameMinerals,'Value',1);

handles.Data = Data;
handles.MaskFile = MaskFile;

guidata(hObject, handles);
PlotImages(hObject, eventdata, handles)

set(handles.ButtonCopy,'visible','off');
set(handles.ButtonApply,'visible','off');

set(handles.ButtonDelete,'visible','off');
set(handles.ButtonCloseApply,'visible','off');
set(handles.ButtonCloseCancel,'visible','off');

% Choose default command line output for VER_XMTModTRC_804
handles.output1 = handles.CorrMatrix;
handles.output2 = handles.OrdoMatrix;
handles.output3 = 0;


handles.gcf = gcf;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTModTRC_804 wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModTRC_804_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output1;
varargout{2} = handles.output2;
varargout{3} = handles.output3;

delete(hObject);


function PlotImages(hObject, eventdata, handles)

axes(handles.axes1); cla
axes(handles.axes2); cla
axes(handles.axes3); cla
axes(handles.axes4); cla

CorrMatrix = handles.CorrMatrix;

Data = handles.Data;
MaskFile = handles.MaskFile;

TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;

AAfficher = Data(TheSelEl).values;

if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

if TheSelMin
    AAfficher = AAfficher .* TheMask;
end

axes(handles.axes3) 
imagesc(AAfficher), axis image, colorbar horizontal
set(gca,'XTick',[],'YTick',[]);
title(['uncorrected ',char(Data(TheSelEl).name)]) 


CMin = min(AAfficher(find(AAfficher(:))));
CMax = max(AAfficher(find(AAfficher(:))));

set(handles.EditMin,'String',num2str(CMin));
set(handles.EditMax,'String',num2str(CMax));

colormap([0,0,0;jet(64)]);

Xray = Data(TheSelEl).values.*TheMask;
Topo = Data(handles.WhereIsTopo).values.*TheMask;

Xall = Topo(find(Topo));
Yall = Xray(find(Topo));

axes(handles.axes1);
plot(Xall,Yall,'.','markersize',1);
xlabel('TOPO intensity');
ylabel([char(Data(TheSelEl).name),' intensity'])

if CorrMatrix(TheSelEl,TheSelMin+1) 
    set(handles.axes2,'visible','on');
    set(handles.axes4,'visible','on');
   
    a = CorrMatrix(TheSelEl,TheSelMin+1);

    Ycorr = Yall - a*Xall;

    axes(handles.axes2);
    plot(Xall,Ycorr,'.k','markersize',1);
    xlabel('TOPO intensity');
    ylabel(['corrected ',char(Data(TheSelEl).name),' intensity']);
    TheAxis = axis;
    
    if min(Ycorr(:)) < 0
        hold on
        plot([TheAxis(1),TheAxis(2)],[0,0],'--r','Linewidth',2)
    end 

    axes(handles.axes4);
    imagesc(Xray - a*Topo), axis image, handles.h = colorbar('horizontal');
    set(gca,'XTick',[],'YTick',[]);
    title(['corrected ',char(Data(TheSelEl).name)]);
    
    set(handles.TextA,'visible','on','String',num2str(a));
    
    set(handles.ButtonCopy,'visible','on');
    set(handles.ButtonDelete,'visible','on');
    %keyboard
else
    
    axes(handles.axes4);
    imagesc(1);
    cla
    
    set(handles.axes2,'visible','off');
    set(handles.axes4,'visible','off');
    set(handles.TextA,'visible','off');
    set(handles.ButtonDelete,'visible','off');
    set(handles.ButtonCopy,'visible','off');
    %set(handles.ButtonApply,'visible','off');
    
end

if TheSelMin > 0
    set(handles.ButtonDefine,'visible','on');
else
    set(handles.ButtonDefine,'visible','off');
    set(handles.ButtonApply,'visible','off');
end

guidata(hObject,handles);
return


function EditMin_Callback(hObject, eventdata, handles)
CorrMatrix = handles.CorrMatrix;

TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;

CMin = str2num(get(handles.EditMin,'String'));
CMax = str2num(get(handles.EditMax,'String'));
if CMin < CMax
    axes(handles.axes3)
    caxis([CMin,CMax]);
    if CorrMatrix(TheSelEl,TheSelMin+1)
        axes(handles.axes4)
        caxis([CMin,CMax]);
    end
    drawnow
end
return



% --- Executes during object creation, after setting all properties.
function EditMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditMax_Callback(hObject, eventdata, handles)
EditMin_Callback(hObject, eventdata, handles)
return

% --- Executes during object creation, after setting all properties.
function EditMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function PopUpMenu2_Callback(hObject, eventdata, handles)
PlotImages(hObject, eventdata, handles)
return



% --- Executes during object creation, after setting all properties.
function PopUpMenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PopUpMenu1.
function PopUpMenu1_Callback(hObject, eventdata, handles)
PlotImages(hObject, eventdata, handles)
return


% --- Executes during object creation, after setting all properties.
function PopUpMenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpMenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonAuto.
function ButtonAuto_Callback(hObject, eventdata, handles)

lesInd = get(handles.axes3,'child');
for i=1:length(lesInd)
    if length(get(lesInd(i),'type')) == 5 % image 
        AADonnees = get(lesInd(i),'CData');
        break
    else
        AADonnees = [];
    end
end

Triee = sort(AADonnees(:));
for i=1:length(Triee)
	if Triee(i) > 0 % defined
    	break 
    end
end
NTriee = Triee(i:end);

Val = round(length(NTriee) * 0.065); 

axes(handles.axes3)
if Val > 1
    if NTriee(Val) < NTriee(length(NTriee)-Val)
        % V1.4.2 sans caxis
        set(handles.axes3,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        %caxis([NTriee(Val),NTriee(length(NTriee)-Val)]);
    end
else
    return % no posibility to update (size  = 0)
end

set(handles.EditMax,'String',num2str(NTriee(length(NTriee)-Val)));
set(handles.EditMin,'String',num2str(NTriee(Val)));

CorrMatrix = handles.CorrMatrix;
TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;

if CorrMatrix(TheSelEl,TheSelMin+1)
	set(handles.axes4,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
end

guidata(hObject,handles);
return


% --- Executes on button press in ButtonDefine.
function ButtonDefine_Callback(hObject, eventdata, handles)

%
Data = handles.Data;
MaskFile = handles.MaskFile;

TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;


if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

Xray = Data(TheSelEl).values .* TheMask;
Topo = Data(handles.WhereIsTopo).values .* TheMask;

Xall = Topo(find(Topo));
Yall = Xray(find(Topo));

axes(handles.axes1), hold on

for i=1:2
    switch i
        case 1
            title('Define the first point')
        case 2
            title('Define the second point')
    end
    drawnow
    [X(i),Y(i)] = ginput(1);
    plot(X(i),Y(i),'or')
end
title('...')

p = polyfit(X,Y,1);
 
xi = [min(Xall):max(Xall)];
yfitP =  p(1) * xi + p(2);

plot(xi,yfitP,'-r')

a = p(1);
b = p(2);

Ycorr = Yall - a*Xall;

axes(handles.axes2)
plot(Xall,Ycorr,'.k','markersize',1)
xlabel('TOPO intensity');
ylabel(['corrected ',char(Data(TheSelEl).name),' intensity'])

TheAxis = axis;

if min(Ycorr(:)) < 0
    hold on
    plot([TheAxis(1),TheAxis(2)],[0,0],'--r','Linewidth',2)
end

axes(handles.axes4)
imagesc(Xray - a*Topo), axis image, colorbar horizontal
set(gca,'XTick',[],'YTick',[]);
title(['corrected ',char(Data(TheSelEl).name)]) 

% We save the results...
handles.CorrMatrix(TheSelEl,TheSelMin+1) = a;
handles.OrdoMatrix(TheSelEl,TheSelMin+1) = b;

set(handles.TextA,'visible','on','String',num2str(a));

set(handles.ButtonCopy,'visible','on');
set(handles.ButtonDelete,'visible','on');
set(handles.ButtonCloseApply,'visible','on');
set(handles.ButtonCloseCancel,'visible','on');

guidata(hObject,handles);
return


% --- Executes on button press in ButtonCopy.
function ButtonCopy_Callback(hObject, eventdata, handles)

TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;

CorrMatrix = handles.CorrMatrix;
a = CorrMatrix(TheSelEl,TheSelMin+1);

handles.copy = a;

set(handles.ButtonApply,'visible','on');

guidata(hObject,handles);
return


% --- Executes on button press in ButtonApply.
function ButtonApply_Callback(hObject, eventdata, handles)
Data = handles.Data;
MaskFile = handles.MaskFile;

TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;


if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

Xray = Data(TheSelEl).values .* TheMask;
Topo = Data(handles.WhereIsTopo).values .* TheMask;

Xall = Topo(find(Topo));
Yall = Xray(find(Topo));

a = handles.copy;

Ycorr = Yall - a*Xall;

axes(handles.axes2); cla
plot(Xall,Ycorr,'.k','markersize',1)

axes(handles.axes4); cla
imagesc(Xray - a*Topo), axis image, colorbar horizontal

% We save the results...
handles.CorrMatrix(TheSelEl,TheSelMin+1) = a;
handles.OrdoMatrix(TheSelEl,TheSelMin+1) = 1;

set(handles.TextA,'visible','on','String',num2str(a));

%set(handles.ButtonCopy,'visible','on');

guidata(hObject,handles);
PlotImages(hObject, eventdata, handles);
return


% --- Executes on button press in ButtonDelete.
function ButtonDelete_Callback(hObject, eventdata, handles)
Data = handles.Data;
MaskFile = handles.MaskFile;

TheSelEl = get(handles.PopUpMenu1,'Value');
TheSelMin = get(handles.PopUpMenu2,'Value')-1;

% We save the results...
handles.CorrMatrix(TheSelEl,TheSelMin+1) = 0;
handles.OrdoMatrix(TheSelEl,TheSelMin+1) = 0;

guidata(hObject,handles);
PlotImages(hObject, eventdata, handles);
return


% --- Executes on button press in ButtonCloseApply.
function ButtonCloseApply_Callback(hObject, eventdata, handles)


ButtonName = questdlg({'Would you like to apply the corrections to X-ray maps','This is an irreversible process'}, 'TRC', 'Yes');

switch ButtonName
    
    case 'Yes'
        handles.output1 = handles.CorrMatrix;
        handles.output2 = handles.OrdoMatrix;
        handles.output3 = 1;
        
        guidata(hObject, handles);
        close(handles.gcf);
        
    case 'No'
        handles.output1 = handles.CorrMatrix;
        handles.output2 = handles.OrdoMatrix;
        handles.output3 = 0;
        
        guidata(hObject, handles);
        close(handles.gcf);

    case 'Cancel'
        return
end

return


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
return


% --- Executes on button press in ButtonCloseCancel.
function ButtonCloseCancel_Callback(hObject, eventdata, handles)

handles.output1 = handles.CorrMatrix;
handles.output2 = handles.OrdoMatrix;
handles.output3 = 0;

guidata(hObject, handles);
close(handles.gcf);
return
