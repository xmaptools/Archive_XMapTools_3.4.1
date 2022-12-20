function varargout = VER_XMTModRGB_804(varargin)
% VER_XMTMODRGB_804 MATLAB code for VER_XMTModRGB_804.fig
%      VER_XMTMODRGB_804, by itself, creates a new VER_XMTMODRGB_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODRGB_804 returns the handle to a new VER_XMTMODRGB_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODRGB_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODRGB_804.M with the given input arguments.
%
%      VER_XMTMODRGB_804('Property','Value',...) creates a new VER_XMTMODRGB_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModRGB_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModRGB_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModRGB_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModRGB_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModRGB_804_OutputFcn, ...
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


% --- Executes just before VER_XMTModRGB_804 is made visible.
function VER_XMTModRGB_804_OpeningFcn(hObject, eventdata, handles, varargin)
%


% - - - Data organisation - - -
for i=1:length(varargin)-4
    Data(i).values = varargin{i}(:);
    Data(i).label = varargin{end-3}(i);
    Labels(i) = Data(i).label;
    Data(i).reshape = varargin{end-2};
end

% - - - Variable save - - -
handles.Data = Data;
handles.LocBase = char(varargin{end-1});

PositionXMapTools = varargin{end};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.9,0.9]);

set(gcf,'Position',PositionGui);

guidata(hObject, handles);

% - - - Update GUI - - -
axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

for i=1:length(Data)
    ListName{i} = char(Data(i).label);
end
set(handles.Menu_R,'String',ListName,'Value',1);
set(handles.Menu_G,'String',ListName,'Value',2);
set(handles.Menu_B,'String',ListName,'Value',3);

IndR = get(handles.Menu_R,'Value');
IndG = get(handles.Menu_G,'Value');
IndB = get(handles.Menu_B,'Value');

ThePosR = find(Data(IndR).values > 0);
MinR = min(Data(IndR).values(ThePosR));
MaxR = max(Data(IndR).values(ThePosR));

set(handles.Min_R,'String',num2str(MinR));
set(handles.Max_R,'String',num2str(MaxR));

ThePosG = find(Data(IndG).values > 0);
MinG = min(Data(IndG).values(ThePosG));
MaxG = max(Data(IndG).values(ThePosG));

set(handles.Min_G,'String',num2str(MinG));
set(handles.Max_G,'String',num2str(MaxG));

ThePosB = find(Data(IndB).values > 0);
MinB = min(Data(IndB).values(ThePosB));
MaxB = max(Data(IndB).values(ThePosB));

set(handles.Min_B,'String',num2str(MinB));
set(handles.Max_B,'String',num2str(MaxB));



guidata(hObject, handles);

% - - - Update PLOTS - - -
UpdatePlot(hObject, eventdata, handles);



% Choose default command line output for VER_XMTModRGB_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTModRGB_804 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModRGB_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function UpdatePlot(hObject, eventdata, handles)
%

Data = handles.Data;

IndR = get(handles.Menu_R,'Value');
IndG = get(handles.Menu_G,'Value');
IndB = get(handles.Menu_B,'Value');

MinR = str2num(get(handles.Min_R,'String'));
MaxR = str2num(get(handles.Max_R,'String'));

if MinR < 0 || MinR >= MaxR
    ThePosR = find(Data(IndR).values > 0);
    MinR = min(Data(IndR).values(ThePosR));
    MaxR = max(Data(IndR).values(ThePosR));
    
    set(handles.Min_R,'String',num2str(MinR));
    set(handles.Max_R,'String',num2str(MaxR));
end

MinG = str2num(get(handles.Min_G,'String'));
MaxG = str2num(get(handles.Max_G,'String'));

if MinG < 0 || MinG >= MaxG
    ThePosG = find(Data(IndG).values > 0);
    MinG = min(Data(IndG).values(ThePosG));
    MaxG = max(Data(IndG).values(ThePosG));

    set(handles.Min_G,'String',num2str(MinG));
    set(handles.Max_G,'String',num2str(MaxG));
end

MinB = str2num(get(handles.Min_B,'String'));
MaxB = str2num(get(handles.Max_B,'String'));

if MinB < 0 || MinB >= MaxB
    ThePosB = find(Data(IndB).values > 0);
    MinB = min(Data(IndB).values(ThePosB));
    MaxB = max(Data(IndB).values(ThePosB));

    set(handles.Min_B,'String',num2str(MinB));
    set(handles.Max_B,'String',num2str(MaxB));
end

SelR = find(Data(IndR).values >= MinR & Data(IndR).values <= MaxR);
SelG = find(Data(IndG).values >= MinG & Data(IndG).values <= MaxG);
SelB = find(Data(IndB).values >= MinB & Data(IndB).values <= MaxB);

SatR = find(Data(IndR).values > MaxR);
SatG = find(Data(IndG).values > MaxG);
SatB = find(Data(IndB).values > MaxB);
 
axes(handles.Axe_R)
hist(Data(IndR).values(SelR),30); drawnow
if get(handles.Log1,'Value')
    % Get histogram patches
    ph = get(gca,'children');
    % Determine number of histogram patches
    N_patches = length(ph);
    for i = 1:N_patches
          % Get patch vertices
          vn = get(ph(i),'Vertices');
          % Adjust y location
          vn(:,2) = vn(:,2) + 1;
          % Reset data
          set(ph(i),'Vertices',vn)
    end
    % Change scale    
    set(gca,'YScale','Log')
else
    set(gca,'YScale','Linear')
end

axes(handles.Axe_G)
hist(Data(IndG).values(SelG),30); drawnow
if get(handles.Log2,'Value')
    % Get histogram patches
    ph = get(gca,'children');
    % Determine number of histogram patches
    N_patches = length(ph);
    for i = 1:N_patches
          % Get patch vertices
          vn = get(ph(i),'Vertices');
          % Adjust y location
          vn(:,2) = vn(:,2) + 1;
          % Reset data
          set(ph(i),'Vertices',vn)
    end
    % Change scale    
    set(gca,'YScale','Log')
else
    set(gca,'YScale','Linear')
end

axes(handles.Axe_B)
hist(Data(IndB).values(SelB),30); drawnow
if get(handles.Log3,'Value')
    % Get histogram patches
    ph = get(gca,'children');
    % Determine number of histogram patches
    N_patches = length(ph);
    for i = 1:N_patches
          % Get patch vertices
          vn = get(ph(i),'Vertices');
          % Adjust y location
          vn(:,2) = vn(:,2) + 1;
          % Reset data
          set(ph(i),'Vertices',vn)
    end
    % Change scale    
    set(gca,'YScale','Log')
else
    set(gca,'YScale','Linear')
end


RedChannel = zeros(Data(1).reshape);
GreenChannel = zeros(Data(1).reshape);
BlueChannel = zeros(Data(1).reshape);

RedChannel(SelR) = Data(IndR).values(SelR)./MaxR;
GreenChannel(SelG) = Data(IndG).values(SelG)./MaxG;
BlueChannel(SelB) = Data(IndB).values(SelB)./MaxB;
 
% SATURATION
if get(handles.ApplySat,'Value')
    RedChannel([SatR;SatG;SatB]) = ones(size([SatR;SatG;SatB]));
    GreenChannel([SatR;SatG;SatB]) = ones(size([SatR;SatG;SatB]));
    BlueChannel([SatR;SatG;SatB]) = ones(size([SatR;SatG;SatB]));
end 

RgbImage = cat(3, RedChannel, GreenChannel, BlueChannel);
axes(handles.Axe_RGB), 
image(RgbImage)
axis image
set(gca,'visible','off');

%imshow(RgbImage);



PlotTriangle(hObject, eventdata, handles);
return



function PlotTriangle(hObject, eventdata, handles)
%

Nb=100;
Step = (1-0)/(Nb);

RiS = ones(Nb+1,Nb+1);
BiS = ones(Nb+1,Nb+1);
GiS = ones(Nb+1,Nb+1);

for i = 1:Nb+1
    RiS(i,1:i) = (1-(i-1)*Step).*ones(size(RiS(i,1:i)));
    BiS(i:end,i) = (0+(i-1)*Step)*ones(size(BiS(i:end,i)));
    GiS(i:end,i) = [0:Step:(Nb+1-i)*Step]';
end

Fac = 2;

Ri = ones(Fac*(Nb+1),Fac*(Nb+1));
Bi = ones(Fac*(Nb+1),Fac*(Nb+1));
Gi = ones(Fac*(Nb+1),Fac*(Nb+1));

Where = round(Nb/Fac+1);

Ri(Where:Where+Nb,Where:Where+Nb) = RiS;
Bi(Where:Where+Nb,Where:Where+Nb) = BiS;
Gi(Where:Where+Nb,Where:Where+Nb) = GiS;

RgbImage = cat(3, Ri, Gi, Bi);
axes(handles.Axe_Leg); cla
image(RgbImage); set(gca,'visible','off'); hold on
%imshow(RgbImage,'Border','loose'); hold on

plot([(Nb+2)/Fac,(Nb+2)/Fac],[(Nb+2)/Fac,Nb+(Nb+2)/Fac],'k','LineWidth',1)
plot([(Nb+2)/Fac,Nb+(Nb+2)/Fac],[(Nb+2)/Fac,Nb+(Nb+2)/Fac],'k','LineWidth',1)
plot([(Nb+2)/Fac,Nb+(Nb+2)/Fac],[Nb+(Nb+2)/Fac,Nb+(Nb+2)/Fac],'k','LineWidth',1)

plot((Nb+2)/Fac,(Nb+2)/Fac,'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',4);
plot((Nb+2)/Fac,Nb+(Nb+2)/Fac,'o','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',4);
plot(Nb+(Nb+2)/Fac,Nb+(Nb+2)/Fac,'o','MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',4);

plot([1,1],[1,Fac*(Nb+1)],'k','LineWidth',1)
plot([1,Fac*(Nb+1)],[1,1],'k','LineWidth',1)
plot([Fac*(Nb+1),Fac*(Nb+1)],[0,Fac*(Nb+1)],'k','LineWidth',1)
plot([1,Fac*(Nb+1)],[Fac*(Nb+1),Fac*(Nb+1)],'k','LineWidth',1)

IndR = get(handles.Menu_R,'Value');
IndG = get(handles.Menu_G,'Value');
IndB = get(handles.Menu_B,'Value');

hR = text(Nb/Fac,Nb/Fac-0.15*Nb,handles.Data(IndR).label);
set(hR,'FontName','Times New Roman','HorizontalAlignment','Center');

hG = text(Nb/Fac,Nb+Nb/Fac+0.15*Nb,handles.Data(IndG).label);
set(hG,'FontName','Times New Roman','HorizontalAlignment','Center');

hB = text(Nb+Nb/Fac+0.15*Nb,Nb+Nb/Fac+0.15*Nb,handles.Data(IndB).label);
set(hB,'FontName','Times New Roman','HorizontalAlignment','Center');



% Ri = [ ...
% 1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .9,.9,1.,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .8,.8,.8,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .7,.7,.7,.7,1.,1.,1.,1.,1.,1.,1. ; ...
% .6,.6,.6,.6,.6,1.,1.,1.,1.,1.,1. ; ...
% .5,.5,.5,.5,.5,.5,1.,1.,1.,1.,1. ; ...
% .4,.4,.4,.4,.4,.4,.4,1.,1.,1.,1. ; ...
% .3,.3,.3,.3,.3,.3,.3,.3,1.,1.,1. ; ...
% .2,.2,.2,.2,.2,.2,.2,.2,.2,1.,1. ; ...
% .1,.1,.1,.1,.1,.1,.1,.1,.1,.1,1. ; ...
% .0,.0,.0,.0,.0,.0,.0,.0,.0,.0,0];
% 
% Bi = [ ...
% .0,1.,1.,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .0,.1,1.,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .0,.1,.2,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .0,.1,.2,.3,1.,1.,1.,1.,1.,1.,1. ; ...
% .0,.1,.2,.3,.4,1.,1.,1.,1.,1.,1. ; ...
% .0,.1,.2,.3,.4,.5,1.,1.,1.,1.,1. ; ...
% .0,.1,.2,.3,.4,.5,.6,1.,1.,1.,1. ; ...
% .0,.1,.2,.3,.4,.5,.6,.7,1.,1.,1. ; ...
% .0,.1,.2,.3,.4,.5,.6,.7,.8,1.,1. ; ...
% .0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1. ; ...
% .0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1];
% 
% 
% Gi = [ ...
% .0,1.,1.,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .1,.0,1.,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .2,.1,.0,1.,1.,1.,1.,1.,1.,1.,1. ; ...
% .3,.2,.1,.0,1.,1.,1.,1.,1.,1.,1. ; ...
% .4,.3,.2,.1,.0,1.,1.,1.,1.,1.,1. ; ...
% .5,.4,.3,.2,.1,.0,1.,1.,1.,1.,1. ; ...
% .6,.5,.4,.3,.2,.1,.0,1.,1.,1.,1. ; ...
% .7,.6,.5,.4,.3,.2,.1,.0,1.,1.,1. ; ...
% .8,.7,.6,.5,.4,.3,.2,.1,.0,1.,1. ; ...
% .9,.8,.7,.6,.5,.4,.3,.2,.1,.0,1. ; ...
% 1.,.9,.8,.7,.6,.5,.4,.3,.2,.1,0];

return



% --- Executes on selection change in Menu_R.
function Menu_R_Callback(hObject, eventdata, handles)
%

Data = handles.Data;

IndR = get(handles.Menu_R,'Value');

ThePosR = find(Data(IndR).values > 0);
MinR = min(Data(IndR).values(ThePosR));
MaxR = max(Data(IndR).values(ThePosR));

set(handles.Min_R,'String',num2str(MinR));
set(handles.Max_R,'String',num2str(MaxR));

UpdatePlot(hObject, eventdata, handles)
return

% --- Executes during object creation, after setting all properties.
function Menu_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_R_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Min_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_R_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Max_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Auto_R.
function Auto_R_Callback(hObject, eventdata, handles)
%
Data = handles.Data;

IndR = get(handles.Menu_R,'Value');

TheMap = Data(IndR).values;

Triee = sort(TheMap(:));
for i=1:length(Triee)
    if Triee(i) > 0 % defined
        break 
    end
end
NTriee = Triee(i:end);

Val = round(length(NTriee) * 0.065); % voir avec une detection du pic.

MinR = NTriee(Val);
MaxR = NTriee(length(NTriee)-Val);

set(handles.Min_R,'String',num2str(MinR));
set(handles.Max_R,'String',num2str(MaxR));

guidata(hObject, handles);
UpdatePlot(hObject, eventdata, handles);
return


% --- Executes on selection change in Menu_G.
function Menu_G_Callback(hObject, eventdata, handles)
%

Data = handles.Data;

IndG = get(handles.Menu_G,'Value');

ThePosG = find(Data(IndG).values > 0);
MinG = min(Data(IndG).values(ThePosG));
MaxG = max(Data(IndG).values(ThePosG));

set(handles.Min_G,'String',num2str(MinG));
set(handles.Max_G,'String',num2str(MaxG));

UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Menu_G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_G_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Min_G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_G_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Max_G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Auto_G.
function Auto_G_Callback(hObject, eventdata, handles)
%
Data = handles.Data;

IndG = get(handles.Menu_G,'Value');

TheMap = Data(IndG).values;

Triee = sort(TheMap(:));
for i=1:length(Triee)
    if Triee(i) > 0 % defined
        break 
    end
end
NTriee = Triee(i:end);

Val = round(length(NTriee) * 0.065); % voir avec une detection du pic.

MinG = NTriee(Val);
MaxG = NTriee(length(NTriee)-Val);

set(handles.Min_G,'String',num2str(MinG));
set(handles.Max_G,'String',num2str(MaxG));

guidata(hObject, handles);
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes on selection change in Menu_B.
function Menu_B_Callback(hObject, eventdata, handles)
%

Data = handles.Data;

IndB = get(handles.Menu_B,'Value');

ThePosB = find(Data(IndB).values > 0);
MinB = min(Data(IndB).values(ThePosB));
MaxB = max(Data(IndB).values(ThePosB));

set(handles.Min_B,'String',num2str(MinB));
set(handles.Max_B,'String',num2str(MaxB));

UpdatePlot(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function Menu_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_B_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Min_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_B_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Max_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Auto_B.
function Auto_B_Callback(hObject, eventdata, handles)
%

Data = handles.Data;

IndB = get(handles.Menu_B,'Value');

TheMap = Data(IndB).values;

Triee = sort(TheMap(:));
for i=1:length(Triee)
    if Triee(i) > 0 % defined
        break 
    end
end
NTriee = Triee(i:end);

Val = round(length(NTriee) * 0.065); % voir avec une detection du pic.

MinB = NTriee(Val);
MaxB = NTriee(length(NTriee)-Val);

set(handles.Min_B,'String',num2str(MinB));
set(handles.Max_B,'String',num2str(MaxB));

guidata(hObject, handles);
UpdatePlot(hObject, eventdata, handles);
return


% --- Executes on button press in ApplySat.
function ApplySat_Callback(hObject, eventdata, handles)
%
UpdatePlot(hObject, eventdata, handles)
return


% --- Executes on button press in ExportFigures.
function ExportFigures_Callback(hObject, eventdata, handles)


axes(handles.Axe_RGB)

lesInd = get(handles.Axe_RGB,'child');

CLim = get(handles.Axe_RGB,'CLim');
YDir = get(handles.Axe_RGB,'YDir');

axes(handles.Axe_Leg)

lesInd2 = get(handles.Axe_Leg,'child');

CLim2 = get(handles.Axe_Leg,'CLim');
YDir2 = get(handles.Axe_Leg,'YDir');

figure;
hold on

% On trace d'abord les images...
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            imagesc(get(lesInd(i),'CData')), axis image
        end
    end
    
end


% ensuite les lignes
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end

% puis les textes
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 4
        if leType == 'text'
            LaPosition = get(lesInd(i),'Position');
            LeTxt = text(LaPosition(1),LaPosition(2),get(lesInd(i),'String'));
            set(LeTxt,'Color',get(lesInd(i),'Color'),'BackgroundColor',get(lesInd(i),'BackgroundColor'), ...
                'FontName',get(lesInd(i),'FontName'),'FontSize',get(lesInd(i),'FontSize'));
        end
    end
end

set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)

% Scale bar VER_XMapTools_750 2.1.1
LimitsMap = axis;

if LimitsMap(2) > 170

    plot([20 120],[LimitsMap(4)+40 LimitsMap(4)+40],'-k','linewidth',4);

    text(40,LimitsMap(4)+20,'100 px')

    if LimitsMap(2) > 350
        text(140,LimitsMap(4)+18,'XMapTools')
        text(140,LimitsMap(4)+42,datestr(clock))
    else
        %text(140,LimitsMap(4)+30,'VER_XMapTools_750')
    end

    plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(4),LimitsMap(4)],'k','linewidth',1);
    plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(3),LimitsMap(3)],'k','linewidth',1);

    axis([LimitsMap(1) LimitsMap(2) LimitsMap(3) LimitsMap(4)+60]);
end


figure,
hold on 

% On trace d'abord les images...
for i=1:length(lesInd2)
    leType = get(lesInd2(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            imagesc(get(lesInd2(i),'CData')), axis image
        end
    end
    
end


% ensuite les lignes
for i=1:length(lesInd2)
    leType = get(lesInd2(i),'Type');
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd2(i),'XData'),get(lesInd2(i),'YData'),'Marker',get(lesInd2(i),'Marker'),'Color',get(lesInd2(i),'Color'),'LineStyle',get(lesInd2(i),'LineStyle'),'LineWidth',get(lesInd2(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd2(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd2(i),'MarkerFaceColor'),'Markersize',get(lesInd2(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end

% puis les textes
for i=1:length(lesInd2)
    leType = get(lesInd2(i),'Type');
    if length(leType) == 4
        if leType == 'text'
            LaPosition = get(lesInd2(i),'Position');
            LeTxt = text(LaPosition(1),LaPosition(2),get(lesInd2(i),'String'));
            set(LeTxt,'Color',get(lesInd2(i),'Color'),'BackgroundColor',get(lesInd2(i),'BackgroundColor'), ...
                'FontName',get(lesInd2(i),'FontName'),'FontSize',get(lesInd2(i),'FontSize'));
        end
    end
end

set(gca,'CLim',CLim2);
set(gca,'YDir',YDir2);
set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)

return


% --- Executes on button press in Log1.
function Log1_Callback(hObject, eventdata, handles)
UpdatePlot(hObject, eventdata, handles)


% --- Executes on button press in Log2.
function Log2_Callback(hObject, eventdata, handles)
UpdatePlot(hObject, eventdata, handles)


% --- Executes on button press in Log3.
function Log3_Callback(hObject, eventdata, handles)
UpdatePlot(hObject, eventdata, handles)
