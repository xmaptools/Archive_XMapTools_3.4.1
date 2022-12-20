function varargout = VER_XMTStandardizationTool_804(varargin)
% VER_XMTSTANDARDIZATIONTOOL_804 MATLAB code for VER_XMTStandardizationTool_804.fig
%      VER_XMTSTANDARDIZATIONTOOL_804, by itself, creates a new VER_XMTSTANDARDIZATIONTOOL_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTSTANDARDIZATIONTOOL_804 returns the handle to a new VER_XMTSTANDARDIZATIONTOOL_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTSTANDARDIZATIONTOOL_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTSTANDARDIZATIONTOOL_804.M with the given input arguments.
%
%      VER_XMTSTANDARDIZATIONTOOL_804('Property','Value',...) creates a new VER_XMTSTANDARDIZATIONTOOL_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTStandardizationTool_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTStandardizationTool_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTStandardizationTool_804

% Last Modified by GUIDE v2.5 18-Jul-2019 08:27:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTStandardizationTool_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTStandardizationTool_804_OutputFcn, ...
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


% --- Executes just before VER_XMTStandardizationTool_804 is made visible.
function VER_XMTStandardizationTool_804_OpeningFcn(hObject, eventdata, handles, varargin)
% 

handles.Data = varargin{1};
handles.Quanti = varargin{2};
handles.Profils = varargin{3};
handles.LesRefsPro = varargin{4};
handles.LesRefsCarte = varargin{5};
handles.SelectionMap = varargin{6};
handles.LesNomsOxydes = varargin{7};
handles.MaskValues = varargin{8};
handles.StandardizationParameters = varargin{9};
handles.LocBase = varargin{10};
handles.ColorMap = varargin{11};
PositionXMapTools = varargin{12};

handles.WeClose = 0;

handles.LaBonnePlace = length(handles.Quanti);

guidata(hObject, handles);


% Calculate a first standardization for every element
handles.Quanti = InitAutomatedStandardization(hObject, eventdata, handles);
guidata(hObject, handles);

% Update the Menu
UpdateMenuNames(hObject, eventdata, handles);
guidata(hObject, handles);

% Logo
axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');
zoom off

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.8,0.92]);

set(gcf,'Position',PositionGui);

% Call the function to display the first standardization...
PopUpElems_Callback(hObject, eventdata, handles);

handles.gcf = gcf;

% Choose default command line output for VER_XMTStandardizationTool_804
handles.output = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTStandardizationTool_804 wait for user response (see UIRESUME)
uiwait(handles.figure1);
return


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTStandardizationTool_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output1;
% 
%  
% delete(hObject);

if isempty(handles)
    varargout{1} = 0;
else
    varargout{1} = handles.output1;
    
    delete(hObject);
end



return

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% if isequal(get(hObject, 'waitstatus'),'waiting')
%     uiresume(hObject);
% else
%     delete(hObject);
% end

if isequal(handles.WeClose,0)
    if isequal(get(hObject, 'waitstatus'),'waiting')
    
        handles.output = 0;

        guidata(hObject, handles);

        uiresume(hObject);
        delete(hObject);
    else
        delete(hObject);
    end
else
    if isequal(get(hObject, 'waitstatus'),'waiting')
        uiresume(hObject);
    else
        delete(hObject);
    end
end

return 


% --- Executes on button press in DONE.
function DONE_Callback(hObject, eventdata, handles)
%

LaBonnePlace = handles.LaBonnePlace;
Quanti = handles.Quanti(LaBonnePlace);


% Ask to save the quanti_file:
%ButtonName = questdlg('Would you like to export the standardization parameters?','XMapTools','Yes','No','Yes');

ButtonName = 'Yes';

switch ButtonName
    case 'Yes'
        
        TheDate = datestr(now);
        WhereSpaces = find(TheDate == ' ');
        for i=1:length(WhereSpaces)
            TheDate(WhereSpaces(i)) = '_';
        end
        WhereGood = find(TheDate ~= '-' & TheDate ~= ':');
        TheDate4Name = TheDate(WhereGood);
        
        NameMin = char(Quanti.mineral);
        WhereSpaces = find(NameMin == ' ');
        for i=1:length(WhereSpaces)
            NameMin(WhereSpaces(i)) = '_';
        end
        WhereDash = find(NameMin == '-');
        for i=1:length(WhereDash)
            NameMin(WhereDash(i)) = '_';
        end
        
        NameFile = [NameMin,'_',TheDate4Name,'.txt'];
        
        [Success,Message,MessageID] = mkdir('Standardization');

        %cd Standardization
        %[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export Standardization file as',NameFile);
        %cd ..
        
        %if isequal(pathname,0)
        %    return
        %end
        
        fid = fopen([cd,'/Standardization/',NameFile],'w');
        
        fprintf(fid,'%s\n','########################################');
        fprintf(fid,'%s\n','## Standardization file for XMapTools ##');
        fprintf(fid,'%s\n\n','########################################');
        
        fprintf(fid,'%s\n\n','Case sensitive: DO NOT EDIT this file!');
        
        fprintf(fid,'%s\n\n',TheDate);
        
        fprintf(fid,'%s\t%s\n','>>',char(Quanti.mineral));
        
        for i=1:length(Quanti.elem)
            fprintf(fid,'%s\n','----');
            fprintf(fid,'%s%s%s\t%s\t%s\n','#',num2str(i),'#',char(Quanti.elem(i).name),num2str(Quanti.elem(i).ref));
 
            fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','OK','Std','Back.','X_calib','Y_calib');
            fprintf(fid,'%.0f\t%.0f\t%.0f\t%f\t%f\n',Quanti.elem(i).Standardization,Quanti.elem(i).StandardizationType,Quanti.elem(i).BackgroundValue,Quanti.elem(i).param(1),Quanti.elem(i).param(2));
            fprintf(fid,'%s\t','Selected:');
            for j=1:length(Quanti.elem(i).Selected)
                fprintf(fid,'%f\t',Quanti.elem(i).Selected(j));
            end
            fprintf(fid,'\n%s\t','OxideWt%:');
            for j=1:length(Quanti.elem(i).Ox)
                fprintf(fid,'%f\t',Quanti.elem(i).Ox(j));
            end
            fprintf(fid,'\n%s\t','Intensity:');
            for j=1:length(Quanti.elem(i).Ra)
                fprintf(fid,'%f\t',Quanti.elem(i).Ra(j));
            end
            fprintf(fid,'\n%s\t','Int_Unc:');
            for j=1:length(Quanti.elem(i).RaUnc)
                fprintf(fid,'%f\t',Quanti.elem(i).RaUnc(j));
            end
            fprintf(fid,'\n');
        end
        fclose(fid);
end 

handles.output1 = handles.Quanti;

handles.WeClose = 1;

guidata(hObject, handles);
close(handles.gcf);


return



function UpdateMenuNames(hObject, eventdata, handles)
% 

Quanti = handles.Quanti;
LaBonnePlace = handles.LaBonnePlace;

UserChecked = ones(size(handles.SelectionMap));

SelectedMenu = get(handles.PopUpElems,'Value');

% Update the menu...
for i=1:length(handles.SelectionMap)
    
    Type = Quanti(LaBonnePlace).elem(i).StandardizationType;
    
    Part1 = char(handles.Data.map(handles.SelectionMap(i)).name);
    
    switch Type
        case -1
            Part2 = '"No standard"';
            Part3 = '**NA**';
            if isequal(i,SelectedMenu)
                set(handles.ButtonRejectOutlier,'Enable','off');
            end
        case 0
            Part2 = '"Not checked"';
            Part3 = '**??**';
            
            UserChecked(i) = 0;
            if isequal(i,SelectedMenu)
                set(handles.ButtonRejectOutlier,'Enable','off');
            end
            
        case 1  % Automated
            Part2 = '"Automated (no correction)"';
            Part3 = '**OK**';
            if isequal(i,SelectedMenu)
                set(handles.ButtonRejectOutlier,'Enable','on');
            end
        case 2  % Automated with background
            Part2 = '"Automated (with background correction)"';
            Part3 = '**OK**';
            if isequal(i,SelectedMenu)
                set(handles.ButtonRejectOutlier,'Enable','on');
            end
        case 3  % Manual
            Part2 = '"Manual"';
            Part3 = '**OK**';
            if isequal(i,SelectedMenu)
                set(handles.ButtonRejectOutlier,'Enable','on');
            end
    end
    
    NamesMapsSel{i} = [Part1,'   ',Part2,'   ',Part3];
end

set(handles.PopUpElems,'String',NamesMapsSel);

if isequal(length(UserChecked),sum(UserChecked))
    set(handles.DONE,'Enable','On');
else
    set(handles.DONE,'Enable','Off');
end

guidata(hObject, handles);
return



function Quanti = InitAutomatedStandardization(hObject, eventdata, handles)
% 

LesRefsCarte = handles.LesRefsCarte;
LaBonnePlace = handles.LaBonnePlace;

for i=1:length(LesRefsCarte)
    handles = AutomatedInitiateStandardization(i,handles,hObject);
end

% Prepare the files for the first plot...
SelElem = 1;
Quanti = TryAutomatedBackgroundCorrection(handles.Quanti,LaBonnePlace,SelElem,0,1,handles);

% Plot the residuals of the best solution...
%axes(handles.axes3)
%hist(Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsBestSol);

handles.Quanti = Quanti; 
guidata(hObject, handles);

return



function [handles] = AutomatedInitiateStandardization(SelElem,handles,hObject)

Data = handles.Data;
Quanti = handles.Quanti;
Profils = handles.Profils;
LesRefsPro = handles.LesRefsPro;
LesRefsCarte = handles.LesRefsCarte;
SelectionMap = handles.SelectionMap;
LaBonnePlace = handles.LaBonnePlace;
LesNomsOxydes = handles.LesNomsOxydes;
MaskValues = handles.MaskValues;


LaMap = LesRefsCarte(SelElem);
LePro = find(LesRefsPro == LaMap); % warning, empty cell if missmatch.

Quanti(LaBonnePlace).elem(SelElem).ref = LaMap;

Quanti(LaBonnePlace).elem(SelElem).name = LesNomsOxydes(SelElem); % yet sort

Quanti(LaBonnePlace).elem(SelElem).values = Profils.data(:,LePro);
Quanti(LaBonnePlace).elem(SelElem).coor = Profils.idxallpr;

for j=1:length(Quanti(LaBonnePlace).elem(SelElem).coor(:,1))
    Line = Quanti(LaBonnePlace).elem(SelElem).coor(j,2); % Y -> L
    Column = Quanti(LaBonnePlace).elem(SelElem).coor(j,1); % X -> C
    if Line && Column
        Quanti(LaBonnePlace).elem(SelElem).raw(j) = MaskValues(Line,Column) * Data.map(SelectionMap(SelElem)).values(Line,Column);
        Quanti(LaBonnePlace).elem(SelElem).values(j) = MaskValues(Line,Column) * Quanti(LaBonnePlace).elem(SelElem).values(j);
    else
        Quanti(LaBonnePlace).elem(SelElem).raw(j) = 0;
        Quanti(LaBonnePlace).elem(SelElem).values(j) = 0;
    end 
end

[Quanti(LaBonnePlace).elem(SelElem).Ox,Quanti(LaBonnePlace).elem(SelElem).Ra] = GenerateOxRa(Quanti,Profils,SelElem,LaBonnePlace);

Quanti(LaBonnePlace).elem(SelElem).Selected = ones(size(Quanti(LaBonnePlace).elem(SelElem).Ox));

Quanti(LaBonnePlace).elem(SelElem).RaUnc = Quanti(LaBonnePlace).elem(SelElem).Ra.*(2./sqrt(Quanti(LaBonnePlace).elem(SelElem).Ra));

Quanti(LaBonnePlace).elem(SelElem).param = [median(Quanti(LaBonnePlace).elem(SelElem).Ox),median(Quanti(LaBonnePlace).elem(SelElem).Ra)];

% CHECK THE PARAMS and move the point up (new XMapTools 2.4.1)
% Otherwise it crashes if y < 1;  
 if Quanti(LaBonnePlace).elem(SelElem).param(2) < 0
    Quanti(LaBonnePlace).elem(SelElem).param(2) = 1;
end

Quanti(LaBonnePlace).elem(SelElem).paramType = 1;

Quanti(LaBonnePlace).elem(SelElem).polyfit = polyfit(Quanti(LaBonnePlace).elem(SelElem).Ox,Quanti(LaBonnePlace).elem(SelElem).Ra,1);

Quanti(LaBonnePlace).elem(SelElem).polyfit(2) = round(Quanti(LaBonnePlace).elem(SelElem).polyfit(2));

polydata = polyval(Quanti(LaBonnePlace).elem(SelElem).polyfit,Quanti(LaBonnePlace).elem(SelElem).Ox);
sstot = sum((Quanti(LaBonnePlace).elem(SelElem).Ra - mean(Quanti(LaBonnePlace).elem(SelElem).Ra)).^2);
ssres = sum((Quanti(LaBonnePlace).elem(SelElem).Ra - polydata).^2);

Quanti(LaBonnePlace).elem(SelElem).R2 = 1 - (ssres / sstot);

Quanti(LaBonnePlace).elem(SelElem).warning = 0;
Quanti(LaBonnePlace).elem(SelElem).usepolyfit = 0;

if Quanti(LaBonnePlace).elem(SelElem).polyfit(2) < 1
    Quanti(LaBonnePlace).elem(SelElem).warning = 1;
end

MinOx = min(Quanti(LaBonnePlace).elem(SelElem).Ox);
MaxOx = max(Quanti(LaBonnePlace).elem(SelElem).Ox);

DeltaOx = MaxOx-MinOx;

if DeltaOx/MaxOx > handles.StandardizationParameters.PFIT && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) > 1 && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) < handles.StandardizationParameters.ICOT(2) && Quanti(LaBonnePlace).elem(SelElem).polyfit(1) > 0
    % We are going to use the polyfit value...
    Quanti(LaBonnePlace).elem(SelElem).usepolyfit = 1;
    X = MaxOx + handles.StandardizationParameters.PLOX * MaxOx;
    Quanti(LaBonnePlace).elem(SelElem).param = [X,Quanti(LaBonnePlace).elem(SelElem).polyfit(1) * X + Quanti(LaBonnePlace).elem(SelElem).polyfit(2)];
    Quanti(LaBonnePlace).elem(SelElem).paramType = 2;
else
    X = max(Quanti(LaBonnePlace).elem(SelElem).Ox);
end

Quanti(LaBonnePlace).elem(SelElem).plotX = [Quanti(LaBonnePlace).elem(SelElem).Ox;Quanti(LaBonnePlace).elem(SelElem).Ox];
Quanti(LaBonnePlace).elem(SelElem).plotY = [Quanti(LaBonnePlace).elem(SelElem).Ra-Quanti(LaBonnePlace).elem(SelElem).RaUnc;Quanti(LaBonnePlace).elem(SelElem).Ra+Quanti(LaBonnePlace).elem(SelElem).RaUnc];

Quanti(LaBonnePlace).elem(SelElem).plotXi = [0:0.0001:X];

Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals = [];

Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsFirstSol = [];
Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsBestSol = [];

Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = 0;

if Quanti(LaBonnePlace).elem(SelElem).usepolyfit
    Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = Quanti(LaBonnePlace).elem(SelElem).polyfit(2);
end

Quanti(LaBonnePlace).elem(SelElem).BackgroundMinResidualValue = 0;

if isequal(length(Quanti(LaBonnePlace).elem(SelElem).Ox),1) && isequal(Quanti(LaBonnePlace).elem(SelElem).Ox,0.0000001)
    Quanti(LaBonnePlace).elem(SelElem).Standardization = 0;
    Quanti(LaBonnePlace).elem(SelElem).StandardizationType = -1;
else
    Quanti(LaBonnePlace).elem(SelElem).Standardization = 1;
    Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 0;
end

handles.Quanti = Quanti; 
guidata(hObject, handles);

return



function PlotCorrection(hObject, eventdata, handles)
%

Quanti = handles.Quanti;
LaBonnePlace = handles.LaBonnePlace;
SelElem = get(handles.PopUpElems,'Value');

if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,-1)
    % Nothing to do here as we don't have standard values...
    axes(handles.axes1), cla
    axes(handles.axes2), cla
    %axes(handles.axes3), cla
    %axes(handles.axes4), cla
    axes(handles.axes7), cla
    return
end


if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,0)
    % Let's calculate if a background correcton is needed...
    % with outlier rejection (2.5.1) ...
    Quanti = TryAutomatedBackgroundCorrection(Quanti,LaBonnePlace,SelElem,1,1,handles);
    handles.Quanti = Quanti;
    guidata(hObject, handles);
end

SelectedStd = find(Quanti(LaBonnePlace).elem(SelElem).Selected);
UnSelectedStd = find(Quanti(LaBonnePlace).elem(SelElem).Selected == 0);

% CALIB POINT METHOD: 
if isequal(Quanti(LaBonnePlace).elem(SelElem).paramType,2)
    set(handles.Text_Calib,'String',['polyfit; ',num2str(length(find(UnSelectedStd))),' outlier(s) rejected'],'ForegroundColor',[1,0,1]);
else
    set(handles.Text_Calib,'String',['median; ',num2str(length(find(UnSelectedStd))),' outlier(s) rejected'],'ForegroundColor',[1,0,0]);
end


if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,0)
    
    
    set(handles.Text_BackMeth,'String','not checked','ForegroundColor',[0,0,0]);
    set(handles.Text_PolyfitR2,'String','not available');
    
    if Quanti(LaBonnePlace).elem(SelElem).usepolyfit || isequal(Quanti(LaBonnePlace).elem(SelElem).paramType,2)
        set(handles.Text_PolyfitR2,'String',num2str(Quanti(LaBonnePlace).elem(SelElem).R2));
    end
    
end



if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,1)
    
    Case = 1; % No background correction
    
    set(handles.Text_BackMeth,'String','no background correction','ForegroundColor',[0,0,0]);
    set(handles.Text_PolyfitR2,'String','not available');

elseif isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,2)
    
    if Quanti(LaBonnePlace).elem(SelElem).polyfit(1) > 0 && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) > 0 && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) < handles.StandardizationParameters.ICOT(2) %Quanti(LaBonnePlace).elem(SelElem).usepolyfit
        set(handles.Text_PolyfitR2,'String',num2str(Quanti(LaBonnePlace).elem(SelElem).R2));
    end
    
    % Which background correction is set later on ...
    
elseif isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
    
    Case = 10; % Manual Background Correction
    
    set(handles.Text_Calib,'String','manual mode','ForegroundColor',[0,.5,0]);
    
    set(handles.Text_BackMeth,'String','manual background correction');
    set(handles.Text_PolyfitR2,'String','not available');
end

drawnow

% [1] Plot the calibration ...
axes(handles.axes1), hold on

xlabel('Standard composition (wt%)')
ylabel('Pixel composition (Intensity)')


cla

%plot(Quanti(LaBonnePlace).elem(SelElem).plotX(1,SelectedStd),Quanti(LaBonnePlace).elem(SelElem).plotY(1,SelectedStd)+0.5*(Quanti(LaBonnePlace).elem(SelElem).plotY(2,SelectedStd)-Quanti(LaBonnePlace).elem(SelElem).plotY(1,SelectedStd)),'.k');

plot(Quanti(LaBonnePlace).elem(SelElem).plotX(:,SelectedStd),Quanti(LaBonnePlace).elem(SelElem).plotY(:,SelectedStd),'-k')
plot(Quanti(LaBonnePlace).elem(SelElem).plotXi,Quanti(LaBonnePlace).elem(SelElem).plotXi*Quanti(LaBonnePlace).elem(SelElem).param(2)/Quanti(LaBonnePlace).elem(SelElem).param(1),'-k');

% Plot the polyfit if positive slope and intercept and background < ICOT(2)
if Quanti(LaBonnePlace).elem(SelElem).polyfit(1) > 0 && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) > 0 && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) < handles.StandardizationParameters.ICOT(2) 
    plot(Quanti(LaBonnePlace).elem(SelElem).plotXi,Quanti(LaBonnePlace).elem(SelElem).polyfit(1)*Quanti(LaBonnePlace).elem(SelElem).plotXi+Quanti(LaBonnePlace).elem(SelElem).polyfit(2),'--m');
end

if ~isempty(UnSelectedStd)
    plot(Quanti(LaBonnePlace).elem(SelElem).plotX(:,UnSelectedStd),Quanti(LaBonnePlace).elem(SelElem).plotY(:,UnSelectedStd),'-r')
end

if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,2)
	if isequal(Quanti(LaBonnePlace).elem(SelElem).BackgroundMinResidualValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)
        plot(Quanti(LaBonnePlace).elem(SelElem).plotXi,Quanti(LaBonnePlace).elem(SelElem).plotXi*(Quanti(LaBonnePlace).elem(SelElem).param(2)-Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)/Quanti(LaBonnePlace).elem(SelElem).param(1)+Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,'-b');
        
        if ~isempty(UnSelectedStd)
            set(handles.Text_BackMeth,'String',['auto (least-square); ',num2str(length(find(UnSelectedStd))),' outlier(s) rejected'],'ForegroundColor',[0,0,1]);
        else 
            set(handles.Text_BackMeth,'String',['auto (least-square); no outlier rejection'],'ForegroundColor',[0,0,1]);
        end

    else
        plot(Quanti(LaBonnePlace).elem(SelElem).plotXi,Quanti(LaBonnePlace).elem(SelElem).plotXi*(Quanti(LaBonnePlace).elem(SelElem).param(2)-Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)/Quanti(LaBonnePlace).elem(SelElem).param(1)+Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,'-m');
        
        if ~isempty(UnSelectedStd)
            set(handles.Text_BackMeth,'String',['auto (polyfit); ',num2str(length(find(UnSelectedStd))),' outlier(s) rejected'],'ForegroundColor',[1,0,1]);
        else
            set(handles.Text_BackMeth,'String',['auto (polyfit); no outlier rejection'],'ForegroundColor',[1,0,1]);
        end
        
    end
    %plot(0,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,'ok','MarkerFaceColor','k','Markersize',4);
end

if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
    plot(Quanti(LaBonnePlace).elem(SelElem).plotXi,Quanti(LaBonnePlace).elem(SelElem).plotXi*(Quanti(LaBonnePlace).elem(SelElem).param(2)-Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)/Quanti(LaBonnePlace).elem(SelElem).param(1)+Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,'-','Color',[0,.5,0]);
    set(handles.Text_BackMeth,'String',['manual background'],'ForegroundColor',[0,0.5,0]);
end

% Plot the calibration point
if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
    plot(Quanti(LaBonnePlace).elem(SelElem).param(1),Quanti(LaBonnePlace).elem(SelElem).param(2),'o','MarkerEdgeColor',[0,.5,0],'MarkerFaceColor',[0,.5,0]);
else
    if isequal(Quanti(LaBonnePlace).elem(SelElem).paramType,2)
        plot(Quanti(LaBonnePlace).elem(SelElem).param(1),Quanti(LaBonnePlace).elem(SelElem).param(2),'om','MarkerFaceColor','m');
    else
        plot(Quanti(LaBonnePlace).elem(SelElem).param(1),Quanti(LaBonnePlace).elem(SelElem).param(2),'or','MarkerFaceColor','r');
    end
end

zoom on

hold off

set(handles.Manual_X,'String',num2str(Quanti(LaBonnePlace).elem(SelElem).param(1)));
set(handles.Manual_Y,'String',num2str(Quanti(LaBonnePlace).elem(SelElem).param(2)));

% Calculate and display the slope
Slope = (Quanti(LaBonnePlace).elem(SelElem).param(2) - Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)/Quanti(LaBonnePlace).elem(SelElem).param(1);

if Slope < 0
    keyboard
end

set(handles.Disp_Slope,'String',num2str(Slope));


% [2] Plot the residuals...
axes(handles.axes2), hold on

xlabel('Background value (Intensity)')
ylabel('Residual')

cla

plot([1:1:floor(Quanti(LaBonnePlace).elem(SelElem).param(2))],Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals,'-b','LineWidth',1);

TheAxes = axis;

if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
    plot([Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue],TheAxes(3:end),'-','Color',[0,.5,0],'LineWidth',1);
    plot(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue),'o','MarkerEdgeColor',[0,.5,0],'MarkerFaceColor',[0,.5,0],'MarkerSize',7);
else
    if Quanti(LaBonnePlace).elem(SelElem).BackgroundValue > 1
        if isequal(Quanti(LaBonnePlace).elem(SelElem).BackgroundMinResidualValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)
            plot([Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue],TheAxes(3:end),'-b','LineWidth',1);
            plot(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue),'ob','MarkerFaceColor','w','MarkerSize',7);
        else
            plot([Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue],TheAxes(3:end),'-m','LineWidth',1);
            plot(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue),'om','MarkerFaceColor','w','MarkerSize',7);

            %plot([Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue],TheAxes(3:end),'-r');
            plot(Quanti(LaBonnePlace).elem(SelElem).BackgroundMinResidualValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals(Quanti(LaBonnePlace).elem(SelElem).BackgroundMinResidualValue),'ob','MarkerFaceColor','w','MarkerSize',7);
        end
    else
        plot([Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue],TheAxes(3:end),'-k','LineWidth',2);
        %keyboard
        if Quanti(LaBonnePlace).elem(SelElem).BackgroundValue
            plot(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue),'ok','MarkerFaceColor','w','MarkerSize',7);
        end
    end
    
end

set(handles.Manual_BACK,'String',num2str(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue));


% [3 - new 2.5.1] Plot the standardized map

% Improvement XMapTools 2.5.1 *** This code was taken from XMapTools ***
%
% Below I use BackgroundValue - 1 because there is a shift of one
% count; e.g. no background correction has a value of 1. 

Data = handles.Data;
SelectionMap = handles.SelectionMap;

Y = Data.map(SelectionMap(SelElem)).values.*handles.MaskValues;
Xb = Quanti(LaBonnePlace).elem(SelElem).param(1);
Yb = Quanti(LaBonnePlace).elem(SelElem).param(2);
Back = Quanti(LaBonnePlace).elem(SelElem).BackgroundValue - 1;
        
% Temporary to fix an issue in XMTStandardization (XMapTools 2.4.3)
if Back < 0
    Back = 0;
end

Map4Plot = (Y-Back)*(Xb/(Yb-Back));
%Quanti(LaBonnePlace).elem(i).quanti = (Y-Back)*(Xb/(Yb-Back));

% Find and replace negative values...
WhereNeg = find(Map4Plot < 0);

if ~isempty(WhereNeg)
    Map4Plot(WhereNeg) = zeros(size(WhereNeg));
end

axes(handles.axes7), 
imagesc(Map4Plot), axis image, colorbar vertical
colormap(handles.ColorMap)
set(gca,'XTickLabel',[],'YTickLabel',[]);

% Check for values above 110 %
WhereAbove110 = length(find(Map4Plot > 110));
WhereAbove0 = length(find(Map4Plot));

if WhereAbove110 > 0
    set(handles.text_WarningStd,'Visible','on','String',['WARNING: ',num2str(WhereAbove110),' pixels with ',char(Quanti(LaBonnePlace).elem(SelElem).name),'>110 wt%']);
else
    set(handles.text_WarningStd,'Visible','off','String','');
end
% [3] Plot the residuals of the best solution...

% axes(handles.axes3)
% hist(Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsFirstSol,10);
% 
% set(get(gca,'child'),'FaceColor',[0.6,0.6,0.6]);
% 
% ylabel('Number of Std');
% xlabel('Dist (no back.)');
% 
% set(handles.axes3,'FontName','Times New Roman','FontSize',10);
% 
% Axis3 = axis;
% 
% if Quanti(LaBonnePlace).elem(SelElem).StandardizationType > 1 && Quanti(LaBonnePlace).elem(SelElem).StandardizationType < 3
%     axes(handles.axes4)
%     set(gca,'Visible','off');
%     hist(Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsBestSol);
%     
%     
%     Axis4 = axis;
%     
%     if Axis4(2) < Axis3(2)
%         
%         Ymax = max([Axis3(4),Axis4(4)]);
%         
%         DiffHist = Axis4(2)/Axis3(2);
%         hist(Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsBestSol,round(10*DiffHist));
%         axis([Axis4(1),Axis3(2),Axis4(3),Ymax]);
%         
%         set(get(gca,'child'),'FaceColor',[0.3,0.65,1]);
%         
%         xlabel('Dist (back.)');
%         
%         axes(handles.axes3)
%         axis([Axis3(1:3),Ymax]);
%         
%         set(handles.axes3,'FontName','Times New Roman','FontSize',10);
%         
%     end
% elseif isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
%     
%     % Manual mode we should recalculate the residuals (simplified in only
%     % one loop of outlier rejection...
%     
%     Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = str2num(get(handles.Manual_BACK,'String'));
%     Quanti(LaBonnePlace).elem(SelElem).param(1) = str2num(get(handles.Manual_X,'String'));
%     Quanti(LaBonnePlace).elem(SelElem).param(2) = str2num(get(handles.Manual_Y,'String'));
%     
%     [BackgroundResiduals] = UpdateBackgroundResidualsManual(Quanti,LaBonnePlace,SelElem,handles);
%     
%     axes(handles.axes4)
%     
%     hist(BackgroundResiduals);
%     
%     Axis4 = axis;
%     
%     if Axis4(2) < Axis3(2)
%         
%         Ymax = max([Axis3(4),Axis4(4)]);
%         
%         DiffHist = Axis4(2)/Axis3(2);
%         hist(BackgroundResiduals,round(10*DiffHist));
%         axis([Axis4(1),Axis3(2),Axis4(3),Ymax]);
% 
%         set(get(gca,'child'),'FaceColor',[0,.5,0]);
%         xlabel('Dist (back.)')
%         
%         axes(handles.axes3)
%         axis([Axis3(1:3),Ymax]);
%         
%         set(handles.axes3,'FontName','Times New Roman','FontSize',10);
%         
%     else
%         Ymax = max([Axis3(4),Axis4(4)]);
%         Xmax = max([Axis3(2),Axis4(2)]);
%         
%         DiffHist = Axis4(2)/Axis3(2);
%         hist(BackgroundResiduals,round(10*DiffHist));
%         axis([Axis4(1),Axis4(2),Axis4(3),Ymax]);
%         
%         set(get(gca,'child'),'FaceColor',[0,.5,0]);
%         xlabel('Dist (back.)')
% 
%         axes(handles.axes3)
%         axis([Axis4(1),Axis4(2),Axis4(3),Ymax]);
%         
%         set(handles.axes3,'FontName','Times New Roman','FontSize',10);
%     end
%     
% else
%     axes(handles.axes4)
%     cla
% end

handles.Quanti = Quanti;
guidata(hObject, handles);


return



function [BackgroundResiduals] = UpdateBackgroundResidualsManual(Quanti,LaBonnePlace,SelElem,handles)
%

Xvalues = Quanti(LaBonnePlace).elem(SelElem).Ox;
Yvalues = Quanti(LaBonnePlace).elem(SelElem).Ra;

xi = Xvalues;
yi = Yvalues;

%figure, plot(xi,yi,'ok'), hold on, plot(Quanti(LaBonnePlace).elem(SelElem).param(1),Quanti(LaBonnePlace).elem(SelElem).param(2),'or');
AverI = mean(yi);

ScaleX = max(xi);
ScaleY = max(yi);
% 
% Scale = median(yi./xi);
% xi = xi*Scale;

xi = xi./ScaleX;
yi = yi./ScaleY;

X = Quanti(LaBonnePlace).elem(SelElem).param(1)/ScaleX;
Y = Quanti(LaBonnePlace).elem(SelElem).param(2)/ScaleY;

%figure, plot(xi,yi,'ok'), hold on, plot(X,Y,'or');

Yunscaled = Quanti(LaBonnePlace).elem(SelElem).param(2);

Ystop = floor(Yunscaled)/ScaleY;

b = -1;
Yori = 0:(Y)/(floor(Yunscaled)-1):Y;
a = (Y-Yori)/(X-0);
c = Y - a*X;

for i=1:length(c);
    for j=1:length(xi)
        Dists(j,i) = abs((a(i)*xi(j))+(b*yi(j))+c(i))/sqrt(a(i)^2 + b^2);
    end
end

BackgroundResiduals = Dists(:,Quanti(LaBonnePlace).elem(SelElem).BackgroundValue);

return


function [Selected,Residuals,ValMin,WhereInd,BackgroundResidualsFirstSol,BackgroundResidualsBestSol] = OutlierRejection(X,Y,xi,yi,Yunscaled,ScaleY,handles)
%

% equation ax+by+c = 0  (if b=-1 it reduces to y = ax+c)
%Xser = 0:0.001:2*X;

Ystop = floor(Yunscaled)/ScaleY;

b = -1;
if Yunscaled < 1.0001
    Yori = 0:(Y)/(floor(Yunscaled)-0.99):Y;
else
    Yori = 0:(Y)/(floor(Yunscaled)-1):Y;
end
a = (Y-Yori)/(X-0);
c = Y - a*X;

for i=1:length(c);
    for j=1:length(xi)
        Dists(j,i) = abs((a(i)*xi(j))+(b*yi(j))+c(i))/sqrt(a(i)^2 + b^2);
    end
end

AverI = mean(yi*ScaleY);

% [1] Estimate the best fit with regular outlier rejection
AllMean = mean(Dists,2);
TheMean = mean(AllMean);
%TheStd = std(AllMean);

IsOutlier = find(AllMean > TheMean+handles.StandardizationParameters.OUTL(1)*TheMean);

Temp = 1:length(xi);

if length(IsOutlier)
    Temp(IsOutlier) = zeros(size(IsOutlier));
end

SelectedStd = find(Temp);

% Here I'm calculating the residuals:
Residuals1 = sqrt(sum(Dists(SelectedStd,:).^2,1));

[ValMin,WhereInd] = min(Residuals1);

if WhereInd > handles.StandardizationParameters.ICOT(2) && AverI > handles.StandardizationParameters.ICOT(1)
    % Here we have to check quickly that there is no problem
    WhereInd = 1;
end

% [2] Second outlier test using the best fit
SpecMean = Dists(:,WhereInd);
SpecTheMean = mean(SpecMean);
%SpecTheStd = std(SpecMean);

IsOutlier = find(SpecMean > SpecTheMean+handles.StandardizationParameters.OUTL(2)*SpecTheMean);

Temp2 = 1:length(xi);

if length(IsOutlier)
    Temp2(IsOutlier) = zeros(size(IsOutlier));
end

SelectedStd2 = find(Temp2);

% [3] Calculate the residuals...
Residuals = sqrt(sum(Dists(SelectedStd2,:).^2,1));

[ValMin,WhereInd] = min(Residuals);

Selected = zeros(size(SpecMean'));
Selected(SelectedStd2) = ones(size(SelectedStd2));

BackgroundResidualsFirstSol = Dists(SelectedStd2,1);
BackgroundResidualsBestSol = Dists(SelectedStd2,WhereInd);

return


function [Selected,Residuals,ValMin,WhereInd,BackgroundResidualsFirstSol,BackgroundResidualsBestSol] = OutlierRejectionNoRejection(X,Y,xi,yi,Yunscaled,ScaleY,SelectedBefore,handles)
%

% This is a copy of the previous function // there is no outlier rejection
% here.

Ystop = floor(Yunscaled)/ScaleY;

b = -1;
if Yunscaled < 1.0001
    Yori = 0:(Y)/(floor(Yunscaled)-0.99):Y;
else
    Yori = 0:(Y)/(floor(Yunscaled)-1):Y;
end
a = (Y-Yori)/(X-0);
c = Y - a*X;

for i=1:length(c);
    for j=1:length(xi)
        Dists(j,i) = abs((a(i)*xi(j))+(b*yi(j))+c(i))/sqrt(a(i)^2 + b^2);
    end
end


Selected = SelectedBefore;

Selected_ind = find(Selected);

% We directily calculate the residuals...
Residuals = sqrt(sum(Dists(Selected_ind,:).^2,1));

[ValMin,WhereInd] = min(Residuals);

BackgroundResidualsFirstSol = Dists(Selected_ind,1);
BackgroundResidualsBestSol = Dists(Selected_ind,WhereInd);

return


function [Quanti] = TryAutomatedBackgroundCorrection(Quanti,LaBonnePlace,SelElem,FitBack,RejOut,handles)
% 

% Calculate the residuals 
%Residuals = zeros(floor(Quanti(LaBonnePlace).elem(SelElem).param(2))-1,1);

Xvalues = Quanti(LaBonnePlace).elem(SelElem).Ox;
Yvalues = Quanti(LaBonnePlace).elem(SelElem).Ra;

% Reject negative values...
PosX = find(Xvalues);
PosY = find(Yvalues);

if length(PosX) >= length(PosY)
    PosOk = find(ismember(PosX,PosY));
else
    PosOk = find(ismember(PosY,PosX));
end

xi = Xvalues(PosOk);
yi = Yvalues(PosOk);

% Check if all the values of Yi are ones...
if mean(yi) < 1.0001
    yi = yi + 0.1*rand(size(yi));
end
 
if length(xi) < 1 || length(yi) < 1
    disp('You shouldn''t be there!!! please contact pierre.lanari@geo.unibe.ch (error STD-47829)')
    disp('type "return" to exit the keyboard mode')
    keyboard
end

%figure, plot(xi,yi,'ok'), hold on, plot(Quanti(LaBonnePlace).elem(SelElem).param(1),Quanti(LaBonnePlace).elem(SelElem).param(2),'or');
AverI = mean(yi);

ScaleX = max(xi);
ScaleY = max(yi);
% 
% Scale = median(yi./xi);
% xi = xi*Scale;

xi = xi./ScaleX;
yi = yi./ScaleY;

X = Quanti(LaBonnePlace).elem(SelElem).param(1)/ScaleX;
Y = Quanti(LaBonnePlace).elem(SelElem).param(2)/ScaleY;

%figure, plot(xi,yi,'ok'), hold on, plot(X,Y,'or');

SelectedBefore = Quanti(LaBonnePlace).elem(SelElem).Selected;

OnRecalc = 0;
if isequal(RejOut,1)
    [Selected,Residuals,ValMin,WhereInd,BackgroundResidualsFirstSol,BackgroundResidualsBestSol] = OutlierRejection(X,Y,xi,yi,Quanti(LaBonnePlace).elem(SelElem).param(2),ScaleY,handles);
    if ~isequal(SelectedBefore,Selected) && Quanti(LaBonnePlace).elem(SelElem).StandardizationType < 3
        OnRecalc = 1;
    end
else
    [Selected,Residuals,ValMin,WhereInd,BackgroundResidualsFirstSol,BackgroundResidualsBestSol] = OutlierRejectionNoRejection(X,Y,xi,yi,Quanti(LaBonnePlace).elem(SelElem).param(2),ScaleY,SelectedBefore,handles);
    OnRecalc = 1;
end
    
if OnRecalc
    
    % We shall update X and Y  
    
    TheSelectedStd = find(Selected);
    
    Quanti(LaBonnePlace).elem(SelElem).polyfit = polyfit(Quanti(LaBonnePlace).elem(SelElem).Ox(TheSelectedStd),Quanti(LaBonnePlace).elem(SelElem).Ra(TheSelectedStd),1);
    
    Quanti(LaBonnePlace).elem(SelElem).polyfit(2) = round(Quanti(LaBonnePlace).elem(SelElem).polyfit(2));

    polydata = polyval(Quanti(LaBonnePlace).elem(SelElem).polyfit,Quanti(LaBonnePlace).elem(SelElem).Ox(TheSelectedStd));
    sstot = sum((Quanti(LaBonnePlace).elem(SelElem).Ra(TheSelectedStd) - mean(Quanti(LaBonnePlace).elem(SelElem).Ra(TheSelectedStd))).^2);
    ssres = sum((Quanti(LaBonnePlace).elem(SelElem).Ra(TheSelectedStd) - polydata).^2);
    
    Quanti(LaBonnePlace).elem(SelElem).R2 = 1 - (ssres / sstot);
    
    Quanti(LaBonnePlace).elem(SelElem).warning = 0;
    Quanti(LaBonnePlace).elem(SelElem).usepolyfit = 0;
    
    if Quanti(LaBonnePlace).elem(SelElem).polyfit(2) < 1
        Quanti(LaBonnePlace).elem(SelElem).warning = 1;
    end

    MinOx = min(Quanti(LaBonnePlace).elem(SelElem).Ox);
    MaxOx = max(Quanti(LaBonnePlace).elem(SelElem).Ox);
    
    DeltaOx = MaxOx-MinOx; 
        
    if DeltaOx/MaxOx > handles.StandardizationParameters.PFIT && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) > 1 && Quanti(LaBonnePlace).elem(SelElem).polyfit(2) < handles.StandardizationParameters.ICOT(2) && Quanti(LaBonnePlace).elem(SelElem).polyfit(1) > 0
        % We are going to use the polyfit value...
        Quanti(LaBonnePlace).elem(SelElem).usepolyfit = 1;
        X = MaxOx + handles.StandardizationParameters.PLOX * MaxOx;
        Quanti(LaBonnePlace).elem(SelElem).param = [X,Quanti(LaBonnePlace).elem(SelElem).polyfit(1) * X + Quanti(LaBonnePlace).elem(SelElem).polyfit(2)];
        Quanti(LaBonnePlace).elem(SelElem).paramType = 2;
        Quanti(LaBonnePlace).elem(SelElem).plotXi = [0:0.001:X]; 
    else
        Quanti(LaBonnePlace).elem(SelElem).plotXi = [0:0.001:max(Quanti(LaBonnePlace).elem(SelElem).Ox)];
    end
        
    X = Quanti(LaBonnePlace).elem(SelElem).param(1)/ScaleX;
    Y = Quanti(LaBonnePlace).elem(SelElem).param(2)/ScaleY;
    
    if isequal(RejOut,1)
        [Selected,Residuals,ValMin,WhereInd,BackgroundResidualsFirstSol,BackgroundResidualsBestSol] = OutlierRejection(X,Y,xi,yi,Quanti(LaBonnePlace).elem(SelElem).param(2),ScaleY,handles);
    else
        [Selected,Residuals,ValMin,WhereInd,BackgroundResidualsFirstSol,BackgroundResidualsBestSol] = OutlierRejectionNoRejection(X,Y,xi,yi,Quanti(LaBonnePlace).elem(SelElem).param(2),ScaleY,SelectedBefore,handles);
    end
end    

Quanti(LaBonnePlace).elem(SelElem).Selected = Selected;

Quanti(LaBonnePlace).elem(SelElem).BackgroundResiduals = Residuals;

if WhereInd > handles.StandardizationParameters.ICOT(2) && AverI > handles.StandardizationParameters.ICOT(1)
    % cut off limit...
    WhereInd = 1;
end

Quanti(LaBonnePlace).elem(SelElem).BackgroundMinResidualValue = WhereInd;

if FitBack
    Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = WhereInd;

    % Check to update the Background value...
    if ~isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
        
        if isequal(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,1)
            Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 1;
        else
            Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 2;
        end
        
    end
end

Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsFirstSol = BackgroundResidualsFirstSol;
Quanti(LaBonnePlace).elem(SelElem).BackgroundResidualsBestSol = BackgroundResidualsBestSol;

if Quanti(LaBonnePlace).elem(SelElem).usepolyfit && sum(Quanti(LaBonnePlace).elem(SelElem).Selected) == length(Quanti(LaBonnePlace).elem(SelElem).Selected)
    Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = Quanti(LaBonnePlace).elem(SelElem).polyfit(2);
else
    Quanti(LaBonnePlace).elem(SelElem).usepolyfit = 0;
end
  
% Check for max background
if isequal(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,floor(Quanti(LaBonnePlace).elem(SelElem).param(2)))
    Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = Quanti(LaBonnePlace).elem(SelElem).BackgroundValue -1;
end

return



function [Ox,Ra] = GenerateOxRa(Quanti,Profils,ElemInd,LaBonnePlace)
%

Ox=[]; Ra=[];
Compt = 1;

for j=1:length(Quanti(LaBonnePlace).elem(ElemInd).values)
    
    % I added the criterion Quanti(LaBonnePlace).elem(ElemInd).raw(j) in
    % XMapTools 2.4.3 to fix an issue with low count rates...
    
    if Quanti(LaBonnePlace).elem(ElemInd).values(j) > 0  && Quanti(LaBonnePlace).elem(ElemInd).raw(j) > 0 && Profils.pointselected(j)    % Edited 1.6.2 (compatible with select/uselect points)
        Ox(Compt) = Quanti(LaBonnePlace).elem(ElemInd).values(j);
        Ra(Compt) = Quanti(LaBonnePlace).elem(ElemInd).raw(j);
        Compt = Compt+1;
    else        
        Quanti(LaBonnePlace).elem(ElemInd).values(j) = 0;    % Edited 1.6.2 (compatible with select/uselect points)
        Quanti(LaBonnePlace).elem(ElemInd).raw(j) = 0;       % we fixed to zero the unused compositions (for the plots).

        % bug correction (1.6.4) resulting from 0 intensity values
        %                        --> no matches between minerals and profils warning
        %
        %                            But now, the softawre doesn't detect
        %                            mask without quantitative
        %                            analyses...
        
        
        if isequal(Compt,1) % This is a tentative to solve the problem (4.02.17)
            Ox(Compt) = 0.0000001;
            Ra(Compt) = 1.; 
        end
    end
end

if Compt > 1 && ~sum(Ra)
    Ra(1) = 1;
end

return




function ButtonRejectOutlier_Callback(hObject, eventdata, handles)
%

Quanti = handles.Quanti;
LaBonnePlace = handles.LaBonnePlace;
SelElem = get(handles.PopUpElems,'Value');

set(handles.text_WarningStd2,'Visible','on','String','Select a std to be added/rejected')

axes(handles.axes1)
[XSel,YSel] = ginput(1);

%keyboard

Xi = Quanti(LaBonnePlace).elem(SelElem).Ox;
Yi = Quanti(LaBonnePlace).elem(SelElem).Ra;

%Xi = Quanti(LaBonnePlace).elem(SelElem).plotX(1,:);
%Yi = Quanti(LaBonnePlace).elem(SelElem).plotY(1,:) + (Quanti(LaBonnePlace).elem(SelElem).plotY(2,:)-Quanti(LaBonnePlace).elem(SelElem).plotY(1,:));

XLim = get(gca,'XLim');
YLim = get(gca,'YLim');

ScaleX = XLim(2);
ScaleY = YLim(2);

Xi =Xi./ScaleX;
Yi = Yi./ScaleY;

Dist = sqrt((Xi-XSel/ScaleX).^2+(Yi-YSel/ScaleY).^2);

[Val,Where] = min(Dist);

if Quanti(LaBonnePlace).elem(SelElem).Selected(Where);
    Quanti(LaBonnePlace).elem(SelElem).Selected(Where) = 0;
else
    Quanti(LaBonnePlace).elem(SelElem).Selected(Where) = 1;
end

set(handles.text_WarningStd2,'Visible','off','String','')



% figure, plot(Xi.*ScaleX,Yi.*ScaleY,'o')
% hold on
% plot(XSel,YSel,'+r')
% plot(Xi(Where).*ScaleX,Yi(Where).*ScaleY,'.r')
% 
% figure, plot(Xi,Yi,'o')
% hold on
% plot(XSel/ScaleX,YSel/ScaleY,'+r')
% plot(Xi(Where),Yi(Where),'.r')
% 
% keyboard 


Quanti = TryAutomatedBackgroundCorrection(Quanti,LaBonnePlace,SelElem,1,0,handles);

handles.Quanti = Quanti;
guidata(hObject, handles);
PlotCorrection(hObject, eventdata, handles)
return





% --- Executes on selection change in PopUpElems.
function PopUpElems_Callback(hObject, eventdata, handles)
%

set(handles.DIAGNOSTIC,'Enable','On');

Quanti = handles.Quanti;
LaBonnePlace = handles.LaBonnePlace;

SelElem = get(handles.PopUpElems,'Value');

set(handles.Check_Automated,'Value',0);
set(handles.Check_NoCorr,'Value',0);
set(handles.Check_Manual,'Value',0,'Enable','On');

set(handles.Manual_BACK,'Enable','inactive');
set(handles.Manual_X,'Enable','inactive');
set(handles.Manual_Y,'Enable','inactive');

switch(Quanti(LaBonnePlace).elem(SelElem).StandardizationType)
    case -1
        set(handles.DIAGNOSTIC,'Enable','off');
        set(handles.Check_Manual,'Enable','inactive');
        set(handles.ButtonRejectOutlier,'Enable','off');
        
    case 0
        set(handles.ButtonRejectOutlier,'Enable','off');
        
    case 1
        set(handles.Check_NoCorr,'Value',1);
    case 2
        set(handles.Check_Automated,'Value',1);
    case 3
        set(handles.Check_Manual,'Value',1);
        
        set(handles.Manual_BACK,'Enable','on');
        set(handles.Manual_X,'Enable','on');
        set(handles.Manual_Y,'Enable','on');
end


PlotCorrection(hObject, eventdata, handles);

axes(handles.axes1);
axis auto

return



% --- Executes during object creation, after setting all properties.
function PopUpElems_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpElems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Check_Automated.
function Check_Automated_Callback(hObject, eventdata, handles)
% 
return



% --- Executes on button press in Check_Manual.
function Check_Manual_Callback(hObject, eventdata, handles)
%

IsManual = get(handles.Check_Manual,'Value');

if isequal(IsManual,1)
    
    % Update display ....
    set(handles.Manual_BACK,'Enable','on');
    set(handles.Manual_X,'Enable','on');
    set(handles.Manual_Y,'Enable','on');
    
    set(handles.Check_NoCorr,'Value',0);
    set(handles.Check_Automated,'Value',0);
    
    ApplyManualORAuto(hObject, eventdata, handles, 1);
    
else
    
    % Update display ....
    set(handles.Manual_BACK,'Enable','inactive');
    set(handles.Manual_X,'Enable','inactive');
    set(handles.Manual_Y,'Enable','inactive');
        
    ApplyManualORAuto(hObject, eventdata, handles, 2);
    
end



function ApplyManualORAuto(hObject, eventdata, handles, Mode)
%

Quanti = handles.Quanti;
LaBonnePlace = handles.LaBonnePlace;

SelElem = get(handles.PopUpElems,'Value');

if isequal(Mode,2)
    % Back to automated mode ...
    
    handles.Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 0;
    
    [handles] = AutomatedInitiateStandardization(SelElem,handles,hObject);

    [handles.Quanti] = TryAutomatedBackgroundCorrection(handles.Quanti,LaBonnePlace,SelElem,1,1,handles);
    
    guidata(hObject, handles);
    
    UpdateMenuNames(hObject, eventdata, handles); 
    
    switch handles.Quanti(LaBonnePlace).elem(SelElem).StandardizationType
        case 1
            set(handles.Check_NoCorr,'Value',1);
            set(handles.Check_Automated,'Value',0);
            set(handles.Check_Manual,'Value',0);
            
        case 2   
            set(handles.Check_NoCorr,'Value',0);
            set(handles.Check_Automated,'Value',1);
            set(handles.Check_Manual,'Value',0);
    end
    
else
    % Go to manual mode...

    Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 3;
    Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = str2num(get(handles.Manual_BACK,'String'));
    Quanti(LaBonnePlace).elem(SelElem).param(1) = str2num(get(handles.Manual_X,'String'));
    Quanti(LaBonnePlace).elem(SelElem).param(2) = str2num(get(handles.Manual_Y,'String'));
    
    % Calculate and display the slope
    Slope = (Quanti(LaBonnePlace).elem(SelElem).param(2) - Quanti(LaBonnePlace).elem(SelElem).BackgroundValue)/Quanti(LaBonnePlace).elem(SelElem).param(1);
    if isequal(Slope,0) || Slope < 0
        warndlg('The slope of the callibration line cannot be null or negative', 'Warning - cancellation');
        return
    end
    set(handles.Disp_Slope,'String',num2str(Slope));
    
    Quanti = TryAutomatedBackgroundCorrection(Quanti,LaBonnePlace,SelElem,0,1,handles);
    
    Quanti(LaBonnePlace).elem(SelElem).BackgroundValue = str2num(get(handles.Manual_BACK,'String'));

    handles.Quanti = Quanti;
    
    guidata(hObject, handles);
    
    UpdateMenuNames(hObject, eventdata, handles);
    
end

guidata(hObject, handles);


PlotCorrection(hObject, eventdata, handles);

return




function Manual_BACK_Callback(hObject, eventdata, handles)
%
ApplyManualORAuto(hObject, eventdata, handles, 1);
return


% --- Executes during object creation, after setting all properties.
function Manual_BACK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Manual_BACK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DIAGNOSTIC.
function DIAGNOSTIC_Callback(hObject, eventdata, handles)
% 

Quanti = handles.Quanti;
LaBonnePlace = handles.LaBonnePlace;

SelElem = get(handles.PopUpElems,'Value');

if isequal(Quanti(LaBonnePlace).elem(SelElem).StandardizationType,3)
    ApplyManualORAuto(hObject, eventdata, handles, 2);
    return
else

    Quanti = TryAutomatedBackgroundCorrection(Quanti,LaBonnePlace,SelElem,1,1,handles);

    % Diagnostic
    if isequal(Quanti(LaBonnePlace).elem(SelElem).BackgroundValue,1)
        % There is no need of background correction
        Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 1;
    else
        % Suggest a background correction
        Quanti(LaBonnePlace).elem(SelElem).StandardizationType = 2;
    end
end

handles.Quanti = Quanti;
guidata(hObject, handles);

UpdateMenuNames(hObject, eventdata, handles);
PlotCorrection(hObject, eventdata, handles);
PopUpElems_Callback(hObject, eventdata, handles);
return


% --- Executes on button press in Check_NoCorr.
function Check_NoCorr_Callback(hObject, eventdata, handles)
% hObject    handle to Check_NoCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_NoCorr


% --- Executes on button press in EXPORT.
function EXPORT_Callback(hObject, eventdata, handles)
%

NameAxes = handles.axes1;

axes(NameAxes);

lesInd = get(NameAxes,'child');

CLim = get(NameAxes,'CLim');
YDir = get(NameAxes,'YDir');

Labels = get(NameAxes,'XTickLabel');

figure;
hold on

% ensuite les lignes
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    %leType
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end

%set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
%set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)



NameAxes = handles.axes2;

axes(NameAxes);

lesInd = get(NameAxes,'child');

CLim = get(NameAxes,'CLim');
YDir = get(NameAxes,'YDir');

Labels = get(NameAxes,'XTickLabel');

figure;
hold on

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

%set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
%set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)






return





% --- Executes on button press in LOAD.
function LOAD_Callback(hObject, eventdata, handles)
% 
LaBonnePlace = handles.LaBonnePlace;
Quanti = handles.Quanti(LaBonnePlace);


[Success,Message,MessageID] = mkdir('Standardization');

cd Standardization
[filename, pathname] = uigetfile('*.txt', 'Select a standardization file');
cd ..
        
if ~length(filename)
    return
end
    
fid = fopen(strcat(pathname,filename),'r');

ComptEl = 0;

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1);
        break
    end
    
    if length(TheLine) > 1
        if isequal(TheLine(1),'>') % Mineral Block
            TheStr = strread(TheLine,'%s');
            NameStandardizazion = TheStr{2};
            
            while 1
                TheLine = fgetl(fid);
                
                if isequal(TheLine,-1);
                    break
                end
                
                if isequal(TheLine(1),'#') % Element Block
                    
                    ComptEl = ComptEl+1;
                    
                    TheStr = strread(TheLine,'%s');
                    
                    ElName{ComptEl} = TheStr{2};
                    ElInd(ComptEl) = str2num(TheStr{3});
                    
                    TheLine = fgetl(fid);
                    
                    TheLine = fgetl(fid);
                    TheNum = strread(TheLine,'%f');
                    
                    param(ComptEl,:) = [TheNum(4),TheNum(5);];
                    
                    BackgroundValue(ComptEl) = TheNum(3);
                    Standardization(ComptEl) = TheNum(1);
                    StandardizationType(ComptEl) = TheNum(2); 
                    
                end
            end
            
        end
    end
    
end

return





function Manual_X_Callback(hObject, eventdata, handles)
%
ApplyManualORAuto(hObject, eventdata, handles, 1);
return

% --- Executes during object creation, after setting all properties.
function Manual_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Manual_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Manual_Y_Callback(hObject, eventdata, handles)
%
ApplyManualORAuto(hObject, eventdata, handles, 1);
return

% --- Executes during object creation, after setting all properties.
function Manual_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Manual_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Disp_Slope_Callback(hObject, eventdata, handles)
% hObject    handle to Disp_Slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Disp_Slope as text
%        str2double(get(hObject,'String')) returns contents of Disp_Slope as a double


% --- Executes during object creation, after setting all properties.
function Disp_Slope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_Slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Check_Outliers.
function Check_Outliers_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Outliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Check_Outliers
