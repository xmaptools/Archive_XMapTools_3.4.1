function varargout = VER_XMapTools_804(varargin)
% VER_XMAPTOOLS_804 runs the program VER_XMapTools_804
%      VER_XMAPTOOLS_804 is a MATLAB-based graphic user interface for the
%      processing of chemical images
%
%      VER_XMAPTOOLS_804 launches the inteface
%
%      VER_XMAPTOOLS_804 software has been developed and is maintained by
%      Dr. Pierre Lanari (pierre.lanari@geo.unibe.ch)
%
%      Find out more at https://www.xmaptools.com
%

% VER_XMapTools_804('Untitled_1_Callback',hObject,eventdata,guidata(hObject))

%
%      VER_XMAPTOOLS_804('Property','Value',...) creates a new VER_XMAPTOOLS_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMapTools_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMapTools_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMapTools_804

% Last Modified by GUIDE v2.5 08-May-2020 16:29:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VER_XMapTools_804_OpeningFcn, ...
    'gui_OutputFcn',  @VER_XMapTools_804_OutputFcn, ...
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
return
% End initialization code - DO NOT EDIT


%###############

% General opening function
function VER_XMapTools_804_OpeningFcn(hObject, eventdata, handles, varargin)
%

%set(handles.XMapToolsGUI,'visible','off');
%drawnow

disp('____________________________________________________________________')

% 1.6.5 Activate XThermoTools for USERs
handles.XThermoToolsACTIVATION = 1;


% New 2.1.3 - VER_XMapTools_804 Commands
handles.Xmode = 'normal';
handles.Xload = '';
handles.DisplayMode = 'normal';

if iscell(varargin) && length(varargin) >= 1
    skip = 0;
    for i = 1:length(varargin)
        if isequal(skip,0)
            switch varargin{i}
                
                case 'HD'
                    handles.DisplayMode = 'HD';
                    
                case 'open'
                    if length(varargin) > i
                        handles.Xload = [varargin{i+1},'.mat'];
                    end
                    skip = 1;
                    
                case 'mode'
                    if length(varargin) > i
                        handles.Xmode = 'admin';
                    end
                    skip = 1;
            end
            
        else
            skip = 0;
        end
    end
end                  
  
% if iscell(varargin) && length(varargin) >= 2
%     switch varargin{1}
%         case 'open'
%             handles.Xload = [varargin{2},'.mat'];
%             
%             if length(varargin) >= 4 % we can use two labels
%                 switch varargin{3}
%                     case 'mode'
%                         if isequal(varargin{4},'Xadmin')
%                             handles.Xmode = 'admin';
%                         end
%                 end
%             end
%             
%         case 'mode'
%             if isequal(varargin{2},'Xadmin')
%                 handles.Xmode = 'admin';
%             end
%     end
%     
% end

% New 2.1.1
if ispc
    handles.FileDirCode = 'file:/';
else
    handles.FileDirCode = 'file://';
end

archstr = computer('arch');

% New 2.1.3 Matlab version
TheVersion = strread(version,'%s','delimiter','.');
handles.MatlabVersion = str2num(TheVersion{1}) + 0.01*str2num(TheVersion{2});

set(handles.DebugMode,'visible','on');

% VER_XMapTools_804 version information                                   new 1.6.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen('XMT_Local_version.txt');
localVersion =fgetl(fid);
fclose(fid);

localStr = strread(localVersion,'%s','delimiter','-');

Version = localStr{2};
ReleaseDate = localStr{3};
ProgramState = localStr{4};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.title2,'String',['XMapTools ',char(Version),'-',char(ProgramState)]);
set(gcf,'Name',['XMapTools ',char(Version)]);

% Choose default command line output for VER_XMapTools_804
handles.output = hObject;

% Axes hide
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.axes3,'Visible','off');

%Waitbar hidden
set(handles.UiPanelScrollBar,'visible','off');
set(handles.WaitBar1,'Visible','off');
set(handles.WaitBar2,'Visible','off');
set(handles.WaitBar3,'Visible','off');

% Button position (new 3.0.1)
PositionBar = get(handles.uipanel61,'Position');
Position1 = get(handles.OPT1,'Position');
Position2 = get(handles.OPT2,'Position');
Position3 = get(handles.OPT3,'Position');

NewPosition = PositionBar(2)+PositionBar(4);

Position1(2) = NewPosition;
Position2(2) = NewPosition;
Position3(2) = NewPosition;

set(handles.OPT1,'Position',Position1);
set(handles.OPT2,'Position',Position2);
set(handles.OPT3,'Position',Position3);

% XMT_Config (2.3.1)
fid = fopen('XMT_Config.txt');
LocBase = char(fgetl(fid)); % main directory of XMapTools
fclose(fid);
handles.LocBase = LocBase;

WhereWeAre = cd;

if isequal(LocBase,WhereWeAre) || isequal([LocBase,'/Dev'],WhereWeAre) || isequal([LocBase,'/Functions'],WhereWeAre) || isequal([LocBase,'/Modules'],WhereWeAre)
    textAfficher = {'You are running XMapTools from your setup''s directory ...', ...
        ' ', ...
        'The files stored here will be deleted during the next update!', ...
        ' ', ...
        'Please check back the user guide for more details', ...
        (' ')};
    
    buttonName = questdlg(textAfficher,'WARNING','Continue (not recommended)','Cancel','Cancel');
    
    switch buttonName
        case 'Cancel'
            
            handles.update = 1;
            guidata(hObject, handles);
            
            close all
            
            return
    end
    
end


% -------------------------------------------------------------------------
%                               LOGO AND ICONS
% -------------------------------------------------------------------------


handles.LogoXMapTools = imread([LocBase,'/Dev/logo/logo_xmap_final.png']);
                                          
%guidata(hObject, handles);

handles.LogoXMapToolsWhite = imread([LocBase,'/Dev/logo/logo_xmap_final_white.png']);


handles.update = 0;

% % Define iconsFolder (depending on the resolution)                new 3.0.1
% ScreenSize = get(0,'ScreenSize');
% 
% if ScreenSize(3) > 3600
%     iconsFolder = fullfile(handles.LocBase,'/Dev/img_hr/');
% else
%     iconsFolder = fullfile(handles.LocBase,'/Dev/img/');
% end
% 

% New 3.2
gif_image = [handles.LocBase,'/Dev/media/spinner2.gif'];
[handles.DataGifImage.im,handles.DataGifImage.map] = imread(gif_image,'frames','all');
handles.DataGifImage.delay = 0.1;

info=imfinfo(gif_image);
TransparentColor=info(1).TransparentColor;
info(1).ColorTable(TransparentColor,:)=[0.9400 0.9400 0.9400];

handles.DataGifImage.colortable =info(1).ColorTable;

% 

switch handles.DisplayMode % new 3.0.1
    case 'normal'
        iconsFolder = fullfile(handles.LocBase,'/Dev/icons/'); 
        
    case 'HD'
        iconsFolder = fullfile(handles.LocBase,'/Dev/icons_hr/');
        
end
[IconsData,IconsList] = ReadIconsFolder(iconsFolder);
%handles.iconsFolder = iconsFolder;
handles.IconsData = IconsData;
handles.IconsList = IconsList;

% -------------------------------------------------------------------------
%                       CREATE THE XMAPTOOLS PATH
% -------------------------------------------------------------------------

%
% Addpath (version 2.1.1 - Nov 2014)
FunctionPath = strcat(LocBase,'/Functions');
addpath(FunctionPath);
ModulesPath = strcat(LocBase,'/Modules');
addpath(ModulesPath);
ModulesPath = strcat(LocBase,'/Dev');
addpath(ModulesPath);

if exist(strcat(LocBase(1:end-7),'/UserFiles')) == 7        % test if the directory exists
    FunctionPath = strcat(LocBase(1:end-7),'/UserFiles');
    addpath(FunctionPath);
end

if exist(strcat(LocBase(1:end-7),'/Addons')) == 7        % test if the directory exists
    %FunctionPath = strcat(LocBase(1:end-7),'/Addons');
    %addpath(FunctionPath);
    
    ThereCouldBeAddons = 1;
else
    
    ThereCouldBeAddons = 0;
end

% Path and display
set(handles.PRAffichage0,'String',LocBase);
LocAct = char(cd);
set(handles.PRAffichage01,'String',LocAct);


% -------------------------------------------------------------------------
%                            AXES AND COLORMAPS
% -------------------------------------------------------------------------


% Figure axes
set(handles.axes1,'xtick',[], 'ytick',[]);
set(handles.axes2,'xtick',[], 'ytick',[]);
set(handles.axes3,'xtick',[], 'ytick',[]);


% Read colormaps (3.2.1)
handles = ReadColorMaps(handles);

ColorMaps = handles.ColorMaps;
NbCM = length(ColorMaps);

Type = zeros(NbCM,1);

for i = 1:NbCM
    NamesDef{i} = ColorMaps(i).Name;
    Type(i) = 1;  % auto 
end

%      ----------------------------------------------------
%       Code    Description         Additional info   
%      ----------------------------------------------------
%       1       Auto XMapTools      ... to be interpolated
%       0       File                ... to be interpolated
%       2       MATLAB colormap
%      ----------------------------------------------------

% Old colormaps (to be deleted)
ToAddNames = {'Jet','Parula','Bone','Copper','Pink'};
ToAddType = [2;2;2;2;2];

Names = [NamesDef,ToAddNames];
Types = [Type;ToAddType];

set(handles.PopUpColormap,'String',Names);
set(handles.PopUpColormap_LEFT,'String',Names);
handles.ColorBArTypes = Types;

%handles.wyrk = load('ColorScaleWYRK.txt');
%handles.cw = load('ColorScaleCW.txt');
%handles.CSfw = load('ColorScaleFreezeWarm.txt');

% Figure auto-contrast
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0;

% Graphic window
handles.PositionAxeWindow(1,:) = [0.1389 0.0914 0.8547 0.7402];
handles.PositionAxeWindow(2,:) = [0.2769 0.1872 0.5814 0.5414];
handles.PositionAxeWindow(3,:) = [0.4149 0.2830 0.3081 0.3426];
handles.PositionAxeWindowValue = 1;

% Histogram Mode
handles.HistogramMode = 0;

% UiContextMenu
%handles.ContextMenu = get(handles.axes1,'uicontextmenu');

handles.OptionPanelDisp = 0;
handles.AdminPanelDisp = 0;

% Desactivate the X-Pad Correction Mode
set(handles.ButtonXPadApply,'UserData',0,'Visible','off');


% -------------------------------------------------------------------------
%                            DEFAULT SETTINGS
% -------------------------------------------------------------------------

% Default settings  (New 2.1.1)
load([handles.LocBase,'/Default_XMapTools.mat']);

set(handles.DisplayComments,'Value',Default_XMapTools(1));
set(handles.ActivateDiary,'Value',Default_XMapTools(2));
set(handles.DisplayActions,'Value',Default_XMapTools(3));
set(handles.DisplayCoordinates,'Value',Default_XMapTools(4));
set(handles.PopUpColormap,'Value',Default_XMapTools(5));
set(handles.PopUpColormap_LEFT,'Value',Default_XMapTools(5));
set(handles.CheckLogColormap,'Value',Default_XMapTools(6));
set(handles.CheckLogColormap_LEFT,'Value',Default_XMapTools(6));

if length(Default_XMapTools) < 7
    Default_XMapTools(7) = 64;
    Default_XMapTools(8) = 0;
    Default_XMapTools(9) = 1;
    Default_XMapTools(10) = 1;
    Default_XMapTools(11) = 0;
    Default_XMapTools(12) = 1;
end

set(handles.EditColorDef,'String',num2str(Default_XMapTools(7)));
set(handles.CheckInverseColormap,'Value',Default_XMapTools(8));

set(handles.SettingsAddCLowerCheck,'Value',Default_XMapTools(9));
set(handles.checkbox1,'Value',Default_XMapTools(9));
set(handles.SettingsAddCLowerMenu,'Value',Default_XMapTools(10));
set(handles.SettingsAddCUpperCheck,'Value',Default_XMapTools(11));
set(handles.checkbox7,'Value',Default_XMapTools(11));
set(handles.SettingsAddCUpperMenu,'Value',Default_XMapTools(12));

disp(' ')
disp(['Load default settings ... (from Default_XMapTools.mat) ... Done'])


% -------------------------------------------------------------------------
%                                  DIARY
% -------------------------------------------------------------------------

disp(' '), Date = clock;

if get(handles.ActivateDiary,'Value') % Activate Diary
    handles.diary = 1;
    
    DiaryName = strcat('Diary-',sprintf('%.0f %.0f %.0f %.0f %.0f',Date(1:end-1)),'.txt');
    [Success,Message,MessageID] = mkdir('XmapTools-Diary');
    diary(strcat('XmapTools-Diary/',DiaryName));
else
    handles.diary = 0;
end


% -------------------------------------------------------------------------
%                            UPDATE COMMAND WINDOW
% -------------------------------------------------------------------------

TexteVersion = ['Version: ',char(Version),' - ',char(ProgramState),' - ',char(ReleaseDate)];
Ltv = length(TexteVersion);
NbBlanc = round((67-Ltv)/2);
for i=1:NbBlanc
    TexteVersion = [' ',TexteVersion];
end


disp(' ')
disp('                               * * *  ');
disp(' ')
disp('      ------------------------------------------------------- ');
disp('       #   # #   # ##### ##### ##### ##### ##### #     #####  ');
disp('        # #  ## ## #   # #   #   #   #   # #   # #     #      ');
disp('         #   # # # ##### #####   #   #   # #   # #     #####  ');
disp('        # #  #   # #   # #       #   #   # #   # #         #  ');
disp('       #   # #   # #   # #       #   ##### ##### ##### #####  ');
disp('      ------------------------------------------------------- ');
disp(' ');
disp(TexteVersion);
disp(' ');
disp('                               * * *  ');
disp(' ');
%disp([num2str(Date(3)),'/',num2str(Date(2)),'/',num2str(Date(1)),' ',num2str(Date(4)),'h',num2str(Date(5)),'''',num2str(round(Date(6))),''''''])
disp(' ');
disp(' ');
if handles.diary
    disp(['Diary   ... (activation) ... Done']);
    disp(['Diary   ... (',char(DiaryName),') ... Done']);
else
    disp(['Diary   ... not activated (see user''s settings)']);
end
disp(' ');

% ##############################################

disp('Starting ... (Check XMapTools paths) ... Done')

if exist(strcat(LocBase(1:end-7),'/UserFiles')) == 7        % test if the directory exists
    disp('Starting ... (Check user files path) ... Done');
else
    disp('Starting ... (Check user files path) ... Error ES0145 - /UserFiles not found (see user guide)');
end


% Defaut parameters setting :
fid = fopen('XMap_Default.txt','r');
Compt = 1;
tline = fgets(fid);
while length(tline) > 1
    if tline(1) ~= '!' % for comments
        LesElems(Compt,:) = strread(tline,'%s','delimiter',' ');
        Compt = Compt+1;
    end
    tline = fgets(fid);
end
fclose(fid);

handles.NameMaps.filename = LesElems(:,2)';
handles.NameMaps.elements = LesElems(:,1)';
handles.NameMaps.oxydes = LesElems(:,3)';
handles.NameMaps.oxydes2 = LesElems(:,4)';
handles.NameMaps.ref = [1:length(handles.NameMaps.filename)];

disp('Starting ... (Load XMapTools Element list) ... Done')


% ----------------------------------------
% Standardization parameters List setting:
fid = fopen('Xmap_Standardization.txt','r');
Compt = 1;
tline = fgets(fid);
while 1
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) > 1
        if isequal(tline(1),'*')
            
            TheValues  = [];
            
            TheStr = strread(tline,'%s');
            TheVariableName = TheStr{2};
            TheVariableName = TheVariableName(1:end-1);
            
            for i = 3:length(TheStr)
                TheValues(i-2) = str2num(TheStr{i});
            end
            
            eval(['StandardizationParameters.',char(TheVariableName),' = TheValues;']);
        end
    end
    tline = fgets(fid);
end
fclose(fid);

handles.StandardizationParameters = StandardizationParameters;

guidata(hObject, handles);

disp('Starting ... (Load XMapTools Standardization parameters) ... Done')


% ----------------------
% Variable List setting:
fid = fopen('Xmap_Variables.txt','r');
Compt = 1;
tline = fgets(fid);
while length(tline) > 1
    if tline(1) ~= '!' % for comments
        TheStr = strread(tline,'%s');
        ResultsVariables(Compt).name = TheStr{1};
        ResultsVariables(Compt).code = TheStr{2};
        ListVaris{Compt} = TheStr{1};
        Compt = Compt+1;
    end
    tline = fgets(fid);
end
fclose(fid);

set(handles.REppmenu3,'String',ListVaris);
handles.ResultsVariables = ResultsVariables;

guidata(hObject, handles);

REppmenu3_Callback(hObject, eventdata, handles);

disp('Starting ... (Load XMapTools variables for Results) ... Done')


% -----------------------------------
% Variables definition for GENERATOR:
fid = fopen('Xmap_VarDefinition.txt','r');
Compt = 0;

while 1
    tline = fgets(fid);
    if isequal(tline,-1)
        break
    end
    
    if length(tline) > 1 
        if isequal(tline(1),'>')
            Compt = Compt+1;
            GeneratorVariables(Compt).Title = tline(3:end-1);
            
            ComptVar = 0;
            while 1
                tline = fgets(fid);
                if length(tline) > 3
                    ComptVar = ComptVar+1;
                    Code = strread(tline,'%s','delimiter','');
%                     while isequal(Code(end),sprintf('\n'))
%                         disp('Format issue with the file Xmap_VarDefinition.txt')
%                         Code = Code(1:end-1);
%                         keyboard
%                     end
                    GeneratorVariables(Compt).Code{ComptVar} = Code;
                else
                    break
                end
            end
        end
    end
end
fclose(fid);

handles.GeneratorVariables = GeneratorVariables;

disp('Starting ... (Load variables for the Generator module) ... Done')

% --------------------
% Spider List setting:
handles = ReadSpiderFileNORM(handles);

% ------------------------
% Conversion factors list:
handles = ReadConversionFactors(handles);

% ------------------------
% Oxide data (molar mass & conversion) list:
handles = ReadOxideData(handles);


% -------------
% SpiderColors: 
handles = ReadSpiderFileCOLORS(handles);



% handles.NameMaps.filename = {'na','mg','al','si','p','s','cl','k','ca','ti','v','cr','mn','fe','co','ni','cu','zn','zr','ag','cd','sn','ce'};
% handles.NameMaps.elements = {'Na','Mg','Al','Si','P','S','Cl','K','Ca','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','Zr','Ag','Cd','Sn','Ce'};
% handles.NameMaps.oxydes = {'Na2O','MgO','Al2O3','SiO2','P2O5','SO2','Cl2O','K2O','CaO','TiO2','V2O5','Cr2O3','MnO','FeO','CoO','NiO','CuO','ZnO','ZrO2','AgO','CdO','SnO2','CeO2'};
% handles.NameMaps.oxydes2 = {'NA2O','MGO','AL2O3','SIO2','P2O5','SO2','CL2O','K2O','CAO','TIO2','V2O5','CR2O3','MNO','FEO','COO','NIO','CUO','ZNO','ZRO2','AGO','CDO','SNO2','CEO2'};
% handles.NameMaps.ref = [1:length(handles.NameMaps.filename)];

% Database of minerals : lire le fichier Mineralo.txt
% handles.NameMin.name = {'Chlorite','Mica','Biotite','Quartz','Feldspath','Plagioclase'};
% handles.NameMin.abrev = {'Chl','Mic','Biotite'};
% handles.NameMin.struct = {'FctFSChlorite','FctFSphengite'};
% handles.NameMin.ref = [1:length(handles.NameMin.name)];

handles.data.map(1).type = 0;
handles.MaskFile(1).type = 0;
handles.profils = [];

handles.quanti(1).mineral = {'none'};
handles.quanti(1).elem = [];
handles.quanti(1).listname = [];
handles.quanti(1).maskfile = [];
handles.quanti(1).nbpoints = [];
handles.quanti(1).isoxide = [];

% Corrections settings:
handles.corrections(1).name = 'BRC';
handles.corrections(1).value = 0;
%
handles.corrections(2).name = 'TRC';
handles.corrections(2).value = 0;

handles.CorrectionMode = 0;  % used only to hide icones during select/unselect spot analyses

handles.save = 0;
handles.results = [];

disp('Starting ... (Setting additional GUI parameters) ... Done')

% ---------- TxtControl ----------
fid = fopen('XMap_Help.txt','r');
while 1
    LaLigne = fgetl(fid);
    if length(char(LaLigne)) == 3
        if LaLigne == 'END'
            break
        end
    end
    OnLit = 1;
    if LaLigne(1) == '!' || LaLigne(1) == '-'
        OnLit = 0;
    end
    if OnLit
        A = strread(char(LaLigne),'%s','delimiter','<');
        
        B = strread(char(A(1)),'%s','delimiter','.');
        Elemtxt = str2num(char(B(1)));
        Outxt = str2num(char(B(2)));
        
        Txt = char(A(2));
        TxtForm = Txt(3:end);
        
        LeCode = str2num(Txt(1));
        
        TxtDatabase(Elemtxt).txt{Outxt} = TxtForm;
        TxtDatabase(Elemtxt).Color(Outxt) = LeCode;
        
    end
end
fclose(fid);
handles.TxtDatabase = TxtDatabase;

set(handles.DisplayComments,'Value',1); % object

% Update handles structure
guidata(hObject, handles);

CodeTxt = [13,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

disp('Starting ... (Loading Help dialogs) ... Done')

% ---------- Structural Formulas and ThermoBaro functions ----------
% ...
% New 1.6.4 (P. Lanari 03/08/2013)
% Notes:
%      * Compatible with External variables (if defined)

if isequal(exist('ListFunctions_USER.txt'),2)
    fid = fopen('ListFunctions_USER.txt');
else
    fid = fopen('ListFunctions.txt');
end

Compt = 1;
tline = fgets(fid);
lesFormules = cell(1,7);
while length(tline) > 1
    if tline(1) ~= '!' % for commented lines
        TheLine = strread(tline,'%s','delimiter','>');
        if length(TheLine) == 6                                     % 1.6.4
            lesFormules(Compt,1:6) = TheLine;
            lesFormules{Compt,7} = '';            % Empty external variable
        else
            lesFormules(Compt,1:7) = TheLine;
        end
        Compt = Compt+1;
    end
    tline = fgets(fid);
end
fclose(fid);

% Variable ExternalFunctions with all the informations (different types)
externalFunctions(1).listMin = {};
externalFunctions(2).listMin = {};
externalFunctions(3).listMin = {};
externalFunctions(4).listMin = {};
externalFunctions(5).listMin = {};

for i=1:length(lesFormules(:,1))
    leCase = str2double(char(lesFormules(i,1)));
    
    readNameMin = lesFormules(i,2);
    
    Ou = find(ismember(externalFunctions(leCase).listMin,readNameMin));
    if isempty(Ou)
        onEcrit = length(externalFunctions(leCase).listMin) + 1;
        compt1 = 1;
    else
        onEcrit = Ou;
        compt1 = length(externalFunctions(leCase).minerals(onEcrit).listMeth) + 1;
    end
    
    externalFunctions(leCase).listMin{onEcrit} = char(readNameMin);
    externalFunctions(leCase).minerals(onEcrit).name = char(readNameMin);
    externalFunctions(leCase).minerals(onEcrit).listMeth(compt1) = lesFormules(i,3);
    
    externalFunctions(leCase).minerals(onEcrit).method(compt1).name = lesFormules(i,3);
    externalFunctions(leCase).minerals(onEcrit).method(compt1).file = lesFormules(i,4);
    externalFunctions(leCase).minerals(onEcrit).method(compt1).output = strread(char(lesFormules(i,5)),'%s','delimiter',' ');
    externalFunctions(leCase).minerals(onEcrit).method(compt1).input = strread(char(lesFormules(i,6)),'%s','delimiter',' ');
    
    % 1.6.4
    if char(lesFormules(i,7)) % external variable
        TheExternal = char(lesFormules(i,7));
        TheExternalSepar = strread(TheExternal,'%s','delimiter',')');
        clear TheExternalFinal
        for j=1:length(TheExternalSepar)
            TheExternalFinal = strread(char(TheExternalSepar{j}),'%s','delimiter','(');
            externalFunctions(leCase).minerals(onEcrit).method(compt1).variables{j} = TheExternalFinal{1};
            externalFunctions(leCase).minerals(onEcrit).method(compt1).varvals{j} = TheExternalFinal{2};
        end
    else
        externalFunctions(leCase).minerals(onEcrit).method(compt1).variables = {''};
        externalFunctions(leCase).minerals(onEcrit).method(compt1).varvals = {''};
    end
end

% update the menu lists (version 1.6.2):

set(handles.THppmenu3,'Value',1); % default: structural formulas

set(handles.THppmenu1,'String',externalFunctions(1).listMin);
set(handles.THppmenu1,'Value',1);

set(handles.THppmenu2,'String',externalFunctions(1).minerals(1).listMeth);
set(handles.THppmenu2,'Value',1);


handles.externalFunctions = externalFunctions;


if isequal(exist('ListFunctions_USER.txt'),2)
    disp('Starting ... (External functions: ListFunctions_USER.txt [user file]) ... Done'),
    disp('WARNING - You are not using the XMapTools default file ListFunction.txt (see above) !!!')
else
    disp('Starting ... (External functions: ListFunctions.txt [default]) ... Done'),
end


% ---------- Add-ons ----------
disp(' ')
disp('Add-ons ... (Check for XMapTools add-ons) ... ');
%handles.Addons = [];

Print = 1;
[handles] = ReadAddons(Print,hObject,handles);   % 3.3.1

% if ThereCouldBeAddons
%     
%     D = dir([LocBase(1:end-7),'/Addons']);
%     
%     ContAddon = 0;
%     CorrAdd = 0;
%     
%     for i=3:length(D)
%         
%         if D(i).isdir
%             % Potential Add-on:
%             AddonName = D(i).name;
%             
%             Test1 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'.p']);
%             if ~Test1
%                 Test1 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'.m']);
%             end
%             
%             Test2 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'_Install.p']);
%             if ~Test2
%                 Test2 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'_Install.m']);
%             end
%             
%             if Test1 && Test2
%                 % Add the new add-on
%                 ContAddon = ContAddon + 1;
%                 
%                 handles.Addons(ContAddon).name = AddonName;
%                 handles.Addons(ContAddon).valid = 1;
%                 
%                 if ispc
%                     handles.Addons(ContAddon).path = [LocBase(1:end-7),'Addons\',AddonName,'\'];
%                 else
%                     handles.Addons(ContAddon).path = [LocBase(1:end-7),'Addons/',AddonName,'/'];
%                 end
%                 
%                 addpath(handles.Addons(ContAddon).path);
%                 ListAddons{ContAddon} = AddonName;
%                 
%                 disp(['Add-ons ...   - ',handles.Addons(ContAddon).name,':   check test: ok   *** Activated ***']);
%             else
%                 disp(['Add-ons ...   * ',AddonName,':   add-on package seems corrupted    (not available)']);
%                 CorrAdd = CorrAdd+1;
%             end
%         end
%     end
%     
%     if ~ContAddon && ~CorrAdd
%         disp(['Add-ons ... *** No add-on packages in the add-on directory ***']);
%     end
%     if ContAddon
%         set(handles.Menu_AddonsList,'String',ListAddons,'Value',1);
%     end
%     
% else
%     disp('WARNING - XMapTools does not find the add-on directory!')
% end

disp('Add-ons ... (Check for XMapTools add-ons) ... Done')

disp(' ')

% ---------- Masks methods ----------
MethodList = {'Classic computation','Normalized intensities'};
set(handles.PPMaskMeth,'String',MethodList);
set(handles.PPMaskMeth,'Value',2);

% ---------- Quantification methods ----------
MethodListQuanti = {'Advanced Standardization','Manual (homogeneous phase)','Auto (no backround correction)','Transfer to quanti'};
set(handles.QUmethod,'String',MethodListQuanti);


% ---------- Display options ----------
handles.rotateFig = 0;


% Were there before 3.4.1: FigureInitialization & OnEstOu


if isequal(handles.Xmode,'admin')
    %iconsFolder = fullfile(get(handles.PRAffichage0,'String'),'/Dev/img/');
    %iconsFolder = handles.iconsFolder;                          % new 3.0.1
    
    handles = UpdateIconButton('ADMINbutton1','administrator.jpg','Open admin panel',handles);
    handles = UpdateIconButton('DebugMode','shell.jpg','Debug mode [ADMIN]',handles);
    handles = UpdateIconButton('MaskButton8','shell.jpg','Grain Boundary Orientation [ADMIN]',handles);
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'administrator.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ADMINbutton1,'string',str,'visible','on','TooltipString','Open admin panel');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'shell.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.DebugMode,'string',str,'visible','on','TooltipString','Debug mode [ADMIN]');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'shell.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.MaskButton8,'string',str,'visible','on','TooltipString','Grain Boundary Orientation [ADMIN]');
    
else
    set(handles.ADMINbutton1,'visible','off');
end


if isequal(handles.Xmode,'admin')
    disp('XMapTools [ADMIN]; the dark side is fully flowing through your veins!')
else
    disp('XMapTools will soon be ready to work; thanks for using the software and enjoy!')
end
disp(' ')

% set the figure large enough and centered (new 2.6.2)

%disp('_ Before anything')
%disp([get(gcf,'Units'),' ',num2str(get(gcf,'Position'))])

UnitBefore = get(gcf,'Units');
set(gcf,'Units','pixels');

%disp('_ After changing to pixels')
%disp([get(gcf,'Units'),' ',num2str(get(gcf,'Position'))])

FigPosition = get(gcf,'Position');
ScreenSize = get(0,'ScreenSize');

RatioXMapTools = 0.6007;
ProportionScreen = 0.9;
RatioScreen = ScreenSize(4)/ScreenSize(3);

if RatioScreen < RatioXMapTools
    FigHeight = ScreenSize(4)*ProportionScreen;
    FigWidth = FigHeight/RatioXMapTools;
else
    FigWidth = ScreenSize(3)*ProportionScreen;
    FigHeight = FigWidth*RatioXMapTools;
end
FigX = (ScreenSize(3)-FigWidth)/2;
FigY = (ScreenSize(4)-FigHeight)/3;

set(gcf,'Position',[FigX,FigY,FigWidth,FigHeight]) 
set(gcf,'Units',UnitBefore);
movegui(gcf,'center');

% -------------------------------------------------------------------------
% Update of the GUI Only here... (3.4.1)

% Update the logo
axes(handles.LOGO);

image(handles.LogoXMapTools), axis image
set(gca,'handlevisibility','off','visible','off')    

% Fix a bug on MATLAB 2016a (colorbar displayed within the logo axes)
axes(handles.axes1);
     
% update display MaJ 1.4.1
AffOPT(1, hObject, eventdata, handles);

% Set handles.activecolorbar:
[handles] = XMapColorbar('Init',1,handles);

% Update Environnement
FigureInitialization(hObject, eventdata, handles);
OnEstOu(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% ---------- Additional functions (new 2.1.3) ----------
if length(handles.Xload)
    % we must open a project...
    if exist(handles.Xload) == 2
        
        s=dir([cd,'/',handles.Xload]); 
        
        CodeTxt = [1,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),num2str(s.bytes/1e6,'%.2f'),' MB - loading can take some time :)']);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        XMapTools_LoadProject(hObject, eventdata, handles, handles.Xload, handles.Xload);
        
    end
end

if exist([handles.LocBase,'/XMT_Msg.txt'])
    movefile([handles.LocBase,'/XMT_Msg.txt'],[handles.LocBase,'/XMT_Msg_update.txt'],'f');
    web([handles.LocBase,'/XMT_Msg_update.txt'])
end
    
return


% General output function
function varargout = VER_XMapTools_804_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [1];% handles.output;
%keyboard
return



% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%                          FONCTIONS GENERALES (V1.6)
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



% #########################################################################
%     ABOUT VER_XMAPTOOLS_804... V1.5.4
function AboutXMapTools_Callback(hObject, eventdata, handles)

 

url = [handles.LocBase,'/About.txt'];
web(url)

return

warndlg({' ', ...
    'XMapTools has been created by Pierre Lanari', ...
    'contact: pierre.lanari@geo.unibe.ch', ...
    ' ', ...
    'find out more at http://www.xmaptools.com', ...
    ' ',' ', ...
    '>> XMapTools License Policies: ', ...
    ' ', ...
    'XMapTools is distributed in an Double Regime: Academic and Commercial. In the Academic and Public Research World XMapTools is distributed under the terms of the Scientific Software Open Source Academic For Free License. This License sets the code GRATIS and Open Source and grants Freedom to use copy study modify and redistribute it. But these policies hold only within the Academic and Public Research world. In the Commercial World XMapTools is going to be distributed under other Licenses, to be negotiated from case to case. In this case it is a paying code, and exclusiveness for a certain merceological sector, or even full exclusiveness can be agreed with commercial institutions.',...
    ' ',' ',' ',},'About XMapTools... ');
return


function FigureInitialization(hObject, eventdata, handles)
%

%iconsFolder = fullfile(get(handles.PRAffichage0,'String'),'/Dev/img/');
%iconsFolder = handles.iconsFolder;                          % new 3.0.1

%set(handles.OPT1,'TooltipString','X-ray mode')
%set(handles.OPT2,'TooltipString','Quanti mode')
%set(handles.OPT3,'TooltipString','Result mode')


% Here the buttons that don't need update...

%iconUrl = strrep([handles.FileDirCode, iconsFolder 'box_open.png'],'\','/');
%str = ['<html><img src="' iconUrl '"/></html>'];
%set(handles.Button2,'string',str,'TooltipString','Open existing project ...');

%iconUrl = strrep([handles.FileDirCode, iconsFolder 'new_window.png'],'\','/');
%str = ['<html><img src="' iconUrl '"/></html>'];
%set(handles.Button1,'string',str,'TooltipString','Close and open a new XMapTools window ...');

%iconUrl = strrep([handles.FileDirCode, iconsFolder 'cross.png'],'\','/');
%str = ['<html><img src="' iconUrl '"/></html>'];
%set(handles.Button4,'string',str,'TooltipString','Close and exit XMapTools ...');

%iconUrl = strrep([handles.FileDirCode, iconsFolder 'setting_tools.png'],'\','/');
%str = ['<html><img src="' iconUrl '"/></html>'];
%set(handles.ButtonSettings,'string',str,'TooltipString','XMapTools settings ...');

%iconUrl = strrep([handles.FileDirCode, iconsFolder 'information.png'],'\','/');
%str = ['<html><img src="' iconUrl '"/></html>'];
%set(handles.AboutXMapTools,'string',str,'TooltipString','XMapTools info ...');


handles = UpdateIconButton('MButton1','picture_add.jpg','Import map(s) ...',handles);
handles = UpdateIconButton('ButtonUp','arrow_up.jpg','Move up ...',handles);
handles = UpdateIconButton('ButtonDown','arrow_down.jpg','Move down ...',handles);
handles = UpdateIconButton('ButtonRight','arrow_right.jpg','Move right ...',handles);
handles = UpdateIconButton('ButtonLeft','arrow_left.jpg','Move left ...',handles);
handles = UpdateIconButton('THbutton2','info_rhombus.jpg','Information ...',handles);

% iconUrl = strrep([handles.FileDirCode, iconsFolder 'picture_add.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.MButton1,'string',str,'TooltipString','Import map(s) ...');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'arrow_up.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.ButtonUp,'string',str,'TooltipString','Move up ...');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'arrow_down.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.ButtonDown,'string',str,'TooltipString','Move down ...');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'arrow_right.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.ButtonRight,'string',str,'TooltipString','Move right ...');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'arrow_left.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.ButtonLeft,'string',str,'TooltipString','Move left ...');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'info_rhombus.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.THbutton2,'string',str,'TooltipString','Information ...');


DisplayComments_Callback(hObject, eventdata, handles);


guidata(hObject, handles);
return


function [IconsData,IconsList] = ReadIconsFolder(iconsFolder)
%

Files = dir([iconsFolder,'*.jpg']);
Compt = 0;
for i = 1:length(Files)
    
    if ~isequal(Files(i).name(1),'.')
        Compt = Compt +1;
        IconsData(Compt).name = Files(i).name;
        %Files(i).name
        IconsData(Compt).image = imread([iconsFolder,Files(i).name]);
        IconsList{Compt} = IconsData(Compt).name;
    end
    
    
end  

return


function [handles] = UpdateIconButton(ButtonName,ImageName,Text,handles)
%

Idx = find(ismember(handles.IconsList,ImageName));

if ~Idx 
    % HERE Question MARK %
end

BackColor = [1,1,1];
if length(ImageName) > 7
    if isequal(ImageName(end-6:end),'_bw.jpg')
        BackColor = [0.65,0.65,0.65];
    end
end

eval(['set(handles.',ButtonName,',''CData'',handles.IconsData(Idx).image,''String'','''',''Tooltip'',''',Text,''',''BackgroundColor'',[',num2str(BackColor(1)),',',num2str(BackColor(2)),',',num2str(BackColor(3)),']);'])

return


% ****
% #########################################################################
%     FONCTION ON EST OU
function OnEstOu(hObject, eventdata, handles)
%

%tic
% New XMapTools 3.0.1 - Find the active workspace and only apply the
%                       changes to the active workspace
WP1 = get(handles.OPT1,'Value');
WP2 = get(handles.OPT2,'Value');
WP3 = get(handles.OPT3,'Value');

% main directory of the icons...
%iconsFolder = fullfile(get(handles.PRAffichage0,'String'),'/Dev/img/');
%iconsFolder = handles.iconsFolder;                          % new 3.0.1

% Display update
set(handles.SamplingDisplay,'String','');

if isequal(get(handles.ButtonXPadApply,'UserData'),0)
    CorrectionMode = 0;
else
    CorrectionMode = 1;
end

if handles.HistogramMode && ~CorrectionMode   % We are using the Correction Mode for the histogram mode...
    CorrectionMode = 1;
end

if handles.CorrectionMode
    CorrectionMode = 1;
end

% Button Credits
%str = '<HTML><center>Find out more at <br /><a href="http://www.ver_xmaptools_804.com">www.ver_xmaptools_804.com</a></center></HTML>';
%jDispLink = findjobj(handles.DispLink);
%jDispLink.setContentAreaFilled(0);
%jDispLink.setBorder([]);

XmapWaitBar(1, handles);
% Check existing timers and clear
out = timerfindall;
for i = 1:length(out)
    stop(out(i));
    delete(out(i));
end

% Add on
AddOnList = get(handles.Menu_AddonsList,'String');
AddonSel = get(handles.Menu_AddonsList,'Value');
if iscell(AddOnList)
    AddonName = char(AddOnList{AddonSel});
    set(handles.Menu_AddonsList,'Enable','On');
else
    AddonName = AddOnList;
    set(handles.Menu_AddonsList,'Enable','On');
end

if isequal(AddonName,'no add-on')
    set(handles.Menu_AddonsList,'Enable','off');
    set(handles.Button_AddonRun,'Enable','off');
else
    if CorrectionMode
        set(handles.Button_AddonRun,'Enable','off');
    else
        set(handles.Button_AddonRun,'Enable','on');
    end
end

% MENU and correction mode
if CorrectionMode
    set(handles.Menu_File,'Enable','off');
    set(handles.Menu_Edit,'Enable','off');
    set(handles.Menu_Image,'Enable','off');
    set(handles.Menu_Modules,'Enable','off');
    set(handles.Menu_Sampling,'Enable','off');
    set(handles.Menu_Workspace,'Enable','off');
    set(handles.Menu_Help,'Enable','off');
else
    set(handles.Menu_File,'Enable','on');
    set(handles.Menu_Edit,'Enable','on');
    set(handles.Menu_Image,'Enable','on');
    set(handles.Menu_Modules,'Enable','on');
    set(handles.Menu_Sampling,'Enable','on');
    set(handles.Menu_Workspace,'Enable','on');
    set(handles.Menu_Help,'Enable','on');
end

% NEW 2.5.1 to unfreeze the interface if the program is crashed. 
if CorrectionMode
    
    handles = UpdateIconButton('ButtonUnfreeze','unfreeze.jpg','Unfreeze the interface ...',handles);
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'unfreeze.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ButtonUnfreeze,'string',str,'TooltipString','Unfreeze the interface ...');
    
    set(handles.ButtonUnfreeze,'Visible','on');
else
    
    handles = UpdateIconButton('ButtonUnfreeze','unfreeze_bw.jpg','Unfreeze the interface ...',handles);

%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'unfreeze_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ButtonUnfreeze,'string',str,'TooltipString','Unfreeze the interface ...');
    
    set(handles.ButtonUnfreeze,'Visible','off');
end


% ZOOM button
UpdateZoomButtons(handles);


% 0) FIGURE
if isequal(get(handles.axes1,'Visible'),'on') && ~CorrectionMode
    % On affiche les options
    %set(handles.ExportWindow,'Enable','on');
    set(handles.checkbox1,'Enable','on');
    set(handles.checkbox7,'Enable','on');
    set(handles.FIGbutton1,'Enable','on');
    set(handles.FIGtext1,'Enable','on');
    set(handles.ColorMin,'Enable','on');
    set(handles.ColorMax,'Enable','on');
    set(handles.ColorButton1,'Enable','on');
    
    %set(handles.BUsampling1,'Enable','on');
    %set(handles.BUsampling2,'Enable','on');
    %set(handles.BUsampling3,'Enable','on');
    %set(handles.BUsampling4,'Enable','on');
    %set(handles.BUsampling5,'Enable','on');
    %set(handles.SamplingDisplay,'Enable','on');
    
    set(handles.PopUpColormap,'Enable','on');
    set(handles.PopUpColormap_LEFT,'Enable','on');
    set(handles.CheckLogColormap,'Enable','on');
    set(handles.CheckLogColormap_LEFT,'Enable','on');
    set(handles.RotateButton,'Enable','on');
    
    set(handles.ButtonFigureMode,'Enable','on');
    set(handles.ButtonWindowSize,'Enable','on');
    
    set(handles.text77,'Enable','on');  % black layer text
    
    %Menu: 
    set(handles.Menu_ExportWindow,'Enable','on');
    set(handles.Menu_Copy,'Enable','on');
    set(handles.Menu_CleanFigure,'Enable','on');
    
    set(handles.Menu_SamplingLine,'Enable','on');
    set(handles.Menu_SamplingPath,'Enable','on');
    set(handles.Menu_SamplingArea,'Enable','on');
    set(handles.Menu_SamplingIntLine,'Enable','on');
    set(handles.Menu_SamplingSlideWin,'Enable','on');
    
    % Icons that do not need to be hidden in HISTOGRAM mode:
    
    if handles.AutoContrastActiv
        
        handles = UpdateIconButton('ColorButton1','magic_wand_active.jpg','Disable auto-contrast ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'magic_wand_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ColorButton1,'string',str,'TooltipString','Disable auto-contrast ...');
    else
        
        handles = UpdateIconButton('ColorButton1','magic_wand.jpg','Apply auto-contrast ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'magic_wand.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ColorButton1,'string',str,'TooltipString','Apply auto-contrast ...');
    end
    
    if handles.MedianFilterActiv
        
        handles = UpdateIconButton('FIGbutton1','filter_delete.jpg','Disable median-filter ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_delete.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.FIGbutton1,'string',str,'TooltipString','Disable median-filter ...');
    else
        
        handles = UpdateIconButton('FIGbutton1','filter_add.jpg','Apply median-filter ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_add.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.FIGbutton1,'string',str,'TooltipString','Apply median-filter ...');
    end
    
    % Axes1 Window and size
    set(handles.uipanel59,'Position',handles.PositionAxeWindow(handles.PositionAxeWindowValue,:));
    set(handles.uipanel60,'Position',handles.PositionAxeWindow(handles.PositionAxeWindowValue,:));
    
    if handles.PositionAxeWindowValue == 1 || handles.PositionAxeWindowValue == 2
        
        handles = UpdateIconButton('ButtonWindowSize','layer_resize_actual.jpg','Reduce size of display window ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_resize_actual.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ButtonWindowSize,'string',str,'TooltipString','Reduce size of display window ...');
    else
        
        handles = UpdateIconButton('ButtonWindowSize','layer_resize.jpg','Increase size of display window ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_resize.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ButtonWindowSize,'string',str,'TooltipString','Increase size of display window ...');
    end
    
    
    % HISTOGRAM MODE
    
    % Now we arrive here if HistogramMode = 0.  (and in the next loop if HistogramMode = 1)
    
    if handles.HistogramMode                  % if HISTOGRAM mode is ACTIVE
        set(handles.uipanel60,'visible','on');
        set(handles.uipanel59,'visible','off');
        
        set(handles.ButtonFigureMode,'Enable','on');
        
        handles = UpdateIconButton('ButtonFigureMode','layer_raster.jpg','Disable histogram mode (back to mapping mode) ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_raster.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ButtonFigureMode,'string',str,'TooltipString','Disable histogram mode (back to mapping mode) ...');

        
    else                                  % if HISTOGRAM mode is NOT ACTIVE
        set(handles.uipanel60,'visible','off');
        set(handles.uipanel59,'visible','on');
        
        set(handles.ButtonFigureMode,'Enable','on');
        
        handles = UpdateIconButton('ButtonFigureMode','layer_histogram.jpg','Enable histogram mode ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_histogram.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ButtonFigureMode,'string',str,'TooltipString','Enable histogram mode ...');
        
    end
    
    %iconUrl = strrep([handles.FileDirCode, iconsFolder 'export.png'],'\','/');
    %str = ['<html><img src="' iconUrl '"/></html>'];
    %set(handles.ExportWindow,'string',str,'TooltipString','Export displayed image ...');
    
    handles = UpdateIconButton('RotateButton','arrow_rotate.jpg','Rotate the figure of 90? (counterclockwise) ...',handles);
    handles = UpdateIconButton('BUsampling2','draw_line.jpg','Sampling: line mode ...',handles);
    handles = UpdateIconButton('BUsampling3','select_lasso.jpg','Sampling: area mode ...',handles);
    handles = UpdateIconButton('BUsampling4','draw_rectangle.jpg','Sampling: integrated line mode ...',handles);
    handles = UpdateIconButton('BUsampling5','draw_scanningwindow.jpg','Sampling: scanning window mode ...',handles);
    handles = UpdateIconButton('MButton4','format_percentage.jpg','Display precision map (in %) ...',handles);
    handles = UpdateIconButton('MButton3','info_rhombus.jpg','Display "info" window ...',handles);

    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'arrow_rotate.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.RotateButton,'string',str,'TooltipString','Rotate the figure of 90? (counterclockwise) ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'draw_line.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling2,'string',str,'TooltipString','Sampling: line mode ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'select_lasso.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling3,'string',str,'TooltipString','Sampling: area mode ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'draw_rectangle.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling4,'string',str,'TooltipString','Sampling: integrated line mode ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'draw_scanningwindow.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling5,'string',str,'TooltipString','Sampling: scanning window mode ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'format_percentage.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.MButton4,'string',str,'TooltipString','Display precision map (in %) ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'info_rhombus.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.MButton3,'string',str,'TooltipString','Display "info" window ...');
    
    
else
    
    % Now we arrive here if HistogramMode = 1  / Corr mode = 1 .
    
    if handles.HistogramMode                  % if HISTOGRAM mode is ACTIVE
        set(handles.uipanel60,'visible','on');
        set(handles.uipanel59,'visible','off');
        
        set(handles.ButtonFigureMode,'Enable','on');
        
        handles = UpdateIconButton('ButtonFigureMode','layer_raster.jpg','Disable histogram mode (back to mapping mode) ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_raster.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ButtonFigureMode,'string',str,'TooltipString','Disable histogram mode (back to mapping mode) ...');
%         

    else                                  % if HISTOGRAM mode is NOT ACTIVE
        set(handles.uipanel60,'visible','off');
        set(handles.uipanel59,'visible','on');
        
        set(handles.ButtonFigureMode,'Enable','off');
        
        handles = UpdateIconButton('ButtonFigureMode','layer_histogram_bw.jpg','',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_histogram_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ButtonFigureMode,'string',str);
        
    end
    
    %set(handles.ExportWindow,'Enable','off');
    set(handles.checkbox1,'Enable','off');
    set(handles.checkbox7,'Enable','off');
    set(handles.FIGbutton1,'Enable','off');
    set(handles.FIGtext1,'Enable','off');
    set(handles.ColorMin,'Enable','off');
    set(handles.ColorMax,'Enable','off');
    set(handles.ColorButton1,'Enable','off');
    
    %set(handles.BUsampling1,'Enable','off');
    set(handles.BUsampling2,'Enable','off');
    set(handles.BUsampling3,'Enable','off');
    set(handles.BUsampling4,'Enable','off');
    set(handles.BUsampling5,'Enable','off');
    set(handles.SamplingDisplay,'Enable','inactive');
    
    set(handles.RotateButton,'Enable','off');
    
    set(handles.CheckLogColormap_LEFT,'Enable','off');
    set(handles.PopUpColormap_LEFT,'Enable','off');
    
    %set(handles.ButtonFigureMode,'Enable','off');
    set(handles.ButtonWindowSize,'Enable','off');
    
    set(handles.text77,'Enable','off');  % black layer text
    
    %Menu: 
    set(handles.Menu_ExportWindow,'Enable','off');
    set(handles.Menu_Copy,'Enable','off');
    set(handles.Menu_CleanFigure,'Enable','off');
    
    set(handles.Menu_SamplingLine,'Enable','off');
    set(handles.Menu_SamplingPath,'Enable','off');
    set(handles.Menu_SamplingArea,'Enable','off');
    set(handles.Menu_SamplingIntLine,'Enable','off');
    set(handles.Menu_SamplingSlideWin,'Enable','off');
    
    % Images:
    %iconUrl = strrep([handles.FileDirCode, iconsFolder 'export_bw.png'],'\','/');
    %str = ['<html><img src="' iconUrl '"/></html>'];
    %set(handles.ExportWindow,'string',str);
    
    handles = UpdateIconButton('RotateButton','arrow_rotate_bw.jpg','',handles);
    handles = UpdateIconButton('ColorButton1','magic_wand_bw_bw.jpg','',handles);
    handles = UpdateIconButton('FIGbutton1','filter_add_bw.jpg','',handles);
    handles = UpdateIconButton('ButtonWindowSize','layer_resize_actual_bw.jpg','',handles);
    handles = UpdateIconButton('BUsampling2','draw_line_bw.jpg','',handles);
    handles = UpdateIconButton('BUsampling3','select_lasso_bw.jpg','',handles);
    handles = UpdateIconButton('BUsampling4','draw_rectangle_bw.jpg','',handles);
    handles = UpdateIconButton('BUsampling5','draw_scanningwindow_bw.jpg','',handles);
    handles = UpdateIconButton('MButton4','format_percentage_bw.jpg','',handles);
    handles = UpdateIconButton('MButton3','info_rhombus_bw.jpg','',handles);
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'arrow_rotate_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.RotateButton,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'magic_wand_bw_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ColorButton1,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_add_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.FIGbutton1,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_resize_actual_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ButtonWindowSize,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'draw_line_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling2,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'select_lasso_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling3,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'draw_rectangle_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling4,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'draw_scanningwindow_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.BUsampling5,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'format_percentage_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.MButton4,'string',str);
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'info_rhombus_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.MButton3,'string',str);
    
end

% New MaskFile Menu

if handles.MaskFile(1).type == 0 || CorrectionMode
    set(handles.LeftMenuMaskFile,'Enable','off');
    set(handles.Menu_MaskFileSize,'Enable','off');
else
    set(handles.LeftMenuMaskFile,'Enable','on');
    set(handles.Menu_MaskFileSize,'Enable','on');
end


if WP1
    % 1) RAW DATA
    data = handles.data;
    if length(data.map) == 1 || CorrectionMode
        % avec ou sans maps:
        if data.map(1).type == 0 || CorrectionMode
            set(handles.PPMenu1,'Enable','off');
            set(handles.MButton2,'Enable','off');
            set(handles.MButton3,'Enable','off');
            set(handles.MButton4,'Enable','off');
            set(handles.PPMaskMeth,'Enable','off');
            set(handles.PPMaskFrom,'Enable','off');
            set(handles.MaskButton1,'Enable','off');
            set(handles.PRButton1,'Enable','off'); % Pas de profils sans maps
            set(handles.MaskButton7,'Enable','off');

            %set(handles.Button3,'Enable','off'); % pas de sauvegarde
            %set(handles.Button5,'Enable','off');

            % Menu:
            set(handles.Menu_Button3,'Enable','off'); % pas de sauvegarde
            set(handles.Menu_Button5,'Enable','off');

            %set(handles.Tranfert2Quanti,'Enable','off'); % pas de TTQUanti

            handles = UpdateIconButton('PRButton1','layer_open_bw.jpg','',handles);
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_open_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.PRButton1,'string',str);

            % Images:
%             %iconUrl = strrep([handles.FileDirCode, iconsFolder 'save_data_bw.png'],'\','/');
%             %str = ['<html><img src="' iconUrl '"/></html>'];
%             %set(handles.Button3,'string',str);
% 
%             %iconUrl = strrep([handles.FileDirCode, iconsFolder 'save_as_bw.png'],'\','/');
%             %str = ['<html><img src="' iconUrl '"/></html>'];
%             %set(handles.Button5,'string',str);

            handles = UpdateIconButton('MaskButton7','layers_map_bw.jpg','',handles);
            handles = UpdateIconButton('MButton2','picture_delete_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.MaskButton7,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'picture_delete_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.MButton2,'string',str);

            Ou.data = 0; % Etat
        else
            set(handles.PPMenu1,'Enable','on');
            set(handles.MButton2,'Enable','off');
            set(handles.MButton3,'Enable','on');
            set(handles.MButton4,'Enable','on');
            set(handles.PPMaskMeth,'Enable','off');
            set(handles.PPMaskFrom,'Enable','off');
            set(handles.MaskButton1,'Enable','off');
            set(handles.PRButton1,'Enable','on');
            set(handles.MaskButton7,'Enable','off');

            %set(handles.Button3,'Enable','on');
            %set(handles.Button5,'Enable','on');

            % Menu:
            set(handles.Menu_Button3,'Enable','on'); 
            set(handles.Menu_Button5,'Enable','on');

            %set(handles.Tranfert2Quanti,'Enable','off'); % pas de TTQUanti

            handles = UpdateIconButton('PRButton1','layer_open.jpg','Import standard file ...',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_open.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.PRButton1,'string',str,'TooltipString','Import standard file ...');
% 
%             %
%             %iconUrl = strrep([handles.FileDirCode, iconsFolder 'save_data.png'],'\','/');
%             %str = ['<html><img src="' iconUrl '"/></html>'];
%             %set(handles.Button3,'string',str,'TooltipString','Save the project ...');
% 
%             %iconUrl = strrep([handles.FileDirCode, iconsFolder 'save_as.png'],'\','/');
%             %str = ['<html><img src="' iconUrl '"/></html>'];
%             %set(handles.Button5,'string',str,'TooltipString','Save the project as ...');
            
            handles = UpdateIconButton('MaskButton7','layers_map_bw.jpg','',handles);
            handles = UpdateIconButton('MButton2','picture_delete_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.MaskButton7,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'picture_delete_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.MButton2,'string',str);

            Ou.data = 1; % Etat
        end
    else
        % On charge tout
        set(handles.PPMenu1,'Enable','on');
        set(handles.MButton2,'Enable','on');
        set(handles.MButton3,'Enable','on');
        set(handles.MButton4,'Enable','on');
        set(handles.PPMaskMeth,'Enable','on');
        set(handles.PPMaskFrom,'Enable','on');
        set(handles.MaskButton1,'Enable','on');
        set(handles.PRButton1,'Enable','on');
        set(handles.MaskButton7,'Enable','on');

        %set(handles.Button3,'Enable','on');
        %set(handles.Button5,'Enable','on');

        % Menu:
        set(handles.Menu_Button3,'Enable','on');
        set(handles.Menu_Button5,'Enable','on');

        %set(handles.Tranfert2Quanti,'Enable','on');
        
        handles = UpdateIconButton('PRButton1','layer_open.jpg','Import standard file ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_open_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton1,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_open.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton1,'string',str,'TooltipString','Import standard file ...');
% 
%         %
%         %iconUrl = strrep([handles.FileDirCode, iconsFolder 'save_data.png'],'\','/');
%         %str = ['<html><img src="' iconUrl '"/></html>'];
%         %set(handles.Button3,'string',str,'TooltipString','Save the project ...');
% 
%         %iconUrl = strrep([handles.FileDirCode, iconsFolder 'save_as.png'],'\','/');
%         %str = ['<html><img src="' iconUrl '"/></html>'];
%         %set(handles.Button5,'string',str,'TooltipString','Save the project as ...');

        handles = UpdateIconButton('MaskButton7','layers_map.jpg','Import and merge maskfile(s) ...',handles);
        handles = UpdateIconButton('MButton2','picture_delete.jpg','Delete map ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton7,'string',str,'TooltipString','Import and merge maskfile(s) ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'picture_delete.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MButton2,'string',str,'TooltipString','Delete map ...');

        Ou.data = 2; % Etat
    end


    % 2) PROFILS
    if length(handles.profils) < 1 || CorrectionMode
        set(handles.PRButton5,'Enable','off');
        set(handles.PRButton3,'Enable','off');
        set(handles.PRButton4,'Enable','off');
        %   set(handles.PRButton2,'Enable','off'); % deleted in 2.1.3
        set(handles.PRButton7,'Enable','off');

        handles = UpdateIconButton('PRButton5','chart_curve_bw.jpg','',handles);
        handles = UpdateIconButton('PRButton3','lightbulb_add_bw.jpg','',handles);
        handles = UpdateIconButton('PRButton4','lightbulb_delete_bw.jpg','',handles);
        handles = UpdateIconButton('PRButton7','check_box_bw.jpg','',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'chart_curve_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton5,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'lightbulb_add_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton3,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'lightbulb_delete_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton4,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'check_box_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton7,'string',str);


        Ou.profil = 0;
    else
        set(handles.PRButton5,'Enable','on');
        set(handles.PRButton3,'Enable','on');
        set(handles.PRButton4,'Enable','on');
        %set(handles.PRButton2,'Enable','on');
        set(handles.PRButton7,'Enable','on');
        
        handles = UpdateIconButton('PRButton5','chart_curve.jpg','Display intensity vs composition chart ...',handles);
        handles = UpdateIconButton('PRButton3','lightbulb_add.jpg','Display standards ...',handles);
        handles = UpdateIconButton('PRButton4','lightbulb_delete.jpg','Hide standards ...',handles);
        handles = UpdateIconButton('PRButton7','check_box.jpg','Check quality of std/maps positions',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'chart_curve.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton5,'string',str,'TooltipString','Display intensity vs composition chart ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'lightbulb_add.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton3,'string',str,'TooltipString','Display standards ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'lightbulb_delete.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton4,'string',str,'TooltipString','Hide standards ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'check_box.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PRButton7,'string',str,'TooltipString','Check quality of std/maps positions');


        Ou.profil = 1;
    end


    % 3) MASQUES
    if handles.MaskFile(1).type == 0 || CorrectionMode
        set(handles.PPMenu2,'Enable','off');
        set(handles.PPMenu3,'Enable','off');
        set(handles.MaskButton2,'Enable','off');
        set(handles.MaskButton4,'Enable','off');
        set(handles.MaskButton3,'Enable','off');
        set(handles.MaskButton6,'Enable','off');
        set(handles.MaskButton9,'Enable','off');

        set(handles.MaskButton5,'Enable','off'); % pas de bouton delete

        %Menu:
        set(handles.Menu_MaskButton4,'Enable','off');
        
        handles = UpdateIconButton('MaskButton2','map_bw.jpg','',handles);
        handles = UpdateIconButton('MaskButton6','map_go_bw.jpg','',handles);
        handles = UpdateIconButton('MaskButton4','export_bw.jpg','',handles);
        handles = UpdateIconButton('MaskButton3','map_edit_bw.jpg','',handles);
        handles = UpdateIconButton('MaskButton5','map_delete_bw.jpg','',handles);
        handles = UpdateIconButton('MaskButton9','map_go_bw.jpg','',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton2,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton6,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'export_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton4,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_edit_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton3,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_delete_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton5,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton9,'string',str);

        Ou.masques = 0;
    else
        set(handles.PPMenu2,'Enable','on');
        set(handles.PPMenu3,'Enable','on');
        set(handles.MaskButton2,'Enable','on');
        set(handles.MaskButton4,'Enable','on');
        set(handles.MaskButton3,'Enable','on');
        set(handles.MaskButton6,'Enable','on');
        set(handles.MaskButton9,'Enable','on');

        %Menu:
        set(handles.Menu_MaskButton4,'Enable','on');

        Ou.masques = 1;

        if length(handles.MaskFile) > 1 % il faut au moins 2 masques pour en supp 1
            set(handles.MaskButton5,'Enable','on');

            handles = UpdateIconButton('MaskButton5','map_delete.jpg','Delete maskfile ...',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_delete.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.MaskButton5,'string',str,'TooltipString','Delete maskfile ...');

        else
            set(handles.MaskButton5,'Enable','off');
            
            handles = UpdateIconButton('MaskButton5','map_delete_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_delete_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.MaskButton5,'string',str);

        end

        handles = UpdateIconButton('MaskButton2','map.jpg','Display mask image ...',handles);
        handles = UpdateIconButton('MaskButton6','map_go.jpg','Export phase proportions ...',handles);
        handles = UpdateIconButton('MaskButton4','export.jpg','Export mask image ...',handles);
        handles = UpdateIconButton('MaskButton3','map_edit.jpg','Rename phases ...',handles);
        handles = UpdateIconButton('MaskButton9','map_go.jpg','Export mask file ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton2,'string',str,'TooltipString','Display mask image ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton6,'string',str,'TooltipString','Export phase proportions ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'export.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton4,'string',str,'TooltipString','Export mask image ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_edit.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton3,'string',str,'TooltipString','Rename phases ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.MaskButton9,'string',str,'TooltipString','Export mask file ...');

    end

    %On Affichage des bouttons profils que si XRay map

    % - - Change ici le 10 Octobre 2011 - Version 1.4.3
    % - - En effet, probl?me d'affichage au retour ? la partie Raw
    % - - Comme chaque partie affiche son image, on peut laisser les bouttons
    % - - dispo...

    % if get(handles.QUppmenu2,'Value') > 1 || get(handles.REppmenu1,'Value') > 1
    %     set(handles.PRButton3,'Enable','off')
    %     set(handles.PRButton4,'Enable','off')
    % end
    % if get(handles.QUppmenu2,'Value') == 0 && get(handles.REppmenu1,'Value') == 0 && Ou.profil == 1
    %     set(handles.PRButton3,'Enable','on')
    %     set(handles.PRButton4,'Enable','on')
    % end

    % 4) CORRECTIONS
    if  isequal(handles.corrections(1).value,1) && isequal(get(handles.OPT1,'value'),1) && ~CorrectionMode
        set(handles.CorrButtonBRC,'Enable','on');
    else
        set(handles.CorrButtonBRC,'Enable','off');
    end

    % if  isequal(handles.corrections(2).value,1)
    %     set(handles.CorrButtonTRC,'Enable','on');
    % else
    %     set(handles.CorrButtonTRC,'Enable','off');
    % end


    if isequal(get(handles.axes1,'Visible'),'off')    % Activate this if we have data
        
        set(handles.CorrButton1,'Enable','off');
        set(handles.CorrPopUpMenu1,'Enable','off');
    else
        if get(handles.CorrPopUpMenu1,'Value') >= 2 && ~CorrectionMode

            CorrPopUpMenu1_Callback(hObject, eventdata, handles) % udpate...

        else
            set(handles.CorrButton1,'Enable','off');
        end
        set(handles.CorrPopUpMenu1,'Enable','on');
        
    end



    % 5) STANDARDIZATION


    if get(handles.PPMenu2,'Value') > 1 && Ou.data == 2 && Ou.profil == 1 && Ou.masques == 1
        set(handles.QUButton1,'Enable','on');
        Ou.xray = 1;                          % not sure if this is till useful
    else
        set(handles.QUButton1,'Enable','off');
        Ou.xray = 0;
    end

    if get(handles.QUmethod,'value') == 4 && Ou.data >= 1
        set(handles.QUButton1,'String','TRANSFER','Enable','on');
    else
        set(handles.QUButton1,'String','STANDARDIZE');
    end

end


if WP2
    % 5) QUANTI
    if length(handles.quanti) == 1 || CorrectionMode
        set(handles.QUppmenu2,'Enable','off');
        set(handles.QUppmenu1,'Enable','off');
        set(handles.QUbutton0,'Enable','off');
        set(handles.QUbutton11,'Enable','off');
        set(handles.QUbutton_TEST,'Enable','off');
        set(handles.QUbutton2,'Enable','off');
        set(handles.QUbutton3,'Enable','off');
        set(handles.THbutton1,'Enable','off');
        set(handles.QUbutton4,'Enable','off');

        set(handles.QUbutton17,'Enable','off');

        set(handles.QUbutton5,'Enable','off');
        set(handles.MergeInterpBoundaries,'Enable','off');
        set(handles.QUbutton6,'Enable','off');
        set(handles.QUbutton7,'Enable','off');

        set(handles.QUbutton13rec,'Enable','off');

        set(handles.QUbutton8,'Enable','off');
        set(handles.QUbutton9,'Enable','off');
        
        set(handles.QUbutton21,'Enable','off');
        set(handles.QUbutton22,'Enable','off');

        set(handles.QUbutton10,'Enable','off');

        set(handles.QUbutton12,'Enable','off');
        set(handles.QUbutton13,'Enable','off');
        set(handles.QUbutton18,'Enable','off');

        set(handles.QUbutton14,'Enable','off');
        set(handles.QUbutton15,'Enable','off');
        set(handles.QUbutton16,'Enable','off');

        set(handles.QUbutton20,'Enable','off');

        set(handles.Menu_Resampling,'Enable','off');

        handles = UpdateIconButton('QUbutton4','textfield_rename_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton17','duplicate_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton0','delete_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton2','text_exports_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton8','filter_advanced_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton21','ax_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton22','wizard_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton3','sum_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton_TEST','check_box_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton11','chart_curve_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton5','layers_map_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton6','compo_map_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton7','compo_area_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton9','compo_prop_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton10','compo_ellipse_bw.jpg','',handles);  
        handles = UpdateIconButton('QUbutton12','layer_black_out_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton13','layer_black_in_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton18','map_go_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton14','map_add_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton15','map_bw.jpg','',handles);        
        handles = UpdateIconButton('QUbutton20','interaction_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton16','map_goto_bw.jpg','',handles);
        handles = UpdateIconButton('QUbutton13rec','compo_map_unc_bw.jpg','',handles);  
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'textfield_rename_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton4,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'duplicate_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton17,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton0,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'text_exports_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton2,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_advanced_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton8,'string',str);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'ax_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton21,'string',str);
%         
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'wizard_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton22,'string',str);
%         
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'sum_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton3,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'check_box_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton_TEST,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'chart_curve_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton11,'string',str);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton5,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton6,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_area_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton7,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_prop_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton9,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_ellipse_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton10,'string',str);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_out_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton12,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_in_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton13,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton18,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_add_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton14,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton15,'string',str);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'interaction_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton20,'string',str);
%         
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_goto_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton16,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_unc_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.QUbutton13rec,'string',str);

    else
        set(handles.QUppmenu2,'Enable','on');
        if get(handles.QUppmenu2,'Value') > 1 % actif
            
            set(handles.Menu_Resampling,'Enable','on');
            
            set(handles.QUppmenu1,'Enable','on');
            set(handles.QUbutton3,'Enable','on');
            set(handles.QUbutton2,'Enable','on');
            set(handles.THbutton1,'Enable','on');
            set(handles.QUbutton4,'Enable','on');

            set(handles.QUbutton17,'Enable','on');

            set(handles.QUbutton8,'Enable','on');
            
            set(handles.QUbutton21,'Enable','on');
            set(handles.QUbutton22,'Enable','on');

            TheText = get(handles.QUtexte1,'String');        
            NbPoints = str2num(TheText(1:end-4));

            if NbPoints && get(handles.QUppmenu2,'Value') >= 2
                set(handles.QUbutton11,'Enable','on');
                set(handles.QUbutton_TEST,'Enable','on');

                handles = UpdateIconButton('QUbutton_TEST','check_box.jpg','Check quality of standardization ...',handles);
                handles = UpdateIconButton('QUbutton11','chart_curve.jpg','Plot itensity vs wt.% callibrations ...',handles);
                
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'check_box.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton_TEST,'string',str,'TooltipString','Check quality of standardization ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'chart_curve.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton11,'string',str,'TooltipString','Plot itensity vs wt.% callibrations ...');

            else
                set(handles.QUbutton11,'Enable','off');
                set(handles.QUbutton_TEST,'Enable','off');
                
                handles = UpdateIconButton('QUbutton_TEST','check_box_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton11','chart_curve_bw.jpg','',handles);
                
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'check_box_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton_TEST,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'chart_curve_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton11,'string',str);

            end


            if length(get(handles.QUppmenu2,'String')) > 2
                set(handles.QUbutton0,'Enable','on');
                set(handles.QUbutton5,'Enable','on');
                set(handles.MergeInterpBoundaries,'Enable','on');
                set(handles.QUbutton6,'Enable','on');
                set(handles.QUbutton7,'Enable','on');
                set(handles.QUbutton9,'Enable','on');
                set(handles.QUbutton13rec,'Enable','on');

                set(handles.QUbutton10,'Enable','on');

                set(handles.QUbutton12,'Enable','on');
                set(handles.QUbutton13,'Enable','on');
                set(handles.QUbutton18,'Enable','on');

                %set(handles.QUbutton13,'Enable','on');

                set(handles.QUbutton14,'Enable','on');
                
                handles = UpdateIconButton('QUbutton0','delete.jpg','Delete Quanti file ...',handles);
                handles = UpdateIconButton('QUbutton5','layers_map.jpg','Merge Quanti files (maps) ...',handles);
                handles = UpdateIconButton('QUbutton6','compo_map.jpg','Export local composition: map ...',handles);
                handles = UpdateIconButton('QUbutton7','compo_area.jpg','Export local composition: area ...',handles);
                handles = UpdateIconButton('QUbutton9','compo_prop.jpg','Export composition build from proportions ...',handles);
                handles = UpdateIconButton('QUbutton10','compo_ellipse.jpg','Export local composition: ellipse ...',handles);
                handles = UpdateIconButton('QUbutton12','layer_black_out.jpg','Select an area & eliminate pixels outside ...',handles);
                handles = UpdateIconButton('QUbutton13','layer_black_in.jpg','Select an area & eliminate pixels inside ...',handles);
                handles = UpdateIconButton('QUbutton18','map_go.jpg','Export phase proportions ...',handles);
                handles = UpdateIconButton('QUbutton14','map_add.jpg','Generate a density map (from selected mask) ...',handles);
                handles = UpdateIconButton('QUbutton13rec','compo_map_unc.jpg','Export local composition: variable size rectangle ...',handles);

%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton0,'string',str,'TooltipString','Delete Quanti file ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton5,'string',str,'TooltipString','Merge Quanti files (maps) ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton6,'string',str,'TooltipString','Export local composition: map ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_area.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton7,'string',str,'TooltipString','Export local composition: area ...');

%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_prop.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton9,'string',str,'TooltipString','Export composition build from proportions ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_ellipse.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton10,'string',str,'TooltipString','Export local composition: ellipse ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_out.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton12,'string',str,'TooltipString','Select an area & eliminate pixels outside ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_in.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton13,'string',str,'TooltipString','Select an area & eliminate pixels inside ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton18,'string',str,'TooltipString','Export phase proportions ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_add.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton14,'string',str,'TooltipString','Generate a density map (from selected mask) ...');
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_unc.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton13rec,'string',str,'TooltipString','Export local composition: variable size rectangle ...');


                % Special case of the density map...

                WeDisplayButton = 0;
                if ~isequal(handles.MaskFile(1).type,0)
                    SelectedMaskFile = get(handles.PPMenu3,'Value');

                    if isfield(handles.MaskFile,'DensityMap')
                        if length(handles.MaskFile(SelectedMaskFile).DensityMap(:))
                            WeDisplayButton = 1;
                        end
                    end
                end

                if WeDisplayButton
                    set(handles.QUbutton15,'Enable','on');
                    set(handles.QUbutton16,'Enable','on');
                    set(handles.QUbutton20,'Enable','on');
                    
                    handles = UpdateIconButton('QUbutton15','map.jpg','Display the density map ...',handles);
                    handles = UpdateIconButton('QUbutton16','map_goto.jpg','Compute a density-corrected oxide map ...',handles);
                    handles = UpdateIconButton('QUbutton20','interaction.jpg','Calculate interaction volume ...',handles);

%                     iconUrl = strrep([handles.FileDirCode, iconsFolder 'map.png'],'\','/');
%                     str = ['<html><img src="' iconUrl '"/></html>'];
%                     set(handles.QUbutton15,'string',str,'TooltipString','Display the density map ...');
% 
%                     iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_goto.png'],'\','/');
%                     str = ['<html><img src="' iconUrl '"/></html>'];
%                     set(handles.QUbutton16,'string',str,'TooltipString','Compute a density-corrected oxide map ...');
% 
%                     iconUrl = strrep([handles.FileDirCode, iconsFolder 'interaction.png'],'\','/');
%                     str = ['<html><img src="' iconUrl '"/></html>'];
%                     set(handles.QUbutton20,'string',str,'TooltipString','Calculate interaction volume ...');


                    AverageDensity = handles.MaskFile(SelectedMaskFile).AverageDensity;

                    if AverageDensity > 10
                        set(handles.QUtext2,'String',[num2str(round(AverageDensity)),' kg/m3']);
                    else
                        AverageDensity = (round(AverageDensity*100))/100;
                        set(handles.QUtext2,'String',[num2str(AverageDensity),' g/cm3']);
                    end
                else
                    set(handles.QUbutton15,'Enable','off');
                    set(handles.QUbutton16,'Enable','off');
                    set(handles.QUbutton20,'Enable','off');
                    
                    handles = UpdateIconButton('QUbutton15','map_bw.jpg','',handles);
                    handles = UpdateIconButton('QUbutton16','map_goto_bw.jpg','',handles);
                    handles = UpdateIconButton('QUbutton20','interaction_bw.jpg','',handles);

%                     iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_bw.png'],'\','/');
%                     str = ['<html><img src="' iconUrl '"/></html>'];
%                     set(handles.QUbutton15,'string',str);
% 
%                     iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_goto_bw.png'],'\','/');
%                     str = ['<html><img src="' iconUrl '"/></html>'];
%                     set(handles.QUbutton16,'string',str);
% 
%                     iconUrl = strrep([handles.FileDirCode, iconsFolder 'interaction_bw.png'],'\','/');
%                     str = ['<html><img src="' iconUrl '"/></html>'];
%                     set(handles.QUbutton20,'string',str);

                    set(handles.QUtext2,'String','not av.');
                end


            else
                set(handles.QUbutton0,'Enable','off');
                set(handles.QUbutton5,'Enable','off');
                set(handles.MergeInterpBoundaries,'Enable','off');
                set(handles.QUbutton6,'Enable','off');
                set(handles.QUbutton7,'Enable','off');
                set(handles.QUbutton9,'Enable','off');
                set(handles.QUbutton13rec,'Enable','off');

                set(handles.QUbutton10,'Enable','off');

                set(handles.QUbutton12,'Enable','off');
                set(handles.QUbutton13,'Enable','off');
                set(handles.QUbutton18,'Enable','off');

                %set(handles.QUbutton13,'Enable','off');

                set(handles.QUbutton14,'Enable','off');
                set(handles.QUbutton15,'Enable','off');
                set(handles.QUbutton16,'Enable','off');

                set(handles.QUbutton20,'Enable','off');
                
                handles = UpdateIconButton('QUbutton0','delete_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton5','layers_map_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton6','compo_map_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton7','compo_area_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton9','compo_prop_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton10','compo_ellipse_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton12','layer_black_out_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton13','layer_black_in_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton14','map_add_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton15','map_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton20','interaction_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton16','map_goto_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton18','map_go_bw.jpg','',handles);
                handles = UpdateIconButton('QUbutton13rec','compo_map_unc_bw.jpg','',handles);
                
                
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton0,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton5,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton6,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_area_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton7,'string',str);

%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_prop_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton9,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_ellipse.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton10,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_out_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton12,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_in_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton13,'string',str);

%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_add_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton14,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton15,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'interaction_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton20,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_goto.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton16,'string',str);
                
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton18,'string',str);
% 
%                 iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_unc_bw.png'],'\','/');
%                 str = ['<html><img src="' iconUrl '"/></html>'];
%                 set(handles.QUbutton13rec,'string',str);

            end

            handles = UpdateIconButton('QUbutton4','textfield_rename.jpg','Rename Quanti file ...',handles);
            handles = UpdateIconButton('QUbutton17','duplicate.jpg','Duplicate Quanti file ...',handles);
            handles = UpdateIconButton('QUbutton2','text_exports.jpg','Export compositions ...',handles);
            handles = UpdateIconButton('QUbutton8','filter_advanced.jpg','Apply filter (between min and max values) ...',handles);
            handles = UpdateIconButton('QUbutton21','ax.jpg','Eliminate data below LOD ...',handles);
            handles = UpdateIconButton('QUbutton22','wizard.jpg','Correct mixing pixels ...',handles);
            handles = UpdateIconButton('QUbutton3','sum.jpg','Generate the Oxide wt.% sum map ...',handles);
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'textfield_rename.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton4,'string',str,'TooltipString','Rename Quanti file ...');
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'duplicate.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton17,'string',str,'TooltipString','Duplicate Quanti file ...');
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'text_exports.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton2,'string',str,'TooltipString','Export compositions ...');
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_advanced.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton8,'string',str,'TooltipString','Apply filter (between min and max values) ...');
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'ax.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton21,'string',str,'TooltipString','Eliminate data below LOD ...');
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'wizard.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton22,'string',str,'TooltipString','Correct mixing pixels ...');
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'sum.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton3,'string',str,'TooltipString','Generate the Oxide wt.% sum map ...');

        else
            set(handles.QUbutton0,'Enable','off');
            set(handles.QUppmenu1,'Enable','off');
            set(handles.QUbutton11,'Enable','off');
            set(handles.QUbutton_TEST,'Enable','off');
            set(handles.QUbutton3,'Enable','off');
            set(handles.QUbutton2,'Enable','off');
            set(handles.THbutton1,'Enable','off');
            set(handles.QUbutton4,'Enable','off');
            set(handles.QUbutton17,'Enable','off');
            set(handles.QUbutton5,'Enable','off');
            set(handles.MergeInterpBoundaries,'Enable','off');
            set(handles.QUbutton6,'Enable','off');
            set(handles.QUbutton7,'Enable','off');
            set(handles.QUbutton8,'Enable','off');
            set(handles.QUbutton21,'Enable','off');
            set(handles.QUbutton22,'Enable','off');
            set(handles.QUbutton9,'Enable','off');
            set(handles.QUbutton13rec,'Enable','off');

            set(handles.QUbutton12,'Enable','off');
            set(handles.QUbutton13,'Enable','off');

            %set(handles.QUbutton13,'Enable','off');
            set(handles.QUbutton14,'Enable','off');

            
            handles = UpdateIconButton('QUbutton4','textfield_rename_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton7','duplicate_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton0','delete_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton2','text_exports_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton8','filter_advanced_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton21','ax_bw.jpg','',handles);
            
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'textfield_rename_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton4,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'duplicate_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton7,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton0,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'text_exports_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton2,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_advanced_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton8,'string',str);
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'ax_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton21,'string',str);
            
            handles = UpdateIconButton('QUbutton22','wizard_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton3','sum_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton5','layers_map_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton6','compo_map_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton7','compo_area_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton9','compo_prop_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton12','layer_black_out_bw.jpg','',handles);
            
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'wizard_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton22,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'sum_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton3,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton5,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton6,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_area_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton7,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_prop_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton9,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_out_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton12,'string',str);

            handles = UpdateIconButton('QUbutton13','layer_black_in_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton18','map_go_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton14','map_add_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton15','map_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton13rec','compo_map_unc_bw.jpg','',handles);
            handles = UpdateIconButton('QUbutton20','interaction_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layer_black_in_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton13,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_go_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton18,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_add_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton14,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'map_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton15,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'compo_map_unc_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton13rec,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'interaction_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.QUbutton20,'string',str);

        end
    end
    
    
    
else
    set(handles.Menu_Resampling,'Enable','off');
end
    
% Commented 3.0.1 (Not anymore relevant?)    
%set(handles.THppmenu3,'Enable','on');

% Update of the menu for XThermotools                             new 1.6.5
%THppmenu3_Callback(hObject, eventdata, handles)


% 6) QUANTI BULK-COMPOSITION
% note pour la suite, il suffi ici d'avoir deux cartes ou plus pour
% activer le premier bouton qui declenchera les autres en chaine.


if WP3
    % 7) RESULTS
    results = handles.results;
    if length(results) && ~CorrectionMode
        set(handles.REppmenu1,'Enable','on');
        set(handles.REppmenu2,'Enable','on');

        set(handles.REbutton1,'Enable','on');
        set(handles.REbutton3,'Enable','on');
        set(handles.REbutton4,'Enable','on');

        set(handles.REbutton7,'Enable','on');
        set(handles.REbutton8,'Enable','on');

        set(handles.REbutton9,'Enable','on');

        set(handles.Module_Spider,'Enable','on');

        set(handles.FilterMin,'Enable','inactive');
        set(handles.FilterMax,'Enable','inactive');

        % Menu:
        %set(handles.Menu_Module_Spider,'Enable','on');

        handles = UpdateIconButton('REbutton1','textfield_rename.jpg','Rename Result file ...',handles);
        handles = UpdateIconButton('REbutton3','text_exports.jpg','Export compositions ...',handles);
        handles = UpdateIconButton('REbutton4','filter_advanced.jpg','Apply filter (between min and max values) ...',handles);
        handles = UpdateIconButton('REbutton7','slide_number.jpg','Compute new variable ...',handles);
        handles = UpdateIconButton('REbutton8','slide_number_remove.jpg','Delete variable ...',handles);
        handles = UpdateIconButton('REbutton9','cross2.jpg','Relative map ...',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'textfield_rename.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton1,'string',str,'TooltipString','Rename Result file ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'text_exports.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton3,'string',str,'TooltipString','Export compositions ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_advanced.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton4,'string',str,'TooltipString','Apply filter (between min and max values) ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'slide_number.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton7,'string',str,'TooltipString','Compute new variable ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'slide_number_remove.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton8,'string',str,'TooltipString','Delete variable ...');
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'cross2.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton9,'string',str,'TooltipString','Relative map ...');

        if length(results) >= 2
            set(handles.REbutton2,'Enable','on'); % delete
            set(handles.REbutton10,'Enable','on');
            
            handles = UpdateIconButton('REbutton2','delete.jpg','Delete Result file ...',handles);
            handles = UpdateIconButton('REbutton10','layers_map.jpg','Merge results ...',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton2,'string',str,'TooltipString','Delete Result file ...');
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton10,'string',str,'TooltipString','Merge results ...');

        else
            set(handles.REbutton2,'Enable','off'); % delete
            set(handles.REbutton10,'Enable','off'); % delete
            
            handles = UpdateIconButton('REbutton2','delete_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton10','layers_map_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton2,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton10,'string',str);

        end

        %     if length(get(handles.REppmenu2,'String')) >= 3
        %         set(handles.Module_TriPlot3D,'Enable','on'); % triplot
        %     else
        %         set(handles.Module_TriPlot3D,'Enable','off');
        %     end
        %     if length(get(handles.REppmenu2,'String')) >= 2
        %         set(handles.Module_Chem2D,'Enable','on'); % triplot
        %
        %     else
        %         %set(handles.Module_Chem2D,'Enable','off');
        %
        %     end

        if get(handles.REppmenu1,'Value') == 1;
            set(handles.REppmenu2,'Enable','off');
            set(handles.REbutton1,'Enable','off');
            set(handles.REbutton2,'Enable','off');
            set(handles.REbutton3,'Enable','off');
            set(handles.REbutton4,'Enable','off');
            %set(handles.Module_Chem2D,'Enable','off');
            %set(handles.Module_TriPlot3D,'Enable','off');

            set(handles.REbutton7,'Enable','off');
            set(handles.REbutton8,'Enable','off');

            set(handles.REbutton9,'Enable','off');

            set(handles.Module_Spider,'Enable','off');

            set(handles.FilterMin,'Enable','off');
            set(handles.FilterMax,'Enable','off');

            % Menu:
            set(handles.Menu_Module_Spider,'Enable','off');
            
            handles = UpdateIconButton('REbutton2','delete_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton1','textfield_rename_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton3','text_exports_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton4','filter_advanced_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton7','slide_number_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton8','slide_number_remove_bw.jpg','',handles);
            handles = UpdateIconButton('REbutton9','cross2_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton2,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'textfield_rename_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton1,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'text_exports_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton3,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_advanced_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton4,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'slide_number_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton7,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'slide_number_remove_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton8,'string',str);
% 
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'cross2_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.REbutton9,'string',str);

        end
    else
        set(handles.REppmenu1,'Enable','off');
        set(handles.REppmenu2,'Enable','off');
        set(handles.REbutton1,'Enable','off');
        set(handles.REbutton2,'Enable','off');
        set(handles.REbutton3,'Enable','off');
        set(handles.REbutton4,'Enable','off');
        %set(handles.Module_Chem2D,'Enable','off');
        %set(handles.Module_TriPlot3D,'Enable','off');

        set(handles.REbutton7,'Enable','off');
        set(handles.REbutton8,'Enable','off');

        set(handles.REbutton9,'Enable','off');

        set(handles.REbutton10,'Enable','off'); % delete

        set(handles.Module_Spider,'Enable','off');

        set(handles.FilterMin,'Enable','off');
        set(handles.FilterMax,'Enable','off');

        % Menu:
        %set(handles.Menu_Module_Spider,'Enable','off');
        
        handles = UpdateIconButton('REbutton2','delete_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton1','textfield_rename_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton3','text_exports_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton4','filter_advanced_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton7','slide_number_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton8','slide_number_remove_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton9','cross2_bw.jpg','',handles);
        handles = UpdateIconButton('REbutton10','layers_map_bw.jpg','',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'delete_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton2,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'textfield_rename_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton1,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'text_exports_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton3,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'filter_advanced_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton4,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'slide_number_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton7,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'slide_number_remove_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton8,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'cross2_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton9,'string',str);
% 
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'layers_map_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.REbutton10,'string',str);

    end
end

% Special TriPlot and Scheme2D
if WP1
    if iscellstr(get(handles.PPMenu1,'String')) && ~CorrectionMode % you should have more than tree maps loaded
        if length(get(handles.PPMenu1,'String')) >= 1
            set(handles.Menu_Module_Histogram,'Enable','on');
        else
            set(handles.Menu_Module_Histogram,'Enable','off');
        end
        if length(get(handles.PPMenu1,'String')) >= 2
            set(handles.Module_Chem2D,'Enable','on');
            set(handles.Module_Generator,'Enable','on');
            
            % Menu:
            set(handles.Menu_Module_Chem2D,'Enable','on');
            set(handles.Menu_Module_Generator,'Enable','on');
            
        else
            set(handles.Module_Chem2D,'Enable','off');
            set(handles.Module_Generator,'Enable','off');
            
            % Menu:
            set(handles.Menu_Module_Chem2D,'Enable','off');
            set(handles.Menu_Module_Generator,'Enable','off');
        end
        if length(get(handles.PPMenu1,'String')) >= 3
            set(handles.Module_TriPlot3D,'Enable','on');
            set(handles.Module_RGB,'Enable','on');
            
            % Menu:
            set(handles.Menu_Module_TriPlot3D,'Enable','on');
            set(handles.Menu_Module_RGB,'Enable','on');
            set(handles.Menu_Module_Spider,'Enable','on');
        else
            set(handles.Module_TriPlot3D,'Enable','off');
            set(handles.Module_RGB,'Enable','off');
            
            % Menu:
            set(handles.Menu_Module_TriPlot3D,'Enable','off');
            set(handles.Menu_Module_RGB,'Enable','off');
            set(handles.Menu_Module_Spider,'Enable','off');
        end
    else
        set(handles.Module_Chem2D,'Enable','off');
        set(handles.Module_Generator,'Enable','off');
        set(handles.Module_TriPlot3D,'Enable','off');
        set(handles.Module_RGB,'Enable','off');
        
        % Menu:
        set(handles.Menu_Module_Histogram,'Enable','off');
        set(handles.Menu_Module_Chem2D,'Enable','off');
        set(handles.Menu_Module_Generator,'Enable','off');
        set(handles.Menu_Module_TriPlot3D,'Enable','off');
        set(handles.Menu_Module_RGB,'Enable','off');
        set(handles.Menu_Module_Spider,'Enable','off');
    end
elseif WP2
    if iscellstr(get(handles.QUppmenu1,'String')) && ~CorrectionMode % you should have more than tree maps loaded
        if length(get(handles.QUppmenu1,'String')) >= 1
            set(handles.Menu_Module_Histogram,'Enable','on');
        else
            set(handles.Menu_Module_Histogram,'Enable','off');
        end
        if length(get(handles.QUppmenu1,'String')) >= 2
            set(handles.Module_Chem2D,'Enable','on');
            set(handles.Module_Generator,'Enable','on');
            
            % Menu:
            set(handles.Menu_Module_Chem2D,'Enable','on');
            set(handles.Menu_Module_Generator,'Enable','on');
        else
            set(handles.Module_Chem2D,'Enable','off');
            set(handles.Module_Generator,'Enable','off');
            
            % Menu:
            set(handles.Menu_Module_Chem2D,'Enable','off');
            set(handles.Menu_Module_Generator,'Enable','off');
        end
        if length(get(handles.QUppmenu1,'String')) >= 3
            set(handles.Module_TriPlot3D,'Enable','on');
            set(handles.Module_RGB,'Enable','on');
            
            % Menu:
            set(handles.Menu_Module_TriPlot3D,'Enable','on');
            set(handles.Menu_Module_RGB,'Enable','on');
            set(handles.Menu_Module_Spider,'Enable','on');
        else
            set(handles.Module_TriPlot3D,'Enable','off');
            set(handles.Module_RGB,'Enable','off');
            
            % Menu:
            set(handles.Menu_Module_TriPlot3D,'Enable','off');
            set(handles.Menu_Module_RGB,'Enable','off');
            set(handles.Menu_Module_Spider,'Enable','off');
        end
    else
        set(handles.Module_Chem2D,'Enable','off');
        set(handles.Module_Generator,'Enable','off');
        set(handles.Module_TriPlot3D,'Enable','off');
        set(handles.Module_RGB,'Enable','off');
        
        % Menu:
        set(handles.Menu_Module_Histogram,'Enable','off');
        set(handles.Menu_Module_Chem2D,'Enable','off');
        set(handles.Menu_Module_Generator,'Enable','off');
        set(handles.Menu_Module_TriPlot3D,'Enable','off');
        set(handles.Menu_Module_RGB,'Enable','off');
        set(handles.Menu_Module_Spider,'Enable','off');
    end
elseif WP3
    if iscellstr(get(handles.REppmenu2,'String')) && ~CorrectionMode % you should have more than tree maps loaded
        if length(get(handles.REppmenu2,'String')) >= 1
            set(handles.Menu_Module_Histogram,'Enable','on');
        else
            set(handles.Menu_Module_Histogram,'Enable','off');
        end
        if length(get(handles.REppmenu2,'String')) >= 2
            set(handles.Module_Chem2D,'Enable','on');
            set(handles.Module_Generator,'Enable','on');
            
            % Menu:
            set(handles.Menu_Module_Chem2D,'Enable','on');
            set(handles.Menu_Module_Generator,'Enable','on');
        else
            set(handles.Module_Chem2D,'Enable','off');
            set(handles.Module_Generator,'Enable','off');
            
            % Menu:
            set(handles.Menu_Module_Chem2D,'Enable','off');
            set(handles.Menu_Module_Generator,'Enable','off');
        end
        if length(get(handles.REppmenu2,'String')) >= 3
            set(handles.Module_TriPlot3D,'Enable','on');
            set(handles.Module_RGB,'Enable','on');
            
            % Menu:
            set(handles.Menu_Module_TriPlot3D,'Enable','on');
            set(handles.Menu_Module_RGB,'Enable','on');
            set(handles.Menu_Module_Spider,'Enable','on');
        else
            set(handles.Module_TriPlot3D,'Enable','off');
            set(handles.Module_RGB,'Enable','off');
            
            % Menu:
            set(handles.Menu_Module_TriPlot3D,'Enable','off');
            set(handles.Menu_Module_RGB,'Enable','off');
            set(handles.Menu_Module_Spider,'Enable','off');
        end
    else
        set(handles.Module_Chem2D,'Enable','off');
        set(handles.Module_Generator,'Enable','off');
        set(handles.Module_TriPlot3D,'Enable','off');
        set(handles.Module_RGB,'Enable','off');
        
        % Menu:
        set(handles.Menu_Module_Histogram,'Enable','off');
        set(handles.Menu_Module_Chem2D,'Enable','off');
        set(handles.Menu_Module_Generator,'Enable','off');
        set(handles.Menu_Module_TriPlot3D,'Enable','off');
        set(handles.Menu_Module_RGB,'Enable','off');
        set(handles.Menu_Module_Spider,'Enable','off');
    end
end



if CorrectionMode
    %set(handles.Button2,'Enable','off');
    %set(handles.Button1,'Enable','off');
    %set(handles.Button4,'Enable','off');
    
    %set(handles.ButtonSettings,'Enable','off');
    %set(handles.AboutXMapTools,'Enable','off');
    set(handles.OPT1,'Enable','off');
    set(handles.OPT2,'Enable','off');
    set(handles.OPT3,'Enable','off');
    set(handles.MButton1,'Enable','off');
    
    set(handles.THppmenu1,'Enable','off');
    set(handles.THppmenu2,'Enable','off');
    set(handles.THppmenu3,'Enable','off');
    
    set(handles.THbutton2,'Enable','off');
    
    %Menu:
    %set(handles.Menu_Button1,'Enable','off');
    set(handles.Menu_Button2,'Enable','off');
    %set(handles.Menu_Button4,'Enable','off');
    set(handles.Menu_ButtonSettings,'Enable','off');
    
else
    %set(handles.Button2,'Enable','on');
    %set(handles.Button1,'Enable','on');
    %set(handles.Button4,'Enable','on');
    %set(handles.ButtonSettings,'Enable','on');
    
    %set(handles.ButtonSettings,'Enable','on');
    %set(handles.AboutXMapTools,'Enable','on');
    set(handles.OPT1,'Enable','on');
    set(handles.OPT2,'Enable','on');
    set(handles.OPT3,'Enable','on');
    set(handles.MButton1,'Enable','on');
    
    set(handles.THppmenu1,'Enable','on');
    set(handles.THppmenu2,'Enable','on');
    set(handles.THppmenu3,'Enable','on');
    
    set(handles.THbutton2,'Enable','on');
    
    %Menu:
    set(handles.Menu_Button1,'Enable','on');
    set(handles.Menu_Button2,'Enable','on');
    set(handles.Menu_Button4,'Enable','on');
    set(handles.Menu_ButtonSettings,'Enable','on');
end


% Check for the histogram mode to activate a button export (new 2.5.1)
if isequal(handles.HistogramMode,1) && isequal(CorrectionMode,1)
    
    set(handles.ButtonUnfreeze,'Visible','off');
    %set(handles.ExportWindow,'Enable','on');
    
    %Menu: 
    set(handles.Menu_ExportWindow,'Enable','on');
    
    %iconUrl = strrep([handles.FileDirCode, iconsFolder 'export.png'],'\','/');
    %str = ['<html><img src="' iconUrl '"/></html>'];
    %set(handles.ExportWindow,'string',str,'TooltipString','Export figures ...');
    
end

% Special for the menu Image Size (available in any workspace provided that
% a map is displayed)
if ~CorrectionMode
    if WP1
        if length(get(handles.axes1,'Visible')) == 3
            set(handles.Menu_ImageSize,'Enable','off');
        else
            set(handles.Menu_ImageSize,'Enable','on');
        end
    elseif WP2
        if get(handles.QUppmenu2,'Value') > 1
            set(handles.Menu_ImageSize,'Enable','on');
        else
            set(handles.Menu_ImageSize,'Enable','off');
        end
    elseif WP3
        if length(results) >= 1
            set(handles.Menu_ImageSize,'Enable','on');
        else
            set(handles.Menu_ImageSize,'Enable','off');
        end
    end
else
    set(handles.Menu_ImageSize,'Enable','off');
end


%toc
return



% #########################################################################
%     GESTION D'AFFICHAGE

function handles = AffOPT(Opt, hObject, eventdata, handles)

set(handles.axes1,'Visible','Off');
ZoomButtonReset_Callback(hObject, eventdata, handles);
set(handles.axes1,'Visible','On');

handles.AutoContrastActiv = 0;

if Opt == 1 % XRay
    set(handles.OPT1,'Value',1);
    set(handles.OPT2,'Value',0);
    set(handles.OPT3,'Value',0);
    
    set(handles.Menu_Workspace_Xray,'Checked','On');
    set(handles.Menu_Workspace_Quanti,'Checked','Off');
    set(handles.Menu_Workspace_Results,'Checked','Off');
    
    % Update
    %set(handles.PAN1,'Visible','off');
    %set(handles.PAN2,'Visible','off');
    %set(handles.PAN3,'Visible','off');
    
    % Update
    set(handles.PAN1a,'Visible','on');
    set(handles.PAN2a,'Visible','off');
    set(handles.PAN3a,'Visible','off');
    
    set(handles.OPT1,'ForegroundColor',[0 0 0])
    set(handles.OPT2,'ForegroundColor',[0.6 0.6 0.6])
    set(handles.OPT3,'ForegroundColor',[0.6 0.6 0.6])
    
    Data = handles.data;
    if length(Data.map) > 1
        set(handles.PPMenu1,'Value',1);
        PPMenu1_Callback(hObject, eventdata, handles);
        
        %axes(handles.axes1)
        %zoom on                                                         % New 1.6.2
        
        % Display coordinates new 1.5.4 (11.2012)
        %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        
        
    else
        HidePlotAxes1(handles);
        set(gcf, 'WindowButtonMotionFcn', '');
    end
    
    % Menu
    %     set(handles.MenXray,'enable','on');
    %     set(handles.MenQuanti,'enable','off');
    %     set(handles.MenResults,'enable','off');
end

if Opt == 2 % Quanti
    set(handles.OPT1,'Value',0);
    set(handles.OPT2,'Value',1);
    set(handles.OPT3,'Value',0);
    
    set(handles.Menu_Workspace_Xray,'Checked','Off');
    set(handles.Menu_Workspace_Quanti,'Checked','On');
    set(handles.Menu_Workspace_Results,'Checked','Off');
    
    % Update
    %set(handles.PAN1,'Visible','off');
    %set(handles.PAN2,'Visible','off');
    %set(handles.PAN3,'Visible','off');
    
    % Update
    set(handles.PAN1a,'Visible','off');
    set(handles.PAN2a,'Visible','on');
    set(handles.PAN3a,'Visible','off');
    
    set(handles.OPT1,'ForegroundColor',[0.6 0.6 0.6])
    set(handles.OPT2,'ForegroundColor',[0 0 0])
    set(handles.OPT3,'ForegroundColor',[0.6 0.6 0.6])
    
    Quanti = handles.quanti;
    if length(Quanti) > 1
        if get(handles.QUppmenu2,'Value') == 1
            set(handles.QUppmenu2,'Value',length(Quanti));
        end
        QUppmenu2_Callback(hObject, eventdata, handles);
        
        %axes(handles.axes1)
        %zoom on                                                         % New 1.6.2
        
        % Display coordinates new 1.5.4 (11.2012)
        %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        
    else
        HidePlotAxes1(handles);
        set(gcf, 'WindowButtonMotionFcn', '');
    end
    
    % Menu
    %     set(handles.MenXray,'enable','off');
    %     set(handles.MenQuanti,'enable','on');
    %     set(handles.MenResults,'enable','off');
end

if Opt == 3 % Results
    set(handles.OPT1,'Value',0);
    set(handles.OPT2,'Value',0);
    set(handles.OPT3,'Value',1);
    
    set(handles.Menu_Workspace_Xray,'Checked','Off');
    set(handles.Menu_Workspace_Quanti,'Checked','Off');
    set(handles.Menu_Workspace_Results,'Checked','On');
    
    % Update
    %set(handles.PAN1,'Visible','off');
    %set(handles.PAN2,'Visible','off');
    %set(handles.PAN3,'Visible','on');
    
    % Update
    set(handles.PAN1a,'Visible','off');
    set(handles.PAN2a,'Visible','off');
    set(handles.PAN3a,'Visible','on');
    
    set(handles.OPT1,'ForegroundColor',[0.6 0.6 0.6])
    set(handles.OPT2,'ForegroundColor',[0.6 0.6 0.6])
    set(handles.OPT3,'ForegroundColor',[0 0 0])
    
    Results = handles.results;
    if length(Results)
        set(handles.REppmenu1,'Value', length(Results)+1);
        REppmenu1_Callback(hObject, eventdata, handles);
        
        %axes(handles.axes1)
        %zoom on                                                         % New 1.6.2
        
        % Display coordinates new 1.5.4 (11.2012)
        %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        
    else
        HidePlotAxes1(handles);
        set(gcf, 'WindowButtonMotionFcn', '');
    end
    
    % Menu
    %     set(handles.MenXray,'enable','off');
    %     set(handles.MenQuanti,'enable','off');
    %     set(handles.MenResults,'enable','on');
end

% handles.AutoContrastActiv = 0;  %reset auto-contrast (v2.6.1) 

% guidata(hObject, handles);
% OnEstOu(hObject, eventdata, handles);
return


function OPT1_Callback(hObject, eventdata, handles)
handles = AffOPT(1, hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


function OPT2_Callback(hObject, eventdata, handles)
handles = AffOPT(2, hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


function OPT3_Callback(hObject, eventdata, handles)
handles = AffOPT(3, hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%    STYLE DES GRAPHS
function GraphStyle(hObject, eventdata, handles)
set(handles.axes1,'FontName','Times New Roman')
set(handles.axes2,'FontName','Times New Roman')
set(handles.axes2,'FontSize',10)
 

% we display a new graph and we delete the button to select/unselect points
% for the standardization.                         Pierre Lanari (26.04.13)
set(handles.PRButton6,'visible','off');

% Activate the context menu
%set(handles.axes1,'UIContextMenu',handles.ContextMenu );
%guidata(hObject, handles);

return


% #########################################################################
%    CLEAN AND HIDE MAP (AXES1)
function [] = HidePlotAxes1(handles)
%

cla(handles.axes1);
set(handles.axes1,'Visible','off');
hc = colorbar;
set(hc,'Visible','off');


return

% #########################################################################
%    READ DIRECTORY: ADD-ONS (NEW 3.3.1)
function [handles] = ReadAddons(Print,hObject,handles)
%
LocBase = handles.LocBase;

if ~exist(strcat(LocBase(1:end-7),'/Addons')) == 7
    if Print
        disp('WARNING - XMapTools does not find the add-on directory!')
    end
    return
end

D = dir([LocBase(1:end-7),'/Addons']);

handles.Addons = [];
ContAddon = 0;
CorrAdd = 0;

for i=3:length(D)
    
    if D(i).isdir
        % Potential Add-on:
        AddonName = D(i).name;
        
        Test1 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'.p']);
        if ~Test1
            Test1 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'.m']);
        end
        
        Test2 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'_Install.p']);
        if ~Test2
            Test2 = exist([LocBase(1:end-7),'/Addons/',AddonName,'/',AddonName,'_Install.m']);
        end
        
        if Test1 && Test2
            % Add the new add-on
            ContAddon = ContAddon + 1;
            
            handles.Addons(ContAddon).name = AddonName;
            handles.Addons(ContAddon).valid = 1;
            
            if ispc
                handles.Addons(ContAddon).path = [LocBase(1:end-7),'Addons\',AddonName,'\'];
            else
                handles.Addons(ContAddon).path = [LocBase(1:end-7),'Addons/',AddonName,'/'];
            end
            
            addpath(handles.Addons(ContAddon).path);
            ListAddons{ContAddon} = AddonName;
            
            if Print
                disp(['Add-ons ...   - ',handles.Addons(ContAddon).name,':   check test: ok   *** Activated ***']);
            end
        else
            if Print
                disp(['Add-ons ...   * ',AddonName,':   add-on package seems corrupted    (add-on ignored)']);
            end
            CorrAdd = CorrAdd+1;
        end
    end
end

if ~ContAddon && ~CorrAdd
    disp(['Add-ons ... *** No add-on packages in the add-on directory ***']);
end

if ContAddon
    set(handles.Menu_AddonsList,'String',ListAddons,'Value',1,'Enable','On');
end

guidata(hObject, handles);
return


% #########################################################################
%    READ FILE: CONVERSION FACTORS (NEW 3.2.1)
function [handles] = ReadConversionFactors(handles)

fid = fopen('XMap_ConversionFactors.txt','r');
Compt = 0;

ConversionFactor.ListElem = '';
ConversionFactor.Factors = [];

while 1
    tline = fgetl(fid);
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            
            while 1
                tline = fgetl(fid);
                
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                
                Compt = Compt + 1;
                
                TheStr = strread(tline,'%s');
                ConversionFactor.ListElem{Compt} = TheStr{1};
                ConversionFactor.Factors(Compt) = str2num(TheStr{2});
            end
        end
        
    end
end

handles.ConversionFactor = ConversionFactor;

return


% #########################################################################
%    READ FILE: OXIDE MASS & CONVERSION FACTORS (NEW 3.3.2)
function [handles] = ReadOxideData(handles)

fid = fopen('XMap_OxideData.txt','r');
Compt = 0;

OxideData.ListOxide = '';
OxideData.ListElem = '';
OxideData.NbEl = [];
OxideData.NbOx = [];
OxideData.MolarMass = [];
OxideData.Factors = [];

while 1
    tline = fgetl(fid);
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            
            while 1
                tline = fgetl(fid);
                
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                
                Compt = Compt + 1;
                
                TheStr = strread(tline,'%s');
                
                OxideData.ListOxide{Compt} = TheStr{1};
                
                Ox = TheStr{1};
                WhereO = find(Ox == 'O');
                
                if regexp(Ox(WhereO-1),'\d');
                    NbEl = str2num(Ox(WhereO-1));
                    El = Ox(1:WhereO-2);
                else
                    NbEl = 1;
                    El = Ox(1:WhereO-1);
                end
                
                if isequal(WhereO,numel(Ox))
                    NbO = 1;
                else
                    NbO = str2num(Ox(WhereO+1));
                end
                
                
                OxideData.ListElem{Compt} = El;
                OxideData.NbEl(Compt) = NbEl;
                OxideData.NbOx(Compt) = NbO;
                
                OxideData.MolarMass(Compt) = str2num(TheStr{2});
                OxideData.Factors(Compt) = str2num(TheStr{3});
                
                
            end
        end
        
    end
end

handles.OxideData = OxideData;

return


% #########################################################################
%    READ FILE: SPIDER NORM (NEW 2.6.1)
function handles = ReadSpiderFileNORM(handles)

% --------------------
% Spider List setting:
fid = fopen('Xmap_Spider.txt','r');
Compt = 0;

SpiderData(1).Name = 'None';
SpiderData(1).Elements = 'None';
SpiderData(1).Concentration = 0;

ErrorLoad = 0;
while 1
    tline = fgetl(fid);
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            Str1 = tline(3:end);
            Str2 = strread(fgetl(fid),'%s');
            Str3 = strread(fgetl(fid),'%s');
            
            if isequal(length(Str2),length(Str3))
                Compt = Compt+1;
                SpiderData(Compt).Name = Str1;
                SpiderData(Compt).Elements = Str2;
                for i=1:length(Str3)
                    Int3(i) = str2num(Str3{i});
                end
                SpiderData(Compt).Concentration = Int3;
                
            else
                ErrorLoad = 1;
                break, break
            end
        end
        if isequal(tline(1),'*') % Definitions for the isotopes
            ComptEl = 0;
            SpiderData(1).Isotopes.IsoList = {};
            SpiderData(1).Isotopes.RefList = [];
            SpiderData(1).Isotopes.Els = {};
            while 1
                tline = fgetl(fid);
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                
                ComptEl = ComptEl + 1;
                Str = strread(tline,'%s');
                
                SpiderData(1).Isotopes.Els{ComptEl} = char(Str{1});
                
                for i=1:length(Str)-1
                    SpiderData(1).Isotopes.IsoList{end+1} = char(Str{i+1});
                    SpiderData(1).Isotopes.RefList(end+1) = ComptEl;
                    
                    SpiderData(1).Isotopes.Iso(ComptEl).Names{i} = char(Str{i+1});
                end
            end
        end
    end
    
end
fclose(fid);

handles.SpiderData = SpiderData;

if ErrorLoad
    disp('Starting ... (Load data for the Spider module) ... NOT COMPLETED');
    disp(' ')
    disp(['### Check the block: ',char(Str1),'###'])
    disp(' ')
else
    disp('Starting ... (Load data for the Spider module) ... Done');
end


return


% #########################################################################
%    READ FILE: SPIDER COLOR (NEW 2.6.1)
function handles = ReadSpiderFileCOLORS(handles)
fid = fopen('Xmap_SpiderColors.txt','r');
Compt = 0;

SpiderColorData(1).Name = 'None';
SpiderColorData(1).Code = 0;

Compt = 0;
ErrorLoad = 0;
while 1
    tline = fgetl(fid);
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            Compt = Compt+1;
            SpiderColorData(Compt).Name = tline(3:end);
            Row = 0;
            while 1
                tline = fgetl(fid);
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                NUM = strread(tline,'%f');
                Row = Row+1;
                SpiderColorData(Compt).Code(Row,1:3) = NUM(1:3);
            end
            
        end
    end
end
fclose(fid);
handles.SpiderColorData = SpiderColorData;

disp('Starting ... (Load color data for the Spider module) ... Done');

return


% #########################################################################
%    READ FILE: NEW COLOR MAPS (NEW 3.2.1)
function handles = ReadColorMaps(handles)
fid = fopen('XMap_ColorMaps.txt','r');
Compt = 0;

ColorMaps(1).Name = 'None';
ColorMaps(1).Code = 0;

Compt = 0;
ErrorLoad = 0;
while 1
    tline = fgetl(fid);
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            Compt = Compt+1;
            ColorMaps(Compt).Name = tline(3:end);
            Row = 0;
            while 1
                tline = fgetl(fid);
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                NUM = strread(tline,'%f');
                Row = Row+1;
                ColorMaps(Compt).Code(Row,1:3) = NUM(1:3);
            end
            
        end
    end
end
fclose(fid);
handles.ColorMaps = ColorMaps;

%disp('Starting ... (Load color maps for XMapTools) ... Done');

return


% #########################################################################
%     WAITBARPERSO - Used in the GUI (V1.6.2)
function WaitBarPerso(Percent, hObject, eventdata, handles)

LesValues = [0.03654485048338874 0.34090909090909094 0.7375415282392027 0.1818181818181818];
LaLong = LesValues(3) * (Percent + 0.0001);

LesValues(3) = LaLong;

set(handles.WaitBar1,'Visible','on');
set(handles.WaitBar2,'Visible','on');
set(handles.WaitBar3,'Visible','on');

set(handles.UiPanelScrollBar,'visible','on');

% Trace
set(handles.WaitBar3,'Position',LesValues)

if Percent == 0 % we display the image
    
    %iconsFolder = handles.iconsFolder;                          % new 3.0.1
    
    % HERE TAKE CARE OF THE ICON
%     iconsFolder = [handles.LocBase,'/Dev/media/'];
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'spinner.gif'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.DispWait,'string',str,'visible','on'); 

    delay_length = 0.2;

    gif_image = [handles.LocBase,'/Dev/media/spinner2.gif'];
    [handles.GifImage.im,handles.GifImage.map] = imread(gif_image,'frames','all');
    
    handles.GifImage.len = size(handles.GifImage.im,4);
    axes(handles.GifWait)
    handles.GifImage.count = 1;
    handles.GifImage.h1 = imshow(handles.GifImage.im(:,:,:,1),handles.GifImage.map);
    tmr = timer('TimerFcn', {@TmrFcn,handles.GifWait},'BusyMode','Queue',...
        'ExecutionMode','FixedRate','Period',delay_length);
    guidata(handles.GifWait, handles);
    start(tmr); %starts Timer

    
end


if Percent == 1 % on cache
    
    set(handles.UiPanelScrollBar,'visible','off');
    
    set(handles.WaitBar1,'Visible','off');
    set(handles.WaitBar2,'Visible','off');
    set(handles.WaitBar3,'Visible','off');
    
    %str = [''];
    %set(handles.DispWait,'string',str,'visible','off');
    
end

guidata(hObject, handles);
drawnow
return

function TmrFcn(src,event,handles)
%Timer Function to animate the GIF
handles = guidata(handles);
set(handles.GifImage.h1,'CData',handles.GifImage.im(:,:,:,handles.GifImage.count)); %update the frame in the axis
handles.GifImage.count = handles.GifImage.count + 1; %increment to next frame
if handles.GifImage.count > handles.GifImage.len %if the last frame is achieved intialise to first frame
    handles.GifImage.count = 1;
end
guidata(handles.GifWait, handles);
return


% #########################################################################
%     TXT COLOR CONTROL
function TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles)

LaGoodColor = handles.TxtDatabase(CodeTxt(1)).Color(CodeTxt(2));
if LaGoodColor == 1
    set(handles.TxtControl,'ForegroundColor',[0,0,1])
end

if LaGoodColor == 2
    set(handles.TxtControl,'ForegroundColor',[0.847059,0.160784,0]) %red
end

return


% #########################################################################
%     FOR SIZE in MOUSEMOVE (3.3.1)
function [ImageData] = GetActiveImageData(handles)
%
ImageData = [];

if get(handles.OPT1,'Value')
    Data = handles.data;
    if length(Data.map) > 1
        Selected = get(handles.PPMenu1,'Value');
        ImageData = Data.map(Selected).values;
    end
end

if get(handles.OPT2,'Value')
    Quanti = handles.quanti;
    if length(Quanti) > 1
        TheQuanti = get(handles.QUppmenu2,'Value');
        El = get(handles.QUppmenu1,'Value');
        ImageData = Quanti(TheQuanti).elem(El).quanti;
    end
end

if get(handles.OPT3,'Value')
    Results = handles.results;
    if length(Results)
        SelResult = get(handles.REppmenu1,'Value') - 1;
        SelElem = get(handles.REppmenu2,'Value');
        ImageData = reshape(Results(SelResult).values(:,SelElem),Results(SelResult).reshape);
    end
end


%keyboard
return


% #########################################################################
%     MOUSEMOVE (NEW 1.6.2)
function mouseMove(hObject, eventdata)
handles = guidata(hObject);

if ~handles.OptionPanelDisp && get(handles.DisplayCoordinates,'Value')
    
    [ImageData] = GetActiveImageData(handles);
    if isempty(ImageData) % 3.3.1 Check map size to avoid error
        return
    end
    laSize = size(XimrotateX(ImageData,handles.rotateFig));
    
    %laSize = size(XimrotateX(handles.data.map(1).values,handles.rotateFig));
    %keyboard
    
    lesX = [0 laSize(2)]; %get(handles.axes1,'XLim');
    lesY = [0 laSize(1)]; %get(handles.axes1,'YLim');
    
    xLength = lesX(2)-lesX(1);
    yLength = lesY(2)-lesY(1);
    
    C = get (handles.axes1, 'CurrentPoint');
    %title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);
    
    
    % - - - - - - - - - - - - - - - - - - -
    lesInd = get(handles.axes1,'child');
    
    % On extrait l'image...
    for i=1:length(lesInd)
        leType = get(lesInd(i),'Type');
        if length(leType) == 5
            if leType == 'image';
                Data = get(lesInd(i),'CData');
            end
        end
    end
    % - - - - - - - - - - - - - - - - - - -
    
    
    if C(1,1) >= 0 && C(1,1) <= lesX(2) && C(1,2) >= 0 && C(1,2) <= lesY(2) && handles.HistogramMode == 0
        
        %keyboard
        set(gcf,'pointer','crosshair');
        
        switch handles.rotateFig
            
            case 0
                
                set(handles.text47, 'string', round(C(1,1))); %abscisse
                set(handles.text48, 'string', round(C(1,2))); %ordonn?e
                
            case 90
                set(handles.text47, 'string', round(yLength - C(1,2))); %abscisse
                set(handles.text48, 'string', round(C(1,1))); %ordonn?e
                
            case 180
                set(handles.text47, 'string', round(xLength - C(1,1))); %abscisse
                set(handles.text48, 'string', round(yLength - C(1,2))); %ordonn?e
                
            case 270
                set(handles.text47, 'string', round(C(1,2))); %abscisse
                set(handles.text48, 'string', round(xLength - C(1,1))); %ordonn?e
                
        end
        
        % no rotation here because we read the map !!!
        
        TheX = round(C(1,2));
        TheY = round(C(1,1));
        
        if ~TheX, TheX = 1; end   % This is to fix a border error
        if ~TheY, TheY = 1; end
        
        TheZ = Data(TheX,TheY);
        
        switch get(handles.CheckLogColormap,'Value')
            case 1
                TheZ = exp(TheZ);
        end
        
        if get(handles.OPT1,'value')
            TheZ = round(TheZ);
        end
        
        set(handles.text76, 'string', num2str(TheZ));
        
        
        
        
    else
        set(gcf,'pointer','arrow');
        set(handles.text47, 'string', '...'); %abscisse
        set(handles.text48, 'string', '...'); %ordonn?e
        set(handles.text76, 'string', '...'); %value
    end
    
else
    set(gcf,'pointer','arrow');
    set(handles.text47, 'string', '...'); %abscisse
    set(handles.text48, 'string', '...'); %ordonn?e
    set(handles.text76, 'string', '...'); %value
end

return


function [ColorMap] = RdYlBu(ResColorMap)
%

ColorData = [0.271	0.459	0.706;0.455	0.678	0.820;0.671	0.851	0.914;0.878	0.953	0.973;1.000	1.000	0.749;0.996	0.878	0.565;0.992	0.682	0.380;0.957	0.427	0.263;0.843	0.188	0.153];

Xi = 1:ResColorMap;
Step = (ResColorMap-1)/(size(ColorData,1)-1);
X = 1:Step:ResColorMap;

ColorMap = zeros(length(Xi),size(ColorData,2));
for i = 1:size(ColorData,2)
    ColorMap(:,i) = interp1(X',ColorData(:,i),Xi);
    % = polyval(P,);
end

return


% #########################################################################
%     XMAPCOLORBAR (UPDATED 3.2.2)
function [handles] = XMapColorbar(Mode,SelAxis,handles)
%

%      --------------------------------------------------------------------
%        Mode           Description
%      --------------------------------------------------------------------
%       'Auto'          The resolution is fixed by handles.EditColorDef
%       'Mask'          The resolution is determined by the number of
%                       phases in the selected mask
%       'Last'          Apply the last mode stored in handles.ColormapMode
%      --------------------------------------------------------------------

switch Mode
    case 'Init'
        Mode = 'Auto';
        NoDisplay = 1;
    otherwise
        NoDisplay = 0;
end


switch Mode
    case 'Last'
        Mode = handles.ColormapMode;
end

switch Mode
    
    case 'Auto'
        ResColorMap = str2num(get(handles.EditColorDef,'String'));
        handles.ColormapMode = 'Auto';
        Mask = 0;
        
    case 'Mask'
        ResColorMap = length(get(handles.PPMenu2,'String'))-1;
        handles.ColormapMode = 'Mask';
        Mask = 1;
end


if SelAxis == 1             % Otherwise no control on the active axis
    axes(handles.axes1);
    %if NoDisplay
    %    set(handles.XMapToolsGUI,'visible','off');
    %    drawnow
    %end
end

Value = get(handles.checkbox1,'Value');
Value2 = get(handles.checkbox7,'Value');

ColorLower = get(handles.SettingsAddCLowerMenu,'Value'); % 1 black / 2 White 
ColorUpper = get(handles.SettingsAddCUpperMenu,'Value'); % 1 black / 2 White

ColorMaps = handles.ColorMaps;

TheCodeColorMap = get(handles.PopUpColormap,'String');
TheSelected = get(handles.PopUpColormap,'Value');
TheType = handles.ColorBArTypes(TheSelected);

TheCode = TheCodeColorMap{TheSelected};

% Default value
%handles.activecolorbar = RdYlBu(ResColorMap);

switch TheType
    case 1
        if isequal(get(handles.CheckInverseColormap,'Value'),1)
            ColorData = ColorMaps(TheSelected).Code;
        else
            ColorData = flipud(ColorMaps(TheSelected).Code);
        end
        
        Xi = 1:ResColorMap;
        Step = (ResColorMap-1)/(size(ColorData,1)-1);
        X = 1:Step:ResColorMap;
        
        ColorMap = zeros(length(Xi),size(ColorData,2));
        for i = 1:size(ColorData,2)
            ColorMap(:,i) = interp1(X',ColorData(:,i),Xi);
            % = polyval(P,);
        end
        
        %figure, plot([Xi',Xi',Xi'],ColorMap,'-')
        %hold on 
        %plot([X',X',X'],ColorData,'o')
        
    case 2
        Name2Eval = lower(TheCodeColorMap(TheSelected));
        eval(['ColorMap = ',char(Name2Eval),'(ResColorMap);']);
        
        
    case 0
        Name2Apply = char(TheCodeColorMap(TheSelected));
        
        % Below are the colormaps entered manually:
        switch Name2Apply
            case 'x'
                ColorMap = handles.cw;
            case 'FreezeWarm'
                ColorMap = handles.CSfw;
            %case 'WYRK'
                %ColorMap = handles.wyrk;
        end
end



    
if ~Mask
    % New version 3.2.1:
    AddLower = [];
    AddUpper = [];  
    
    if isequal(Value,1)
        if isequal(ColorLower,1)
            AddLower = [0,0,0];
        else
            AddLower = [1,1,1];
        end
    end

    if isequal(Value2,1)
        if isequal(ColorUpper,1)
            AddUpper = [0,0,0];
        else
            AddUpper = [1,1,1];
        end
    end

    % New 3.2.1
    colormap([AddLower;ColorMap;AddUpper]);
    handles.activecolorbar = [AddLower;ColorMap;AddUpper];
    
else
    MaskFile = handles.MaskFile;
    NumMask = get(handles.PPMenu3,'Value');
    NameMask = MaskFile(NumMask).NameMinerals;
    NbMask = MaskFile(NumMask).Nb;
    
    if get(handles.CorrButtonBRC,'Value')
        colormap([0,0,0;ColorMap])
        hcb = colorbar('peer',gca,'YTickLabel',NameMask); caxis([0 NbMask+1]);
        set(hcb,'YTickMode','manual','YTick',[0.5:1:NbMask+1]);
        handles.activecolorbar = [0,0,0;ColorMap];
    else
        colormap(ColorMap)
        hcb = colorbar('peer',gca,'YTickLabel',NameMask(2:end)); caxis([1 NbMask+1]);
        set(hcb,'YTickMode','manual','YTick',[1.5:1:NbMask+1]);
        handles.activecolorbar = [ColorMap];
    end
    
end
    


drawnow
return


% #########################################################################
%    COORDINATES OF MAPS (FIG) FROM REF COORDINATES (NEW 1.6.2)
function [x,y] = CoordinatesFromRef(xref,yref,handles)
% This function transform the true coordinates (Xref,Yref) get from
% XginputX into map coordinates (x,y) for display.
%
% This function use the variable handles.rotateFig to get the orientation
% of the current figure (case 0, 90, 180, 270).
%
% P. Lanari (25.04.13)


laSize = size(XimrotateX(handles.data.map(1).values,handles.rotateFig));

lesX = [0 laSize(2)]; %get(handles.axes1,'XLim');
lesY = [0 laSize(1)]; %get(handles.axes1,'YLim');


xLengthFig = lesX(2)-lesX(1);          % FOR Yfig and Yfig (not Xref and Yref)
yLengthFig = lesY(2)-lesY(1);


switch handles.rotateFig
    
    case 0
        
        x = xref;
        y = yref;
        
    case 90
        
        x = yref;
        y = yLengthFig - xref;
        
    case 180
        
        x = xLengthFig - xref;
        y = yLengthFig - yref;
        
    case 270
        
        x = xLengthFig - yref;
        y = xref;
        
end



return


% #########################################################################
%    COORDINATES OF REF FROM MAP (FIG) COORDINATES (NEW 1.6.2)
function [xref,yref] = CoordinatesFromFig(x,y,handles)
% This function transform the Fig coordinates (X,Y) get from
% CoordinatesFromRef into Ref coordinates (Xref,YRef) for projectiob.
%
% This function use the variable handles.rotateFig to get the orientation
% of the current figure (case 0, 90, 180, 270).
%
% P. Lanari (25.04.13)


laSize = size(XimrotateX(handles.data.map(1).values,handles.rotateFig));

lesX = [0 laSize(2)]; %get(handles.axes1,'XLim');
lesY = [0 laSize(1)]; %get(handles.axes1,'YLim');

xLengthFig = lesX(2)-lesX(1);
yLengthFig = lesY(2)-lesY(1);


switch handles.rotateFig
    
    case 0
        
        xref = x;
        yref = y;
        
        
    case 90
        
        xref = yLengthFig - y;
        yref = x;
        
        
    case 180
        
        xref = xLengthFig - x;
        yref = yLengthFig - y;
        
        
    case 270
        
        xref = y;
        yref = xLengthFig - x;
        
end
return


% #########################################################################
%    XimrotateX (NEW 1.6.3)
function [b] = XimrotateX(A,phi)

if phi == 0
    b = A;
elseif phi == 90
    b = rot90(A,1);
elseif phi == 180
    b = rot90(A,2);
elseif phi == 270
    b = rot90(A,3);
elseif phi == -90
    b = rot90(A,-1);
elseif phi == -180
    b = rot90(A,-2);
elseif phi == -270
    b = rot90(A,-3);
end

return


% #########################################################################
%    QUERY TO SAVE THE FIGURE (NEW 1.6.3)
function [] = WouldYouLike2SaveTheFigure(FileDirectory,hObject, eventdata, handles)
%
ButtonName = questdlg('Would you like to export and save the corresponding map?', ...
    'Figure save', ...
    'Yes');

switch ButtonName
    
    case 'Yes'
        DoSaveTheFigure(FileDirectory,hObject, eventdata, handles);
end

return


% #########################################################################
%    DO SAVE THE FIGURE (NEW 2.1.1)
function [] = DoSaveTheFigure(FileDirectory,hObject, eventdata, handles)
%

WhereOK = FileDirectory(1:end-3);
WhereOK = [WhereOK,'fig'];

hf1 = ExportFigureInNewWindow(1,hObject, eventdata, handles);

%set(hf1,'Visible','on');
saveas(hf1,WhereOK,'fig');

% new 2.6.1:
close(hf1)
        
return


% #########################################################################
%    UNFREEZE BUTTON (v3.0.1)
function ButtonUnfreeze_Callback(hObject, eventdata, handles)
%

% A few checks before we proceed: 

% (1) Standardization Tool:
h2 = findobj('Type','figure','name','VER_XMTStandardizationTool_804');

if length(h2)
    if ishghandle(h2)
        f = errordlg({'WARNING: You''re using the Standardization Tool,' ...
            'close the Standardization Module to unfreeze XMapTools'}, 'XMapTools');
        return
    end
end


% (2) Generator
h2 = findobj('Type','figure','name','VER_XMTModGenerator_804');

if length(h2)
    if ishghandle(h2)
        f = errordlg({'WARNING: You''re using the Generator Module,' ...
            'close the Generator Module to unfreeze XMapTools'}, 'XMapTools');
        return
    end
end

% (3) IDC
h2 = findobj('Type','figure','name','VER_XMTModIDC_804');

if length(h2)
    if ishghandle(h2)
        f = errordlg({'WARNING: You''re using the IDC Module,' ...
            'close the IDC Module to unfreeze XMapTools'}, 'XMapTools');
        return
    end
end

% (4) TRC
h2 = findobj('Type','figure','name','VER_XMTModTRC_804');

if length(h2)
    if ishghandle(h2)
        f = errordlg({'WARNING: You''re using the TRC Module,' ...
            'close the TRC Module to unfreeze XMapTools'}, 'XMapTools');
        return
    end
end




% Go
WarnMessage = {'Are you sure you want to unfreeze the main XMapTools window?', ...
    ' ', ...
    'USE this ONLY if the program is crashed! ', ...
    '   - an error message is displayed in the command window of MATLAB', ...
    '   - there is no ongoing computation', ...
    ' ', ...
    'DO NOT USE this if', ...
    '   - a correction mode is active', ...
    '     [try to press "Apply" to exit the correction mode]', ...
    '   - you''re using: Standardization, Generator, TRC or IDC', ...
    '     [close the external module]', ...
    ' ', ...
    'CHECK the user guide (section 5.3) if you are not sure about what to do', ...
    ' ', ...
    };


Answer = questdlg(WarnMessage,'DEBUG XMapTools','Yes (Unfreeze)','No (cancel)','No (cancel)');


if isequal(Answer,'Yes (Unfreeze)')
    
    %zoom on
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    
end


return


% #########################################################################
%    CHECK DIRECTORY (v3.3.1)
function [handles] = FixDirectoryIssues(Destination, hObject, eventdata, handles)
%

WhereWeAre = cd;
LocBase = handles.LocBase;

% Check the destination directory and eventually move to this directory
if ~isequal(WhereWeAre,Destination)
    cd(Destination);
end

return




% goto plot

% **** 
% #########################################################################
%    PLOT FUNCTION (2.6.1)
function handles = XPlot(AAfficher,hObject, eventdata, handles)
%

% New 2.6.1 - Save the zoom options
ZoomValues = get(gca,{'xlim','ylim'});
hz = zoom;
hp = pan; 
if isequal(get(hz,'Enable'),'on') || isequal(get(hp,'Enable'),'on')   %isequal(get(gca,'Visible'),'on') && 
    WeZoom = 1;
else 
    WeZoom = 0;
end
 
set(handles.axes1, 'Visible', 'off');  % 3.4.1

% Updated with image rotate (25.04.13)
set(gcf, 'WindowButtonMotionFcn', '');

cla(handles.axes1)
axes(handles.axes1)

switch get(handles.CheckLogColormap,'Value')
    case 1
        imagesc(XimrotateX(log(AAfficher),handles.rotateFig));
        
    case 0
        imagesc(XimrotateX(AAfficher,handles.rotateFig));
end
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])

axis image

% New 2.6.1 - Restore the zoom options
%zoom on 
if WeZoom
    zoom reset             % Here is the trick: This is the original image! 
    set(gca,{'xlim','ylim'},ZoomValues);
end

hc = colorbar('peer',handles.axes1,'vertical');
set(hc,'Color',[0,0,0])
set(handles.axes1,'xtick',[], 'ytick',[]);
             
handles = XMapColorbar('Auto',1,handles);       % 1      is for axes1 (new 2.1.3)
                                                % Auto   is for the resolution

%disp(['TEST - ',num2str(isfield(handles,'activecolorbar')),' - XPlot 1'])

guidata(hObject,handles); % to update the handles 
                                                      % New 1.6.2

% Display coordinates new 1.5.4 (11.2012)
set(gcf, 'WindowButtonMotionFcn', @mouseMove);

drawnow

Min = min(AAfficher(find(AAfficher(:) > 0)));
Max = max(AAfficher(:));

set(handles.ColorMin,'String',Min);
set(handles.ColorMax,'String',Max);
set(handles.FilterMin,'String',Min);
set(handles.FilterMax,'String',Max);

if Max > Min
    switch get(handles.CheckLogColormap,'Value')
        case 1
            caxis([log(Min) log(Max)]);
            %caxis([Min Max]);
             
            Labels = get(hc,'YTickLabel');
            for i = 1:length(Labels)
                Value = exp(str2num(char(Labels(i,:))));
                if Value >= 10
                    LabelsOk{i} = num2str(round(Value),'%.0f');
                elseif Value >= 1
                    LabelsOk{i} = num2str(Value,'%.2f');
                elseif Value >= 0.01
                    LabelsOk{i} = num2str(Value,'%.4f');
                else
                    LabelsOk{i} = num2str(Value,'%.6f');
                end
            end
            set(hc,'YTickLabel',LabelsOk);
        case 0
            caxis([Min Max]);
    end
end
 
set(handles.axes1, 'Visible', 'on');  % 3.4.1
drawnow
%disp(['TEST - ',num2str(isfield(handles,'activecolorbar')),' - XPlot 2'])

handles.HistogramMode = 0;
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0; 

GraphStyle(hObject, eventdata, handles)

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);


%disp(['TEST - ',num2str(isfield(handles,'activecolorbar')),' - XPlot 3'])
return





% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%                          MAIN MENU FONCTIONS
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

% goto menu


% #########################################################################
%    MENU - DOCUMENTATION DOWNLOAD (new 3.4.1)
function Menu_Help_Doc_Callback(hObject, eventdata, handles)
%

CodeTxt = [19,10];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

directoryname = uigetdir(cd, 'Select a directory');

if isequal(directoryname,0)
    
    CodeTxt = [19,13];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

CodeTxt = [19,11];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

h = waitbar(0,'The user guide is dowloading - Please wait...');
waitbar(0.5,h);

WebAdress = ['http://www.xmaptools.com/FTP_help/UserGuide_LastVersion.zip'];
unzip(WebAdress,directoryname);

waitbar(0.9,h);
if isdir([directoryname,'/__MACOSX'])
    [status,msg,msgID] = rmdir([directoryname,'/__MACOSX'], 's');
end

waitbar(1,h);
close(h);

CodeTxt = [19,12];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

uiwait(msgbox(['The last version of the user guide has been downloaded'],'XMapTools','modal'));
return




% #########################################################################
%    MENU - TUTORIAL DOWNLOAD (new 3.4.1)
function Menu_Help_Tutorials_Callback(hObject, eventdata, handles)
%

% Check online:
[OnLineTutorials,flag] = urlread('http://www.xmaptools.com/FTP_help/Tutorial_List.php');

if flag && length(OnLineTutorials)
    
    OLAStr = strread(OnLineTutorials,'%s','delimiter','\n');
    
    Count = 0;
    for i = 1:length(OLAStr)
        
        TheStr = char(OLAStr{i});
        
        if length(TheStr)
            if isequal(TheStr(1),'>')
                Count = Count+1;

                StrOk = strread(TheStr,'%s'); 
                OLTutorial(Count).Name = TheStr(3:end);
                
                OLTutorial(Count).Version = char(OLAStr{i+1});
                OLTutorial(Count).Package = char(OLAStr{i+2});
                OLTutorial(Count).Date = char(OLAStr{i+3});
                OLTutorial(Count).Developers = char(OLAStr{i+4});
                OLTutorial(Count).Comment = char(OLAStr{i+5});
            end
        end 
    end
else
    warndlg({'The tutorial server cannot be reached','check your Internet connection'},'XMapTools');
    return
end



handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

PositionXMapTools = get(gcf,'Position');
XMTTutorialDownload(OLTutorial,handles.LocBase,PositionXMapTools);

handles.CorrectionMode = 0;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)
return


% #########################################################################
%    MENU - ADD-ONS DOWNLOAD (new 3.3.1)
function Menu_AddOns_Download_Callback(hObject, eventdata, handles)
% 

% Add-ons already installed:
Addons = handles.Addons;
AddOnsInstalled = '';
for i = 1:length(Addons)
    AddOnsInstalled{i} = Addons(i).name;
end


% Check online:
[OnLineAddOns,flag] = urlread('http://www.xmaptools.com/FTP_addons/AddOn_List.php');

if flag && length(OnLineAddOns)
    
    OLAStr = strread(OnLineAddOns,'%s','delimiter','\n');
    
    Count = 0;
    for i = 1:length(OLAStr)
        
        TheStr = char(OLAStr{i});
        
        if length(TheStr)
            if isequal(TheStr(1),'>')
                Count = Count+1;

                StrOk = strread(TheStr,'%s'); 
                OLAddOns(Count).Name = StrOk{2};
                
                OLAddOns(Count).Version = char(OLAStr{i+1});
                OLAddOns(Count).Package = char(OLAStr{i+2});
                OLAddOns(Count).Date = char(OLAStr{i+3});
                OLAddOns(Count).Developers = char(OLAStr{i+4});
                OLAddOns(Count).Comment = char(OLAStr{i+5});
            end
        end 
    end
else
    warndlg({'The add-on server cannot be reached','check your Internet connection'},'XMapTools');
    return
end

for i = 1:length(OLAddOns)
    OLAddOns(i).IsInstalled = ismember(OLAddOns(i).Name,AddOnsInstalled);
end
   
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

PositionXMapTools = get(gcf,'Position');
XMTAddOnDownload(OLAddOns,handles.LocBase,PositionXMapTools);

% Recheck the add-ons as we can have changed things
disp(' ')
disp('Add-ons ... (Verify XMapTools add-ons) ... ');
Print = 1;
[handles] = ReadAddons(Print,hObject,handles);
disp('Add-ons ... (Verify XMapTools add-ons) ... Done')
disp(' ')

handles.CorrectionMode = 0;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)
return


% #########################################################################
%    MENU - IMAGE SIZE (3.3.1)
function Menu_ImageSize_Callback(hObject, eventdata, handles)
%
% This function is expected to growth in the future

[ImageData] = GetActiveImageData(handles);
[StringPlot] = PlotIdentification(handles);

Min = get(handles.ColorMin,'String');
Max = get(handles.ColorMax,'String');

switch get(handles.CheckLogColormap,'Value')
    case 1
        Scale = 'log';
    otherwise
        Scale = 'linear';
end

ListColorPal = get(handles.PopUpColormap_LEFT,'String');
Sel = get(handles.PopUpColormap_LEFT,'Value');

NbPxZero = numel(find(ImageData == 0));
NbPxDisp = length(find(ImageData(:) >= str2num(Min) & ImageData(:) <= str2num(Max)));
NbPxUpper = length(find(ImageData(:) > str2num(Max))); 
NbPxLower = length(find(ImageData(:) < str2num(Min)));

Res = prod(size(ImageData))/1e6;
if Res >= 1
    ResStr = sprintf('%.2f',Res);
else
    ResStr = sprintf('%.3f',Res);
end

msgbox({['Map: ',StringPlot], ... 
    '- - - - - - - - - - - - - - - - - - - -', ...
    ['Width: ',num2str(size(ImageData,2)),' px'], ...
    ['Height: ',num2str(size(ImageData,1)),' px'], ...
    ['Resolution: ',ResStr,' MP'], ...
    '- - - - - - - - - - - - - - - - - - - -',...
    ['Image Min: ',Min], ...
    ['Image Max: ',Max], ...
    ['Data Min: ',num2str(min(ImageData(find(ImageData))))], ...
    ['Data Max: ',num2str(max(ImageData(:)))], ...
    '- - - - - - - - - - - - - - - - - - - -',...
    ['Nb Px disp: ',num2str(NbPxDisp)], ...
    ['Nb Px zero: ',num2str(NbPxZero)], ...
    ['Nb Px >max: ',num2str(NbPxUpper)], ...
    ['Nb Px <min: ',num2str(NbPxLower-NbPxZero)], ...
    '- - - - - - - - - - - - - - - - - - - -',...
    ['Color palette: ',ListColorPal{Sel}], ...
    ['Scale: ',Scale], ...
    ['Resolution: ',num2str(size(handles.activecolorbar,1))], ...
    '- - - - - - - - - - - - - - - - - - - -'...
    },'Image Info','help'); 

return


% #########################################################################
%    MENU - MASK FILE SIZE (3.3.1)
function Menu_MaskFileSize_Callback(hObject, eventdata, handles)
%

MaskFile = handles.MaskFile;
SelMaskFile = get(handles.LeftMenuMaskFile,'Value');

Mask = MaskFile(SelMaskFile).Mask;

Res = prod(size(Mask))/1e6;
if Res >= 1
    ResStr = sprintf('%.2f',Res);
else
    ResStr = sprintf('%.3f',Res);
end

Structure = '';
Structure{1} = [char(MaskFile(SelMaskFile).Name),'   (type: ',num2str(MaskFile(SelMaskFile).type),')'];
Structure{end+1} = ['- - - - - - - - - - - - - - - - - - - -'];
Structure{end+1} = ['Width: ',num2str(size(Mask,2)),' px'];
Structure{end+1} = ['Height: ',num2str(size(Mask,1)),' px'];
Structure{end+1} = ['Resolution: ',ResStr,' MP'];
Structure{end+1} = ['- - - - - - - - - - - - - - - - - - - -'];
Structure{end+1} = ['Nb masks: ',num2str(MaskFile(SelMaskFile).Nb)];
Structure{end+1} = ['Classified px: ',num2str(length(find(Mask>0)))];
Structure{end+1} = ['Unclassified px: ',num2str(length(find(Mask<1))),'  (should be 0)'];
Structure{end+1} = ['- - - - - - - - - - - - - - - - - - - -'];
Structure{end+1} = ['Masks: '];
for i = 2:MaskFile(SelMaskFile).Nb+1
    Structure{end+1} = ['   - ',MaskFile(SelMaskFile).NameMinerals{i},'  (',sprintf('%.2f',length(find(Mask==i-1))/prod(size(Mask))*100),' %)'];
end
Structure{end+1} = [' '];

msgbox(Structure,'Mask File Info','help');

return


% #########################################################################
%    MENU - RESAMPLING FUNCTION (3.3.1)
function Menu_Resampling_Callback(hObject, eventdata, handles)
% 

Quanti = handles.quanti;

TheQuanti = get(handles.QUppmenu2,'Value');
TheElem = get(handles.QUppmenu1,'Value');

SizeMapOri = size(Quanti(TheQuanti).elem(TheElem).quanti);
Ratio = SizeMapOri(2)/SizeMapOri(1);

OldWith = SizeMapOri(2);
NewWidth = str2num(char(inputdlg({'Width (pixels)'},'Image Size',1,{num2str(OldWith)})));

NewStep = OldWith/NewWidth;

if isequal(OldWith,NewWidth)
    return
end

% ---------- Duplicate Quanti ----------

NewPos = length(Quanti) + 1;
Quanti(NewPos) = Quanti(TheQuanti);

% we only duplicate the quanti we do not change any settings. This should
% work quite fine

if NewWidth > OldWith
    Quanti(NewPos).mineral = {[char(Quanti(NewPos).mineral),'_HR']};
else
    Quanti(NewPos).mineral = {[char(Quanti(NewPos).mineral),'_LR']};
end

% ---------- Apply resampling ----------

for i = 1:length(Quanti(NewPos).elem)

    MapOri = Quanti(NewPos).elem(i).quanti;
    
    [X,Y] = ndgrid(1:SizeMapOri(1),[1:SizeMapOri(2)]);
    F = griddedInterpolant(X,Y,MapOri);
    
    [Xi,Yi] = ndgrid(1:NewStep:SizeMapOri(1),[1:NewStep:SizeMapOri(2)]);
    
    NewMap = F(Xi,Yi);

    Quanti(NewPos).elem(i).quanti = NewMap;
end

% ---------- Update Mineral Menu QUppmenu2 ----------
for i=1:length(Quanti)
    NamesQuanti{i} = char(Quanti(i).mineral);
end

set(handles.QUppmenu2,'String',NamesQuanti);
set(handles.QUppmenu2,'Value',NewPos);

handles.quanti = Quanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
QUppmenu2_Callback(hObject, eventdata, handles);

return


% #########################################################################
%    CONVERT RAW DATA (3.4.1)
function [Test_Ok] = ReadConvertRawData(ConvType, hObject, eventdata, handles)
%
Test_Ok = 0;

TypeStr = { 'JEOL (SUN)', ...
            'JEOL (WIN)', ...
            };
        
% --------------------------------
% (1) Select the folder containing the raw data
CodeTxt = [19,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(TypeStr{ConvType})]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

WhereSource = uigetdir(cd, ['Pick a Directory with ',char(TypeStr{ConvType}),' data']);

if isequal(WhereSource,0)
    CodeTxt = [19,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end
        
% --------------------------------
% (2) Select the destination folder
CodeTxt = [19,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(TypeStr{ConvType})]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

WhereDestination = WhereSource;
while isequal(WhereSource,WhereDestination)
    WhereDestination = uigetdir(cd, ['Create the Map Directory']);
    if isequal(WhereSource,WhereDestination)
        uiwait(warndlg({' You can not select the same directory!',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))},'XMapTools','modal'));
    end
end

if isequal(WhereDestination,0)
    CodeTxt = [19,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

        
% --------------------------------
% (3) Check the destination directory...
Valid = CheckIfDirIsEmpty(WhereDestination,hObject, eventdata, handles);

if isequal(Valid,0)
    CodeTxt = [19,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end
        
% --------------------------------
% (4) Copy the maps
CodeTxt = [19,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(TypeStr{ConvType})]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

for i = 1:1000
    FileName = num2str(i);
    
    if exist([WhereSource,'/',FileName,'.cnd']) && exist([WhereSource,'/',FileName,'_map.txt'])
        
        [Name] = ReadCndFileMap([WhereSource,'/',FileName,'.cnd']);
        
        [Success,Message,MessageID] = copyfile([WhereSource,'/',FileName,'_map.txt'],[WhereDestination,'/',Name,'.txt']);
    
        if Success
            disp(['>> Copying ',FileName,'_map.txt  ->  ',Name,'.txt   -  Done']);
        else
            disp('  ')
            disp(['** WARNING ** ',FileName,'_map.txt  not found']);
            disp('  ')
        end
        
    else
        break
    end
end
        
% --------------------------------
% (5) Create the file Classification.txt 
disp('  '); disp('  ');

fid = fopen([WhereDestination,'/Classification.txt'],'w');
fprintf(fid,'\n\n%s\n','! Below define the input pixels for the classification function');
fprintf(fid,'%s\n','! Format: MINERAL_NAME_(no blank!)   X   Y');
fprintf(fid,'%s\n','>1');
fprintf(fid,'\n\n\n%s\n','! Below define the density of mineral phases (same order as >1)');
fprintf(fid,'%s\n','! Format: DENSITY');
fprintf(fid,'%s\n','>2');
fprintf(fid,'\n\n\n');
fclose(fid);

disp('>> Classification.txt has been created ');

        
% --------------------------------
% (6) Read the map coordinates 
[MapCoord] = ReadZeroCndFile([WhereSource,'/0.cnd']);

disp('  '); disp('  ');
disp('>> Coordinates extracted from 0.cnd ');

        
% --------------------------------
% (7) Read the map coordinates 
Data = [];
Compt = 0;

CodeTxt = [19,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

Answer = questdlg(char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),'XMapTools','Yes','No','Yes');
while isequal(Answer,'Yes')
    % 
    Compt = Compt+1;
    
    CodeTxt = [19,7];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [filename, pathname, filterindex] = uigetfile({'*.txt','TEXT-file (*.txt)';'*.csv','CSV-file (*.csv)'; ...
        '*.*',  'All Files (*.*)'},'Select SUMMARY file...');
    
    DataTEMP = ReadSummaryFile([pathname,filename]);
    
    
    CodeTxt = [19,8];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [filename, pathname, filterindex] = uigetfile({'*.txt','TEXT-file (*.txt)';'*.csv','CSV-file (*.csv)'; ...
        '*.*',  'All Files (*.*)'},'Select STAGE file...');
    
    [Coord] = ReadStageFile([pathname,filename]);
    
    % Check if the two files are compatible (size)
    
    DataTEMP.Coord = Coord;
    Data(Compt).Data = DataTEMP;
    
    CodeTxt = [19,9];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

    Answer = questdlg(char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),'Warning','Yes','No','Yes');
end

        
% --------------------------------
% (8) Check the element list
ElList = '';
for i = 1:length(Data)
    for j = 1:length(Data(i).Data.Labels)-2;
        TheEL = Data(i).Data.Labels{j};
        Where = find(ismember(ElList,TheEL));
        if ~isempty(Where)
            Ind(i,j) = Where;
        else
            ElList{end+1} = TheEL;
            Ind(i,j) = length(ElList);
        end
    end
end

% --------------------------------
% (9) Write the file

fid = fopen([WhereDestination,'/Standards.txt'],'w');
fprintf(fid,'\n\n%s\n','>1');
fprintf(fid,'%f\t%f\t%f\t%f\n',MapCoord);
fprintf(fid,'\n\n%s\n','>2');
for i=1:length(ElList)
    fprintf(fid,'%s\t',ElList{i});
end
fprintf(fid,'%s\t%s','X','Y');
fprintf(fid,'\n\n\n%s\n','>3');

XRefCoord = MapCoord(1:2);
YRefCoord = MapCoord(3:4);

ComptRejected = 0;
ComptOk = 0;

for iFile = 1:length(Data)
    iFile
    DataMat = Data(iFile).Data.Data;
    CoordMat = Data(iFile).Data.Coord;
    ConvInd = Ind(iFile,:);
    
    for iL = 1:size(DataMat,1)
        if CoordMat(iL,2) < max(XRefCoord) && CoordMat(iL,2) > min(XRefCoord) && CoordMat(iL,1) < max(YRefCoord) && CoordMat(iL,1) > min(YRefCoord)
            ComptOk = ComptOk + 1;
            for iC = 1:numel(ConvInd)
                if ConvInd(iC) > 0
                    fprintf(fid,'%f\t',DataMat(iL,ConvInd(iC)));
                else
                    fprintf(fid,'%f\t',0);
                end
            end
            fprintf(fid,'%f\t',CoordMat(iL,2));
            fprintf(fid,'%f\n',CoordMat(iL,1));
        else
            ComptRejected = ComptRejected + 1;
        end
    end
end

fclose(fid);

cd(WhereDestination)

%keyboard   
return





function [Coord] = ReadStageFile(FileName)
% Subroutine to reand 0.cnd file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr)

            if isequal(TheStr{1},'No.')
                Labels = TheStr;
                WhereX = find(ismember(Labels,'X'));
                WhereY = find(ismember(Labels,'Y'));
                
                Compt = 0;
                while 1
                    TheLine = fgetl(fid);
                    if length(TheLine) > 10
                        Compt = Compt+1;
                        TheStr = strread(TheLine,'%s','delimiter','\t');
                        Coord(Compt,1) = str2double(TheStr(WhereX));
                        Coord(Compt,2) = str2double(TheStr(WhereY));
                    else
                        break
                    end
                    
                    
                end
            end
        end
    end
end
return

function [Data] = ReadSummaryFile(FileName)
% Subroutine to reand Summary file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr)

            if isequal(TheStr{1},'No.')
                Data.Labels = TheStr(2:end-2);
                
                Compt = 0;
                while 1
                    TheLine = fgetl(fid);
                    if length(TheLine) > 10
                        Compt = Compt+1;
                        TheStr = strread(TheLine,'%s','delimiter','\t');
                        Data.Data(Compt,:) = str2double(TheStr(2:end-2));
                        Data.Comments{Compt} = TheStr{end};
                    else
                        break
                    end
                    
                    
                end
            end
        end
    end
end

Data.Labels{end+1} = 'X';
Data.Labels{end+1} = 'Y';

return

function [MapCoord] = ReadZeroCndFile(FileName)
% Subroutine to reand 0.cnd file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s','delimiter','\t');

        switch char(TheStr{end})
            case 'Measurement Center Position X [mm]'
                CenterPosition(1) = str2num(TheStr{1});
                
            case 'Measurement Center Position Y [mm]'
                CenterPosition(2) = str2num(TheStr{1});
                
            case 'X-axis Step Number [1~1024]'
                MapSize(1) = str2num(TheStr{1});
                
            case 'Y-axis Step Number [1~1024]'
                MapSize(2) = str2num(TheStr{1});
                
            case 'X Step Size [um], or Beam Dots Width'
                StepSize(1) = str2num(TheStr{1})/1000;
            
            case 'Y Step Size [um], or Beam Dots Width'
                StepSize(2) = str2num(TheStr{1})/1000;    
        end
    end
end

MapCoord(1) = CenterPosition(2) - MapSize(2)*StepSize(2)/2;
MapCoord(2) = CenterPosition(2) + MapSize(2)*StepSize(2)/2;

MapCoord(3) = CenterPosition(1) + MapSize(1)*StepSize(1)/2;
MapCoord(4) = CenterPosition(1) - MapSize(1)*StepSize(1)/2;

return

function [Valid] = CheckIfDirIsEmpty(WhereDestination,hObject, eventdata, handles)
%
Valid = 1;

Files = dir(WhereDestination);

for i = 1:length(Files)
    if Files(i).bytes > 0
        CodeTxt = [19,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        Answer = questdlg(char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),'Warning','Yes','No','Yes');
        
        if ~isequal(Answer,'Yes')
            Valid = 0;
            return
        end
        
        [SUCCESS,MESSAGE,MESSAGEID] = rmdir(WhereDestination,'s');
        [SUCCESS,MESSAGE,MESSAGEID] = mkdir(WhereDestination);
        
        return
    end
end

return

function [Name] = ReadCndFileMap(FileName)
% Subroutine to read a cnd map file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr) > 1

            if isequal(TheStr{1},'$XM_ELEMENT')
                Name = TheStr{2};
            end

            if isequal(TheStr{1},'$XM_CRYSTAL')
                Cryst = TheStr{2};

                switch Cryst(1:3)
                    case 'ROI'
                        Name = ['_',Name];
                    case 'TOP'
                        Name = 'TOPO';
                    case 'SEI'
                        Name = 'SEI';
                end
                          
            end


        end
    end
end

return


% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%                          CALLBACK FONCTIONS
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



% -------------------------------------------------------------------------
% 1) DISPLAY FUNCTIONS
% -------------------------------------------------------------------------
% goto display

% #########################################################################
%     XRAY !! ELEMENT SELECTION FOR DISPLAY. V2.1.1
function PPMenu1_Callback(hObject, eventdata, handles)

Data = handles.data;
MaskFile = handles.MaskFile;

% Temporaire, prendre en compte le fait que l'on l'affiche...
set(handles.UiPanelMapInfo,'Visible','off');

%handles.currentdisplay = 1; % Input change
%set(handles.QUppmenu2,'Value',1); % Input Change
%set(handles.REppmenu1,'Value',1); % Input Change

% Display without median filter...
set(handles.FIGbutton1,'Value',0);

MaskSelected = get(handles.PPMenu3,'Value');
Selected = get(handles.PPMenu1,'Value');
Mineral = get(handles.PPMenu2,'Value');

ListElem = get(handles.PPMenu1,'String');
NameElem = ListElem(Selected);

if Mineral > 1
    RefMin = Mineral - 1;
    AAfficher = MaskFile(MaskSelected).Mask == RefMin;
    
    if ~isequal(size(Data.map(Selected).values),size(AAfficher))
        errordlg({'This image cannot be displayed','The element map and the maskfile have different sizes'},'XMapTools')
        set(gcf, 'WindowButtonMotionFcn', '');
        return
    end
    
    AAfficher = Data.map(Selected).values .* AAfficher;
    
else
    AAfficher = Data.map(Selected).values;
end

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    
    if ~isequal(size(handles.corrections(1).mask),size(AAfficher))
        errordlg({'This map is not compatible with the BRC filter','The element map and the maskfile (used to generate the BRC filter) have different sizes'},'XMapTools')
        set(gcf, 'WindowButtonMotionFcn', '');
        return
    end
    
    AAfficher = AAfficher.*handles.corrections(1).mask;
end

handles = XPlot(AAfficher,hObject, eventdata, handles);

CodeTxt = [3,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(NameElem)]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%handles.AutoContrastActiv = 0;
%handles.MedianFilterActiv = 0;

%guidata(hObject,handles);
%GraphStyle(hObject, eventdata, handles)
%OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%     XRAY !! SELECT A MINERAL (V2.1.1)
function PPMenu2_Callback(hObject, eventdata, handles)

PPMenu1_Callback(hObject, eventdata, handles)
return


% #########################################################################
%     XRAY !! SEE THE MASKS (V2.1.1)
function MaskButton2_Callback(hObject, eventdata, handles)
%

NumMask = get(handles.PPMenu3,'Value');
Liste = get(handles.PPMenu3,'String');
Name = Liste(NumMask);

MaskFile = handles.MaskFile;

Mask4Display = MaskFile(NumMask).Mask;
%NbMask = MaskFile(NumMask).Nb;
%NameMask = MaskFile(NumMask).NameMinerals;

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    Mask4Display = Mask4Display.*handles.corrections(1).mask;
end

% Updated with image rotate (25.04.13)
set(gcf, 'WindowButtonMotionFcn', '');
cla(handles.axes1)
axes(handles.axes1)
imagesc(XimrotateX(Mask4Display,handles.rotateFig)), axis image, % update 1.6.2
set(handles.axes1,'xtick',[], 'ytick',[]);

%zoom on                                                         % New 1.6.2

set(gcf, 'WindowButtonMotionFcn', @mouseMove); 

handles = XMapColorbar('Mask',1,handles);

handles.HistogramMode = 0;
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0;
%cla(handles.axes2)
%axes(handles.axes2), hist(Mask4Display(find(Mask4Display(:)~=0)),30)

CodeTxt = [7,8];
set(handles.TxtControl,'String',[char(Name),' ',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[,char(Name),' ',char(handles.TxtDatabase(7).txt(8))]);

GraphStyle(hObject, eventdata, handles)
guidata(hObject, handles);
return


% #########################################################################
%     XRAY !! DISPLAY PROFILS POINTS INTO THE MAP (V1.6.2)
function PRButton3_Callback(hObject, eventdata, handles)

Profils = handles.profils;

axes(handles.axes1), hold on

xref = Profils.idxallpr(:,1);
yref = Profils.idxallpr(:,2);

[x,y] = CoordinatesFromRef(xref,yref,handles);


hold on
for i=1:length(Profils.pointselected)
    if Profils.pointselected(i)
        plot(x(i),y(i),'+k')
        plot(x(i),y(i),'om','markersize',4,'LineWidth',2)
    else
        plot(x(i),y(i),'+k')
        plot(x(i),y(i),'ok','markersize',4,'LineWidth',2)
    end
end

set(handles.axes1,'xtick',[], 'ytick',[]);

set(handles.PRButton6,'visible','on','enable','on');                          % New 1.6.2

guidata(hObject,handles);
return


% #########################################################################
%     XRAY !! HIDE PROFILS POINTS FROM THE MAP V1.4.1
function PRButton4_Callback(hObject, eventdata, handles)
lesInd = get(handles.axes1,'child');

% On retrouve la carte et on l'affiche...
% Elle va se mettre dessus, mais ?a ne pose pas de probl?mes pour
% l'export... car on a deux fois la m?me carte...

axes(handles.axes1)
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            AAfficher = get(lesInd(i),'CData');
        end
    end
end

% We need to unrotate this dataset
phi = handles.rotateFig;

if phi
    [AAfficher] = XimrotateX(AAfficher,-phi);
end

ZoomButtonReset_Callback(hObject, eventdata, handles);
%keyboard

handles = XPlot(AAfficher,hObject, eventdata, handles);

set(handles.PRButton6,'visible','off');                         % New 1.6.2

guidata(hObject,handles);
return


% #########################################################################
%     QUANTI !! OXIDE W PERCENT LIST **PLOT** (V2.5.1)
function QUppmenu1_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;

ValMin = get(handles.QUppmenu2,'Value');
AllMin = get(handles.QUppmenu2,'String');
SelMin = AllMin(ValMin);

ValOxi = get(handles.QUppmenu1,'Value');
AllOxi = get(handles.QUppmenu1,'String');

if Quanti(ValMin).isoxide == 1
    CodeTxt = [3,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(SelMin),' - ',char(AllOxi(ValOxi))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
elseif Quanti(ValMin).isoxide > 1
    CodeTxt = [3,6];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(SelMin),' - ',char(AllOxi(ValOxi))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
else
    CodeTxt = [3,5];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(SelMin),' - ',char(AllOxi(ValOxi))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
end

%set(handles.TxtControl,'String',[char(handles.TxtDatabase(3).txt(2)),' - ',char(AllMin(ValMin)),' - ',char(AllOxi(ValOxi))]);
%drawnow

AAfficher = Quanti(ValMin).elem(ValOxi).quanti;
handles = XPlot(AAfficher,hObject, eventdata, handles);


return


% #########################################################################
%     QUANTI !! MINERAL LIST (FOR OX%) (V2.5.1)
function QUppmenu2_Callback(hObject, eventdata, handles)

% new 3.3.1 to fix an issue with the map resolution changes
set(handles.axes1,'Visible','off');
ZoomButtonReset_Callback(hObject, eventdata, handles);
set(handles.axes1,'Visible','on');

Quanti = handles.quanti;

set(handles.FIGbutton1,'Value',0); % medianfilter = 0;

ValMin = get(handles.QUppmenu2,'Value');
if ValMin == 1, % verif
    HidePlotAxes1(handles);
    set(gcf, 'WindowButtonMotionFcn', '');
    
    OnEstOu(hObject, eventdata, handles)
    return
end

AllMin = get(handles.QUppmenu2,'String');
SelMin = AllMin(ValMin);

% First element is automaticaly selected if it's possible (NEW 1.6.1
% 28/12/12)
ancOxiListe = get(handles.QUppmenu1,'String');
ancOxi = ancOxiListe(get(handles.QUppmenu1,'Value'));

newOxiListe = Quanti(ValMin).listname;

indInNewOxiListe = ismember(newOxiListe,ancOxi);
if sum(indInNewOxiListe) == 1
    ValOxi = find(indInNewOxiListe);
else
    ValOxi = 1;
end
%keyboard
set(handles.QUppmenu1,'String',Quanti(ValMin).listname);
set(handles.QUppmenu1,'Value',ValOxi);

set(handles.QUtexte1,'String',strcat(num2str(Quanti(ValMin).nbpoints),' pts'));

% new 2.5.1 (we call the other function)
guidata(hObject,handles);
QUppmenu1_Callback(hObject, eventdata, handles);

return


% #########################################################################
%     SUM OF OXIDE (V2.5.1)
function QUbutton3_Callback(hObject, eventdata, handles)
%
set(handles.axes1,'Visible','Off'); % 3.3.1
% At the moment there is no zoom available in the sum map (complicated with
% the different resolutions...
ZoomButtonReset_Callback(hObject, eventdata, handles);
set(handles.axes1,'Visible','On');

Quanti = handles.quanti;


% median filter = 0;
set(handles.FIGbutton1,'Value',0);

ValMin = get(handles.QUppmenu2,'Value');
AllMin = get(handles.QUppmenu2,'String');
SelMin = AllMin(ValMin);

lesOxi = get(handles.QUppmenu1,'String');

% SUM 
SumValue = zeros(size(Quanti(ValMin).elem(1).quanti));
for i=1:length(lesOxi);
    if Quanti(ValMin).elem(i).ref
        SumValue = SumValue + Quanti(ValMin).elem(i).quanti;
    else
        disp([' Oxide sum: ',char(Quanti(ValMin).elem(i).name),' was excluded (Type 0)'])
    end
end
disp(' ')

CodeTxt = [3,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(SelMin),' - Oxide Sum']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

cla(handles.axes1)
axes(handles.axes1)
imagesc(XimrotateX(SumValue,handles.rotateFig)), axis image, colorbar('peer',handles.axes1,'vertical')
set(handles.axes1,'xtick',[], 'ytick',[]);
handles = XMapColorbar('Auto',1,handles);

handles.HistogramMode = 0;
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0;
%axes(handles.axes2), hist(SumValue(find(SumValue ~= 0)),30)

AADonnees = SumValue;
Min = min(AADonnees(find(AADonnees(:) > 0)));
Max = max(AADonnees(:));

set(handles.ColorMin,'String',Min);
set(handles.ColorMax,'String',Max);
set(handles.FilterMin,'String',Min);
set(handles.FilterMax,'String',Max);

Value = get(handles.checkbox1,'Value');
axes(handles.axes1);
if Max > Min
    caxis([Min,Max]);
end

colormap(handles.activecolorbar);
% if Value == 1
% 	colormap([0,0,0;RdYlBu(128)])
% else
%     colormap([RdYlBu(128)])
% end

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);

return


% #########################################################################
%     RESULTS !! DISPLAY RESULTS (CHOICE OF THERMOMETER) (V1.6.2)
function REppmenu1_Callback(hObject, eventdata, handles)

% new 3.3.1 to fix an issue with the map resolution changes
% (Tentatively moved here in 3.4.1 from REppmenu2)
set(handles.axes1,'Visible','off');
ZoomButtonReset_Callback(hObject, eventdata, handles);
set(handles.axes1,'Visible','on');

Results = handles.results;

% Median filter
set(handles.FIGbutton1,'Value',0);

Onest = get(handles.REppmenu1,'Value') - 1; % 1 is none$
if Onest < 1
    OnEstOu(hObject, eventdata, handles);
    return
end
Onaff = 1; % for good transition


set(handles.REppmenu2,'String',Results(Onest).labels);
set(handles.REppmenu2,'Value',Onaff);

REppmenu2_Callback(hObject, eventdata, handles);

return


% #########################################################################
%     RESULTS !! DISPLAY RESULTS (CHOICE OF VARIABLE - T - P ...) (V1.6.2)
function REppmenu2_Callback(hObject, eventdata, handles)


% ---------- Display mode 3 ----------
Results = handles.results;

% median filter
set(handles.FIGbutton1,'Value',0);

Onest = get(handles.REppmenu1,'Value') - 1; % 1 is none$
if Onest == 0
    return
end
Onaff = get(handles.REppmenu2,'Value');

ListResult = get(handles.REppmenu1,'String');
ListDispl = get(handles.REppmenu2,'String');

CodeTxt = [3,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(ListResult(Onest+1)),' - ',char(ListDispl(Onaff))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[char(handles.TxtDatabase(3).txt(3)),' - ',char(ListResult(Onest+1)),' - ',char(ListDispl(Onaff))]);

AAfficher = reshape(Results(Onest).values(:,Onaff),Results(Onest).reshape(1),Results(Onest).reshape(2));

handles = XPlot(AAfficher,hObject, eventdata, handles);

guidata(hObject,handles);

GraphStyle(hObject, eventdata, handles);
OnEstOu(hObject, eventdata, handles);
% GraphStyle(hObject, eventdata, handles)

%keyboard
return




% -------------------------------------------------------------------------
% 2.1) IMAGE DISPLAY OPTIONS
% -------------------------------------------------------------------------



% #########################################################################
%     ACTIVATE ZOOM MODE (NEW 2.6.1)
function ZoomButton_Callback(hObject, eventdata, handles)
% 
axes(handles.axes1)

pan off
hz = zoom;
set(hz,'ActionPostCallback',@ZoomCallbackFcn);
% Be aware that if there is an error in the ZoomCallbackFcn, this error
% will be displayed as a warning and the function will do nothing
set(hz,'Enable','on')
%keyboard 
UpdateZoomButtons(handles);
return


% #########################################################################
%     ZOOM CALLBACK (NEW 2.6.1)
function [x,y] = ZoomCallbackFcn(obj,evd)
%[ZoomFactor] = getZoomFactor(handles);
handles = guidata(obj);
UpdateZoomButtons(handles);
return


% #########################################################################
%     ACTIVATE PAN MODE (NEW 2.6.1)
function PanButton_Callback(hObject, eventdata, handles)
% 
axes(handles.axes1)
hp = pan;
set(hp,'ActionPostCallback',@PanCallbackFcn);
set(hp,'Enable','on')
UpdateZoomButtons(handles);
return


% #########################################################################
%     PAN CALLBACK (NEW 2.6.1)
function [x,y] = PanCallbackFcn(obj,evd)
%[ZoomFactor] = getZoomFactor(handles);

handles = guidata(obj);

% iconsFolder = fullfile(get(handles.PRAffichage0,'String'),'/Dev/img/');
% 
% set(handles.ZoomButton,'Enable','on');
% set(handles.PanButton,'Enable','off');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.ZoomButton,'string',str,'TooltipString','Activate Zoom mode ...');
% 
% iconUrl = strrep([handles.FileDirCode, iconsFolder 'pan_bw.png'],'\','/');
% str = ['<html><img src="' iconUrl '"/></html>'];
% set(handles.PanButton,'string',str);

UpdateZoomButtons(handles);
return


% #########################################################################
%     CALCULATE ZOOM FACTOR (NEW 2.6.1)
function [ZoomFactor] = getZoomFactor(handles)
%
axes(handles.axes1)

lesInd = get(handles.axes1,'child');

XLim = get(handles.axes1,'XLim');
YLim = get(handles.axes1,'YLim');

MapData = 0;
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if isequal(leType,'image');
        MapData = exp(get(lesInd(i),'CData'));
    end    
end

if size(MapData,1) > 1
    [YMap,XMap] = size(MapData);
    
    Xdist = XLim(2) - XLim(1);
    Ydist = YLim(2) - YLim(1);
    
    ZFx = XMap/Xdist;
    ZFy = YMap/Ydist;
    
    if isequal(round(ZFx*10),round(ZFy*10))
        ZoomFactor = ZFx;
    else
        % Something went wrong...
        ZoomFactor = 0;
    end
    
else
    ZoomFactor = 0;
end

%keyboard

return


% #########################################################################
%     RESET ZOOM BUTTON (NEW 2.6.1)
function ZoomButtonReset_Callback(hObject, eventdata, handles)
% 
axes(handles.axes1)

pan off
hz = zoom;
set(hz,'ActionPostCallback','');
set(hz,'Enable','off');

if isfield(handles,'ZoomResetXLim')
    set(handles.axes1,'XLim',handles.ZoomResetXLim,'YLim',handles.ZoomResetYLim);
    zoom reset
else
    zoom out
end

% disp('Zoom has been reset')

% pan off
% hz = zoom;
% set(hz,'ActionPostCallback','');
% set(hz,'Enable','off');
% zoom out

UpdateZoomButtons(handles);
return


% #########################################################################
%     UPDATE ZOOM BUTTONS (NEW 2.6.1)
function UpdateZoomButtons(handles)

% - - - - - - - - - - - - - - - - - - - - -
% Detect the correction mode (from OnEstOu)
if isequal(get(handles.ButtonXPadApply,'UserData'),0)
    CorrectionMode = 0;
else
    CorrectionMode = 1;
end

if handles.HistogramMode && ~CorrectionMode   % We are using the Correction Mode for the histogram mode...
    CorrectionMode = 1;
end

if handles.CorrectionMode
    CorrectionMode = 1;
end
% - - - - - - - - - - - - - - - - - - - - -

%iconsFolder = fullfile(get(handles.PRAffichage0,'String'),'/Dev/img/');
%iconsFolder = handles.iconsFolder;                          % new 3.0.1

% ZOOM / PAN
%hFig = axes(handles.axes1);

% Is the plot displayed? 
if isequal(get(handles.axes1,'Visible'),'on') && ~CorrectionMode
    
    % Is the zoom active?
    [ZoomFactor] = getZoomFactor(handles);
    if ~isequal(ZoomFactor,1)
        
        % Check if pan is active or not
        %keyboard
        drawnow
        hp = pan;
        if isequal(get(hp,'Enable'),'on')
            set(handles.ZoomButton,'Enable','on');
            set(handles.PanButton,'Enable','off');
            
            handles = UpdateIconButton('ZoomButton','zoom.jpg','Activate Zoom mode ...',handles);
            handles = UpdateIconButton('PanButton','pan_bw.jpg','',handles);

%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.ZoomButton,'string',str,'TooltipString','Activate Zoom mode ...');
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'pan_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.PanButton,'string',str);
            
        else
            set(handles.ZoomButton,'enable','off');
            set(handles.PanButton,'enable','on');
            
            handles = UpdateIconButton('ZoomButton','zoom_bw.jpg','',handles);
            handles = UpdateIconButton('PanButton','pan.jpg','Activate Pan mode ...',handles);
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.ZoomButton,'string',str);
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'pan.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.PanButton,'string',str,'tooltipstring','Activate Pan mode ...');
            
        end
        
        
        set(handles.ZoomButtonReset,'Enable','on');
        
        handles = UpdateIconButton('ZoomButtonReset','zoom_refresh.jpg','Reset zoom & pan ...',handles);

%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_refresh.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.ZoomButtonReset,'string',str,'TooltipString','Reset zoom & pan ...');
    else
        
        % Check if zoom needs to be activated or not
        hz = zoom;
        if isequal(get(hz,'Enable'),'on')
            set(handles.ZoomButton,'enable','off');
            set(handles.ZoomButtonReset,'Enable','on');
            
            handles = UpdateIconButton('ZoomButton','zoom_bw.jpg','',handles);
            handles = UpdateIconButton('ZoomButtonReset','zoom_refresh.jpg','Reset zoom & pan ...',handles);
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.ZoomButton,'string',str);
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_refresh.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.ZoomButtonReset,'string',str,'TooltipString','Reset zoom & pan ...');
        else
            set(handles.ZoomButton,'Enable','on');
            set(handles.ZoomButtonReset,'Enable','off');
            
            handles = UpdateIconButton('ZoomButton','zoom.jpg','Activate Zoom mode ...',handles);
            handles = UpdateIconButton('ZoomButtonReset','zoom_refresh_bw.jpg','',handles);
            
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.ZoomButton,'string',str,'TooltipString','Activate Zoom mode ...');
%             
%             iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_refresh_bw.png'],'\','/');
%             str = ['<html><img src="' iconUrl '"/></html>'];
%             set(handles.ZoomButtonReset,'string',str);
        end
        
        set(handles.PanButton,'Enable','off');
        
        handles = UpdateIconButton('PanButton','pan_bw.jpg','',handles);
        
%         iconUrl = strrep([handles.FileDirCode, iconsFolder 'pan_bw.png'],'\','/');
%         str = ['<html><img src="' iconUrl '"/></html>'];
%         set(handles.PanButton,'string',str);
        
        
    end
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ZoomButton,'string',str,'TooltipString','Activate Zoom mode ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'pan.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.PanButton,'string',str,'TooltipString','Activate Pan mode ...');
%     
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_refresh.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ZoomButtonReset,'string',str,'TooltipString','Refresh zoom ...');
    
    
    
else
    set(handles.ZoomButton,'Enable','off');
    set(handles.PanButton,'Enable','off');
    set(handles.ZoomButtonReset,'Enable','off');
    
    % Zoom/Pan mode
    
    handles = UpdateIconButton('ZoomButton','zoom_bw.jpg','',handles);
    handles = UpdateIconButton('PanButton','pan_bw.jpg','',handles);
    handles = UpdateIconButton('ZoomButtonReset','zoom_refresh_bw.jpg','',handles);
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ZoomButton,'string',str);
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'pan_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.PanButton,'string',str);
    
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'zoom_refresh_bw.png'],'\','/');
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     set(handles.ZoomButtonReset,'string',str);
    
end





return


% #########################################################################
%     READ ZOOM ORIGINAL VALUES (NEW 3.0.1)
function [handles] = ReadZoomValue(handles)

XLim = get(handles.axes1,'XLim');
YLim = get(handles.axes1,'YLim');

handles.ZoomResetXLim = XLim;
handles.ZoomResetYLim = YLim;

return

% ***
% #########################################################################
%     EXPORT FIGURE (V2.6.1)
function ExportWindow_Callback(hObject, eventdata, handles)
[hf1] = ExportFigureInNewWindow(1,hObject, eventdata, handles);
return


function [hf1] = ExportFigureInNewWindow(ModeExport,hObject, eventdata, handles)
%
% ModeExport: 
%       2 - figure is not displayed
%

if isequal(handles.HistogramMode,1) 
    AxesN = {'axes2','axes3'};
    
    for i = 1:length(AxesN)
        
        eval(['axes(handles.',char(AxesN{i}),');']);
         
        
        eval(['lesInd = get(handles.',char(AxesN{i}),',''child'');']);
        
        figure,
        hold on
        
        
        for i=1:length(lesInd)
            leType = get(lesInd(i),'Type');
            
            switch leType
                
                case 'Type'
                    
                    switch get(handles.CheckLogColormap,'Value')
                        case 1
                            MapData = exp(get(lesInd(i),'CData'));
                            imagesc(log(MapData)), axis image
                        case 0
                            MapData = get(lesInd(i),'CData');
                            imagesc(MapData), axis image
                    end
                    
                    hc = colorbar('peer',gca,'vertical');
                    
                    
                case 'line'
                    plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                        'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
                    
                case 'text'
                    LaPosition = get(lesInd(i),'Position');
                    LeTxt = text(LaPosition(1),LaPosition(2),get(lesInd(i),'String'));
                    set(LeTxt,'Color',get(lesInd(i),'Color'),'BackgroundColor',get(lesInd(i),'BackgroundColor'), ...
                        'FontName',get(lesInd(i),'FontName'),'FontSize',get(lesInd(i),'FontSize'));
        
                    
                case 'patch'
                    
                    patch(get(lesInd(i),'XData'),get(lesInd(i),'YData'),get(lesInd(i),'FaceColor'));
                    
                    
                    
            end
        end
        set(gca,'box','on')
        
    end
    
    %keyboard
    return
end


axes(handles.axes1)
CMap = colormap;

lesInd = get(handles.axes1,'child');
CLim = get(handles.axes1,'CLim');
YDir = get(handles.axes1,'YDir');

% New 2.6.1 - Save the zoom options
ZoomValues = get(gca,{'xlim','ylim'});

if isequal(ModeExport,2)
    hf1 = figure('visible','off');
else
    hf1 = figure;
end

% set the figure large enough and centered
FigPosition = get(hf1,'Position');
ScreenSize = get(0,'ScreenSize');

FigHeight = ScreenSize(4)*0.8;
FigWidth = ScreenSize(3)*0.8; %FigHeight/FigPosition(4)*FigPosition(3);
FigX = (ScreenSize(3)-FigWidth)/2;
FigY = (ScreenSize(4)-FigHeight)/3;

set(hf1,'Position',[FigX,FigY,FigWidth,FigHeight])

hold on

% On trace d'abord les images...
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            switch get(handles.CheckLogColormap,'Value')
                case 1
                    MapData = exp(get(lesInd(i),'CData'));
                    imagesc(log(MapData)), axis image
                case 0
                    MapData = get(lesInd(i),'CData');
                    imagesc(MapData), axis image
            end 
            
            hc = colorbar('peer',gca,'vertical');
            %disp('read')
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

ha1 = gca;

set(ha1,'YDir',YDir);
set(ha1,{'xlim','ylim'},ZoomValues);
set(ha1,'xtick',[], 'ytick',[]);
set(ha1,'box','on')
set(ha1,'LineStyleOrder','-')
set(ha1,'LineWidth',1)

% Adjust first the colormap
colormap(CMap)
set(ha1,'CLim',CLim);

switch get(handles.CheckLogColormap,'Value')
    case 1
        Labels = get(hc,'YTickLabel');
        for i = 1:length(Labels) 
            Value = exp(str2num(char(Labels(i,:))));
            if Value >= 10
                LabelsOk{i} = num2str(round(Value),'%.0f');
            elseif Value >= 1
                LabelsOk{i} = num2str(Value,'%.2f');
            elseif Value >= 0.01
                LabelsOk{i} = num2str(Value,'%.4f');
            else
                LabelsOk{i} = num2str(Value,'%.6f');
            end
            
            %LabelsOk{i} = num2str(round(exp(str2num(Labels(i,:)))),'%.0f');
        end
        set(hc,'YTickLabel',LabelsOk);
end

LimitsMap = axis; 
 
if (LimitsMap(2)-LimitsMap(1)) > 400
    dScale = 100;
    dY = 60;
    dYLogo = 10;
    dX = 5;
    divSpaceScaleBar0 = 6;
elseif (LimitsMap(2)-LimitsMap(1)) > 300
    dScale = 50;
    dY = 40;
    dYLogo = 5;
    dX = 2;
    divSpaceScaleBar0 = 6;
elseif (LimitsMap(2)-LimitsMap(1)) > 50
    dScale = 10;
    dY = 15;
    dYLogo = 2;
    dX = 3;
    divSpaceScaleBar0 = 1;
else
    dScale = 5;
    dY = 5;
    dYLogo = 0.5;
    dX = 0.5;
    divSpaceScaleBar0 = 3;
end

HalfImage = (LimitsMap(2)-LimitsMap(1))/2;

fill([LimitsMap(1),LimitsMap(2),LimitsMap(2),LimitsMap(1)],[LimitsMap(4),LimitsMap(4),LimitsMap(4)+dY,LimitsMap(4)+dY],'w')

plot([LimitsMap(1)+dScale/divSpaceScaleBar0 LimitsMap(1)+dScale+dScale/divSpaceScaleBar0],[LimitsMap(4)+dY/2 LimitsMap(4)+dY/2],'-k','linewidth',4);

text(LimitsMap(1)+dScale/2+dScale/divSpaceScaleBar0,LimitsMap(4)+dY/2-0.2*dY,[num2str(dScale),' px'],'HorizontalAlignment','center');

if  dScale < 0.5 * HalfImage%LimitsMap(2)-LimitsMap(1) > 400
    [StringPlot] = PlotIdentification(handles);
    text(LimitsMap(1)+dScale+2*dScale/divSpaceScaleBar0,LimitsMap(4)+dY/3,StringPlot,'Interpreter','none')
    text(LimitsMap(1)+dScale+2*dScale/divSpaceScaleBar0,LimitsMap(4)+2*dY/3,datestr(clock),'Interpreter','none')
else
    %text(140,LimitsMap(4)+30,'VER_XMapTools_804')
end


plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(4),LimitsMap(4)],'k','linewidth',1);
plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(3),LimitsMap(3)],'k','linewidth',1);
plot([LimitsMap(1),LimitsMap(1)],[LimitsMap(3),LimitsMap(4)],'k','linewidth',1);
plot([LimitsMap(2),LimitsMap(2)],[LimitsMap(3),LimitsMap(4)],'k','linewidth',1);

axis([LimitsMap(1) LimitsMap(2) LimitsMap(3) LimitsMap(4)+dY]);


RatioLogo = size(handles.LogoXMapToolsWhite,2)/size(handles.LogoXMapToolsWhite,1);
HeightLogo = dY-dYLogo;
LengthLogo = HeightLogo*RatioLogo;

if LengthLogo < HalfImage
    dX = (HalfImage - LengthLogo)/2;
    image(handles.LogoXMapToolsWhite,'XData', [ LimitsMap(2)-LengthLogo-dX LimitsMap(2)-dX], 'YData', [LimitsMap(4)+dYLogo/2 LimitsMap(4)+HeightLogo+dYLogo/2])
else
    
    LengthLogo = HalfImage - 2*dX;
    HeightLogo = LengthLogo*1/RatioLogo;
    dYLogo = dY-HeightLogo;
    image(handles.LogoXMapToolsWhite,'XData', [ LimitsMap(2)-LengthLogo-dX LimitsMap(2)-dX], 'YData', [LimitsMap(4)+dYLogo/2 LimitsMap(4)+HeightLogo+dYLogo/2])    
end

set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

%drawnow




%keyboard
return


% #########################################################################
%     PLOT IDENTIFICATION FOR EXPORT FUNCTION (new V2.6.1)
function [StringPlot] = PlotIdentification(handles)
%

StringPlot = '';

WorkSpace1 = get(handles.OPT1,'Value');
WorkSpace2 = get(handles.OPT2,'Value');
WorkSpace3 = get(handles.OPT3,'Value');

if WorkSpace1
    ElementList = get(handles.PPMenu1,'String');
    Element = char(ElementList{get(handles.PPMenu1,'Value')});
    
    MineralList = get(handles.PPMenu2,'String');
    Selected = get(handles.PPMenu2,'Value');
    if Selected > 1
        Mineral = [' in ',char(MineralList{Selected})];
    else
        Mineral = '';
    end
    
    if isequal(get(handles.CorrButtonBRC,'Value'),1)
        BRC = '; BRC';
    else
        BRC = '';
    end
    
    StringPlot = [Element,Mineral,' (X-ray',BRC,')'];
    return
end


if WorkSpace2
    ElementList = get(handles.QUppmenu1,'String');
    Element = char(ElementList{get(handles.QUppmenu1,'Value')});
    
    MineralList = get(handles.QUppmenu2,'String');
    Selected = get(handles.QUppmenu2,'Value');
    
    Mineral = [' in ',char(MineralList{Selected})];
    
    StringPlot = [Element,Mineral,' (Quanti)'];
    return
end


if WorkSpace3
    ElementList = get(handles.REppmenu2,'String');
    Element = char(ElementList{get(handles.REppmenu2,'Value')});
    
    for i = 1:length(Element)
        if isequal(Element(i),'_')
            Element(i) = '-';
        end
    end
    
    MineralList = get(handles.REppmenu1,'String');
    Selected = get(handles.REppmenu1,'Value');
    
    Mineral = [' in ',char(MineralList{Selected})];
    
    StringPlot = [Element,Mineral,' (Results)'];
    return
end

%keyboard
return


function handles = UpdateColorBarLimits(Min,Max,handles)
%
if Min > Max
    CodeTxt = [6,1];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, 1, eventdata, handles);
    return
end


hc = colorbar('peer',handles.axes1,'vertical');

switch get(handles.CheckLogColormap,'Value')
    case 1
        caxis([log(Min) log(Max)]);
        
        Labels = get(hc,'YTickLabel');
        for i = 1:length(Labels)
            Value = exp(str2num(char(Labels(i,:))));
            if Value >= 10
                LabelsOk{i} = num2str(round(Value),'%.0f');
            elseif Value >= 1
                LabelsOk{i} = num2str(Value,'%.2f');
            elseif Value >= 0.01
                LabelsOk{i} = num2str(Value,'%.4f');
            else
                LabelsOk{i} = num2str(Value,'%.6f');
            end
        end
        set(hc,'YTickLabel',LabelsOk);
        
%         Labels = get(hc,'YTickLabel');
%         for i = 1:length(Labels)
%             LabelsOk{i} = num2str(round(exp(str2num(Labels(i,:)))),'%.0f');
%         end
%         set(hc,'YTickLabel',LabelsOk);
        
        set(handles.FilterMin,'String',exp(Min));
        set(handles.FilterMax,'String',exp(Max));
        
    case 0
        
        if Min < Max          % Changed 2.5.2 (PL) to fix issue while map is 99.5% of the same value..
            caxis([Min Max]);
        
            set(handles.FilterMin,'String',Min);
            set(handles.FilterMax,'String',Max);
        end
end
return


% #########################################################################
%     SELECT THE MIN COLORBAR VALUE V1.4.1
function ColorMin_Callback(hObject, eventdata, handles)
axes(handles.axes1),
Max = str2num(get(handles.ColorMax,'String'));
Min = str2num(get(handles.ColorMin,'String'));

handles = UpdateColorBarLimits(Min,Max,handles);

handles.AutoContrastActiv = 0;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);

return


% #########################################################################
%     SELECT THE MAX COLORBAR VALUE V1.4.1
function ColorMax_Callback(hObject, eventdata, handles)
ColorMin_Callback(hObject, eventdata, handles)
return


% #########################################################################
%     PHASE SEPARATOR SETTING V2.1.1
function checkbox1_Callback(hObject, eventdata, handles)

% 3.2.1
set(handles.SettingsAddCLowerCheck,'Value',get(handles.checkbox1,'Value'));

% We only call the new update general function             % Changed 2.1.1
handles = XMapColorbar('Auto',1,handles);
guidata(hObject, handles);

return


% #########################################################################
%     PHASE SEPARATOR MAX BUTTON V1.5.1
function checkbox7_Callback(hObject, eventdata, handles)
%

% 3.2.1
set(handles.SettingsAddCUpperCheck,'Value',get(handles.checkbox7,'Value'));

% We only call the new update general function             % Changed 2.1.1
handles = XMapColorbar('Auto',1,handles);
guidata(hObject, handles);
% Value = get(handles.checkbox7,'Value');
% if Value ==1
%     set(handles.checkbox1,'Value',1);
% end
%
% checkbox1_Callback(hObject, eventdata, handles);


return


function [Min,Max] = OptimizeContrastFromImage(handles)
%
Min=0;
Max=0;

lesInd = get(handles.axes1,'child');

for i=1:length(lesInd)
    if length(get(lesInd(i),'type')) == 5 % image
        switch get(handles.CheckLogColormap,'Value')
            case 1
                AADonnees = exp(get(lesInd(i),'CData'));
            case 0
                AADonnees = get(lesInd(i),'CData');
        end
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

Val = round(length(NTriee) * 0.065); % voir avec une detection du pic.

if Val <= 1
    return
end

Min = NTriee(Val);
Max = NTriee(length(NTriee)-Val);

return

function [Min,Max] = GetMinMaxFromImage(handles)
%
Min=0;
Max=0;

lesInd = get(handles.axes1,'child');

for i=1:length(lesInd)
    if length(get(lesInd(i),'type')) == 5 % image
        switch get(handles.CheckLogColormap,'Value')
            case 1
                AADonnees = exp(get(lesInd(i),'CData'));
            case 0
                AADonnees = get(lesInd(i),'CData');
        end
        break
    else
        AADonnees = [];
    end
end

Min = min(AADonnees(find(AADonnees(:) > 0)));
Max = max(AADonnees(:));

return


% #########################################################################
%     AUTO LEVELS  (V2.5.1) 
function ColorButton1_Callback(hObject, eventdata, handles)
%
ACA = handles.AutoContrastActiv;

if ACA
    % Reset Auto-contrast
    
    [Min,Max] = GetMinMaxFromImage(handles);
    
    set(handles.ColorMin,'String',Min);
    set(handles.ColorMax,'String',Max);
    %set(handles.FilterMin,'String',Min);
    %set(handles.FilterMax,'String',Max);
    
    handles.AutoContrastActiv = 0;

else
    [Min,Max] = OptimizeContrastFromImage(handles);
    
    set(handles.ColorMax,'String',num2str(Max));
    set(handles.ColorMin,'String',num2str(Min));
    %set(handles.FilterMax,'String',num2str(NTriee(length(NTriee)-Val)));
    %set(handles.FilterMin,'String',num2str(NTriee(Val)));
    
    handles.AutoContrastActiv = 1;
end

% New 2.5.1 to update the colorbar we use the ColorMin function
guidata(hObject,handles);

handles = UpdateColorBarLimits(Min,Max,handles);
%ColorMin_Callback(hObject, eventdata, handles)

OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%     MEDIAN FILTER (V2.5.1)
function FIGbutton1_Callback(hObject, eventdata, handles)
%ValueMedian = get(handles.FIGbutton1,'Value');
MedianSize = str2num(get(handles.FIGtext1,'String'));
lesInd = get(handles.axes1,'child');

% New 2.6.1 - Restore the zoom options
ZoomValues = get(gca,{'xlim','ylim'});
hz = zoom;
hp = pan;
if isequal(get(hz,'Enable'),'on') || isequal(get(hp,'Enable'),'on')   %isequal(get(gca,'Visible'),'on') && 
    WeZoom = 1;
else 
    WeZoom = 0;
end

if ~handles.MedianFilterActiv
    
    for i=1:length(lesInd);
        if length(get(lesInd(i),'type')) == 5 % image
            
            AADonnees = get(lesInd(i),'CData');
            
            switch get(handles.CheckLogColormap,'Value')
                case 1
                    AADonnees = exp(AADonnees);
            end
            break
        else
            AADonnees = [];
        end
    end
    
    data2Image = XMapTools_medfilt2(AADonnees,[MedianSize,MedianSize],hObject, eventdata, handles);
    
    cla(handles.axes1,'reset');
    axes(handles.axes1)
    switch get(handles.CheckLogColormap,'Value')
        case 1
            imagesc(log(data2Image));
        case 0
            imagesc(data2Image);
    end
    
    axis image
    
    % New 2.6.1 - Restore the zoom options
    %zoom on
    if WeZoom
        set(gca,{'xlim','ylim'},ZoomValues);
    end
    
    hc = colorbar('peer',handles.axes1,'vertical');
    set(handles.axes1,'xtick',[], 'ytick',[]);
    handles = XMapColorbar('Auto',1,handles);
    
    handles.medAff = AADonnees;
    handles.MedianFilterActiv = 1;
    
else % Cancel median filter (simple storage variable).
    AADonnees = handles.medAff;
    cla(handles.axes1,'reset');
    axes(handles.axes1)
    
    switch get(handles.CheckLogColormap,'Value')
        case 1
            imagesc(log(AADonnees));
        case 0
            imagesc(AADonnees);
    end 
    
    axis image
    
    % New 2.6.1 - Restore the zoom options
    %zoom on
    if WeZoom
        set(gca,{'xlim','ylim'},ZoomValues);
    end
    
    hc = colorbar('peer',handles.axes1,'vertical');
    
    
    set(handles.axes1,'xtick',[], 'ytick',[]);
    handles = XMapColorbar('Auto',1,handles);
    
    handles.medAff = [];
    handles.MedianFilterActiv = 0;
end



Max = str2num(get(handles.ColorMax,'String'));
Min = str2num(get(handles.ColorMin,'String'));

% Check and adjust the colorbar
if Max > Min
    switch get(handles.CheckLogColormap,'Value')
        case 1
            caxis([log(Min) log(Max)]);
            Labels = get(hc,'YTickLabel');
            for i = 1:length(Labels)
                Value = exp(str2num(char(Labels(i,:))));
                if Value >= 10
                    LabelsOk{i} = num2str(round(Value),'%.0f');
                elseif Value >= 1
                    LabelsOk{i} = num2str(Value,'%.2f');
                elseif Value >= 0.01
                    LabelsOk{i} = num2str(Value,'%.4f');
                else
                    LabelsOk{i} = num2str(Value,'%.6f');
                end
            end
            set(hc,'YTickLabel',LabelsOk);
        case 0
            caxis([Min Max]);
    end
end

%zoom on                                                         % New 1.6.2

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);

return


% #########################################################################
%     ROTATE FIGURE (V2.6.1)
function RotateButton_Callback(hObject, eventdata, handles)

set(handles.RotateButton,'Enable','off')

% In version 2.6.1 we need to reset the zoom (12.11.2018)
ZoomButtonReset_Callback(hObject, eventdata, handles);


previousRotate = handles.rotateFig;

handles.rotateFig = handles.rotateFig + 90;
if handles.rotateFig >= 360
    % Changed PL (10.05.18):
    handles.rotateFig = handles.rotateFig-360;
end

%handles.rotateFig;

lesInd = get(handles.axes1,'child');

for i=1:length(lesInd);
    if length(get(lesInd(i),'type')) == 5 % image
        AADonnees = get(lesInd(i),'CData');
        break
    else
        AADonnees = [];
    end
end


OrignalDonnes = XimrotateX(AADonnees,-previousRotate);

switch get(handles.CheckLogColormap,'Value')
    case 1
        OrignalDonnes = exp(OrignalDonnes);
end

% figure, imagesc(OrignalDonnes), axis image, colorbar

guidata(hObject,handles);

XPlot(OrignalDonnes,hObject, eventdata, handles);

zoom on                                                         % New 1.6.2
zoom reset                                % set the current view as default

GraphStyle(hObject, eventdata, handles)

set(handles.RotateButton,'Enable','on')
guidata(hObject,handles);

return


% #########################################################################
%     TEST IF ROTATE  (NEW V1.6.2)
function [TestRotate] = TestRotateFigure(hObject, eventdata, handles)
%
TestRotate = 1;



if handles.rotateFig
    
    TestRotate = 0;
    WhatToDo = questdlg({'Sorry but this function does not work with rotated images ...','Would you like to restore the original orientation?'},'XMapTools','Yes');
    
    if isequal(WhatToDo,'Yes');
        
        if isequal(handles.rotateFig,90)
            RotateButton_Callback(hObject, eventdata, handles)
            RotateButton_Callback(hObject, eventdata, handles)
            RotateButton_Callback(hObject, eventdata, handles)
        elseif isequal(handles.rotateFig,180)
            RotateButton_Callback(hObject, eventdata, handles)
            RotateButton_Callback(hObject, eventdata, handles)
        else
            RotateButton_Callback(hObject, eventdata, handles)
        end
        
        handles.rotateFig = 0;
        guidata(hObject,handles);
        
        TestRotate = 0;
        return
    end
end
return


% #########################################################################
%     MEDIAN FUNCTION (V1.6.2)
function [Data] = XMapTools_medfilt2(AADonnees,MedSize,hObject, eventdata, handles)

% Modified function 'mediannan.m' from Bruno Luong (MATLAB Newsgroup)
% P. LANARI, 24/04/13

A = AADonnees;
sz = MedSize;

XmapWaitBar(0, handles);
%drawnow

margin=(sz-1);%/2;
AA = nan(size(A)+2*margin);
AA(1+margin(1):end-margin(1),1+margin(2):end-margin(2))=A;
[iB jB]=ndgrid(1:sz(1),1:sz(2));
is=sub2ind(size(AA),iB,jB);
[iA jA] = ndgrid(1:size(A,1),1:size(A,2));
iA = sub2ind(size(AA),iA,jA);

XmapWaitBar(0.33, handles);

iA = uint32(iA(:).');
iS = uint32(is(:)-1);
idx = bsxfun(@plus,iA,iS);
% idx = repmat(iA(:).',numel(is),1) + repmat(is(:)-1,1,numel(iA));

XmapWaitBar(0.55, handles);

B = sort(AA(idx),1);
clear idx
j = any(isnan(B),1);
last = zeros(1,size(B,2))+size(B,1);
[trash last(j)]=max(isnan(B(:,j)),[],1);
last(j)=last(j)-1;

XmapWaitBar(0.75, handles);

M = nan(1,size(B,2));
valid = find(~isnan(A(:).')); % <- Simple check on A
mid = (last(valid)+1)/2;
i1 = sub2ind(size(B),floor(mid),valid);
i2 = sub2ind(size(B),ceil(mid),valid);
M(valid) = 0.5*(B(i1) + B(i2));
M = reshape(M,size(A));

Data = M;

XmapWaitBar(1, handles);

% Old LOOP version:
%
% % here this is not possible to use non-square sizes...
% medianSize = MedSize(1);
% decalSize = medianSize-1;                 % number of pixe before and after
%
% % EXAMPLE:
% %     medianSize = 2;     decalSize = 1;            Ok Center Ok
% %     medianSize = 3;     decalSize = 2;        Ok  Ok Center Ok  Ok
% %     medianSize = 4;     decalSize = 3;    Ok  Ok  Ok Center Ok  Ok  Ok
% %     ...
%
% nbLin = size(AADonnees,1);
% nbCol = size(AADonnees,2);
%
% Data = zeros(size(AADonnees));
%
% WaitBarPerso(0, hObject, eventdata, handles);
% drawnow
%
% compt = 0;
% for i=(decalSize+1):(nbCol-decalSize-1)
%     compt = compt+1;
%     if compt == 50
%         compt = 0;
%         WaitBarPerso(i/nbCol, hObject, eventdata, handles);
%         drawnow
%     end
%
%     for j=(decalSize+1):(nbLin-decalSize-1)
%
%         smallMatrix = AADonnees(j-decalSize:j+decalSize,i-decalSize:i+decalSize);
%         valMean = mean(smallMatrix(find(smallMatrix)));
%         if AADonnees(j,i) > 0 && valMean > 0
%             Data(j,i) = valMean;
%         else
%             Data(j,i) = 0;
%         end
%     end
% end
%
% WaitBarPerso(1, hObject, eventdata, handles);
% drawnow



return


% #########################################################################
%     MEDIAN VALUE (V1.6.2)
function FIGtext1_Callback(hObject, eventdata, handles)
ValueMedian = get(handles.FIGbutton1,'Value');
MedianSize = str2num(get(handles.FIGtext1,'String'));
lesInd = get(handles.axes1,'child');

if ValueMedian == 1 % alors il faut changer...
    AADonnees = handles.medAff;
    cla(handles.axes1,'reset');
    axes(handles.axes1)
    data2Image = XMapTools_medfilt2(AADonnees,[MedianSize,MedianSize],hObject, eventdata, handles);
    imagesc(data2Image), axis image, colorbar('peer',handles.axes1,'vertical')
    zoom on                                                         % New 1.6.2
    %imagesc(medfilt2(AADonnees,[MedianSize,MedianSize])), axis image,
    
    set(handles.axes1,'xtick',[], 'ytick',[]);
    
    Max = str2num(get(handles.ColorMax,'String'));
    Min = str2num(get(handles.ColorMin,'String'));
    
    if Max > Min
        caxis([Min,Max]);
    end
    
    handles = XMapColorbar('Auto',1,handles);
    
else % on attend de cliquer pour faire un filtre...
    return
end

guidata(hObject, handles);
GraphStyle(hObject, eventdata, handles)
% FIGbutton1_Callback(hObject, eventdata, handles);
return


% #########################################################################
%     SAMPLING BUTTON 3 (V1.4.1)
function BUsampling3_Callback(hObject, eventdata, handles)
Sampling(hObject, eventdata, handles, 3);
return

% #########################################################################
%     SAMPLING BUTTON 2 (V1.4.1)
function BUsampling2_Callback(hObject, eventdata, handles)
Sampling(hObject, eventdata, handles, 2);
return


% #########################################################################
%     SAMPLING BUTTON 5 (SCANNING WINDOW) (NEW V2.3.1)
function BUsampling5_Callback(hObject, eventdata, handles)
%
Sampling(hObject, eventdata, handles, 5);
return

% goto sampling

% ***
% #########################################################################
%     NEW GENERAL SAMPLING FUNCTION (V3.0.1)
function GeneralSamplingFunction(Type, hObject, eventdata, handles)
%
% Samping types:
%
%  --------------------------------------------------------------- 
%   Code	Mode        Color   Mode                Export
%  ---------------------------------------------------------------
%	1       Path        BW/C    Simple/Multiple     Data/Fig 
%	2    	Line        BW/C    Simple/Multiple     Data/Fig
%   3       Area        none    Simple/Multiple     Data/Fig
%   4       Int. Line   none    Simple/Multiple     Data/Fig
%   5       Sliding W.  none    Simple/Multiple     Data/Fig
%
%  ---------------------------------------------------------------


% Activate the correction mode
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

% Clean Axis?
switch get(handles.Menu_SamplingClean,'Checked')
        case 'on'
            Menu_CleanFigure_Callback(hObject, eventdata, handles);
end

% Extract the modes from the items in the menu "Sampling"
switch get(handles.Menu_SamplingColor,'Checked')
        case 'on'
            ColorMode = 1;
        case 'off'
            ColorMode = 0;
end

switch get(handles.Menu_SamplingMultiple,'Checked')
        case 'on'
            SamplingMode = 1;
        case 'off'
            SamplingMode = 0;
end

switch get(handles.Menu_SamplingSaveFig,'Checked')
        case 'on'
            SaveFigMode = 1;
        case 'off'
            SaveFigMode = 0;
end

switch get(handles.Menu_SamplingSaveFile,'Checked')
        case 'on'
            SaveFileMode = 1;
        case 'off'
            SaveFileMode = 0;
end



% Extracting data from the displayed figure:
axes(handles.axes1)

CLim = get(handles.axes1,'CLim');
CMap = colormap;

lesInd = get(handles.axes1,'child');
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if isequal(leType,'image');
            Data = get(lesInd(i),'CData');
        end
    end
end

switch get(handles.CheckLogColormap,'Value')
    case 1
        Data = exp(Data);
end

% Set "Decal" to display the text at the right shift from objects
if length(Data(1,:)) > 700
    Decal(1) = 20;
elseif length(Data(1,:)) > 400
    Decal(1) = 10;
else
    Decal(1) = 5;
end

if length(Data(:,1)) > 700
    Decal(2) = 20;
elseif length(Data(:,1)) > 400
    Decal(2) = 10;
else
    Decal(2) = 5;
end


% DATA SELECTION

%set(gcf, 'WindowButtonMotionFcn', '');

if isequal(SamplingMode,1)
    [ChemData,ChemNames] = PrepareMultiSampling(handles,hObject,eventdata);
end


% *************************************************************************
% *************************************************************************
if isequal(Type,1) % Path
    
    Compt = 0;
    while 1
        
        CodeTxt = [12,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        
        [Xref,Yref,Clique] = XginputX(1,handles);
    
        if isequal(Clique,3)
            
            if Compt < 3
                % Correction mode off (2.6.1)
                handles.CorrectionMode = 0;
                guidata(hObject,handles);
                OnEstOu(hObject, eventdata, handles)
                return
            end
            
            break
        else
            Compt = Compt+1;
            [X(Compt),Y(Compt)] = CoordinatesFromRef(Xref,Yref,handles);  
            X(Compt) = round(X(Compt));
            Y(Compt) = round(Y(Compt));
            
            axes(handles.axes1), hold on
            leTxt = text(X(Compt)-Decal(1),Y(Compt)-Decal(2),num2str(Compt));
            set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
            plot(X,Y,'-w')
            plot(X,Y,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
            
        end
    end
    
    LesX = [];
    LesY = [];
    for i = 2:length(X)
        Xs = [X(i-1),X(i)];
        Ys = [Y(i-1),Y(i)];
    
        LX = max(Xs) - min(Xs); 
        LY = max(Ys) - min(Ys);
    
        LZ = round(sqrt(LX^2 + LY^2));
    
        if Xs(2) > Xs(1)
            LesXs = Xs(1):(Xs(2)-Xs(1))/(LZ-1):Xs(2);
        elseif Xs(2) < Xs(1)
            LesXs = Xs(1):-(Xs(1)-Xs(2))/(LZ-1):Xs(2);
        else
            LesXs = ones(LZ,1) * Xs(1);
        end

        if Ys(2) > Ys(1)
            LesYs = Ys(1):(Ys(2)-Ys(1))/(LZ-1):Ys(2);
        elseif Ys(2) < Ys(1)
            LesYs = Ys(1):-(Ys(1)-Ys(2))/(LZ-1):Ys(2);
        else
            LesYs = ones(LZ,1) * Ys(1);
        end
        
        LesX(end+1:end+length(LesXs)) = LesXs;
        LesY(end+1:end+length(LesYs)) = LesYs;
    end
    
    
end


% *************************************************************************
% *************************************************************************
if isequal(Type,2) % line
    
    for i=1:2
        if i ==1
            CodeTxt = [12,3];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(3))]);
        else
            CodeTxt = [12,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(4))]);
        end
        [Xref,Yref,Clique] = XginputX(1,handles);
        
        if isequal(Clique,3) 
            CodeTxt = [12,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

            % Correction mode off (2.6.1) 
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            return
            
        end
        
        [X(i),Y(i)] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
        X(i) = round(X(i));
        Y(i) = round(Y(i));
        axes(handles.axes1)
        leTxt = text(X(i)-Decal(1),Y(i)-Decal(2),num2str(i));
        set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
        hold on, plot(X(i),Y(i),'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    end
    
    %plot(X,Y,'-w','linewidth',2)
    
    LX = max(X) - min(X); 
    LY = max(Y) - min(Y);
    
    LZ = round(sqrt(LX^2 + LY^2));
    
    
    if X(2) > X(1)
        LesX = X(1):(X(2)-X(1))/(LZ-1):X(2);
    elseif X(2) < X(1)
        LesX = X(1):-(X(1)-X(2))/(LZ-1):X(2);
    else
        LesX = ones(LZ,1) * X(1);
    end
    
    if Y(2) > Y(1)
        LesY = Y(1):(Y(2)-Y(1))/(LZ-1):Y(2);
    elseif Y(2) < Y(1)
        LesY = Y(1):-(Y(1)-Y(2))/(LZ-1):Y(2);
    else
        LesY = ones(LZ,1) * Y(1);
    end
    
end


% *************************************************************************
% *************************************************************************
if isequal(Type,1) || isequal(Type,2)
    % Simple or multiple modes for line and path
    
    plot(LesX,LesY,'.w','markersize',1);
    
    % Indexation
    XCoo = 1:1:length(Data(1,:));
    YCoo = 1:1:length(Data(:,1));
    
    for i = 1 : length(LesX)
        [V(i,1), IdxAll(i,1)] = min(abs(XCoo-LesX(i))); % Index X
        [V(i,2), IdxAll(i,2)] = min(abs(YCoo-LesY(i))); % Index Y
    end
    
    plot(IdxAll(:,1),IdxAll(:,2),'.w','markersize',1);
    
    if isequal(SamplingMode,1)   
        CodeTxt = [12,20];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        Activefigure = SamplingMulti(Type,IdxAll,LesX,LesY,ChemData,ChemNames,ColorMode,SaveFigMode,SaveFileMode,hObject, eventdata,handles);
        
        CodeTxt = [12,19];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % Correction mode off (2.6.1)
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        
        figure(Activefigure);
        
        return
    end
    
    % Updated to incorporate the distance 2.6.1
    LesData = zeros(size(IdxAll,1),3);
    for i=1:size(IdxAll,1) % Quanti
        LesData(i,1) = i;
        if i>1
            LesData(i,2) = LesData(i-1,2)+sqrt((LesX(i)-LesX(i-1))^2+(LesY(i)-LesY(i-1))^2);
        end
        LesData(i,3) = Data(IdxAll(i,2),IdxAll(i,1));
        if LesData(i,3) == 0
            LesData(i,3) = NaN;
        end
    end
    
    figure, hold on
    
    plot(LesData(:,2),LesData(:,3),'-k')
    if ColorMode
        scatter(LesData(:,2),LesData(:,3),[],LesData(:,3),'filled')
        colorbar vertical
        colormap(CMap)
        caxis(CLim)
    else
        plot(LesData(:,2),LesData(:,3),'ok','MarkerFaceColor','w')
    end
        
    xlabel('Distance (in pixel)');
    ylabel(PlotIdentification(handles));
    
    %keyboard
end   
    


% *************************************************************************
% *************************************************************************    
if isequal(Type,3) % area
    
    % In this version we directly go to multiple areas as implemented in 
    % XMapTools 1.6.1
    
    axes(handles.axes1); hold on
    ComptArea = 0;
    WeLoop = 1;
    
    
    while 1
        
        if ~WeLoop
            break
        end
        
        CodeTxt = [12,5];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        drawnow
        
        
        clique = 1;
        ComptResult = 1;
        
        h=[];
        while clique <= 2
            [Xref,Yref,clique] = XginputX(1,handles);
            [a,b] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
            if clique <= 2
                h(ComptResult,1) = a;
                h(ComptResult,2) = b;
                plot(floor(h(ComptResult,1)),floor(h(ComptResult,2)),'.w') % point
                if ComptResult >= 2 % start
                    plot([floor(h(ComptResult-1,1)),floor(h(ComptResult,1))],[floor(h(ComptResult-1,2)),floor(h(ComptResult,2))],'-k')
                end
                ComptResult = ComptResult + 1;
            end
        end
        
        if length(h(:)) < 6
            CodeTxt = [12,6];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            Answer = questdlg('This won''t work; you need to select at least 3 points to define an area','XMapTools','Continue','Cancel','Continue');
            
            
            if isequal(Answer,'Cancel')
                % Correction mode off (2.6.1)
                handles.CorrectionMode = 0;
                guidata(hObject,handles);
                OnEstOu(hObject, eventdata, handles)
                return
            end
        else
            
            plot([floor(h(1,1)),floor(h(end,1))],[floor(h(1,2)),floor(h(end,2))],'-k');
            
            % we add the area and ask the user what to do next
            ComptArea = ComptArea+1;
            Area(ComptArea).Coord = h;
            
            if ~SamplingMode
                % In this case we imediatly exit the loop
                break
            end
            
            leTxt = text(min(h(:,1))+(max(h(:,1))-min(h(:,1)))/2,min(h(:,2))+(max(h(:,2))-min(h(:,2)))/2,num2str(ComptArea));
            set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10);
            
            clear h
            
            CodeTxt = [12,21];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            Answer = questdlg('Would you like to add one more area?','XMapTools','Yes','No (continue)','Cancel','No (continue)');
            switch Answer
                case 'No (continue)'
                    WeLoop = 0;
                    
                    CodeTxt = [12,20];
                    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                    
                    
                case 'Cancel'
                    % Correction mode off (2.6.1)
                    handles.CorrectionMode = 0;
                    guidata(hObject,handles);
                    OnEstOu(hObject, eventdata, handles)
                    
                    return
            end
        end
        
    end
    
    if ~SamplingMode
        
        [LinS,ColS] = size(Data);
        MasqueSel = Xpoly2maskX(Area.Coord(:,1),Area.Coord(:,2),LinS,ColS);    % updated 21.03.13
        
        Selected = Data .* MasqueSel;
        
        TheSelValues = Selected(find(Selected > 0));
        
        %keyboard
        % Display a test of the selection:
        %figure, imagesc(MasqueSel), axis image, colorbar
        
        % This is compatible with the data export below.
        LesData(1,1) = 1;
        LesData(1,2) = mean(TheSelValues);
        LesData(1,3) = std(TheSelValues);
        LesData(1,4)= length(TheSelValues);
        LesData(1,5) = LesData(1,3)/sqrt(LesData(1,4));
        
        CodeTxt = [12,19];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
    else
        
        Activefigure = SamplingMulti(3,Area,[],[],ChemData,ChemNames,ColorMode,SaveFigMode,SaveFileMode,hObject, eventdata,handles);
        
        CodeTxt = [12,19];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % Correction mode off (2.6.1)
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles);
        
        figure(Activefigure);
        return
    end
    %set(handles.SamplingDisplay,'String',num2str(LesData(1,2)));
    
end   


% *************************************************************************
% *************************************************************************
if isequal(Type,4)   % INTEGRATED LINES
    
    for i=1:2
        if i ==1
            CodeTxt = [12,3];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(3))]);
        else
            CodeTxt = [12,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(4))]);
        end
        [Xref,Yref,Clique] = XginputX(1,handles);
        [X(i),Y(i)] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
        
        if Clique == 3
            CodeTxt = [12,6];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % Correction mode off (2.6.1)
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            return
        end
        
        X(i) = round(X(i));
        Y(i) = round(Y(i));
        
        % A horizontal line crashes the code so the line can't be horizontal !!!
        if i==2
            if X(2) == X(1)
                X(2) = X(2)+1;
            end
            if Y(2) == Y(1)
                Y(2) = Y(2)+1;
            end
        end
        
        axes(handles.axes1)
        leTxt = text(X(i)-Decal(1),Y(i)-Decal(2),num2str(i));
        set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
        hold on, plot(X(i),Y(i),'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    end
    
    
    X1 = X(1);
    X2 = X(2);
    Y1 = Y(1);
    Y2 = Y(2);
    
    
    % Coordinate of the line P1-P2
    [lesXP1P2,lesYP1P2] = LineCoordinate(round([X1,Y1]),round([X2,Y2]),size(Data));
    Coords = [lesXP1P2,lesYP1P2];
    
    % Calculate details regarding the area
    a1 = (Y2-Y1)/(X2-X1);
    b1 = Y2 - a1*X2;
    
    % line 2 / point 1
    a2 = -1/a1;
    b2 = Y1 - a2*X1;
    
    % line 3 / point 2
    a3 = a2;
    b3 = Y2 - a2*X2;
    
    
    % Plot the Map and the line again !!!
    plot(X,Y,'-m','linewidth',2);
    plot(X,Y,'-k','linewidth',1);
    
    x=1:size(Data,2);
    yi2 = a2*x+b2;
    yi3 = a3*x+b3;
    
    [MaxY,MaxX] = size(Data);
    LesQuels2 = find(x(:)>=1 & x(:)<=MaxX & yi2(:)>=1 & yi2(:)<=MaxY);
    LesQuels3 = find(x(:)>=1 & x(:)<=MaxX & yi3(:)>=1 & yi3(:)<=MaxY);
    
    plot(x(LesQuels2),yi2(LesQuels2),'-m');
    plot(x(LesQuels3),yi3(LesQuels3),'-m');
    
    
    CodeTxt = [12,10];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % Select the tird point
    [Xref,Yref,Clique] = XginputX(1,handles);
    [X3,Y3] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
    X3 = round(X3);
    Y3 = round(Y3);
    
    
    if Clique == 3
        CodeTxt = [12,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    
    %plot(X3,Y3,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    
    % Line 4 / with point3
    a4 = a1;
    b4 = Y3 - a4*X3;
    
    %plot(x,a4*x+b4,'-m');
    
    % Point 4 (intersection of L4 and L2)
    X4 = (b4-b2)/(a2-a4);
    Y4 = a2*X4 + b2;
    
    %plot(X4,Y4,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    
    % Point 5 (intersection of L4 and L3)
    X5 = (b4-b3)/(a3-a4);
    Y5 = a3*X5 + b3;
    
    %plot(X5,Y5,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    
    
    % Point 6
    X6 = X1 - (X4-X1);
    Y6 = Y1 - (Y4-Y1);
    
    %plot(X6,Y6,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    
    % Point 7
    X7 = X2 - (X5-X2);
    Y7 = Y2 - (Y5-Y2);
    
    %plot(X7,Y7,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
    
    % Line 5
    a5 = a1;
    b5 = Y7 - a5*X7;
    
    %plot(x,a5*x+b5,'-m');
    
    yi4 = a4*x+b4;
    yi5 = a5*x+b5;
    
    LesQuels4 = find(x(:)>=1 & x(:)<=MaxX & yi4(:)>=1 & yi4(:)<=MaxY);
    LesQuels5 = find(x(:)>=1 & x(:)<=MaxX & yi5(:)>=1 & yi5(:)<=MaxY);
    
    % Figure Update                                                 (new 2.1.3)
    plot(x(LesQuels4),yi4(LesQuels4),'-m');
    plot(x(LesQuels5),yi5(LesQuels5),'-m');
    
    
    % XMapTools running numbers...
    CodeTxt = [12,20];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

    if SamplingMode
        
        if ~SaveFileMode
            
            % Get first the size for pre-alocation:
            [MatrixProfils,Distances] = ExtractMatrixProfils(ChemData(:,:,1),X4,Y4,X6,Y6,X7,Y7);
            MeanMatrix = zeros(numel(Distances),size(ChemData,3));
            
            for i = 1:size(ChemData,3)
                [MatrixProfils,Distances] = ExtractMatrixProfils(ChemData(:,:,i),X4,Y4,X6,Y6,X7,Y7);
                Name = ChemNames{i};
                Save=0;
                CloseFig = 1;

                [TheMean,TheMedian,TheStd,FractPer,FiguresH] = plotMatrixProfils(MatrixProfils,Distances,Name,Save,'',CloseFig,handles);
                MeanMatrix(:,i) = TheMean';
            end
            
            hc = figure; 
            plot(Distances,MeanMatrix);
            xlabel('Distance (pixel)') % label x-axis
            legend(ChemNames,'Location','best');
            title(['Mean - ',datestr(clock)]) 
            
            % Correction mode off (2.6.1)
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(8))]);
            figure(hc);
            
            return
            
        else
            drawnow
            % Create a directory
            TypeName = 'IntLine';

            DateStr = char(datestr(now));
            DateStr(find(DateStr == ' ')) = '_';

            ProjectName = ['Sampling_',TypeName,'_',DateStr];
            for i=1:length(ProjectName)
                if isequal(ProjectName(i),':')
                    ProjectName(i) = '-';
                end
            end

            %ProjectName = char(inputdlg({'Sampling Project Name'},'XMapTools',1,{ProjectName}));

            if ~length(ProjectName)
                CodeTxt = [12,8];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                return
            end

            PathOri = cd;

            [Success,Message,MessageID] = mkdir('Exported-Sampling');
            cd Exported-Sampling
            [Success,Message,MessageID] = mkdir(char(ProjectName));
            cd(char(ProjectName))

            % Do not change the variable name (see below to save the map)
            pathname = cd;
            cd(PathOri);

            % Get first the size for pre-alocation:
            [MatrixProfils,Distances] = ExtractMatrixProfils(ChemData(:,:,1),X4,Y4,X6,Y6,X7,Y7);
            MeanMatrix = zeros(numel(Distances),size(ChemData,3));
            
            for i = 1:size(ChemData,3)

                [MatrixProfils,Distances] = ExtractMatrixProfils(ChemData(:,:,i),X4,Y4,X6,Y6,X7,Y7);

                Name = ChemNames{i};
                Save=1;
                CloseFig = 1;

                [TheMean,TheMedian,TheStd,FractPer,FiguresH] = plotMatrixProfils(MatrixProfils,Distances,Name,Save,pathname,CloseFig,handles);

                MeanMatrix(:,i) = TheMean';
                
                fid = fopen(strcat(pathname,'/',Name,'.txt'),'w');
                fprintf(fid,'%s\n','Sampling data exported from XMapTools');
                fprintf(fid,'%s\n',datestr(now));
                fprintf(fid,'%s\n','Method: Integrated Area');
                fprintf(fid,'%s\n\n','Columns: Distance (px) | Mean | Median | Std | Frac. Pixel (%)');
                
                for j = 1:length(TheMean(:))
                    fprintf(fid,'%12.8f\t%12.8f\t%12.8f\t%12.8f\t%12.8f\n',Distances(j),TheMean(j),TheMedian(j),TheStd(j),FractPer(j));
                end
                
                %12.8
                fprintf(fid,'\n\n');
                fprintf(fid,'%s\n%s\n\n','---------------------------',['Matrix containing all data: ',num2str(size(MatrixProfils,1)),' steps (rows) & ',num2str(size(MatrixProfils,2)),' lines (columns)']');
                
                Code = '';
                for j=1:size(MatrixProfils,2)
                    Code = [Code,'%12.8f\t'];
                end
                Code(end)='n';
                for j=1:size(MatrixProfils,1)
                    fprintf(fid,Code,MatrixProfils(j,:));
                end
                
                fprintf(fid,'\n');
                fclose(fid);
                
                
            end
            
            hc = figure; 
            plot(Distances,MeanMatrix);
            xlabel('Distance (pixel)') % label x-axis
            legend(ChemNames,'Location','best');
            title(['Mean - ',datestr(clock)]) 
            saveas(hc,[pathname,'/All.fig'],'fig')
            saveas(hc,[pathname,'/All.pdf'],'pdf')
            
        end
        
    else
        % Here we have function to extract the MatrixProfisl from any data...
        [MatrixProfils,Distances] = ExtractMatrixProfils(Data,X4,Y4,X6,Y6,X7,Y7);


        % Here we have a function to generate the plots...

        Name=PlotIdentification(handles);
        Save=0;
        PathSave = [];
        CloseFig = 0;
        
        [TheMean,TheMedian,TheStd,FractPer,FiguresH] = plotMatrixProfils(MatrixProfils,Distances,Name,Save,PathSave,CloseFig,handles);
        
        if SaveFileMode
            drawnow
            CodeTxt = [12,7];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);
            
            [Success,Message,MessageID] = mkdir('Exported-Sampling');
            
            cd Exported-Sampling
            [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export results as');
            cd ..
            
            if ~Directory
                CodeTxt = [12,8];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                a = gca;
                axes(handles.axes1)
                %zoom on
                axes(a)
                
                % Correction mode off (2.6.1)
                handles.CorrectionMode = 0;
                guidata(hObject,handles);
                OnEstOu(hObject, eventdata, handles)
                %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(8))]);
                return
            end
            
            fid = fopen(strcat(pathname,Directory),'w');
            fprintf(fid,'%s\n','Sampling data exported from XMapTools');
            fprintf(fid,'%s\n',datestr(now));
            fprintf(fid,'%s\n','Method: Integrated Area');
            fprintf(fid,'%s\n\n','Columns: Distance (px) | Mean | Median | Std | Frac. Pixel (%)');
            
            for i = 1:length(TheMean(:))
                fprintf(fid,'%12.8f\t%12.8f\t%12.8f\t%12.8f\t%12.8f\n',Distances(i),TheMean(i),TheMedian(i),TheStd(i),FractPer(i));
            end
            
            %12.8
            fprintf(fid,'\n\n');
            fprintf(fid,'%s\n%s\n\n','---------------------------',['Matrix containing all data: ',num2str(size(MatrixProfils,1)),' steps (rows) & ',num2str(size(MatrixProfils,2)),' lines (columns)']');
            
            Code = '';
            for i=1:size(MatrixProfils,2)
                Code = [Code,'%12.8f\t'];
            end
            Code(end)='n';
            for i=1:size(MatrixProfils,1)
                fprintf(fid,Code,MatrixProfils(i,:));
            end
            
            fprintf(fid,'\n');
            fclose(fid);
            
            CodeTxt = [12,9];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % save the figures:
            saveas(FiguresH(1),strcat(pathname,Directory(1:end-4),'_Data_All.fig'),'fig');
            saveas(FiguresH(1),strcat(pathname,Directory(1:end-4),'_Data_All.pdf'),'pdf');
            
            saveas(FiguresH(2),strcat(pathname,Directory(1:end-4),'_Data_Mean.fig'),'fig');
            saveas(FiguresH(2),strcat(pathname,Directory(1:end-4),'_Data_Mean.pdf'),'pdf');
        end
    
    end
    
    %WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
        
    if SaveFigMode
        if SamplingMode
            DoSaveTheFigure(strcat(pathname,'/map.txt'),hObject, eventdata, handles);
        else
            DoSaveTheFigure(strcat(pathname,Directory(1:end-4),'_map.txt'),hObject, eventdata, handles);
        end
    end
    
    CodeTxt = [12,19];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

    % Correction mode off (2.6.1)
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    
    if ~SamplingMode
        figure(FiguresH(1));
        figure(FiguresH(2));
    else
        if exist('hc')
            figure(hc);
        end
    end
    return
end


% *************************************************************************
% *************************************************************************
if isequal(Type,5)  % Scanning window
    
    % Define the reference rectangle...
    axes(handles.axes1), hold on
    
    for i=1:2
        CodeTxt = [12,14+i];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        [a,b,clique] = XginputX(1,handles);
        if clique < 2
            h(i,1) = a;
            h(i,2) = b;
            
            [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
            
            % new (1.6.2)
            hPlot(i,1) = aPlot;
            hPlot(i,2) = bPlot;
            
            plot(floor(hPlot(i,1)),floor(hPlot(i,2)),'.w') % point
        else
            CodeTxt = [12,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % Correction mode off (2.6.1)
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles);
            return
        end
    end
    
    XMin = min(h(:,1));
    XMax = max(h(:,1));
    YMin = min(h(:,2));
    YMax = max(h(:,2));
    
    [XMinPlot,YMinPlot] = CoordinatesFromRef(XMin,YMin,handles);
    [XMaxPlot,YMaxPlot] = CoordinatesFromRef(XMax,YMax,handles);
    
    plot([XMinPlot,XMaxPlot],[YMinPlot,YMinPlot],'-m','linewidth',2), plot([XMinPlot,XMaxPlot],[YMinPlot,YMinPlot],'-k','linewidth',1)
    plot([XMinPlot,XMaxPlot],[YMaxPlot,YMaxPlot],'-m','linewidth',2), plot([XMinPlot,XMaxPlot],[YMaxPlot,YMaxPlot],'-k','linewidth',1)
    plot([XMinPlot,XMinPlot],[YMinPlot,YMaxPlot],'-m','linewidth',2), plot([XMinPlot,XMinPlot],[YMinPlot,YMaxPlot],'-k','linewidth',1)
    plot([XMaxPlot,XMaxPlot],[YMinPlot,YMaxPlot],'-m','linewidth',2), plot([XMaxPlot,XMaxPlot],[YMinPlot,YMaxPlot],'-k','linewidth',1)
    
    XSemiL = (XMax-XMin)/2;
    YSemiL = (YMax-YMin)/2;
    
    XCenter = XMin+XSemiL;
    YCenter = YMin+YSemiL;
    
    [XCenterPlot,YCenterPlot] = CoordinatesFromRef(XCenter,YCenter,handles);
    
    plot(XCenterPlot,YCenterPlot,'.w')
    
    % Define the point where to go...
    CodeTxt = [12,17];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    XSteps = XCenter;
    YSteps = YCenter;
    
    Compt = 1;
    while 1
        [a,b,clique] = XginputX(1,handles);
        if clique < 2
            Compt = Compt+1;
            
            XSteps(Compt) = a;
            YSteps(Compt) = b;
            
            [XStepsPlot,YStepsPlot] = CoordinatesFromRef(XSteps,YSteps,handles);
            %keyboard
            plot(XStepsPlot(end),YStepsPlot(end),'.w') % point
            plot([XStepsPlot(end),XStepsPlot(end-1)],[YStepsPlot(end),YStepsPlot(end-1)],'-m','linewidth',2)
            
        else
            if Compt == 1
                CodeTxt = [12,6];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                % Correction mode off (2.6.1)
                handles.CorrectionMode = 0;
                guidata(hObject,handles);
                OnEstOu(hObject, eventdata, handles)
                
                return
            else
                break
            end
        end
    end
    
    % XMapTools running numbers...
    CodeTxt = [12,20];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    if SamplingMode
    
    
    else
        
        [LesData] = ExtractSLidingWindowProfils(Data,XStepsPlot,XSteps,YSteps,XSemiL,YSemiL,hObject, eventdata, handles);
        % LesData: ComptRes | DistTrav | mean | std
        
        Name=PlotIdentification(handles);
        Save = 0;
        PathSave= [];
        CloseFig = 0;
        
        [hFig] = PlotSlidingWindowProfile(Name,LesData,Save,PathSave,CloseFig,handles);

        if SaveFileMode
            drawnow
            %pause(0.1)
            
            CodeTxt = [12,7];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);
            
            [Success,Message,MessageID] = mkdir('Exported-Sampling');
            
            cd Exported-Sampling
            [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export results as');
            cd ..
            
            if ~Directory
                CodeTxt = [12,8];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                figure(hFig);
                
                % Correction mode off (2.6.1)
                handles.CorrectionMode = 0;
                guidata(hObject,handles);
                OnEstOu(hObject, eventdata, handles)
                %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(8))]);
                return
            end
            
            fid = fopen(strcat(pathname,Directory),'w');
            fprintf(fid,'%s\n','Sampling data exported from XMapTools');
            fprintf(fid,'%s\n',datestr(now));
            fprintf(fid,'%s\n','Method: Sliding Window');
            fprintf(fid,'%s\n\n','Columns: Distance (px) | Mean  | Std ');
            
            % LesData: ComptRes | DistTrav | mean | std
            
            for i = 1:length(LesData(:,1))
                fprintf(fid,'%12.8f\t%12.8f\t%12.8f\n',LesData(i,2:end));
            end
            
            fprintf(fid,'\n');
            fclose(fid);
            
            CodeTxt = [12,9];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            saveas(hFig,strcat(pathname,Directory(1:end-4),'_Data.fig'),'fig');
            saveas(hFig,strcat(pathname,Directory(1:end-4),'_Data.pdf'),'pdf');
          
        end
   
    end
    
    if SaveFigMode
        if SamplingMode
            DoSaveTheFigure(strcat(pathname,'/map.txt'),hObject, eventdata, handles);
        else
            DoSaveTheFigure(strcat(pathname,Directory(1:end-4),'_map.txt'),hObject, eventdata, handles);
        end
    end
    
    CodeTxt = [12,19];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

    % Correction mode off (2.6.1)
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    
    if ~SamplingMode
        figure(hFig);
    else
        if exist('hc')
            figure(hc);
        end
    end
    return

end


% % Temporary
% Activefigure = gcf;
% % Correction mode off (2.6.1)
% handles.CorrectionMode = 0;
% guidata(hObject,handles);
% OnEstOu(hObject, eventdata, handles)
% 
% figure(Activefigure)
% return

% else
%     % Correction mode off (2.6.1)
%     handles.CorrectionMode = 0;
%     guidata(hObject,handles);
%     OnEstOu(hObject, eventdata, handles)
%     
%     return
% end

% *************************************************************************
% *************************************************************************
Activefigure = gcf;
drawnow

if SaveFileMode
    % Save
    CodeTxt = [12,7];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);
    
    [Success,Message,MessageID] = mkdir('Exported-Sampling');
    
    cd Exported-Sampling
    [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export sampling results as');
    cd ..
    
    if ~Directory
        CodeTxt = [12,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        a = gca;
        axes(handles.axes1)
        %zoom on
        axes(a)
        
        %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(8))]);
        
        % Correction mode off (2.6.1)
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
    
    fid = fopen(strcat(pathname,Directory),'w');
    fprintf(fid,'%s\n','Sampling data exported from XMapTools');
    fprintf(fid,'%s\n',datestr(now));
    switch Type
        case 1
            fprintf(fid,'%s\n\n','Sampling mode: Path');
        case 2
            fprintf(fid,'%s\n\n','Sampling mode: Line');
        case 3
            fprintf(fid,'%s\n\n','Sampling mode: Area');
        case 5
            fprintf(fid,'%s\n\n','Sampling mode: Scanning rectangle');
    end
    if Type == 3
        if LesData(1,3) > 1000
            fprintf(fid,'%s\t\t%s\t%s\t%s\t\t%s\n','Ref','Value','StdDev','N','StdErr');
        else
            fprintf(fid,'%s\t\t%s\t%s\t%s\t%s\n','Ref','Value','StdDev','N','StdErr');
        end
        fprintf(fid,'%.4f\t%.4f\t%.4f\t%.0f\t%.4f\n',LesData(1,1),LesData(1,2),LesData(1,3),LesData(1,4),LesData(1,5));
    elseif Type == 5
        fprintf(fid,'%s\t%s\t%s\t%s\n','Ref','Distance(px)','Value','StdDev');
        for i = 1:length(LesData(:,1))
            fprintf(fid,'%.0f\t%.3f\t%.3f\t%.3f\n',LesData(i,1),LesData(i,2),LesData(i,3),LesData(i,4));
        end
    else
        fprintf(fid,'%s\t%s\t%s\n','Ref','Distance[px]','Value');
        for i = 1:length(LesData(:,1))
            fprintf(fid,'%s\n',[char(num2str(LesData(i,1))),' ',char(num2str(LesData(i,2))),' ',char(num2str(LesData(i,3)))]);
        end
    end
    
    fprintf(fid,'\n');
    fclose(fid);
    
    CodeTxt = [12,9];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    if SaveFigMode
        DoSaveTheFigure(strcat(pathname,Directory(1:end-4),'_map.txt'),hObject, eventdata, handles);
        %WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
        
        if ~isequal(Type,3) % we have no figure for simple area...
            saveas(Activefigure,[pathname,Directory(1:end-4),'_plot.fig'],'fig');
        end
    end
end

CodeTxt = [12,19];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% Correction mode off (2.6.1)
handles.CorrectionMode = 0;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

if isequal(Type,3)
    % Update value
    set(handles.SamplingDisplay,'String',[num2str(LesData(1,2)),' +/- ',num2str(LesData(1,3)),' (1s)'],'Enable','On');
end

figure(Activefigure)

%a = gca;
%axes(handles.axes1)
%zoom on
%axes(a)


%set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(9))]);
return


% goto sampling

% ***
% #########################################################################
%     OLD UNUSED SAMPLING FUNCTION (V2.6.1)
function Sampling(hObject, eventdata, handles, Type)

% % Correction mode on (2.6.1)
% handles.CorrectionMode = 1;
% guidata(hObject,handles);
% OnEstOu(hObject, eventdata, handles)
% 
% 
% % Recuperer les data
% axes(handles.axes1)
% 
% CLim = get(handles.axes1,'CLim');
% CMap = colormap;
% 
% lesInd = get(handles.axes1,'child');
% 
% % On extrait l'image...
% for i=1:length(lesInd)
%     leType = get(lesInd(i),'Type');
%     if length(leType) == 5
%         if leType == 'image';
%             Data = get(lesInd(i),'CData');
%         end
%     end
% end
% 
% switch get(handles.CheckLogColormap,'Value')
%     case 1
%         Data = exp(Data);
% end
% 
% if length(Data(1,:)) > 700
%     Decal(1) = 20;
% elseif length(Data(1,:)) > 400
%     Decal(1) = 10;
% else
%     Decal(1) = 5;
% end
% 
% if length(Data(:,1)) > 700
%     Decal(2) = 20;
% elseif length(Data(:,1)) > 400
%     Decal(2) = 10;
% else
%     Decal(2) = 5;
% end
% 
% 
% % New 2.3.1 (8.06.16)
% if isequal(Type,2)
%     set(gcf, 'WindowButtonMotionFcn', '');
%     
%     CodeTxt = [12,11];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     SamplingMode = Menu_XMT({'Sampling mode'},{'Single Map (color)','Multiple Maps (color)','Single Map (bw)','Multiple Maps (bw)'},handles.LocBase);
%     
%     if SamplingMode < 3
%         SamplingMode = SamplingMode;
%         ColorMode = 1;
%     else
%         SamplingMode = SamplingMode-2;
%         ColorMode = 0;
%     end
%     
% elseif isequal(Type,3)
%     set(gcf, 'WindowButtonMotionFcn', '');
%     
%     CodeTxt = [12,11];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     SamplingMode = Menu_XMT({'Sampling mode'},{'Single Area/Map','Multiple Areas/Maps '},handles.LocBase);
%     ColorMode = 0;
% else
%     SamplingMode = 1;
%     ColorMode = 0;
% end
% 
% if isequal(SamplingMode,2)
%     [ChemData,ChemNames] = PrepareMultiSampling(handles,hObject,eventdata);
%     set(gcf, 'WindowButtonMotionFcn', @mouseMove);
% end
% 
% 
% % *************************************************************************
% % *************************************************************************
% 
% if Type == 0 % point
%     
%     CodeTxt = [12,1];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     %     set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(1))]);
%     
%     Clique = 1;
%     Compt = 0;
%     while Clique <= 2
%         [Xref,Yref,Clique] = XginputX(1,handles);
%         [X,Y] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
%         if Clique <= 2
%             Compt = Compt + 1;
%             X = round(X);
%             Y = round(Y);
%             set(handles.SamplingDisplay,'String',num2str(Data(Y,X),3));
%             LesData(Compt,2) = Data(Y,X);
%             LesData(Compt,1) = Compt;
%             axes(handles.axes1)
%             leTxt = text(X-Decal(1),Y-Decal(2),num2str(Compt));
%             set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
%             
%             hold on, plot(X,Y,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
%         else
%             if Compt == 0
%                 CodeTxt = [12,2];
%                 set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%                 TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%                 % set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(2))]);
%                 
%                 % Correction mode off (2.6.1)
%                 handles.CorrectionMode = 0;
%                 guidata(hObject,handles);
%                 OnEstOu(hObject, eventdata, handles)
%                 return
%             end
%             
%             set(handles.SamplingDisplay,'String','');
%             figure, plot(LesData(:,1),LesData(:,2),'o-k')
%             break
%         end
%     end
%     
%     set(handles.axes1,'xtick',[], 'ytick',[]);
%     GraphStyle(hObject, eventdata, handles)
%     
%     
% elseif Type == 2 % line
%     
%     for i=1:2
%         if i ==1
%             CodeTxt = [12,3];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(3))]);
%         else
%             CodeTxt = [12,4];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(4))]);
%         end
%         [Xref,Yref,Clique] = XginputX(1,handles);
%         
%         if isequal(Clique,3) 
%             CodeTxt = [12,2];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
% 
%             % Correction mode off (2.6.1) 
%             handles.CorrectionMode = 0;
%             guidata(hObject,handles);
%             OnEstOu(hObject, eventdata, handles)
%             return
%             
%         end
%         
%         [X(i),Y(i)] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
%         X(i) = round(X(i));
%         Y(i) = round(Y(i));
%         axes(handles.axes1)
%         leTxt = text(X(i)-Decal(1),Y(i)-Decal(2),num2str(i));
%         set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
%         hold on, plot(X(i),Y(i),'o','MarkerEdgeColor','r','MarkerFaceColor','w')
%     end
%     
%     %plot(X,Y,'-w','linewidth',2)
%     
%     LX = max(X) - min(X); 
%     LY = max(Y) - min(Y);
%     
%     LZ = round(sqrt(LX^2 + LY^2));
%     
%     
%     if X(2) > X(1)
%         LesX = X(1):(X(2)-X(1))/(LZ-1):X(2);
%     elseif X(2) < X(1)
%         LesX = X(1):-(X(1)-X(2))/(LZ-1):X(2);
%     else
%         LesX = ones(LZ,1) * X(1);
%     end
%     
%     if Y(2) > Y(1)
%         LesY = Y(1):(Y(2)-Y(1))/(LZ-1):Y(2);
%     elseif Y(2) < Y(1)
%         LesY = Y(1):-(Y(1)-Y(2))/(LZ-1):Y(2);
%     else
%         LesY = ones(LZ,1) * Y(1);
%     end
%     
%     plot(LesX,LesY,'.w','markersize',1);
%     
%     % Indexation
%     XCoo = 1:1:length(Data(1,:));
%     YCoo = 1:1:length(Data(:,1));
%     
%     for i = 1 : length(LesX)
%         [V(i,1), IdxAll(i,1)] = min(abs(XCoo-LesX(i))); % Index X
%         [V(i,2), IdxAll(i,2)] = min(abs(YCoo-LesY(i))); % Index Y
%     end
%     
%     plot(IdxAll(:,1),IdxAll(:,2),'.w','markersize',1);
%     
%     if isequal(SamplingMode,2)
%         CodeTxt = [12,20];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         SamplingMulti(2,IdxAll,LesX,LesY,ChemData,ChemNames,ColorMode,hObject, eventdata,handles);
%         
%         CodeTxt = [12,19];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         % Correction mode off (2.6.1)
%         handles.CorrectionMode = 0;
%         guidata(hObject,handles);
%         OnEstOu(hObject, eventdata, handles)
%         return
%     end
%     
%     % Updated to incorporate the distance 2.6.1
%     LesData = zeros(size(IdxAll,1),3);
%     for i=1:size(IdxAll,1) % Quanti
%         LesData(i,1) = i;
%         if i>1
%             LesData(i,2) = LesData(i-1,2)+sqrt((LesX(i)-LesX(i-1))^2+(LesY(i)-LesY(i-1))^2);
%         end
%         LesData(i,3) = Data(IdxAll(i,2),IdxAll(i,1));
%         if LesData(i,3) == 0
%             LesData(i,3) = NaN;
%         end
%     end
%     
%     figure, hold on
%     
%     plot(LesData(:,2),LesData(:,3),'-k')
%     if ColorMode
%         scatter(LesData(:,2),LesData(:,3),[],LesData(:,3),'filled')
%         colorbar vertical
%         colormap(CMap)
%         caxis(CLim)
%     else
%         plot(LesData(:,2),LesData(:,3),'ok','MarkerFaceColor','w')
%     end
%         
%     xlabel('Distance (in pixel)');
%     ylabel(PlotIdentification(handles));
%     
%     %keyboard
%     
%     
%     
% elseif Type == 3 % area
%     
%    
%     if isequal(SamplingMode,2)
%         
%         % Here we need to select multiple areas (1.6.1)
%         axes(handles.axes1); hold on
%         ComptArea = 0;
%         WeLoop = 1;
% 
%         while 1
%             CodeTxt = [12,5];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             
%             if ~WeLoop
%                 break
%             end
%              
%             clique = 1;
%             ComptResult = 1;
%             
%             h=[];
%             while clique <= 2
%                 [Xref,Yref,clique] = XginputX(1,handles);
%                 [a,b] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
%                 if clique <= 2
%                     h(ComptResult,1) = a;
%                     h(ComptResult,2) = b;
%                     plot(floor(h(ComptResult,1)),floor(h(ComptResult,2)),'.w') % point
%                     if ComptResult >= 2 % start
%                         plot([floor(h(ComptResult-1,1)),floor(h(ComptResult,1))],[floor(h(ComptResult-1,2)),floor(h(ComptResult,2))],'-k')
%                     end
%                     ComptResult = ComptResult + 1;
%                 end
%             end
%             
%             if length(h(:)) < 6
%                 CodeTxt = [12,6];
%                 set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%                 TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             
%                 Answer = questdlg('This won''t work; you need to select at least 3 points to define an area','XMapTools','Continue','Cancel','Continue');
%                 
%                 
%                 if isequal(Answer,'Cancel')
%                     % Correction mode off (2.6.1)
%                     handles.CorrectionMode = 0;
%                     guidata(hObject,handles);
%                     OnEstOu(hObject, eventdata, handles)
%                     
%                     return
%                 end
%             else
%                 
%                 plot([floor(h(1,1)),floor(h(end,1))],[floor(h(1,2)),floor(h(end,2))],'-k');
%                 
%                 % we add the area and ask the user what to do next
%                 ComptArea = ComptArea+1;
%                 Area(ComptArea).Coord = h;
%                 
%                 leTxt = text(min(h(:,1))+(max(h(:,1))-min(h(:,1)))/2,min(h(:,2))+(max(h(:,2))-min(h(:,2)))/2,num2str(ComptArea));
%                 set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10);
% 
%                 clear h
%                 
%                 CodeTxt = [12,21];
%                 set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%                 TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%                 
%                 Answer = questdlg('Would you like to add one more area?','XMapTools','Yes','No (continue)','Cancel','No (continue)');
%                 switch Answer
%                     case 'No (continue)'
%                         WeLoop = 0;
%                         
%                     case 'Cancel'
%                         % Correction mode off (2.6.1)
%                         handles.CorrectionMode = 0;
%                         guidata(hObject,handles);
%                         OnEstOu(hObject, eventdata, handles)
%                         
%                         return
%                 end
%             end
%             
%         end
%         
%         CodeTxt = [12,20];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         SamplingMulti(3,Area,[],[],ChemData,ChemNames,ColorMode,hObject, eventdata,handles);
%         
%         CodeTxt = [12,19];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         % Correction mode off (2.6.1)
%         handles.CorrectionMode = 0;
%         guidata(hObject,handles);
%         OnEstOu(hObject, eventdata, handles)
%         return
%     end
%         
%         
%     % Below is the "old" procedure with one map and one area to be
%     % selected. 
%     
%     CodeTxt = [12,5];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     clique = 1;
%     ComptResult = 1;
%     axes(handles.axes1); hold on
%     
%     h=[];
%     while clique <= 2
%         [Xref,Yref,clique] = XginputX(1,handles);
%         [a,b] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
%         if clique <= 2
%             h(ComptResult,1) = a;
%             h(ComptResult,2) = b;
%             plot(floor(h(ComptResult,1)),floor(h(ComptResult,2)),'.w') % point
%             if ComptResult >= 2 % start
%                 plot([floor(h(ComptResult-1,1)),floor(h(ComptResult,1))],[floor(h(ComptResult-1,2)),floor(h(ComptResult,2))],'-k')
%             end
%             ComptResult = ComptResult + 1;
%         end
%     end
%     
%     % Trois points minimum...
%     if length(h(:)) < 6
%         CodeTxt = [12,6];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         % Correction mode off (2.6.1)
%         handles.CorrectionMode = 0;
%         guidata(hObject,handles);
%         OnEstOu(hObject, eventdata, handles)
%         
%         %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(6))]);
%         return
%     end
%     
%     % new V1.4.1
%     plot([floor(h(1,1)),floor(h(end,1))],[floor(h(1,2)),floor(h(end,2))],'-k')
%     
%     
%     
%     [LinS,ColS] = size(Data);
%     MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);    % updated 21.03.13
%     
%     Selected = Data .* MasqueSel;
%     
%     TheSelValues = Selected(find(Selected > 0));
%     %keyboard
%     % Display a test of the selection:
%     %figure, imagesc(MasqueSel), axis image, colorbar
%     
%     LesData(1,1) = 1;
%     LesData(1,2) = mean(TheSelValues);
%     LesData(1,3) = std(TheSelValues);
%     LesData(1,4)= length(TheSelValues);
%     LesData(1,5) = LesData(1,3)/sqrt(LesData(1,4));
%     
%     %set(handles.SamplingDisplay,'String',num2str(LesData(1,2)));
%     
%     
% elseif Type == 5  % Scanning window
%     
%     % Define the reference rectangle...
%     axes(handles.axes1), hold on
%     
%     for i=1:2
%         CodeTxt = [12,14+i];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         [a,b,clique] = XginputX(1,handles);
%         if clique < 2
%             h(i,1) = a;
%             h(i,2) = b;
%             
%             [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
%             
%             % new (1.6.2)
%             hPlot(i,1) = aPlot;
%             hPlot(i,2) = bPlot;
%             
%             plot(floor(hPlot(i,1)),floor(hPlot(i,2)),'.w') % point
%         else
%             CodeTxt = [10,6];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             
%             % Correction mode off (2.6.1)
%             handles.CorrectionMode = 0;
%             guidata(hObject,handles);
%             OnEstOu(hObject, eventdata, handles)
%             
%             return
%         end
%     end
%     
%     XMin = min(h(:,1));
%     XMax = max(h(:,1));
%     YMin = min(h(:,2));
%     YMax = max(h(:,2));
%     
%     [XMinPlot,YMinPlot] = CoordinatesFromRef(XMin,YMin,handles);
%     [XMaxPlot,YMaxPlot] = CoordinatesFromRef(XMax,YMax,handles);
%     
%     plot([XMinPlot,XMaxPlot],[YMinPlot,YMinPlot],'-m','linewidth',2), plot([XMinPlot,XMaxPlot],[YMinPlot,YMinPlot],'-k','linewidth',1)
%     plot([XMinPlot,XMaxPlot],[YMaxPlot,YMaxPlot],'-m','linewidth',2), plot([XMinPlot,XMaxPlot],[YMaxPlot,YMaxPlot],'-k','linewidth',1)
%     plot([XMinPlot,XMinPlot],[YMinPlot,YMaxPlot],'-m','linewidth',2), plot([XMinPlot,XMinPlot],[YMinPlot,YMaxPlot],'-k','linewidth',1)
%     plot([XMaxPlot,XMaxPlot],[YMinPlot,YMaxPlot],'-m','linewidth',2), plot([XMaxPlot,XMaxPlot],[YMinPlot,YMaxPlot],'-k','linewidth',1)
%     
%     XSemiL = (XMax-XMin)/2;
%     YSemiL = (YMax-YMin)/2;
%     
%     XCenter = XMin+XSemiL;
%     YCenter = YMin+YSemiL;
%     
%     [XCenterPlot,YCenterPlot] = CoordinatesFromRef(XCenter,YCenter,handles);
%     
%     plot(XCenterPlot,YCenterPlot,'.w')
%     
%     % Define the point where to go...
%     CodeTxt = [12,17];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     XSteps = XCenter;
%     YSteps = YCenter;
%     
%     Compt = 1;
%     while 1
%         [a,b,clique] = XginputX(1,handles);
%         if clique < 2
%             Compt = Compt+1;
%             
%             XSteps(Compt) = a;
%             YSteps(Compt) = b;
%             
%             [XStepsPlot,YStepsPlot] = CoordinatesFromRef(XSteps,YSteps,handles);
%             %keyboard
%             plot(XStepsPlot(end),YStepsPlot(end),'.w') % point
%             plot([XStepsPlot(end),XStepsPlot(end-1)],[YStepsPlot(end),YStepsPlot(end-1)],'-m','linewidth',2)
%             
%         else
%             if Compt == 1
%                 CodeTxt = [12,6];
%                 set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%                 TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%                 
%                 % Correction mode off (2.6.1)
%                 handles.CorrectionMode = 0;
%                 guidata(hObject,handles);
%                 OnEstOu(hObject, eventdata, handles)
%                 
%                 return
%             else
%                 break
%             end
%         end
%     end
%     
%     CodeTxt = [12,18];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     NbSteps = str2num(char(inputdlg({'Steps within each segment'},'XMapTools',1,{'30'})));
%     
%     if ~length(NbSteps) 
%         
%         CodeTxt = [12,8];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         % Correction mode off (2.6.1)
%         handles.CorrectionMode = 0;
%         guidata(hObject,handles);
%         OnEstOu(hObject, eventdata, handles)
% 
%         return
%     end
%     
%     CodeTxt = [12,13];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     NbSegments = length(XStepsPlot)-1;
%     
%     ComptRes = 0;
%     DistTrav = 0;
%     for iSeg = 1:NbSegments
%         
%         XCenter = XSteps(iSeg);
%         XEnd = XSteps(iSeg+1);
%         YCenter = YSteps(iSeg);
%         YEnd = YSteps(iSeg+1);
%         
%         % dX,dY
%         dX = (max([XCenter,XEnd])-min([XCenter,XEnd]))/(NbSteps-1);
%         if XCenter > XEnd
%             dX = -dX;
%         end
%         
%         dY = (max([YCenter,YEnd])-min([YCenter,YEnd]))/(NbSteps-1);
%         if YCenter > YEnd
%             dY = -dY;
%         end
%         
%         XTemp = XCenter;
%         YTemp = YCenter;
%         
%         if isequal(iSeg,1)
%             TheMinInc = 1;
%         else
%             TheMinInc = 2;
%         end
%         
%         for i=TheMinInc:NbSteps
%             
%             if i>1
%                 XTemp = XTemp+dX;
%                 YTemp = YTemp+dY;
%             end
%             
%             XCoord = [XTemp-XSemiL,XTemp+XSemiL,XTemp+XSemiL,XTemp-XSemiL];
%             YCoord = [YTemp-YSemiL,YTemp-YSemiL,YTemp+YSemiL,YTemp+YSemiL];
%             
%             [XTempPlot,YTempPlot] = CoordinatesFromRef(XTemp,YTemp,handles);
%             [XCoordPlot,YCoordPlot] = CoordinatesFromRef(XCoord,YCoord,handles);
%             
%             %plot(XTempPlot,YTempPlot,'.k')
%             plot(XCoordPlot,YCoordPlot,'.k')
%             drawnow
%             
%             [LinS,ColS] = size(handles.data.map(1).values);  % Original size not the rotated one (25.08.16)
%             MasqueSel = Xpoly2maskX(XCoord,YCoord,LinS,ColS);
%             
%             % And now we apply the rotation to the mask...
%             MasqueSel = XimrotateX(MasqueSel,handles.rotateFig);
%             
%             %             figure(1)
%             %             imagesc(MasqueSel), axis image
%             %             drawnow
%             %             pause(0.5)
%             
%             Selected = Data .* MasqueSel;
%             
%             TheSelValues = Selected(find(Selected > 0));
%             
%             ComptRes = ComptRes+1;
%             DistTrav = DistTrav + sqrt(dX^2+dY^2);
%             
%             LesData(ComptRes,1) = ComptRes;
%             LesData(ComptRes,2) = DistTrav;
%             LesData(ComptRes,3) = mean(TheSelValues);
%             LesData(ComptRes,4) = std(TheSelValues);
%             %LesData(ComptRes,5) = std(TheSelValues)/(length(TheSelValues)-1); %Std error
%             
%         end
%     end
%     plot([XCoordPlot(1),XCoordPlot(4)],[YCoordPlot(1),YCoordPlot(4)],'-m','linewidth',2), plot([XCoordPlot(1),XCoordPlot(4)],[YCoordPlot(1),YCoordPlot(4)],'-k','linewidth',1)
%     plot([XCoordPlot(1),XCoordPlot(2)],[YCoordPlot(1),YCoordPlot(2)],'-m','linewidth',2), plot([XCoordPlot(1),XCoordPlot(2)],[YCoordPlot(1),YCoordPlot(2)],'-k','linewidth',1)
%     plot([XCoordPlot(3),XCoordPlot(4)],[YCoordPlot(3),YCoordPlot(4)],'-m','linewidth',2), plot([XCoordPlot(3),XCoordPlot(4)],[YCoordPlot(3),YCoordPlot(4)],'-k','linewidth',1)
%     plot([XCoordPlot(3),XCoordPlot(2)],[YCoordPlot(3),YCoordPlot(2)],'-m','linewidth',2), plot([XCoordPlot(3),XCoordPlot(2)],[YCoordPlot(3),YCoordPlot(2)],'-k','linewidth',1)
%     
%     %keyboard
%     
%     figure
%     plot(LesData(:,2),LesData(:,3),'.-k','linewidth',1), hold on
%     plot(LesData(:,2),LesData(:,3)+LesData(:,4),'--k','linewidth',1)
%     plot(LesData(:,2),LesData(:,3)-LesData(:,4),'--k','linewidth',1)
%     %plot(LesData(:,2),LesData(:,3)+LesData(:,5),'--r','linewidth',1)
%     %plot(LesData(:,2),LesData(:,3)-LesData(:,5),'--r','linewidth',1)
%     
%     xlabel('Distance (px)')
%     
%     CodeTxt = [12,14];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     
%     
% else
%     
%     % Correction mode off (2.6.1)
%     handles.CorrectionMode = 0;
%     guidata(hObject,handles);
%     OnEstOu(hObject, eventdata, handles)
%     
%     return
% end
% 
% % *************************************************************************
% % *************************************************************************
% Activefigure = gcf;
% 
% ButtonName = questdlg('Would you like to save the results? (ASCII file)', 'Sampling', 'Yes');
% 
% switch ButtonName
%     case 'Yes'
%         
%         % Save
%         CodeTxt = [12,7];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         % set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);
%         
%         [Success,Message,MessageID] = mkdir('Exported-Sampling');
%         
%         cd Exported-Sampling
%         [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export results as');
%         cd ..
%         
%         if ~Directory
%             CodeTxt = [12,8];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             
%             a = gca;
%             axes(handles.axes1)
%             %zoom on
%             axes(a)
%             
%             %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(8))]);
%             
%             % Correction mode off (2.6.1) 
%             handles.CorrectionMode = 0;
%             guidata(hObject,handles);
%             OnEstOu(hObject, eventdata, handles)
%             return
%         end
%         
%         fid = fopen(strcat(pathname,Directory),'w');
%         fprintf(fid,'%s\n','Sampling data exported from XMapTools');
%         fprintf(fid,'%s\n',date);
%         if Type == 1
%             fprintf(fid,'%s\n\n','Sampling mode: Point');
%         elseif Type == 2
%             fprintf(fid,'%s\n\n','Sampling mode: Line');
%             
%         elseif Type == 3
%             fprintf(fid,'%s\n\n','Sampling mode: Area');
%         else
%             fprintf(fid,'%s\n\n','Sampling mode: Scanning rectangle');
%         end
%         
%         if Type == 3
%             if LesData(1,3) > 1000
%                 fprintf(fid,'%s\t\t%s\t%s\t%s\t\t%s\n','Ref','Value','StdDev','N','StdErr');
%             else
%                 fprintf(fid,'%s\t\t%s\t%s\t%s\t%s\n','Ref','Value','StdDev','N','StdErr');
%             end
%             fprintf(fid,'%.4f\t%.4f\t%.4f\t%.0f\t%.4f\n',LesData(1,1),LesData(1,2),LesData(1,3),LesData(1,4),LesData(1,5));
%         elseif Type == 5
%             fprintf(fid,'%s\t%s\t%s\t%s\n','Ref','Distance(px)','Value','StdDev');
%             for i = 1:length(LesData(:,1))
%                 fprintf(fid,'%.0f\t%.3f\t%.3f\t%.3f\n',LesData(i,1),LesData(i,2),LesData(i,3),LesData(i,4));
%             end
%         else
%             fprintf(fid,'%s\t%s\t%s\n','Ref','Distance[px]','Value');
%             for i = 1:length(LesData(:,1))
%                 fprintf(fid,'%s\n',[char(num2str(LesData(i,1))),' ',char(num2str(LesData(i,2))),' ',char(num2str(LesData(i,3)))]);
%             end
%         end
%         
%         fprintf(fid,'\n');
%         fclose(fid);
%         
%         CodeTxt = [12,9];
%         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%         
%         
%         WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
%         
% end
% 
% % Correction mode off (2.6.1)
% handles.CorrectionMode = 0;
% guidata(hObject,handles);
% OnEstOu(hObject, eventdata, handles)
% 
% % Update value
% if isequal(Type,3)
%     set(handles.SamplingDisplay,'String',[num2str(LesData(1,2)),' +/- ',num2str(LesData(1,3)),' (1s)'],'Enable','On');
% end
% 
% figure(Activefigure)



return


% #########################################################################
%     PREPARE MULTI-SAMPLING FUNCTION (V1.6.2)
function [ChemData,ChemNames] = PrepareMultiSampling(handles,hObject,eventdata)
%

% Mode Multi...

XRAY = get(handles.OPT1,'Value');
QUANTI = get(handles.OPT2,'Value');
RESULTS = get(handles.OPT3,'Value');

if XRAY
    SelectedMap = get(handles.PPMenu1,'Value');
    ListMaps = get(handles.PPMenu1,'String');
    
    SelectedPhase = get(handles.PPMenu2,'Value');
    
    CodeTxt = [12,12];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [SelectedMaps,OK] = listdlg('ListString',ListMaps,'SelectionMode','Multiple','InitialValue',SelectedMap,'Name','XMapTools','PromptString','Select the maps');
    
    if ~OK
        CodeTxt = [12,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    
    DataAll = handles.data;
    MaskFile = handles.MaskFile;
    
    MaskSelected = get(handles.PPMenu3,'Value');
    
    NbMaps = length(SelectedMaps);
    ChemData = zeros(size(XimrotateX(DataAll.map(SelectedMap).values,handles.rotateFig),1),size(XimrotateX(DataAll.map(SelectedMap).values,handles.rotateFig),2),NbMaps);
    ChemNames = ListMaps(SelectedMaps);
    
    for i=1:NbMaps
        if SelectedPhase > 1
            AAfficher = MaskFile(MaskSelected).Mask == SelectedPhase-1;
            ChemData(:,:,i) = XimrotateX(DataAll.map(SelectedMaps(i)).values,handles.rotateFig) .* XimrotateX(AAfficher,handles.rotateFig);
        else
            ChemData(:,:,i) = XimrotateX(DataAll.map(SelectedMaps(i)).values,handles.rotateFig);
        end
        
    end
    
end

if QUANTI
    SelectedMap = get(handles.QUppmenu1,'Value');
    ListMaps = get(handles.QUppmenu1,'String');
    
    SelectedQuanti = get(handles.QUppmenu2,'Value');
    
    CodeTxt = [12,12];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [SelectedMaps,OK] = listdlg('ListString',ListMaps,'SelectionMode','Multiple','InitialValue',SelectedMap,'Name','XMapTools','PromptString','Select the maps');
    
    if ~OK
        CodeTxt = [12,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    
    QuantiAll = handles.quanti;
    
    NbMaps = length(SelectedMaps);
    ChemData = zeros(size(XimrotateX(QuantiAll(SelectedQuanti).elem(SelectedMap).quanti,handles.rotateFig),1),size(XimrotateX(QuantiAll(SelectedQuanti).elem(SelectedMap).quanti,handles.rotateFig),2),NbMaps);
    ChemNames = ListMaps(SelectedMaps);
    
    for i=1:NbMaps
        ChemData(:,:,i) = XimrotateX(QuantiAll(SelectedQuanti).elem(SelectedMaps(i)).quanti,handles.rotateFig);
    end
    
end

if RESULTS
    SelectedMap = get(handles.REppmenu2,'Value');
    ListMaps = get(handles.REppmenu2,'String');
    
    SelectedResult = get(handles.REppmenu1,'Value')-1;
    
    CodeTxt = [12,12];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [SelectedMaps,OK] = listdlg('ListString',ListMaps,'SelectionMode','Multiple','InitialValue',SelectedMap,'Name','XMapTools','PromptString','Select the maps');
    
    if ~OK
        CodeTxt = [12,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    
    ResultsAll = handles.results;
    
    NbMaps = length(SelectedMaps);
    %keyboard
    Reshaped = reshape(ResultsAll(SelectedResult).values(:,SelectedMap(1)),ResultsAll(SelectedResult).reshape);
    ChemSelMap = XimrotateX(Reshaped,handles.rotateFig);
    ChemData = zeros(size(ChemSelMap,1),size(ChemSelMap,2),NbMaps);
    ChemNames = ListMaps(SelectedMaps);
    
    for i=1:NbMaps
        ChemData(:,:,i) = XimrotateX(reshape(ResultsAll(SelectedResult).values(:,SelectedMaps(i)),ResultsAll(SelectedResult).reshape),handles.rotateFig);
    end
    
end


return


% #########################################################################
%     SAMPLING MULTI FUNCTION (V3.0.1)
function Activefigure = SamplingMulti(Type,IdxAll,LesX,LesY,ChemData,ChemNames,ColorMode,SaveFigMode,SaveFileMode,hObject, eventdata,handles)
%

axes(handles.axes1)
CMap = colormap;

warning('off','all')


if SaveFileMode

    switch Type
        case 1 
            TypeName = 'Path';
        case 2
            TypeName = 'Line';
        case 3
            TypeName = 'Area';        
    end
    
    DateStr = char(datestr(now));
    DateStr(find(DateStr == ' ')) = '_';

    ProjectName = [TypeName,'_',DateStr];
    for i=1:length(ProjectName)
        if isequal(ProjectName(i),':')
            ProjectName(i) = '-';
        end
    end

    ProjectName = char(inputdlg({'Sampling Project Name'},'XMapTools',1,{ProjectName}));

    if ~length(ProjectName)
        CodeTxt = [12,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end

    [Success,Message,MessageID] = mkdir('Exported-Sampling');
    cd Exported-Sampling
    [Success,Message,MessageID] = mkdir(char(ProjectName));
    cd(char(ProjectName))

    Path2Save = [cd,'/'];
    
    cd ..
    cd ..
    
end



if isequal(Type,2) || isequal(Type,1)
    
    % Calculate the distances (2.6.1)
    Distances = zeros(size(IdxAll,1),1);
    for i=2:size(IdxAll,1)
        Distances(i) = Distances(i-1)+sqrt((LesX(i)-LesX(i-1))^2+(LesY(i)-LesY(i-1))^2);
    end
    
    TheProfils = zeros(size(IdxAll,1),size(ChemData,3)+1);
    TheProfils(:,1) = Distances;
    
    for i=2:size(ChemData,3)+1
        for j=1:size(IdxAll,1)
            TheProfils(j,i) = ChemData(IdxAll(j,2),IdxAll(j,1),i-1);
        end
        
    end
    
    WhereZeros = find(TheProfils(:) == 0);
    TheProfils(WhereZeros) = NaN(size(WhereZeros));
    
    % Random color codes for the figures... There are always all differents
    Colorcodes(:,1) = randperm(size(ChemData,3))/size(ChemData,3);
    Colorcodes(:,2) = randperm(size(ChemData,3))/size(ChemData,3);
    Colorcodes(:,3) = randperm(size(ChemData,3))/size(ChemData,3);
    
    if ~SaveFigMode
        figure, hold on
        for i = 1:size(ChemData,3)
            plot([1:size(IdxAll,1)],TheProfils(:,i+1),'o-','Color',Colorcodes(i,:))
        end
        legend(ChemNames,'Location','Best')
        xlabel('Distance (in pixel)');
        ylabel('Y');
        set(gca,'YScale','Linear');
        
        Activefigure = gcf;
        
    else
        % Generate and save the individual plots
        
        XmapWaitBar(0, handles);
        for i=1:size(ChemData,3)
            XmapWaitBar(i/(size(ChemData,3)+3),  handles);
            figure(666), hold on
            
            set(gca,'YScale','Linear');
            
            plot(Distances,TheProfils(:,i+1),'-k')
            
            % New XMapTools 2.6.1
            %plot(LesData(:,2),LesData(:,3),'-k')
            if ColorMode
                scatter(Distances,TheProfils(:,i+1),[],TheProfils(:,i+1),'filled')
                colorbar vertical
                colormap(CMap)
                %caxis(CLim)
            else
                plot(Distances,TheProfils(:,i+1),'ok','MarkerFaceColor','w')
            end
            axis auto
            xlabel('Distance (in pixel)');
            ylabel(char(ChemNames{i}));
            
            title(char(ChemNames{i}));
            
            drawnow
            saveas(gcf,[Path2Save,'lin_',char(ChemNames{i})],'fig');
            saveas(gcf,[Path2Save,'lin_',char(ChemNames{i})],'pdf');
            
            set(gca,'YScale','Log');
            AxVal = axis;
            AxVal(3) = 0;
            if isreal(AxVal(1)) && isreal(AxVal(2)) && isreal(10^floor(log10(min(TheProfils(:,i+1))))) && isreal(10^ceil(log10(max(TheProfils(:,i+1)))))
                axis([AxVal(1:2),10^floor(log10(min(TheProfils(:,i+1)))),10^ceil(log10(max(TheProfils(:,i+1))))]);
            else
                %keyboard
            end
            
            drawnow
            saveas(gcf,[Path2Save,'log_',char(ChemNames{i})],'fig');
            saveas(gcf,[Path2Save,'log_',char(ChemNames{i})],'pdf');
            
            cla
        end
        close(666)
        
        XmapWaitBar((i+1)/(size(ChemData,3)+3), handles);
        figure, hold on
        for i = 1:size(ChemData,3)
            plot([1:size(IdxAll,1)],TheProfils(:,i+1),'o-','Color',Colorcodes(i,:))
        end
        legend(ChemNames)
        xlabel('Distance (in pixel)');
        set(gca,'YScale','Linear');
        
        Activefigure = gcf;
        
        saveas(gcf,[Path2Save,'ALL_lin'],'fig');
        saveas(gcf,[Path2Save,'ALL_lin'],'pdf');
        
        XmapWaitBar((i+2)/(size(ChemData,3)+3), handles);
        h = figure; 
        hold on
        for i = 1:size(ChemData,3)
            plot([1:size(IdxAll,1)],TheProfils(:,i+1),'o-','Color',Colorcodes(i,:))
        end
        legend(ChemNames)
        xlabel('Distance (in pixel)');
        
        set(gca,'YScale','Log');
        AxVal = axis;
        AxVal(3) = 0;
        axis(AxVal)
        
        saveas(h,[Path2Save,'ALL_log'],'fig');
        saveas(h,[Path2Save,'ALL_log'],'pdf');
        close(h);
        
        save([Path2Save,'Data.txt'], 'TheProfils', '-ASCII');
        
        
        DoSaveTheFigure(strcat(Path2Save,'_map.txt'),hObject, eventdata, handles);
        %WouldYouLike2SaveTheFigure('Export-Line_XXX',hObject, eventdata, handles);

        
    end
    
    XmapWaitBar(1, handles);
    
end
 

if isequal(Type,3)
    
    if SaveFileMode
        fid = fopen(strcat(Path2Save,'/Data.txt'),'w');
        fprintf(fid,'%s\n','Sampling data exported from XMapTools');
        fprintf(fid,'%s\n',date);
        
        fprintf(fid,'%s\n\n','Sampling mode: Area (multiple maps/areas)');
    end
    
    Area = IdxAll;
    
    AllMean = zeros(length(Area),size(ChemData,3));
    AllStd = zeros(length(Area),size(ChemData,3));
    
    for iArea = 1:length(Area)
    
        %MasqueSel = [];
        LinS = size(ChemData,1);
        ColS = size(ChemData,2);

        MasqueSel = Xpoly2maskX(Area(iArea).Coord(:,1),Area(iArea).Coord(:,2),LinS,ColS);

        %figure, imagesc(MasqueSel), axis image

        LesData = [];
        
        for i=1:size(ChemData,3)

            Selected = ChemData(:,:,i) .* MasqueSel;
            TheSelValues = Selected(find(Selected > 0));

            LesData(i,1) = i;
            LesData(i,2) = mean(TheSelValues);
            LesData(i,3) = std(TheSelValues);
            LesData(i,4)= length(TheSelValues);
            LesData(i,5) = LesData(i,3)/sqrt(LesData(i,4));

        end
        
        if SaveFileMode
            fprintf(fid,'%s\n',['#',num2str(iArea),'  |  Nb pixels = ',num2str(LesData(i,4))]);
            fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n','Ref','Name','Value','StdDev','N','StdErr');
            
            for i = 1:size(LesData,1)
                fprintf(fid,'%.4f\t%s\t%.4f\t%.4f\t%.0f\t%.4f\n',LesData(i,1),ChemNames{i},LesData(i,2),LesData(i,3),LesData(i,4),LesData(i,5));
            end
            fprintf(fid,'\n');
        end
        
        AllMean(iArea,:) = LesData(:,2)';
        AllStd(iArea,:) = LesData(:,3)';
    end
    
    Activefigure = figure;
    Ax = gca;
    hold on
    
    TheColors = lines(size(AllMean,2));
    
    for i = 1:length(Area)
        for j = 1:size(AllMean,2)
            plot(Ax,[i;i],[AllMean(i,j)-AllStd(i,j);AllMean(i,j)+AllStd(i,j)],'-','Color',TheColors(j,:),'HandleVisibility','off')
        end
    end
    
    for i = 1:size(ChemData,3)
        plot(Ax,[1:length(Area)]',AllMean(:,i),'o--','Color',TheColors(i,:),'MarkerFaceColor',TheColors(i,:))
    end
    legend(ChemNames,'Location','best')
    xlabel('Area #');
    set(Ax,'Xlim',[0.75 length(Area)+0.25])
    set(Ax,'XTick',[1:length(Area)])
    
    
    if SaveFileMode
        fclose(fid);
        
        if SaveFigMode
            saveas(Activefigure,strcat(Path2Save,'Data.fig'),'fig');
            %saveas(Activefigure,strcat(Path2Save,'Plot.pdf'),'pdf');
            DoSaveTheFigure(strcat(Path2Save,'Map.txt'),hObject, eventdata, handles);
        end
    end
    
    
    
end

warning('on','all')



return


% #########################################################################
%     SAMPLING INTEGRATED PROFILS - EXTRACT DATA (NEW 3.0.1)
function [MatrixProfils,Distances] = ExtractMatrixProfils(Data,X4,Y4,X6,Y6,X7,Y7)
%

[lesXOri,lesYOri] = LineCoordinate(round([X6,Y6]),round([X4,Y4]),size(Data));
[lesXref,lesYref] = LineCoordinate(round([X6,Y6]),round([X7,Y7]),size(Data));

MatrixProfils = zeros(length(lesXref),length(lesXOri));  % lines = profils % col = Exp

for i=1:length(lesXOri)
    
    DeltaX = lesXOri(1)-lesXOri(i);
    DeltaY = lesYOri(1)-lesYOri(i);
    
    lesX = lesXref - DeltaX;
    lesY = lesYref - DeltaY;
    
    lesX = round(lesX);
    lesY = round(lesY);
    
    for j=1:length(lesY)
        
        if lesX(j) >= 1 && lesY(j) >= 1 && lesY(j) <= size(Data,1) && lesX(j) <= size(Data,2)
            MatrixProfils(j,i) = Data(lesY(j),lesX(j));
        else
            MatrixProfils(j,i) = NaN;
        end
    end
    
    %NbOK = length(find(lesX>0 & lesY>0));  
end


% Calculate the distances
dX = lesX(2) - lesX(1);
dY = lesY(2) - lesY(1);

Dist2Steps = sqrt(dX^2+dY^2);
Distances = Dist2Steps*([0:1:length(lesX)-1]);


return


% #########################################################################
%     SAMPLING INTEGRATED PROFILS - PLOT DATA (NEW 3.0.1)
function [TheMean,TheMedian,TheStd,FractPer,FiguresH] = plotMatrixProfils(MatrixProfils,Distances,Name,Save,PathSave,CloseFig,handles)
%

TheMean = zeros(1,size(MatrixProfils,1));
TheMedian = zeros(1,size(MatrixProfils,1));
TheStd = zeros(1,size(MatrixProfils,1));
for i=1:size(MatrixProfils,1)
    WhereValues = find(MatrixProfils(i,:) > 1e-19); 
    TheMean(i) = mean(MatrixProfils(i,WhereValues));
    TheMedian(i) = median(MatrixProfils(i,WhereValues));
    TheStd(i) = std(MatrixProfils(i,WhereValues));
end

Nb = zeros(1,size(MatrixProfils,1));
for i=1:size(MatrixProfils,1)
    Nb(i) = length(find(MatrixProfils(i,:)>1e-19));
end
FractPer = Nb/size(MatrixProfils,2)*100;

% This has to be done later tp avoir NaN in the computatin of the mean
WhereZero = find(MatrixProfils(:) < 1e-19); 
MatrixProfils(WhereZero) = nan(size(WhereZero)); 


FiguresH(1) = figure; 
subplot(2,1,2)
plot(Distances,FractPer,'-k','linewidth',1);
ylabel('Fraction of pixels used (%)') % label right y-axis
xlabel('Distance (pixel)') % label x-axis        
title(['Fraction of Pixels - ',datestr(clock)])

subplot(2,1,1)
plot(repmat(Distances',1,size(MatrixProfils,2)),MatrixProfils,'color', [0.5 0.5 0.5]);
hold on
plot(Distances,TheMedian,'-b','linewidth',2);
plot(Distances,TheMean,'-r','linewidth',2);
box on
ylabel(Name) % label right y-axis
xlabel('Distance (pixel)') % label x-axis
title(['All (gray) | Mean (red) | Median (blue)']) 

if Save
    %
    saveas(gcf,[PathSave,'/',Name,'_All.fig']);
    saveas(gcf,[PathSave,'/',Name,'_All.pdf']);
    
end
if CloseFig
    close(gcf);
end

FiguresH(2) = figure; hold on
fill([Distances,fliplr(Distances)],[TheMean-TheStd,fliplr(TheMean+TheStd)],[0.8 0.8 0.8])
plot(Distances,TheMean,'-k','linewidth',2);
plot(Distances,TheMean+TheStd,'-k','linewidth',1);
plot(Distances,TheMean-TheStd,'-k','linewidth',1);
box on
ylabel(Name) % label right y-axis
xlabel('Distance (pixel)') % label x-axis
title(['Mean & Standard Deviation - ',datestr(clock)]) 

if Save
    %
    saveas(gcf,[PathSave,'/',Name,'_Mean.fig']);
    saveas(gcf,[PathSave,'/',Name,'_Mean.pdf']);
end
if CloseFig
    close(gcf);
end

return


% #########################################################################
%     SAMPLING SLIDING WINDOW - EXTRACT DATA (NEW 3.0.1)
function [LesData] = ExtractSLidingWindowProfils(Data,XStepsPlot,XSteps,YSteps,XSemiL,YSemiL,hObject, eventdata, handles)

XmapWaitBar(0,  handles);

NbSegments = length(XStepsPlot)-1;

ComptRes = 0;
DistTrav = 0;
for iSeg = 1:NbSegments
    
    XCenter = XSteps(iSeg);
    XEnd = XSteps(iSeg+1);
    YCenter = YSteps(iSeg);
    YEnd = YSteps(iSeg+1);
    
    % New 3.0.1
    Distance = sqrt((XEnd-XCenter)^2+(YEnd-YCenter)^2);
    
    NbSteps = floor(Distance);  % This is fine at ? 1?m and the real distance is re-calculated below
    
    % dX,dY
    dX = (max([XCenter,XEnd])-min([XCenter,XEnd]))/(NbSteps-1);
    if XCenter > XEnd
        dX = -dX;
    end
    
    dY = (max([YCenter,YEnd])-min([YCenter,YEnd]))/(NbSteps-1);
    if YCenter > YEnd
        dY = -dY;
    end
    
    XTemp = XCenter;
    YTemp = YCenter;
    
    if isequal(iSeg,1)
        TheMinInc = 1;
    else
        TheMinInc = 2;
    end
    
    XmapWaitBar(0, handles);
    ComptWB = 0;
    for i=TheMinInc:NbSteps
        
        
        
        
        if i>1
            XTemp = XTemp+dX;
            YTemp = YTemp+dY;
        end
        
        XCoord = [XTemp-XSemiL,XTemp+XSemiL,XTemp+XSemiL,XTemp-XSemiL];
        YCoord = [YTemp-YSemiL,YTemp-YSemiL,YTemp+YSemiL,YTemp+YSemiL];
        
        [XTempPlot,YTempPlot] = CoordinatesFromRef(XTemp,YTemp,handles);
        [XCoordPlot,YCoordPlot] = CoordinatesFromRef(XCoord,YCoord,handles);
        
        ComptWB = ComptWB+1;
        if ComptWB > 5
            ComptWB = 0;
            XmapWaitBar(i/NbSteps, handles);
            
            axes(handles.axes1)
            plot(XCoordPlot,YCoordPlot,'.k')
            drawnow
        end
        %
        
        [LinS,ColS] = size(handles.data.map(1).values);  % Original size not the rotated one (25.08.16)
        MasqueSel = Xpoly2maskX(XCoord,YCoord,LinS,ColS);
        
        % And now we apply the rotation to the mask...
        MasqueSel = XimrotateX(MasqueSel,handles.rotateFig);
        
        %             figure(1)
        %             imagesc(MasqueSel), axis image
        %             drawnow
        %             pause(0.5)
        
        Selected = Data .* MasqueSel;
        
        TheSelValues = Selected(find(Selected > 0));
        
        ComptRes = ComptRes+1;
        DistTrav = DistTrav + sqrt(dX^2+dY^2);
        
        LesData(ComptRes,1) = ComptRes;
        LesData(ComptRes,2) = DistTrav;
        LesData(ComptRes,3) = mean(TheSelValues);
        LesData(ComptRes,4) = std(TheSelValues);
        %LesData(ComptRes,5) = std(TheSelValues)/(length(TheSelValues)-1); %Std error
        
    end
    
end

XmapWaitBar(1, handles);

axes(handles.axes1);
plot([XCoordPlot(1),XCoordPlot(4)],[YCoordPlot(1),YCoordPlot(4)],'-m','linewidth',2), plot([XCoordPlot(1),XCoordPlot(4)],[YCoordPlot(1),YCoordPlot(4)],'-k','linewidth',1)
plot([XCoordPlot(1),XCoordPlot(2)],[YCoordPlot(1),YCoordPlot(2)],'-m','linewidth',2), plot([XCoordPlot(1),XCoordPlot(2)],[YCoordPlot(1),YCoordPlot(2)],'-k','linewidth',1)
plot([XCoordPlot(3),XCoordPlot(4)],[YCoordPlot(3),YCoordPlot(4)],'-m','linewidth',2), plot([XCoordPlot(3),XCoordPlot(4)],[YCoordPlot(3),YCoordPlot(4)],'-k','linewidth',1)
plot([XCoordPlot(3),XCoordPlot(2)],[YCoordPlot(3),YCoordPlot(2)],'-m','linewidth',2), plot([XCoordPlot(3),XCoordPlot(2)],[YCoordPlot(3),YCoordPlot(2)],'-k','linewidth',1)
 
return



function [hFig] = PlotSlidingWindowProfile(Name,LesData,Save,PathSave,CloseFig,handles)


hFig = figure; hold on
fill([LesData(:,2)',fliplr(LesData(:,2)')],[LesData(:,3)'-LesData(:,4)',fliplr(LesData(:,3)'+LesData(:,4)')],[0.8 0.8 0.8])
plot(LesData(:,2),LesData(:,3),'.-k','linewidth',1), hold on
%plot(LesData(:,2),LesData(:,3)+LesData(:,4),'--k','linewidth',1)
%plot(LesData(:,2),LesData(:,3)-LesData(:,4),'--k','linewidth',1)

xlabel('Distance (px)')
ylabel(Name);

title(['Mean (sliding window) +/- 1 sigma ']) 

if Save
    saveas(hFig,[PathSave,'/',Name,'_All.fig']);
    saveas(hFig,[PathSave,'/',Name,'_All.pdf']);
end
if CloseFig
    close(hFig);
end

return




% #########################################################################
%     UNUSED ----- SAMPLING RECTANGLE (V2.1.4)
function BUsampling4_Callback(hObject, eventdata, handles)
%

% Define plot and extract the rectangle
[FinalData,Coords] = SelectRectangleIntegration(hObject, eventdata, handles);

if isempty(FinalData)
    return
end

TheMean = zeros(1,size(FinalData,1));
TheMedian = zeros(1,size(FinalData,1));
TheStd = zeros(1,size(FinalData,1));
for i=1:size(FinalData,1)
    TheMean(i) = mean(FinalData(i,find(FinalData(i,:)>1e-19)));
    TheMedian(i) = median(FinalData(i,find(FinalData(i,:)>1e-19)));
    TheStd(i) = std(FinalData(i,find(FinalData(i,:)>1e-19)));
end

Nb = zeros(1,size(FinalData,1));
for i=1:size(FinalData,1)
    Nb(i) = length(find(FinalData(i,:)>1e-19));
end
FractPer = Nb/size(FinalData,2)*100;

% if handles.MatlabVersion>=7.14
%     MenuChoice = menuX('What would you like to display?','[1] Mean + All','[2] Mean only','[3] Median + All','[4] Median only','[5] Mean + Median + All','[6] Mean + Median','[7] All only');
% else
%     MenuChoice = menu('What would you like to display?','[1] Mean + All','[2] Mean only','[3] Median + All','[4] Median only','[5] Mean + Median + All','[6] Mean + Median','[7] All only');
% end

% New Menu Alice Vho - 6.07.2017
MenuChoice = Menu_XMT({'What would you like to display?'},{'[1] Mean + All','[2] Mean only','[3] Median + All','[4] Median only','[5] Mean + Median + All','[6] Mean + Median','[7] All only'},handles.LocBase);


Compt = 0;
TheLeg = '';

figure, hold on
switch MenuChoice
    case {1,3,5,7} % we plot all
        for i=1:size(FinalData,2)
            plot(FinalData(:,i), 'color', [0.5 0.5 0.5])
        end
        Compt = Compt+1;
        TheLeg = [TheLeg,' All (gray) |'];
        
end

switch MenuChoice
    case {1,2,5,6} % mean
        plot(TheMean,'-r','linewidth',2);
        %plot(TheMean+TheStd,'-r','linewidth',1);
        %plot(TheMean-TheStd,'-r','linewidth',1);
        Compt = Compt+1;
        TheLeg = [TheLeg,' Mean (red) |'];
        
end

switch MenuChoice
    case {3,4,5,6}
        plot(TheMedian,'-b','linewidth',2);
        Compt = Compt+1;
        TheLeg = [TheLeg,' Median (blue) |'];
end


xlabel('Length');
ylabel('Value');
title([' XMapTools - ',datestr(clock),' ',TheLeg(1:end-1)])


ButtonName = questdlg('Would you like to plot the fraction of pixels used?', 'Sampling', 'Yes');

switch ButtonName
    case 'Yes'
        
        figure, hold on
        plot(FractPer,'--k','linewidth',2);
        
        ylabel('% of pixels used') % label right y-axis
        xlabel('Length') % label x-axis
        
        title(['XMapTools - ',datestr(clock)])
end


ButtonName = questdlg('Would you like to save the results? (ASCII file)', 'Sampling', 'Yes');

switch ButtonName
    case 'Yes'
        
        CodeTxt = [12,7];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);
        
        [Success,Message,MessageID] = mkdir('Exported-Sampling');
        
        cd Exported-Sampling
        [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export results as');
        cd ..
        
        if ~Directory
            CodeTxt = [12,8];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            a = gca;
            axes(handles.axes1)
            %zoom on
            axes(a)
            
            %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(8))]);
            return
        end
        
        fid = fopen(strcat(pathname,Directory),'w');
        fprintf(fid,'%s\n','Sampling from XMapTools');
        fprintf(fid,'%s\n',date);
        fprintf(fid,'%s\n','Method: Integrated Area');
        fprintf(fid,'%s\n\n','Columns: Mean | Median | Std | %Pixels');
        
        for i = 1:length(TheMean(:))
            fprintf(fid,'%12.8f\t%12.8f\t%12.8f\t%12.8f\n',[TheMean(i),TheMedian(i),TheStd(i),FractPer(i)]);
        end
        %12.8
        %fprintf(fid,'\n\n');
        %fprintf(fid,'%s\n\n','Raw Data');
        %fwrite(fid,FinalData,'int');
        
        fprintf(fid,'\n');
        fclose(fid);
        
        CodeTxt = [12,9];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        
        WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
        
end


%figure,
%plot(Nb,'-r','linewidth',2)

return


% #########################################################################
%     UNUSED ----- SELECT RECTANGLE TO INTEGRATE (V2.1.1)
function [FinalData,Coords] = SelectRectangleIntegration(hObject, eventdata, handles)
%

FinalData = [];
Coords = [];

% Recuperer les data
axes(handles.axes1)
%axis image
lesInd = get(handles.axes1,'child');

% On extrait l'image...
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            Data = get(lesInd(i),'CData');
        end
    end
end

switch get(handles.CheckLogColormap,'Value')
    case 1
        Data = exp(Data);
end

if length(Data(1,:)) > 700
    Decal(1) = 20;
elseif length(Data(1,:)) > 400
    Decal(1) = 10;
else
    Decal(1) = 5;
end

if length(Data(:,1)) > 700
    Decal(2) = 20;
elseif length(Data(:,1)) > 400
    Decal(2) = 10;
else
    Decal(2) = 5;
end

for i=1:2
    if i ==1
        CodeTxt = [12,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(3))]);
    else
        CodeTxt = [12,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(4))]);
    end
    [Xref,Yref,Clique] = XginputX(1,handles);
    [X(i),Y(i)] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
    
    if Clique == 3
        CodeTxt = [12,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    
    X(i) = round(X(i));
    Y(i) = round(Y(i));
    
    % A horizontal line crashes the code so the line can't be horizontal !!!
    if i==2
        if X(2) == X(1)
            X(2) = X(2)+1;
        end
        if Y(2) == Y(1)
            Y(2) = Y(2)+1;
        end
    end
    
    axes(handles.axes1)
    leTxt = text(X(i)-Decal(1),Y(i)-Decal(2),num2str(i));
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
    hold on, plot(X(i),Y(i),'o','MarkerEdgeColor','r','MarkerFaceColor','w')
end


X1 = X(1);
X2 = X(2);
Y1 = Y(1);
Y2 = Y(2);

% Coordinate of the line P1-P2
[lesXP1P2,lesYP1P2] = LineCoordinate(round([X1,Y1]),round([X2,Y2]),size(Data));
Coords = [lesXP1P2,lesYP1P2];

% Calculate details regarding the area
a1 = (Y2-Y1)/(X2-X1);
b1 = Y2 - a1*X2;

% line 2 / point 1
a2 = -1/a1;
b2 = Y1 - a2*X1;

% line 3 / point 2
a3 = a2;
b3 = Y2 - a2*X2;


% Plot the Map and the line again !!!
plot(X,Y,'-m','linewidth',2);
plot(X,Y,'-k','linewidth',1);

x=1:size(Data,2);
yi2 = a2*x+b2;
yi3 = a3*x+b3;

[MaxY,MaxX] = size(Data);
LesQuels2 = find(x(:)>=1 & x(:)<=MaxX & yi2(:)>=1 & yi2(:)<=MaxY);
LesQuels3 = find(x(:)>=1 & x(:)<=MaxX & yi3(:)>=1 & yi3(:)<=MaxY);

plot(x(LesQuels2),yi2(LesQuels2),'-m');
plot(x(LesQuels3),yi3(LesQuels3),'-m');


CodeTxt = [12,10];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% Select the tird point
[Xref,Yref,Clique] = XginputX(1,handles);
[X3,Y3] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
X3 = round(X3);
Y3 = round(Y3);


if Clique == 3
    CodeTxt = [12,6];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end


%plot(X3,Y3,'o','MarkerEdgeColor','r','MarkerFaceColor','w')


% Line 4 / with point3
a4 = a1;
b4 = Y3 - a4*X3;

%plot(x,a4*x+b4,'-m');

% Point 4 (intersection of L4 and L2)
X4 = (b4-b2)/(a2-a4);
Y4 = a2*X4 + b2;

%plot(X4,Y4,'o','MarkerEdgeColor','r','MarkerFaceColor','w')

% Point 5 (intersection of L4 and L3)
X5 = (b4-b3)/(a3-a4);
Y5 = a3*X5 + b3;

%plot(X5,Y5,'o','MarkerEdgeColor','r','MarkerFaceColor','w')


% Point 6
X6 = X1 - (X4-X1);
Y6 = Y1 - (Y4-Y1);

%plot(X6,Y6,'o','MarkerEdgeColor','r','MarkerFaceColor','w')

% Point 7
X7 = X2 - (X5-X2);
Y7 = Y2 - (Y5-Y2);

%plot(X7,Y7,'o','MarkerEdgeColor','r','MarkerFaceColor','w')

% Line 5
a5 = a1;
b5 = Y7 - a5*X7;

%plot(x,a5*x+b5,'-m');

yi4 = a4*x+b4;
yi5 = a5*x+b5;

LesQuels4 = find(x(:)>=1 & x(:)<=MaxX & yi4(:)>=1 & yi4(:)<=MaxY);
LesQuels5 = find(x(:)>=1 & x(:)<=MaxX & yi5(:)>=1 & yi5(:)<=MaxY);

% Figure Update                                                 (new 2.1.3)
plot(x(LesQuels4),yi4(LesQuels4),'-m');
plot(x(LesQuels5),yi5(LesQuels5),'-m');

%plot([X4,X5],[Y4,Y5],'-m');
%plot([X6,X7],[Y6,Y7],'-m');


[lesXOri,lesYOri] = LineCoordinate(round([X6,Y6]),round([X4,Y4]),size(Data));
[lesXref,lesYref] = LineCoordinate(round([X6,Y6]),round([X7,Y7]),size(Data));

DataPr = zeros(length(lesXref),length(lesXOri));  % lines = profils % col = Exp

%figure,
%hold on
%h = gca;

for i=1:length(lesXOri)
    
    DeltaX = lesXOri(1)-lesXOri(i);
    DeltaY = lesYOri(1)-lesYOri(i);
    
    lesX = lesXref - DeltaX;
    lesY = lesYref - DeltaY;
    
    lesX = round(lesX);
    lesY = round(lesY);
    
    for j=1:length(lesY)
        
        if lesX(j) >= 1 && lesY(j) >= 1 && lesY(j) <= size(Data,1) && lesX(j) <= size(Data,2)
            DataPr(j,i) = Data(lesY(j),lesX(j));
        else
            DataPr(j,i) = NaN;
        end
    end
    
    NbOK = length(find(lesX>0 & lesY>0));
    
    %axes(h)
    
    %plot(DataPr(:,i),'-b')
    
    %axes(handles.axes1)
    %plot(lesXref-DeltaX,lesYref-DeltaY,'-k');
    %pause(0.5)
    
    
end

%axes(h)

FinalData = DataPr;
%keyboard



return


% #########################################################################
%     GET COORDINATES OF LINE (V2.1.1)
function [lesX,lesY] = LineCoordinate(A,B,MapSize)
%

X = [A(1),B(1)];
Y = [A(2),B(2)];

LX = max(X) - min(X);
LY = max(Y) - min(Y);

LZ = round(sqrt(LX^2 + LY^2));

if X(2) > X(1)
    LesX = X(1):(X(2)-X(1))/(LZ-1):X(2);
elseif X(2) < X(1)
    LesX = X(1):-(X(1)-X(2))/(LZ-1):X(2);
else
    LesX = ones(LZ,1) * X(1);
end

if Y(2) > Y(1)
    LesY = Y(1):(Y(2)-Y(1))/(LZ-1):Y(2);
elseif Y(2) < Y(1)
    LesY = Y(1):-(Y(1)-Y(2))/(LZ-1):Y(2);
else
    LesY = ones(LZ,1) * Y(1);
end


XCoo = 1:1:MapSize(2);
YCoo = 1:1:MapSize(1);

for i = 1 : length(LesX)
    [V(i,1), IdxAll(i,1)] = min(abs(XCoo-LesX(i))); % Index X
    [V(i,2), IdxAll(i,2)] = min(abs(YCoo-LesY(i))); % Index Y
    
    
    if V(i,1) > 1 && IdxAll(i,1) < 2
        IdxAll(i,1) = 1-abs(V(i,1));
    end
    
    if V(i,2) > 1 && IdxAll(i,2) < 2
        IdxAll(i,2) = 1-abs(V(i,2));
    end
    
    
    if V(i,2) > 1 && IdxAll(i,2) > 2      % Y
        IdxAll(i,2) = MapSize(1)+abs(V(i,2));
    end
    
    if V(i,1) > 1 && IdxAll(i,1) > 2
        IdxAll(i,1) = MapSize(2)+abs(V(i,1));
    end
    
end

lesX = IdxAll(:,1);
lesY = IdxAll(:,2);
return


% #########################################################################
%     SIZE OF THE AXES1 WINDOW (NEW V2.1.1)
function ButtonWindowSize_Callback(hObject, eventdata, handles)
if handles.PositionAxeWindowValue == 1
    handles.PositionAxeWindowValue = 2;
elseif handles.PositionAxeWindowValue == 2
    handles.PositionAxeWindowValue = 3;
else
    handles.PositionAxeWindowValue = 1;
end
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%     NEW HISTOGRAM MODE (NEW V2.1.1)
function ButtonFigureMode_Callback(hObject, eventdata, handles)
%
if handles.HistogramMode == 0   % we plot the histogram and save the map
    
    % Recuperer les data
    axes(handles.axes1)
    
    lesInd = get(handles.axes1,'child');
    
    % On extrait l'image...
    for i=1:length(lesInd)
        leType = get(lesInd(i),'Type');
        if length(leType) == 5
            if leType == 'image';
                Data = get(lesInd(i),'CData');
            end
        end
    end
    
    switch get(handles.CheckLogColormap,'Value')
        case 1
            Data = exp(Data);
    end
    
    TheMin = str2num(get(handles.ColorMin,'String'));
    TheMax = str2num(get(handles.ColorMax,'String'));
    
    TheDataSet = Data(find(Data(:) > TheMin & Data(:) < TheMax));
    
    hold off, cla(handles.axes2)
    
    axes(handles.axes2)
    [nelements,centers] = hist(TheDataSet,30);
    hist(Data(find(Data(:) > TheMin & Data(:) < TheMax)),30);
    
    %     switch get(handles.CheckLogColormap,'Value')
    %         case 1
    %             set(gca,'XScale','log');
    %     end
    
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
    
    % Probability density function
    
    R = (max(TheDataSet)-min(TheDataSet))/150;
    xi=min(TheDataSet):R:max(TheDataSet);
    
    NbSimul = 50;
    TheNb = length(TheDataSet);
    TheOriginalDataSet = TheDataSet;
    TheFinalDataSet = zeros(NbSimul*length(TheOriginalDataSet),1);
    
    First = 1;
    End = First+TheNb-1;
    
    XmapWaitBar(0,  handles);
    
    for i=1:NbSimul
        TheFinalDataSet(First:End) = TheOriginalDataSet+randn*(TheOriginalDataSet.*(1./sqrt(TheOriginalDataSet)));
        First = End;
        End = First+TheNb-1;
    end
    
    XmapWaitBar(0.2,  handles);
    
    TheFinalDataSet = TheFinalDataSet(find(TheFinalDataSet(:) > TheMin & TheFinalDataSet(:) < TheMax));
    
    XmapWaitBar(0.5, handles);
    
    N = hist(TheFinalDataSet,xi);
    
    XmapWaitBar(0.9, handles);
    
    axes(handles.axes3)
    plot(xi,N,'-','linewidth',3);
    set(handles.axes3,'XTickLabel','', 'ytick',[]);
    set(handles.axes3,'Xlim',get(handles.axes2,'Xlim'));
    
    %     switch get(handles.CheckLogColormap,'Value')
    %         case 1
    %             set(gca,'XScale','log');
    %     end
    
    XmapWaitBar(1, handles);
    
    
    handles.HistogramMode = 1;
    
    
    
    
    
else % we retablish the map
    
    handles.HistogramMode = 0;
    
end


guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
GraphStyle(hObject, eventdata, handles);
return




% -------------------------------------------------------------------------
% 2.2) VER_XMapTools_804 SETTINGS OPTIONS
% -------------------------------------------------------------------------

% #########################################################################
%    BUTTON DISPLAY SETTINGS WINDOW (NEW 2.1.1)
function ButtonSettings_Callback(hObject, eventdata, handles)
%

WhatDoWeDo = handles.OptionPanelDisp;

switch WhatDoWeDo
    case 0
        set(handles.UiPanelOptions,'visible','on');
        handles.OptionPanelDisp = 1;
        %axes(handles.axes1), zoom off
        
        handles.CorrectionMode = 1;
        guidata(hObject, handles);
        OnEstOu(hObject, eventdata, handles)
        
        set(handles.uipanel59,'visible','off');
        set(handles.TxtControl,'Visible','off');
        
    case 1
        set(handles.UiPanelOptions,'visible','off');
        handles.OptionPanelDisp = 0;
        %axes(handles.axes1), zoom on
        set(handles.uipanel59,'visible','on');
        
        OnAffiche = get(handles.DisplayComments,'Value');
        if OnAffiche
            set(handles.TxtControl,'Visible','on');
        end
        
        handles.CorrectionMode = 0;
        guidata(hObject, handles);
        OnEstOu(hObject, eventdata, handles)
end


return


% #########################################################################
%    BUTTON SAVE DEFAULT SETTINGS (NEW 2.1.1)
function ButtonSaveSettings_Callback(hObject, eventdata, handles)
%
Default_XMaptools = zeros(20,1);

Default_XMapTools(1) = get(handles.DisplayComments,'Value');
Default_XMapTools(2) = get(handles.ActivateDiary,'Value');
Default_XMapTools(3) = get(handles.DisplayActions,'Value');
Default_XMapTools(4) = get(handles.DisplayCoordinates,'Value');

Default_XMapTools(5) = get(handles.PopUpColormap,'Value');
Default_XMapTools(6) = get(handles.CheckLogColormap,'Value');
Default_XMapTools(7) = str2num(get(handles.EditColorDef,'String'));

Default_XMapTools(8) = get(handles.CheckInverseColormap,'Value');

Default_XMapTools(9) = get(handles.SettingsAddCLowerCheck,'Value');
Default_XMapTools(10) = get(handles.SettingsAddCLowerMenu,'Value');
Default_XMapTools(11) = get(handles.SettingsAddCUpperCheck,'Value');
Default_XMapTools(12) = get(handles.SettingsAddCUpperMenu,'Value');

save([handles.LocBase,'/Default_XMapTools.mat'],'Default_XMapTools');

CodeTxt = [3,4];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

ButtonSettings_Callback(hObject, eventdata, handles)
return


% #########################################################################
%    BUTTON APPLY SETTINGS (NEW 3.0.1)
function ButtonApplySettings_Callback(hObject, eventdata, handles)
ButtonSettings_Callback(hObject, eventdata, handles)
return

% #########################################################################
%    BUTTON DISPLAY ADMIN WINDOW (NEW 2.1.3)
function ADMINbutton1_Callback(hObject, eventdata, handles)
%

WhatDoWeDo = handles.AdminPanelDisp;

switch WhatDoWeDo
    case 0
        set(handles.UiPanelAdmin,'visible','on');
        handles.AdminPanelDisp = 1;
        axes(handles.axes1), zoom off
    case 1
        set(handles.UiPanelAdmin,'visible','off');
        handles.AdminPanelDisp = 0;
        axes(handles.axes1), zoom on
end

guidata(hObject, handles);

return


% #########################################################################
%     BUTTON DISPLAY COMMENT V1.4.1
function DisplayComments_Callback(hObject, eventdata, handles)
OnAffiche = get(handles.DisplayComments,'Value');

if OnAffiche
    set(handles.TxtControl,'Visible','on')
else
    set(handles.TxtControl,'Visible','off ')
end

guidata(hObject,handles);


% #########################################################################
%     SETTINGS - ACTIVATE DIARY (NEW V2.1.1)
function ActivateDiary_Callback(hObject, eventdata, handles)
%
warn = warndlg({'In order to apply this setting, you must', ...
    '(1) Save the default settings', ...
    '(2) Save your project', ...
    '(3) Restart XMapTools ...'},'XMapTools warning');

return


% #########################################################################
%     SETTINGS - DISPLAY ACTIONS (NEW V2.1.1)
function DisplayActions_Callback(hObject, eventdata, handles)
return


% #########################################################################
%     SETTINGS - DISPLAY COORDINATES (NEW V2.1.1)
function DisplayCoordinates_Callback(hObject, eventdata, handles)
return


% #########################################################################
%     SETTINGS - COLORMAP CHOICE (NEW V2.1.1)
function PopUpColormap_Callback(hObject, eventdata, handles)
%

TheSelected = get(handles.PopUpColormap,'Value');
set(handles.PopUpColormap_LEFT,'Value',TheSelected);
guidata(hObject,handles);

handles = XMapColorbar('Last',1,handles);
guidata(hObject,handles);
return


% #########################################################################
%     SETTINGS - LOG SCALE FOR PLOT (NEW 2.5.1)
function CheckLogColormap_Callback(hObject, eventdata, handles)
%

Value = get(handles.CheckLogColormap,'Value');
set(handles.CheckLogColormap_LEFT,'Value',Value);
guidata(hObject,handles);

if get(handles.OPT1,'Value')
    PPMenu1_Callback(hObject, eventdata, handles)
elseif get(handles.OPT2,'Value')
    QUppmenu1_Callback(hObject, eventdata, handles)
else
    REppmenu2_Callback(hObject, eventdata, handles)
end

return


% #########################################################################
%     SETTINGS - COLOR SCALE FOR PLOT (NEW 2.5.1)
function EditColorDef_Callback(hObject, eventdata, handles)
%
handles = XMapColorbar('Auto',1,handles);
guidata(hObject,handles);
return


% --- Executes on selection change in PopUpColormap_LEFT.
function PopUpColormap_LEFT_Callback(hObject, eventdata, handles)
% 

TheSelected = get(handles.PopUpColormap_LEFT,'Value');
set(handles.PopUpColormap,'Value',TheSelected);
guidata(hObject,handles);

handles = XMapColorbar('Last',1,handles);
guidata(hObject,handles);
return


% --- Executes on button press in CheckLogColormap_LEFT.
function CheckLogColormap_LEFT_Callback(hObject, eventdata, handles)
%
Value = get(handles.CheckLogColormap_LEFT,'Value');
set(handles.CheckLogColormap,'Value',Value);
guidata(hObject,handles);

CheckLogColormap_Callback(hObject, eventdata, handles);
return


% --- Executes on button press in CheckInverseColormap.
function CheckInverseColormap_Callback(hObject, eventdata, handles)
%
CheckLogColormap_Callback(hObject, eventdata, handles);
return


% --- Executes on selection change in SettingsAddCLowerMenu.
function SettingsAddCLowerMenu_Callback(hObject, eventdata, handles)
%
handles = XMapColorbar('Auto',1,handles);
guidata(hObject,handles);
return

% --- Executes on button press in SettingsAddCLowerCheck.
function SettingsAddCLowerCheck_Callback(hObject, eventdata, handles)
%

set(handles.checkbox1,'Value',get(handles.SettingsAddCLowerCheck,'Value'));
handles = XMapColorbar('Auto',1,handles);
guidata(hObject,handles);
return


% --- Executes on button press in SettingsAddCUpperCheck.
function SettingsAddCUpperCheck_Callback(hObject, eventdata, handles)
%

set(handles.checkbox7,'Value',get(handles.SettingsAddCUpperCheck,'Value'));
handles = XMapColorbar('Auto',1,handles);
guidata(hObject,handles);
return

% --- Executes on selection change in SettingsAddCUpperMenu.
function SettingsAddCUpperMenu_Callback(hObject, eventdata, handles)
%
handles = XMapColorbar('Auto',1,handles);
guidata(hObject,handles);
return




% -------------------------------------------------------------------------
% 3) PROJECT FUNCTIONS
% -------------------------------------------------------------------------
% goto project

% #########################################################################
%     OPEN BACKUP V2.1.3
function Button2_Callback(hObject, eventdata, handles)

CodeTxt = [1,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',handles.TxtDatabase(1).txt(1));

[filename, pathname] = uigetfile('*.mat', 'Select a project');

if ~filename
    CodeTxt = [1,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end


[handles] = FixDirectoryIssues(pathname(1:end-1), hObject, eventdata, handles);

% % New 2.6.2
% WhereWeAre = cd;
% 
% if ~isequal(pathname(1:end-1),WhereWeAre)
% 
%     %Answer = questdlg({'You are trying to open a project in an other directory; this is not recommended as XMapTools will automatically generate files related to this project in a wrong place...','Would you like XMapTools to change your working directory?'},'WARNING','Yes','No (not recommended)','Cancel','Yes');
%     
%     Answer = 'Yes';  % New XMapTools 3.3.1
%     
%     switch Answer
%         
%         case 'No (not recommended)'
%             
%             Answer2 = questdlg('By clicking YES I acknowledge the fact that I ignored a good advice to avoid a mess!','Warning','Yes','Cancel (last chance)','Yes');
%             
%             switch Answer2
%                 case 'Cancel (last chance)'
%                     
%                     CodeTxt = [1,4];
%                     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%                     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%                     return
%             end
%             
%             %BOBA
%         
%         
%         case 'Cancel'
%             
%             CodeTxt = [1,4];
%             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%             return
%             
%             
%             
%         case 'Yes'
%             cd(pathname(1:end-1));
%             
%             disp(['Note: the working directory has been set to: ',char(pathname(1:end-1))]);
%             disp(' ')
%         
%     end
%     
% end

% Check the file size (3.3.1)
s=dir([pathname,filename]); 

CodeTxt = [1,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),num2str(s.bytes/1e6,'%.2f'),' MB - loading can take some time :)']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

if filename
    ProjectPath = strcat(pathname,filename);
else
    ProjectPath = '';
end

XMapTools_LoadProject(hObject, eventdata, handles, ProjectPath, filename);
return


% #########################################################################
%     FUNCTION LOAD PROJECT V2.5.2
function XMapTools_LoadProject(hObject, eventdata, handles, ProjectPath, filename)
set(gcf, 'WindowButtonMotionFcn', '');

Failure = 0;

XmapWaitBar(0, handles);
drawnow
pause(0.25)

% set(handles.TxtControl,'String',handles.TxtDatabase(1).txt(2));
XmapWaitBar(0.35, handles);
drawnow
pause(0.25)

% In case this file is not a XMapTools project...
handlesOri = handles;
hObjectOri = hObject;
eventdataOri = eventdata;

if filename
    load(ProjectPath,'');
else
    CodeTxt = [1,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',handles.TxtDatabase(1).txt(4));
    disp('loading a project ... (No file selected) ... CANCELATION'); disp(' ')
    XmapWaitBar(1, handles);
    return
end

if ~exist('Data','var')
    handles = handlesOri;
    hObject = hObjectOri;
    eventdata = eventdataOri;
    
    XmapWaitBar(1, handles);
    
    CodeTxt = [1,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',handles.TxtDatabase(1).txt(4));
    disp('loading a project ... (Not a valid project) ... CANCELATION'); disp(' ')
    
    warndlg('This file is not a valid XMapTools project', 'XMapTools');
    return
end

% New 2.5.2
if ~exist('XMapTools_Settings','var')
    handles.rotateFig = 0;
else
    % New settings 
    handles.rotateFig = XMapTools_Settings.rotateFig;
end

disp(['loading a project ... (',filename,') ... ']), disp(' ')

XmapWaitBar(0.90, handles);

handles.currentdisplay = 1; % Input change
handles = AffOPT(1, hObject, eventdata, handles);

set(handles.QUppmenu2,'Value',1); % Input Change
set(handles.REppmenu1,'Value',1); % Input Change

set(handles.FIGbutton1,'Value',0);

set(handles.PPMenu1,'string',ListMap);
set(handles.PPMenu1,'Value',1)

% -----------------------------
% Data (Update REFs):                                             New 2.1.5
for i=1:length(Data.map(:))
    
    % Changed 2.3.2 -> the program always check the database and update the
    % refs...
    % If .ref does not exist the program will create it (not tested)
    
    %if ~isfield(Data.map(i),'ref')
    Data.map(i).ref = find(ismember(handles.NameMaps.elements,char(Data.map(i).name)));
    %end
    
    % Changed 2.5.1 -> Check the type of map to take into account EDS maps
    if isempty(Data.map(i).ref)
        % Search for EDS map
        for j = 1:length(handles.NameMaps.elements)
            EDS_Names{j} = char([handles.NameMaps.elements{j},'_EDS']);
        end
        
        Data.map(i).ref = find(ismember(EDS_Names,char(Data.map(i).name)));
        
        if isempty(Data.map(i).ref)
            Data.map(i).ref = 0;
            
            disp(['WARNING: ',Data.map(i).name,' was not found in the database; This map cannot be standardized!'])
            disp(' ')
            Failure = 1;
        end
    end
end

% -----------------------------
% List of mask files:
Compt = 1; Ok=0;
for i=1:length(MaskFile)
    if MaskFile(i).type >= 1
        ListMaskFile(Compt) = MaskFile(i).Name;
        Ok=1;
        Compt = Compt+1;
    end
end
if Ok
    set(handles.PPMenu3,'String', ListMaskFile);
    set(handles.PPMenu3,'Value',1);
    
    set(handles.LeftMenuMaskFile,'String', ListMaskFile);
    set(handles.LeftMenuMaskFile,'Value',1);
    
    NameMinerals = MaskFile(1).NameMinerals;
    set(handles.PPMenu2,'String',NameMinerals)
end

% -----------------------------
% Corrections:
if exist('Corrections','var')
    % New backup 2.1.1 and latest releases
    if Corrections(1).value ==1
        set(handles.CorrButtonBRC,'Enable','on');
    end
    
    % Here define the strategy for the second correction
    
else
    Corrections(1).name = 'BRC';
    Corrections(1).value = 0;
    %
    Corrections(2).name = 'TRC';
    Corrections(2).value = 0;
end

% -----------------------------
% Profils:
if size(Profils,1) == 1
    set(handles.PRAffichage1,'String',Profils.display);
end

% -----------------------------
% Quanti
if length(Quanti) > 1
    for i=1:length(Quanti)
        NameMinQuanti{i} = char(Quanti(i).mineral);
    end
    set(handles.QUppmenu2,'String',NameMinQuanti);
    set(handles.QUppmenu2,'Value',1);
end

%set(handles.QUppmenu1,'String',Quanti(Onlit).listname);

% Update for density-corrected
if ~isfield(Quanti,'isoxide')
    Quanti(1).isoxide = [];
    if length(Quanti) > 1
        for i=2:length(Quanti)
            Quanti(i).isoxide = 1;
        end
    end
end

% UPDATE for compatibility with XMAPTOOLS 2.3.2
if length(Quanti) > 1
    
    % we chek if an update is needed
    Test = Quanti(2).elem;
    
    if ~isfield(Test,'StandardizationType')
        
        % All the Quanti must be updated...
        
        for LaBonnePlace = 2:length(Quanti)
            for i = 1:length(Quanti(LaBonnePlace).elem)
                
                % We cannot recalculate them as we don't know if the
                % profils data are the good ones.
                
                Quanti(LaBonnePlace).elem(i).Ox = [];
                Quanti(LaBonnePlace).elem(i).Ra = [];
                
                Quanti(LaBonnePlace).elem(i).Selected = [];
                Quanti(LaBonnePlace).elem(i).RaUnc = [];
                
                Quanti(LaBonnePlace).elem(i).plotX = [];
                Quanti(LaBonnePlace).elem(i).plotY = [];
                
                Quanti(LaBonnePlace).elem(i).plotXi = [];
                
                Quanti(LaBonnePlace).elem(i).BackgroundResiduals = [];
                Quanti(LaBonnePlace).elem(i).BackgroundResidualsFirstSol = [];
                Quanti(LaBonnePlace).elem(i).BackgroundResidualsBestSol = [];
                
                Quanti(LaBonnePlace).elem(i).BackgroundValue = [];
                
                Quanti(LaBonnePlace).elem(i).Standardization = [];
                Quanti(LaBonnePlace).elem(i).StandardizationType = [];
                
            end
        end
    end
end



% -----------------------------
% Results
if length(Results)>=1
    ListTher(1) = {'none'};
    for i=1:length(Results)
        ListTher(i+1) = Results(i).method;
    end
    
    Onest = length(ListTher);
    
    set(handles.REppmenu1,'String',ListTher);
    set(handles.REppmenu1,'Value',1);
    
end

% -----------------------------
% loading:
handles.project = filename;
handles.save = 1;
handles.data = Data;
handles.ListMap = ListMap;
handles.corrections = Corrections;
handles.MaskFile = MaskFile;
handles.profils = Profils;
handles.quanti = Quanti;
handles.results = Results;


CodeTxt = [1,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(filename),' ',char(handles.TxtDatabase(1).txt(3))])
XmapWaitBar(1, handles);

if Failure
    disp(['loading a project ... (',filename,') ... WARNING, see above']); disp(' ')
else
    disp(['loading a project ... (',filename,') ... Ok']); disp(' ')
end
disp([' ########## The active project is : ',filename,' ##########'])
disp(' ')
set(handles.TextProjet,'String',filename);


% NEW VARIABLES TEST

% 1.6.2 PointSelected
if length(Profils) > 0
    if ~myIsField(handles,'pointselected')
        handles.profils.pointselected = ones(size(handles.profils.coord,1),1);
    end
end


guidata(hObject,handles);

% PLOT 

handles = XPlot(Data.map(1).values,hObject, eventdata, handles);

% Read and save the default values for the zoom!
handles = ReadZoomValue(handles);

guidata(hObject,handles);

% Display coordinates new 1.5.4 (11/2012)
%set(gcf, 'WindowButtonMotionFcn', @mouseMove);    % in the end we wait for handles saved first...

%guidata(hObject,handles);
%OnEstOu(hObject, eventdata, handles);
%set(handles.axes1,'xtick',[], 'ytick',[]);
%GraphStyle(hObject, eventdata, handles)
return


% #########################################################################
%     SAVE V3.0.1
function Button3_Callback(hObject, eventdata, handles)
set(gcf, 'WindowButtonMotionFcn', '');

% Activate the correction mode
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);

Onsave = handles.save;
if ~isfield(handles,'project')
    Onsave = 0;
end

CodeTxt = [2,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[handles.TxtDatabase(2).txt(1)])
XmapWaitBar(0, handles);
drawnow
XmapWaitBar(0.1, handles);

% On recupere les variables a sauvegarder :
Data = handles.data;
MaskFile = handles.MaskFile;
ListMap = handles.ListMap;
Corrections = handles.corrections;
Profils = handles.profils;
Quanti = handles.quanti;
Results = handles.results;

% New settings 
XMapTools_Settings.rotateFig = handles.rotateFig;


%keyboard

if Onsave == 1
    XmapWaitBar(0.25, handles);
    % Sauvegarde n + 1;
    Directory = handles.project;
    save(Directory,'Directory','Data','ListMap','Corrections','MaskFile','Profils','Quanti','Results','XMapTools_Settings','-v7.3');
    disp(['Saving current project ... (',Directory,') ... Ok']), disp(' ')
else
    % On propose une sauvegarde
    CodeTxt = [2,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[handles.TxtDatabase(2).txt(2)])
    drawnow
    
    [Directory, pathname] = uiputfile({'*.mat', 'MATLAB File (*.mat)'}, 'Save the project as');
    if Directory
        XmapWaitBar(0.25,  handles);
        save(strcat(pathname,Directory),'Directory','Data','ListMap','Corrections','MaskFile','Profils','Quanti','Results','XMapTools_Settings','-v7.3');
        disp(['Saving a new project ... (',Directory,') ... Ok']), disp(' ')
        disp([' * * * * * * * * The active project is : ',Directory,' * * * * * * * *']), disp(' ')
        set(handles.TextProjet,'String',Directory);
    else
        CodeTxt = [2,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[handles.TxtDatabase(2).txt(4)])

        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
end

XmapWaitBar(0.95, handles);
handles.project = Directory;
handles.save = 1;

h = clock;
XmapWaitBar(1, handles);

CodeTxt = [2,3];
set(handles.TxtControl,'String',[char(Directory),' ',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',num2str(h(4)),'h',num2str(h(5)),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(Directory),' ',char(handles.TxtDatabase(2).txt(3)),' (',num2str(h(4)),'h',num2str(h(5)),')']);
handles.CorrectionMode = 0;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

set(gcf, 'WindowButtonMotionFcn', @mouseMove);
guidata(hObject,handles);
return


% #########################################################################
%     SAVE AS ... V1.6.1
function Button5_Callback(hObject, eventdata, handles)
set(gcf, 'WindowButtonMotionFcn', '');

Onsave = handles.save;

Data = handles.data;
MaskFile = handles.MaskFile;
ListMap = handles.ListMap;
Corrections = handles.corrections;
Profils = handles.profils;
Quanti = handles.quanti;
Results = handles.results;

% New settings
XMapTools_Settings.rotateFig = handles.rotateFig;

CodeTxt = [2,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[handles.TxtDatabase(2).txt(2)])
drawnow


[Directory, pathname] = uiputfile({'*.mat', 'MATLAB File (*.mat)'}, 'Save the project as');
if Directory
    XmapWaitBar(0.3, handles);
    save(strcat(pathname,Directory),'Directory','Data','ListMap','Corrections','MaskFile','Profils','Quanti','Results','XMapTools_Settings','-v7.3');
    disp(['Saving a new project ... (',Directory,') ... Ok']), disp(' ')
    disp([' * * * * * * * * The active project is : ',Directory,' * * * * * * * *']), disp(' ')
    set(handles.TextProjet,'String',Directory); % updated 1.6.1 (P. Lanari)
else
    CodeTxt = [2,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[handles.TxtDatabase(2).txt(4)])
    return
end

handles.project = Directory;
handles.save = 1;
XmapWaitBar(0.9,handles);

h = clock;
XmapWaitBar(1,handles);

CodeTxt = [2,3];
set(handles.TxtControl,'String',[char(Directory),' ',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',num2str(h(4)),'h',num2str(h(5)),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[char(Directory),' ',char(handles.TxtDatabase(2).txt(3)),' (',num2str(h(4)),'h',num2str(h(5)),')']);

set(gcf, 'WindowButtonMotionFcn', @mouseMove);
guidata(hObject,handles);
return


% #########################################################################
%     NEW V1.5.1
function Button1_Callback(hObject, eventdata, handles)

close all % end of program.
XMapTools % new XmapTool

return


% #########################################################################
%     EXIT V1.5.1
function Button4_Callback(hObject, eventdata, handles)
%

close all
return


% #########################################################################
%     EXIT                                                          V 2.1.3
function XMapToolsGUI_CloseRequestFcn(hObject, eventdata, handles)
%

if handles.update == 1
    delete(gcf);
    return
end

OnPropose = 1;

data = handles.data;
if length(data.map) == 1 && data.map(1).type == 0% type=0 ON EST ICI
    OnPropose = 0;
end


if OnPropose
    ButtonName = questdlg('Do you want to save the current XMapTools session?', ...
        'XMapTools', ...
        'Yes','No','Cancel','No');
    
    drawnow; pause(0.05);  % this innocent line prevents the Matlab hang
    
    switch ButtonName
        case 'Yes'
            % execute la fonction de sauvegarde
            Button3_Callback(hObject, eventdata, handles);
        case 'Cancel'
            % Alors on annule la fermeture
            return
    end
    % Pas de case No bien sur...
end

% New 1.6.2 delete the favorite paths...
fid = fopen('XMT_Config.txt');
LocBase = char(fgetl(fid)); % main directory of xmap tools
fclose(fid);
% Addpath:
FunctionPath = strcat(LocBase,'/Functions');
rmpath(FunctionPath);
ModulesPath = strcat(LocBase,'/Modules');
rmpath(ModulesPath);
ModulesPath = strcat(LocBase,'/Dev');
rmpath(ModulesPath);

if length(handles.Addons)
    for i=1:length(handles.Addons)
        rmpath(handles.Addons(i).path);
    end
end

if exist(strcat(LocBase(1:end-7),'/UserFiles')) == 7        % test if the directory exists
    FunctionPath = strcat(LocBase(1:end-7),'/UserFiles');
    rmpath(FunctionPath);
end

Date = clock;
disp('-----------------------------')
disp([num2str(Date(3)),'/',num2str(Date(2)),'/',num2str(Date(1)),' ',num2str(Date(4)),'h',num2str(Date(5)),'''',num2str(round(Date(6))),''''''])
disp(' ');
disp('-- END OF EXECUTION (Exit) --')
disp(' ')

if handles.diary
    diary off
end

handles.update = 1;
guidata(hObject,handles);

% (Old comment: This works with MATLAB 2014b)

% try close(gcf); catch, end     % commented 02.05.2019 PL because of
                                 % warning when using the close button
delete(gcf);
close all force
return



% -------------------------------------------------------------------------
% 4) XRAY FUNCTIONS
% -------------------------------------------------------------------------
% goto xray

% #########################################################################
%     ADD A NEW MAP. (V2.3.1)
function MButton1_Callback(hObject, eventdata, handles)
NameMaps = handles.NameMaps.filename;
AffNameMaps = handles.NameMaps.elements;
References = handles.NameMaps.ref;

Data = handles.data;

% Changes for associated menus
handles.currentdisplay = 1; % Input change
set(handles.QUppmenu2,'Value',1); % Input Change
set(handles.REppmenu1,'Value',1); % Input Change

set(handles.FIGbutton1,'Value',0);

CodeTxt = [5,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[FileName,PathName,FilterIndex] = uigetfile({'*.txt;*.asc;*.dat;*.csv;','Map Files (*.txt, *.asc, *.dat, *.csv)';'*.*',  'All Files (*.*)'},'Pick map file(s)','MultiSelect', 'on');

if ~FilterIndex
    CodeTxt = [5,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(5).txt(2))]);
    drawnow
    return
end
if length(char(FileName(1))) > 1
    NMaps = length(FileName);
else
    NMaps = 1;
end

ButtonName = 'Yes';
%questdlg('Do you want to use the automated indexation?', ...
%    'Add new map(s)', ...
%    'Yes', 'No', 'Cancel', 'No');

switch ButtonName
    case 'Yes'
        UseAutoIndex = 1;
        
    case 'No'
        UseAutoIndex = 0;
        
    case 'Cancel'
        CodeTxt = [5,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        return
end

set(gcf, 'WindowButtonMotionFcn', '');

WeHaveMapSize = 0;
for i=1:NMaps % version 1.4.1
    
    XmapWaitBar(0,handles);
    
    % pre-selection :
    if NMaps == 1
        Name = char(FileName(1:end-4)); % end-4 pour l'extension
        NameExt = char(FileName);
    else
        NameExt = char(FileName(i));
        Name = char(NameExt(1:end-4));
    end
    
    % Detect the type of map (new 2.3.1 - December, 2015)
    %
    %   -----------------------------------------------
    %    FileName    Description             Variable
    %   -----------------------------------------------
    %    Si.txt      WDS map         ->      Si
    %    _Si.txt     EDS map         ->      Si_EDS
    %    *-Si.txt    Bkg(-) map      ->      not added
    %    *+Si.txt    Bkg(+) map      ->      not added
    %   -----------------------------------------------
    %
    
    TheCode = Name(1);
    TypeOfMap=0;
    
    switch TheCode
        case '_'   % EDS
            
            TypeOfMap = 2;
            NameForIndex = Name(2:end);
            
        case '*'   % BACKGROUND
            
            TypeOfMap = 4;
            
            if isequal(Name(2),'-');
                Bck = 0; % left
            elseif isequal(Name(2),'+')
                Bck = 1; % right
            else
                warndlg(['The background map ',char(Name),' is not recognized by XMapTools'],'Invalid Filename');
                
                CodeTxt = [5,7];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                return
                
            end
            
            NameForIndex = Name(3:end);
            
        otherwise  % WDS
            
            if length(Name) < 3
                TypeOfMap = 1;
            else
                TypeOfMap = 3;  % Oxide + BSE, no deadtime correction
            end
            
            NameForIndex = Name;
            
    end
    
    WhereMap = 0;
    
    if isequal(TypeOfMap,1) || isequal(TypeOfMap,2) || isequal(TypeOfMap,3) || isequal(TypeOfMap,4)
        WhereMap = find(ismember(AffNameMaps,NameForIndex));
        if ~length(WhereMap)
            WhereMap = find(ismember(NameMaps,NameForIndex));
        end
    end
    
    % Indexation to generate variables Selection and Ok
    
    CodeTxt = [5,1];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(NameExt),' (',char(num2str(i)),'/',char(num2str(NMaps)),')']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    drawnow
    
    if isequal(length(WhereMap),0)
        % Map not recognized ...
        
        XmapWaitBar(1,handles);
        
        Reply = questdlg('XMapTools does not recognized the element','Add new map(s)','Manual Selection','Cancel','Manual Selection');
        
        if isequal(Reply,'Cancel')
            
            CodeTxt = [5,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        %         CodeTxt = [5,1];
        %         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(NameExt),' (',char(num2str(i)),'/',char(num2str(NMaps)),')']);
        %         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %
        %         % set(handles.TxtControl,'String',[char(handles.TxtDatabase(5).txt(1)),' ',char(NameExt),' (',char(num2str(i)),'/',char(num2str(NMaps)),')']);
        %         drawnow
        %XmapWaitBar(1,handles);
        %drawnow
        
        [Selection,OK] = listdlg('promptstring','Select a name','selectionmode','single','liststring',AffNameMaps);
        
    else
        
        if UseAutoIndex
            Selection = WhereMap;
            OK = 1;
            
        else
            [Selection,OK] = listdlg('promptstring','Select a name','selectionmode','single','liststring',AffNameMaps,'initialvalue',WhereMap);
        end
    end
    
    
    if OK == 0
        CodeTxt = [5,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(5).txt(2))]);
        drawnow
        return
    end
    
    if ~UseAutoIndex
        CodeTxt = [5,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        drawnow
    end
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(5).txt(3))]);
    XmapWaitBar(0.35,handles);
    
    %loading - we now check for errors new 2.6.1 
    try
        NewMap = load([PathName,NameExt]);   % updated 1.6 (P. Lanari)
    catch ME
        errordlg({'This file is not a valid map file: ',char(NameExt)},'Error XMapTools')
        
        CodeTxt = [5,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        XmapWaitBar(1, handles);
        
        return
    end
    
    
    
    % Check for the size ...
    if isequal(size(NewMap,1),1) || isequal(size(NewMap,2),1)
        if ~WeHaveMapSize
            % ask for mapsize
            CodeTxt = [5,6];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            MapSizeString = inputdlg({'rows (Y)','columns (X)'},'Size of the map');
            if ~length(MapSizeString)
                CodeTxt = [5,2];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            end
            
            for kk=1:length(MapSizeString)
                InputMapSizeVEC(kk) = str2num(char(MapSizeString(kk)));
            end
            
            if ~isequal(InputMapSizeVEC(1)*InputMapSizeVEC(2),length(NewMap(:)))
                CodeTxt = [5,2];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                warndlg('The size of rows*columns does not match the size of the map','Cancelation');
                return
            end
            WeHaveMapSize = 1;
        end
        
        NewMap = reshape(NewMap,InputMapSizeVEC(1),InputMapSizeVEC(2));
    end
    
    XmapWaitBar(0.70, handles);
    
    % The dead time correction has been removed in the version 2.3.1
    % Use the Import Tool to apply a dead-time correction
    if isequal(TypeOfMap,1) || isequal(TypeOfMap,2)
        % Dead time correction (see De Andrade, 2006 phd)
        
        %NewMapCorr = NewMap./(1 - (0.3e-6) .* NewMap);
        NewMapCorr = NewMap;
        
    else
        NewMapCorr = NewMap;
    end
    
    NewName = AffNameMaps(Selection);
    switch TypeOfMap
        case 2
            NewName = [char(NewName),'_EDS'];
        case 4
            if isequal(Bck,0)
                NewName = [char(NewName),'_BCK-'];
            else
                NewName = [char(NewName),'_BCK+'];
            end
    end
    
    NewRef = References(Selection);
    
    XmapWaitBar(0.99, handles);
    
    DataTempNMap(i).NewMapCorr = NewMapCorr;
    DataTempNMap(i).NewMap = NewMap;
    DataTempNMap(i).SelMap = NewMapCorr; % temporary with deadtime ...
    DataTempNMap(i).NewName = NewName;
    DataTempNMap(i).NewRef = NewRef;
    DataTempNMap(i).NewTYPE = TypeOfMap;
    
    XmapWaitBar(1, handles);
    
end

PositionXMapTools = get(gcf,'Position');

% Import Tool (new 2.3.1):
DataTempNMap = XMTImportTool(DataTempNMap,handles.LocBase,handles.activecolorbar,PositionXMapTools);
%return

% Add new maps to Data

nMapsloaded = length(Data.map);
if nMapsloaded == 1;
    if Data.map(1).type
        OnEcritFrom = 2; % On a une carte
    else
        OnEcritFrom = 1; % on a zeros cartes
    end
else
    OnEcritFrom = nMapsloaded + 1; % on a n cartes
end

Concat='';
for i=1:NMaps
    OnEcritici = OnEcritFrom + i - 1; % et oui i)1 = 1;
    
    Concat =strcat(Concat,char(DataTempNMap(i).NewName),'-');
    
    Data.map(OnEcritici).type = DataTempNMap(i).NewTYPE;
    Data.map(OnEcritici).name = DataTempNMap(i).NewName; % Name
    Data.map(OnEcritici).values = DataTempNMap(i).SelMap; % data selected before
    Data.map(OnEcritici).ref = DataTempNMap(i).NewRef; % for element reference.
    Data.map(OnEcritici).corr = [round(mean(DataTempNMap(i).NewMap(:))),round(mean(DataTempNMap(i).NewMapCorr(:)))];
    
end
Concat = char(Concat);
ConcatF = Concat(1:end-1);

% Update LIST for display
Compt = 1;
for i=1:length(Data.map(:))
    if Data.map(i).type > 0
        ListMap{Compt} = char(Data.map(i).name);
        Compt = Compt + 1;
    end
end

set(handles.PPMenu1,'string',ListMap);
set(handles.PPMenu1,'Value',OnEcritici) % derni?re map charg?e

handles.data = Data; % send
handles.ListMap = ListMap;


% PLOT
guidata(hObject,handles);
PPMenu1_Callback(hObject, eventdata, handles);

% Read and save the default values for the zoom!
handles = ReadZoomValue(handles);
guidata(hObject,handles);


if NMaps == 1
    CodeTxt = [5,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(ConcatF),')']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(5).txt(4)),' (',char(ConcatF),')']);
else
    CodeTxt = [5,5];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(ConcatF),')']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(5).txt(5)),' (',char(ConcatF),')']);
end
drawnow

% ancienne version d'affichage
% disp(['Adding ... (Raw data: ',char(FileName),') ... ']);
% disp(['Adding ... (Element: ',char(NewName),') ']);
% disp(['Adding ... (Average Intensity: ',num2str(round(mean(NewMap(:)))),' before timeout correction)']);
% disp(['Adding ... (Average Intensity: ',num2str(round(mean(NewMapCorr(:)))),' after timeout correction)']);
% disp(['Adding ... (Raw data: ',char(FileName),') ... Ok']);
% disp(' ');

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%     DELETE THE SELECTED MAP (V1.6.2)
function MButton2_Callback(hObject, eventdata, handles)
ListMap = handles.ListMap;
Data = handles.data;

% Changes for associated menus
handles.currentdisplay = 1; % Input change
set(handles.QUppmenu2,'Value',1); % Input Change
set(handles.REppmenu1,'Value',1); % Input Change

set(handles.FIGbutton1,'Value',0);

Delete = get(handles.PPMenu1,'Value');
DelList = get(handles.PPMenu1,'String');
DelName = DelList(Delete);

if Delete == 1 % On enleve la premiere map
    for k = 1:length(ListMap) - 1
        NewData.map(k) = Data.map(k+1);
        NewListMap(k) = ListMap(k+1);
    end
end
if Delete > 1 && Delete < length(ListMap)
    NewListMap(1:Delete-1) = ListMap(1:Delete-1);
    for k = 1:Delete
        NewData.map(k) = Data.map(k);
        NewListMap(k) = ListMap(k);
    end
    for k = Delete:length(ListMap)-1
        NewData.map(k) = Data.map(k+1);
        NewListMap(k) = ListMap(k+1);
    end
end
if Delete == length(ListMap)
    for k = 1:length(ListMap) - 1
        NewData.map(k) = Data.map(k);
        NewListMap(k) = ListMap(k);
    end
    %     Old version
    %     Data.map(Delete).type = 0;
    %     Data.map(Delete).name = {};
    % 	Data.map(Delete).values = [];
    %     NewListMap = ListMap(1:Delete-1);
end


set(handles.PPMenu1,'Value',1);
set(handles.PPMenu1,'String',NewListMap);

handles.ListMap = NewListMap;
handles.data = NewData;


% cla(handles.axes1,'reset');
guidata(hObject,handles);
PPMenu1_Callback(hObject, eventdata, handles)   % New 2.1.1

CodeTxt = [4,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(DelName),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[char(handles.TxtDatabase(4).txt(1)),' (',char(DelName),')'])

disp(['Deleting ... (Raw data: ',char(DelName),') ... Ok']); disp(' ');


guidata(hObject,handles);
%OnEstOu(hObject, eventdata, handles);
%set(handles.axes1,'xtick',[], 'ytick',[]);
%GraphStyle(hObject, eventdata, handles)

PPMenu1_Callback(hObject, eventdata, handles); % 3.3.1
return


% #########################################################################
%     MAPS INFO BOX  (V2.1.1)
function MButton3_Callback(hObject, eventdata, handles)

Value = get(handles.UiPanelMapInfo,'Visible');

if length(char(Value)) < 3 % alors 'on'
    set(handles.UiPanelMapInfo,'Visible','off');
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    zoom on
else
    set(handles.UiPanelMapInfo,'Visible','on');
    set(gcf, 'WindowButtonMotionFcn', '');
    zoom off
end

MaskFile = handles.MaskFile;
MaskSelected = get(handles.PPMenu3,'Value');

% Display
Selected = get(handles.PPMenu1,'Value');
Data = handles.data;

DispName = Data.map(Selected).name;
DispRef = Data.map(Selected).ref;
DispSize = size(Data.map(Selected).values);

switch Data.map(Selected).type
    case 1
        DispTypeOfMap = 'X-ray raw data (WDS)';
    case 2
        DispTypeOfMap = 'X-ray raw data (EDS)';
    case 3
        DispTypeOfMap = 'Other type (BSE, SEI, TOPO or Quanti)';
    case 4
        DispTypeOfMap = 'Background Map';
    case 5
        DispTypeOfMap = 'Map created with the Generator';
    otherwise
        DispTypeOfMap = 'UNKNOWN - Contact P. Lanari';
end

% UPDATED 30/04/12 (use the average compositon of the selected mineral)
MineralSelected = get(handles.PPMenu2,'Value');

if MineralSelected < 2
    MatrixData = Data.map(Selected).values(:);
    
    DispMineral = 'not used (all pixels are displayed)';
    
    DispMean = mean(MatrixData);
    DispError = ((2/(sqrt(DispMean)))*100);                  % edited 1.6.2
    DispStd = std(MatrixData);
    DispMin = min(MatrixData);
    DispMax = max(MatrixData);
    
    DispMedian = median(MatrixData);                          % Added 2.1.1
    DispMError = ((2/(sqrt(DispMedian)))*100);
    
else
    RefMin = MineralSelected - 1;
    PourCalcul = MaskFile(MaskSelected).Mask == RefMin;
    
    MatrixData = Data.map(Selected).values(:) .* PourCalcul(:);
    
    DispMineral = MaskFile(MaskSelected).NameMinerals{MineralSelected};
    
    DispMean = mean(MatrixData(find(PourCalcul(:))));
    DispError = ((2/(sqrt(DispMean)))*100);
    DispStd = std(MatrixData(find(PourCalcul(:))));
    DispMin = min(MatrixData(find(PourCalcul(:))));
    DispMax = max(MatrixData(find(PourCalcul(:))));
    
    DispMedian = median(MatrixData(find(PourCalcul(:))));     % Added 2.1.1
    DispMError = ((2/(sqrt(DispMedian)))*100);
    
end

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    FilteredPixels = length(find(handles.corrections(1).mask == 0));
    NbTotal = size(handles.corrections(1).mask,1)*size(handles.corrections(1).mask,2);
    StateCorrectionBRC = ['applied (',num2str(FilteredPixels/NbTotal*100),'% of pixels filtered)'];
else
    StateCorrectionBRC = 'not applied';
end

if handles.corrections(2).value == 1
    % there is a BRC correction available
    StateCorrectionTRC = 'applied';
else
    StateCorrectionTRC = 'not applied';
end

% -> Define the shift variable
if isfield(handles.data.map(Selected),'shift')
    if sum(abs(handles.data.map(Selected).shift))>0
        StateCorrectionMPC = ['applied [',num2str(handles.data.map(Selected).shift(1)),';',num2str(handles.data.map(Selected).shift(2)),']'];
    elseif isequal(length(handles.data.map(Selected).shift),2)
        StateCorrectionMPC = 'not applied [0,0]';
    else
        StateCorrectionMPC = 'not applied';
    end
else
    StateCorrectionMPC = 'not applied';
end


%DispFinal{1} = ['*** RAW DATA DETAILS ***'];
%DispFinal{1} = [' - - - - - - - - -'];
DispFinal{1} = ['* selected map/element: ',char(DispName),'  (ref = ',char(num2str(DispRef)),')'];
DispFinal{end+1} = ['* map type: ',char(DispTypeOfMap)];
DispFinal{end+1} = ['* selected mineral phase: ',char(DispMineral)];
DispFinal{end+1} = [' - - - - - - - - -'];
DispFinal{end+1} = ['* map size: ',char(num2str(DispSize(1))),' rows & ',char(num2str(DispSize(2))),' columns'];
DispFinal{end+1} = [' - - - - - - - - -'];
DispFinal{end+1} = ['* mean intensity = ',char(num2str(DispMean)),' (X-ray Unc. [2sigma] = ',char(num2str(DispError)),' % [1])'];
DispFinal{end+1} = ['* median intensity = ',char(num2str(DispMedian)),' (X-ray Unc. [2sigma] = ',char(num2str(DispMError)),' % [1])'];
DispFinal{end+1} = ['* standard deviation = ',char(num2str(DispStd))];
DispFinal{end+1} = ['* min value = ',char(num2str(DispMin))];
DispFinal{end+1} = ['* max value = ',char(num2str(DispMax))];
DispFinal{end+1} = [' - - - - - - - - -'];
DispFinal{end+1} = ['* BRC correction: ',char(StateCorrectionBRC)];
DispFinal{end+1} = ['* TRC correction: ',char(StateCorrectionTRC)];
DispFinal{end+1} = ['* MPC correction: ',char(StateCorrectionMPC)];
DispFinal{end+1} = [' - - - - - - - - -'];
DispFinal{end+1} = ['[1] Relative Uncertainty (in %) - Poisson distribution (see Lanari et al. 2014, 2018)'];



% mise a jour de la taille
NbLines = length(DispFinal) * 0.25;
MaxFin = 0;
for i=1:length(DispFinal)
    MaxTemp = length(char(DispFinal(i)));
    if MaxTemp > MaxFin
        MaxFin = MaxTemp;
    end
end
NbCol = MaxFin * 0.0055;

VectMod = get(handles.InfosBox,'Position');
VectMod(3:4) = [NbCol,NbLines];
%set(handles.InfosBox,'Position',VectMod);

set(handles.InfosBox,'String',DispFinal,'visible', 'on');

guidata(hObject,handles);
return


% #########################################################################
%  *  CLASSIFICATION: CREATE A NEW MASK SET (V1.6.5)
function MaskButton1_Callback(hObject, eventdata, handles)
Data = handles.data;
MaskFile = handles.MaskFile;
MethodV = get(handles.PPMaskMeth,'Value');
MethodL = get(handles.PPMaskMeth,'String');
Method = MethodL(MethodV);

%Ou est ce que l'on va ajouter ce fichier mask ?
if length(MaskFile) == 1
    if MaskFile(1).type
        OnEcritMaskFile = length(MaskFile) + 1; % fixed bug v1.5
    else
        OnEcritMaskFile = 1;
    end
else
    OnEcritMaskFile = length(MaskFile) + 1; % fixed bug v1.5
end

Selected = get(handles.PPMenu1,'Value');

ListMap = handles.ListMap;


CodeTxt = [7,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(1))]);

AutoSelect = [1:1:length(ListMap)];
[SelectedMap,Ok] = listdlg('ListString',ListMap,'SelectionMode','multiple','Name','Select Maps','InitialValue',AutoSelect);

if length(SelectedMap) < 2   % Added 22/09/2012 P. Lanari (new 1.5.4)
    CodeTxt = [7,4]; % A CHANGER ICI IL FAUT AU MINIMUM DEUX CARTES !!!
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

if Ok == 0
    CodeTxt = [7,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(4))]);
    return
end

ConcatMapName = '';
for i=1:length(SelectedMap)
    SelectedData(i) = Data.map(SelectedMap(i));
    
    % Pour affichage, new 1.5.4 (11/2012)
    ConcatMapName = [ConcatMapName,' ',char(ListMap(SelectedMap(i)))];
    
    % Check the sizes of the maps XMapTools 2.3.2
    SizesMaps(i,:) = size(SelectedData(i).values); 
end

Refsize = SizesMaps(1,:);
DiffSize = zeros(size(SizesMaps,1),1);

for i = 1:size(SizesMaps,1)
    if ~isequal(SizesMaps(i,:),Refsize)
        DiffSize(i) = 1;
    end
end

if sum(DiffSize) > 0
    % There is a problem with the sizes...
    WhereMisMatch = find(DiffSize);
    ConcNames = '';
    for i=1:length(WhereMisMatch)
        ConcNames = [ConcNames,' ',char(SelectedData(WhereMisMatch(i)).name)];
    end
    warndlg({'Error, the classification cannot be done','the follwing map(s) have a different size:',ConcNames(2:end)},'Cancellation');
    
    CodeTxt = [7,10];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

NbdeMaps = length(SelectedMap);

CodeTxt = [7,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(2))]);

% in this version NbdeMap is > 1

% NEW 1.6.5 / Updated 11.11.2018 (2.6.1)
ChoiceMethList = get(handles.PPMaskFrom,'String');
ChoiceMeth = ChoiceMethList{get(handles.PPMaskFrom,'Value')};

% CodeTxt = [7,14];
% set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
% TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%
% [ChoiceMeth,OK] = listdlg('ListString',{'From the Maps (click)','From a file'},'Name','Input pixels');
%
% if ~OK
%     CodeTxt = [7,10];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%     return
% end

switch ChoiceMeth
    case 'File'
        % Update 1.6.5 - New feature - load a file
        
        % - - - Update 2.1.4 - Automatic opening of Classification.txt
        
        if isequal(exist('Classification.txt','file'),2)
            ButtonName = questdlg('Would you like to use Classification.txt?','Classification','Yes');
            switch ButtonName
                case 'Yes'
                    Question = 0;
                    filename = 'Classification.txt';
                otherwise
                    Question = 1;
            end
        else
            Question = 1;
        end
        
        if Question
            [filename, pathname] = uigetfile({'*.txt';'*.*'},'Pick a file');
            
            if ~filename
                CodeTxt = [7,10];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                return
            end
            
            fid = fopen([pathname,filename],'r');
        else
            fid = fopen([filename],'r');
        end
        
        % - - -
        
        NameMinerals(1) = {'none'};
        
        Compt = 0;
        while 1
            LaLign = fgetl(fid);
            
            if isequal(LaLign,-1)
                break
            end
            
            if ~isequal(LaLign,'')
                if length(LaLign) > 1
                    if isequal(LaLign(1:2),'>1')
                        
                        while 1
                            LaLign = fgetl(fid);
                            
                            if isequal(LaLign,-1) || isequal(LaLign,'')
                                break
                            end
                            
                            Compt = Compt+1;
                            LaLignPropre = strread(LaLign,'%s');
                            
                            if ~isequal(length(LaLignPropre),3) 
                                
                                errordlg({['A formatting error has been found in ',filename],['Check line:',LaLign], ...
                                    ' ','The correct format is: PhaseName  X  Y', ...
                                    'Do not add space(s) in the phase name!'},'Error XMapTools')
                                
                                CodeTxt = [7,21];
                                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',filename]);
                                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                                
                                return
                            end
                            
                            
                            NameMinerals{Compt+1} = LaLignPropre{1};
                            
                            
                            X = str2num(LaLignPropre{2});
                            Y = str2num(LaLignPropre{3});
                            
                            [SelPixelX,SelPixelY] = CoordinatesFromRef(X,Y,handles);
                            
                            CenterPixels(Compt,1) = SelPixelX;  % now in display coordinates
                            CenterPixels(Compt,2) = SelPixelY;  % now in display coordinates.
                            
                            % Which is what we would like... Corrected in 2.1.1
                        end
                        
                    end
                end
            end
        end
        
        %keyboard
        axes(handles.axes1); hold on
        plot(CenterPixels(:,1),CenterPixels(:,2), 'mo','linewidth', 2)
        
        NbMask = length(NameMinerals)-1;
        
        
    case 'Selection'   % clicking (old version)
        
        axes(handles.axes1); hold on
        
        clique = 1; ComptMask = 1;
        while clique < 2
            [Xref,Yref,clique] = XginputX(1,handles); % we select the pixel
            [SelPixel(1),SelPixel(2)] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
            % -- Now we are working with the Fig coordinates (For Display)
            if clique < 2
                CenterPixels(ComptMask,:) = round(SelPixel);
                plot(CenterPixels(:,1),CenterPixels(:,2), 'mo','linewidth', 2)
                ComptMask = ComptMask+1;
            end
        end
        NbMask = ComptMask-1;
        
        % --------------------------------------
        % Minerals Name (defaut)
        NameMinerals(1) = {'none'};
        for i=1:NbMask
            TempO = strcat('Mineral',num2str(i));
            NameMinerals(i+1,:) = {TempO};
        end
        
end

CodeTxt = [7,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

if NbMask < 2   % update 1.6.5
    CodeTxt = [7,10];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end


Xfig = CenterPixels(:,1);
Yfig = CenterPixels(:,2);
[Xref,Yref] = CoordinatesFromFig(Xfig,Yfig,handles);   % update 1.6.2 XimrotateX
CenterPixels = [Xref,Yref];
% -- Now we are working with the Ref coordinates (For projection)

Name = inputdlg('Mask file name','define a name',1,{['Meth',num2str(MethodV),'-MaskFile',num2str(OnEcritMaskFile)]});

if length(Name) == 0
    CodeTxt = [7,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(4))]);
    return
end

% Chemic variable creation:
Compt = 1;
for i=1:length(SelectedData(:))
    if Data.map(i).type >= 1
        % it's a raw data map
        Chemic(:,Compt) = SelectedData(i).values(:);
        SizeMap = size(SelectedData(i).values);
        Compt = Compt+1;
    end
end
nPixH = SizeMap(1,2); nPixV = SizeMap(1,1);
NumPixCenter = (CenterPixels(:,1)-1).*nPixV + CenterPixels(:,2);

% Check if the points are in the mapped area (new 2.6.1)
PointsOut = find(CenterPixels(:,1) < 0 | CenterPixels(:,2) < 0 | CenterPixels(:,1) > SizeMap(2) | CenterPixels(:,2) > SizeMap(1)); 
if length(PointsOut)
    
    NameConcat = '';
    for i = 1:length(PointsOut)
        NameConcat = [NameConcat,NameMinerals{PointsOut(i)+1},' '];
    end
    NameConcat = NameConcat(1:end-1);
    
    waitfor(errordlg({'The following standard(s) is/are outside the mapped area:',NameConcat},'XMapTools'))
    
    CodeTxt = [7,22];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),NameConcat]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end


% TEST Display
%figure, imagesc(SelectedData(1).values), axis image, hold on, plot(CenterPixels(:,1),CenterPixels(:,2),'om');

% New 2.5.1
%zoom off
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);


CodeTxt = [7,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',handles.TxtDatabase(7).txt(9));
XmapWaitBar(0, handles);
XmapWaitBar(0.35, handles);
drawnow

% New 1.4.1
DureeCalc = ((SizeMap(1,1) * SizeMap(1,2) * NbMask) * 10^-6 + 0.2126 ) * 3; % secondes  *3 for lag-time...
% estimated using 6 maps between 22880 and 717120 pixels on a MacBook 13';

CodeTxt = [7,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (~ ',char(num2str(round(DureeCalc))),' s)']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(9)),' (~ ',char(num2str(round(DureeCalc))),' s)']);
drawnow

% tic

set(gcf, 'WindowButtonMotionFcn', '');

% METHOD 1 - Classic Computation
if MethodV == 1
    Groups = XkmeansX(Chemic, NbMask, 'start', Chemic(NumPixCenter,:));
    Groups = reshape(Groups, nPixV, nPixH);
end

% METHOD 2 - Normalized intensities
if MethodV == 2
    moyChem = mean(Chemic);
    stdChem = std(Chemic);
    ChemicNorm = (Chemic - ones(nPixV*nPixH,1)*moyChem) ./ (ones(nPixH*nPixV,1)*stdChem);
    
    Groups = XkmeansX(ChemicNorm, NbMask, 'start', ChemicNorm(NumPixCenter,:)); 
    Groups = reshape(Groups, nPixV, nPixH);
end

% New 2.5.1
%zoom on
handles.CorrectionMode = 0;

% toc

XmapWaitBar(0.90, handles);
drawnow


% variables sending:
handles.MaskFile(OnEcritMaskFile).type = 1;
handles.MaskFile(OnEcritMaskFile).Pixels = CenterPixels;
handles.MaskFile(OnEcritMaskFile).Nb = NbMask;
handles.MaskFile(OnEcritMaskFile).Name = Name;
handles.MaskFile(OnEcritMaskFile).Mask = Groups;
handles.MaskFile(OnEcritMaskFile).NameMinerals = NameMinerals;


Compt = 1;
for i=1:length(handles.MaskFile(:))
    if handles.MaskFile(Compt).type == 1
        ListNameMen(Compt) = handles.MaskFile(i).Name;
        Compt = Compt+1;
    end
end
set(handles.PPMenu3,'String',ListNameMen)
set(handles.PPMenu3,'Value',OnEcritMaskFile) % currently selected.

set(handles.LeftMenuMaskFile,'String',ListNameMen)
set(handles.LeftMenuMaskFile,'Value',OnEcritMaskFile) % currently selected.

% --------------------------------------
% Update the menu "Mineral":
set(handles.PPMenu2,'String',NameMinerals)

% Reset zoom (new 2.6.2)
ZoomButtonReset_Callback(hObject, eventdata, handles);

% --------------------------------------
% DISPLAY MASKS
MaskButton2_Callback(hObject, eventdata, handles);

% --------------------------------------
% Statistics:
for i=2:length(NameMinerals)
    Temp4Sum = Groups == i-1;
    NbTot(i-1) = sum(Temp4Sum(:));
end
for i=1:length(NbTot)
    PerTot(i) = NbTot(i)/sum(NbTot)*100;
end

disp(['Mask creating ... (',char(Name),') ...']);
disp(['Mask creating ... (Selected maps: ',char(ConcatMapName),')']);
disp(['Mask creating ... (Nb Masks: ',num2str(NbMask),')']);
for i=1:length(CenterPixels(:,1))
    disp(['Mask creating ... (Selected Pixels: ',char(num2str(i)),' Coordinates: ',char(num2str(CenterPixels(i,1))),'/',char(num2str(CenterPixels(i,2))),'']);
end
disp(['Mask creating ... (Method: ',char(Method),')']);
for i=2:length(NameMinerals)
    disp(['Mask creating ... (Phase: ',num2str(i-1),' name: ',char(NameMinerals(i)),' < ',num2str(PerTot(i-1)),'% >)']);
end
disp(['Mask creating ... (',char(Name),') ... Ok']);
disp(' ');

CodeTxt = [7,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Name),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(5)),' (',char(Name),')']);

XmapWaitBar(1, handles);
drawnow

set(gcf, 'WindowButtonMotionFcn', @mouseMove);

guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%     RENAME MINERALS V1.4.1
function MaskButton3_Callback(hObject, eventdata, handles)
NumMask = get(handles.PPMenu3,'Value'); % MaskGroup selected
MaskFile = handles.MaskFile;

NbMask = MaskFile(NumMask).Nb;
NameList = MaskFile(NumMask).NameMinerals;
AncList = NameList;
Name = MaskFile(NumMask).Name;

MaskButton2_Callback(hObject, eventdata, handles); % dislay the mask map

CodeTxt = [7,6];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(6))]);

for i=1:NbMask, EnTete(i,:) = {'Name:'}; end

OutputInput = inputdlg(EnTete,'Names change',1,NameList(2:end));

if ~length(OutputInput) % V1.4.1
    CodeTxt = [7,10];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

NameList(2:end) = OutputInput;
MaskFile(NumMask).NameMinerals = NameList;

handles.MaskFile = MaskFile;
guidata(hObject,handles);

% Update the list:
set(handles.PPMenu2,'String',NameList)

disp(['Mask editing ... (',char(Name),') ... ']);
for i=2:length(NameList)
    disp(['Mask editing ... (',num2str(i-1),' rename: ',char(AncList(i)),' --> ',char(NameList(i)),')']);
end
disp(['Mask editing ... (',char(Name),') ... Ok']);
disp(' ');

% --------------------------------------
% DISPLAY MASKS
MaskButton2_Callback(hObject, eventdata, handles);


CodeTxt = [7,7];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(7))]);

guidata(hObject,handles);
return


% #########################################################################
%     CHANGE THE MASK FILE V1.4.1
function PPMenu3_Callback(hObject, eventdata, handles)

MaskFile = handles.MaskFile;

OnEstOu = get(handles.PPMenu3,'Value');
Liste = get(handles.PPMenu3,'String');
Name = Liste(OnEstOu);

ListeMin = handles.MaskFile(OnEstOu).NameMinerals;
set(handles.PPMenu2,'String',ListeMin);
set(handles.PPMenu2,'Value',1);

set(handles.LeftMenuMaskFile,'Value',OnEstOu);

CodeTxt = [7,8];
set(handles.TxtControl,'String',[char(Name),' ',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(Name),' ',char(handles.TxtDatabase(7).txt(8))]);
MaskButton2_Callback(hObject, eventdata, handles);


guidata(hObject, handles);
return
% --- Executes during object creation, after setting all properties.

function PPMenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% #########################################################################
%     DELETE THE SELECTED MASK FILE V1.5.4
function MaskButton5_Callback(hObject, eventdata, handles)

% Changes for associated menus
handles.currentdisplay = 1; % Input change
set(handles.QUppmenu2,'Value',1); % Input Change
set(handles.REppmenu1,'Value',1); % Input Change

set(handles.FIGbutton1,'Value',0);

% new function 08/11/2012
MaskFile = handles.MaskFile;

Delete = get(handles.PPMenu3,'Value');
DelList = get(handles.PPMenu3,'String');
DelName = DelList(Delete);


% Simplified in 3.2.2:
if isequal(Delete,1)
    NewMaskFile = MaskFile(2:end);
    NewMaskListe = DelList(2:end);
    Select = 1;
elseif isequal(Delete,length(DelList))
    NewMaskFile = MaskFile(1:end-1);
    NewMaskListe = DelList(1:end-1);
    Select = length(NewMaskListe);
else
    NewMaskFile = MaskFile(1:Delete-1);
    NewMaskListe = DelList(1:Delete-1);
    Nb = length(NewMaskListe);
    NewMaskFile(Nb+1:length(DelList)-1) = MaskFile(Delete+1:end);
    NewMaskListe(Nb+1:length(DelList)-1) = DelList(Delete+1:end);
    Select = Delete;
end

% if Delete == 1 
%     for k = 1:length(DelList) - 1
%         NewMaskFile(k) = MaskFile(k+1);
%         NewMaskListe(k) = DelList(k+1);
%     end
%     
% end
% if Delete > 1 && Delete < length(DelList) % On enleve un au milieu
%     for k = 1:(Delete - 1)
%         NewMaskFile(k) = MaskFile(k);
%         NewMaskListe(k) = DelList(k);
%     end
%     for k = Delete:length(DelList)-1
%         NewMaskFile(k) = MaskFile(k+1);
%         NewMaskListe(k) = DelList(k+1);
%     end
%     
% end
% if Delete == length(DelList) % on enleve le dernier
%     for k = 1:length(DelList) - 1
%         NewMaskFile(k) = MaskFile(k);
%         NewMaskListe(k) = DelList(k);
%     end
%     
% end

set(handles.PPMenu3,'String',NewMaskListe)
set(handles.PPMenu3,'Value',Select)

set(handles.LeftMenuMaskFile,'String',NewMaskListe)
set(handles.LeftMenuMaskFile,'Value',Select)

handles.MaskFile = NewMaskFile; 

guidata(hObject,handles);

CodeTxt = [7,11];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(DelName),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

disp(['Deleting ... (MaskFile: ',char(DelName),') ... Ok']); disp(' ');

% Display the selected MaskFile
PPMenu3_Callback(hObject, eventdata, handles);

OnEstOu(hObject, eventdata, handles);
GraphStyle(hObject, eventdata, handles)
return


% #########################################################################
%     EXPORT THE MASK MAP V1.4.1
function MaskButton4_Callback(hObject, eventdata, handles)
NumMask = get(handles.PPMenu3,'Value');
Liste = get(handles.PPMenu3,'String');
Name = Liste(NumMask);
MaskFile = handles.MaskFile;

Mask4Display = MaskFile(NumMask).Mask;
NbMask = MaskFile(NumMask).Nb;
NameMask = MaskFile(NumMask).NameMinerals;

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    Mask4Display = Mask4Display.*handles.corrections(1).mask;
end

hf1 = figure('visible','off');;
imagesc(XimrotateX(Mask4Display,handles.rotateFig)), axis image, %colormap(hsv(NbMask)); %colormap(jet(NbMask))
set(gca,'xtick',[], 'ytick',[]);

% if get(handles.CorrButtonBRC,'Value')
%     colormap([0,0,0;hsv(NbMask)])
%     hcb = colorbar('YTickLabel',NameMask); caxis([0 NbMask+1]);
%     set(hcb,'YTickMode','manual','YTick',[0.5:1:NbMask+1]);
% else
%     colormap(hsv(NbMask))
%     hcb = colorbar('YTickLabel',NameMask(2:end)); caxis([1 NbMask+1]);
%     set(hcb,'YTickMode','manual','YTick',[1.5:1:NbMask+1]);
% end

handles = XMapColorbar('Mask',0,handles);

title(Name)


% New 3.2.2

FigPosition = get(hf1,'Position');
ScreenSize = get(0,'ScreenSize');

FigHeight = ScreenSize(4)*0.8;
FigWidth = ScreenSize(3)*0.8; %FigHeight/FigPosition(4)*FigPosition(3);
FigX = (ScreenSize(3)-FigWidth)/2;
FigY = (ScreenSize(4)-FigHeight)/3;

set(hf1,'Position',[FigX,FigY,FigWidth,FigHeight])

LimitsMap = axis; hold on
 
if (LimitsMap(2)-LimitsMap(1)) > 400
    dScale = 100;
    dY = 60;
    dYLogo = 10;
    dX = 5;
    divSpaceScaleBar0 = 6;
elseif (LimitsMap(2)-LimitsMap(1)) > 300
    dScale = 50;
    dY = 40;
    dYLogo = 5;
    dX = 2;
    divSpaceScaleBar0 = 6;
elseif (LimitsMap(2)-LimitsMap(1)) > 50
    dScale = 10;
    dY = 15;
    dYLogo = 2;
    dX = 3;
    divSpaceScaleBar0 = 1;
else
    dScale = 5;
    dY = 5;
    dYLogo = 0.5;
    dX = 0.5;
    divSpaceScaleBar0 = 3;
end

HalfImage = (LimitsMap(2)-LimitsMap(1))/2;

fill([LimitsMap(1),LimitsMap(2),LimitsMap(2),LimitsMap(1)],[LimitsMap(4),LimitsMap(4),LimitsMap(4)+dY,LimitsMap(4)+dY],'w')

plot([LimitsMap(1)+dScale/divSpaceScaleBar0 LimitsMap(1)+dScale+dScale/divSpaceScaleBar0],[LimitsMap(4)+dY/2 LimitsMap(4)+dY/2],'-k','linewidth',4);

text(LimitsMap(1)+dScale/2+dScale/divSpaceScaleBar0,LimitsMap(4)+dY/2-0.2*dY,[num2str(dScale),' px'],'HorizontalAlignment','center');

if  dScale < 0.5 * HalfImage%LimitsMap(2)-LimitsMap(1) > 400
    [StringPlot] = 'Mask image';
    text(LimitsMap(1)+dScale+2*dScale/divSpaceScaleBar0,LimitsMap(4)+dY/3,StringPlot)
    text(LimitsMap(1)+dScale+2*dScale/divSpaceScaleBar0,LimitsMap(4)+2*dY/3,datestr(clock))
else
    %text(140,LimitsMap(4)+30,'VER_XMapTools_804')
end


plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(4),LimitsMap(4)],'k','linewidth',1);
plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(3),LimitsMap(3)],'k','linewidth',1);
plot([LimitsMap(1),LimitsMap(1)],[LimitsMap(3),LimitsMap(4)],'k','linewidth',1);
plot([LimitsMap(2),LimitsMap(2)],[LimitsMap(3),LimitsMap(4)],'k','linewidth',1);

axis([LimitsMap(1) LimitsMap(2) LimitsMap(3) LimitsMap(4)+dY]);


RatioLogo = size(handles.LogoXMapToolsWhite,2)/size(handles.LogoXMapToolsWhite,1);
HeightLogo = dY-dYLogo;
LengthLogo = HeightLogo*RatioLogo;

if LengthLogo < HalfImage
    dX = (HalfImage - LengthLogo)/2;
    image(handles.LogoXMapToolsWhite,'XData', [ LimitsMap(2)-LengthLogo-dX LimitsMap(2)-dX], 'YData', [LimitsMap(4)+dYLogo/2 LimitsMap(4)+HeightLogo+dYLogo/2])
else
    
    LengthLogo = HalfImage - 2*dX;
    HeightLogo = LengthLogo*1/RatioLogo;
    dYLogo = dY-HeightLogo;
    image(handles.LogoXMapToolsWhite,'XData', [ LimitsMap(2)-LengthLogo-dX LimitsMap(2)-dX], 'YData', [LimitsMap(4)+dYLogo/2 LimitsMap(4)+HeightLogo+dYLogo/2])    
end

set(gcf,'Units','Inches');
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)],'visible','on')

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);
return


% #########################################################################
%     EXPORT MASK PROPORTIONS (New V2.1.1)
function MaskButton6_Callback(hObject, eventdata, handles)

NumMask = get(handles.PPMenu3,'Value');
Liste = get(handles.PPMenu3,'String');
Name = Liste(NumMask);
MaskFile = handles.MaskFile;

Mask4Display = MaskFile(NumMask).Mask;
NbMask = MaskFile(NumMask).Nb;
NameMask = MaskFile(NumMask).NameMinerals;

Occurences = zeros(NbMask,1);

for i=1:NbMask
    Occurences(i) = length(find(Mask4Display(:) == i));
end

ModalAdundances = Occurences/sum(Occurences)*100;


% Save
CodeTxt = [7,15];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);

[Success,Message,MessageID] = mkdir('Exported-PhaseProportions');

cd Exported-PhaseProportions
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export file as');
cd ..

if ~Directory
    CodeTxt = [12,8];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end


fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Phase proportions (wt.%) from XMapTools');
fprintf(fid,'%s\n',date);
fprintf(fid,'%s\n\n\n',['Maskfile: ',char(Name)]);

fprintf(fid,'%s\n','---------------------------------');
fprintf(fid,'%s\t\t%s\t%s\n','Phase','Prop (%)','Nb Pixels');
fprintf(fid,'%s\n','---------------------------------');
for i = 1:length(ModalAdundances)
    if length(char(NameMask{i+1})) > 4
        fprintf(fid,'%s%s\t%.2f\t\t%.0f\n',char(NameMask{i+1}),': ',ModalAdundances(i),Occurences(i));
    else
        fprintf(fid,'%s%s\t\t%.2f\t\t%.0f\n',char(NameMask{i+1}),': ',ModalAdundances(i),Occurences(i));
    end
end
fprintf(fid,'%s\n','---------------------------------');

fprintf(fid,'\n\n');
fclose(fid);

CodeTxt = [7,16];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);



return


% #########################################################################
%     EXPORT MASK-FILE (New V2.3.1)
function MaskButton9_Callback(hObject, eventdata, handles)
%

NumMask = get(handles.PPMenu3,'Value');
Liste = get(handles.PPMenu3,'String');
Name = Liste(NumMask);
MaskFile = handles.MaskFile;

Mask4Display = MaskFile(NumMask).Mask;
NbMask = MaskFile(NumMask).Nb;
NameMask = MaskFile(NumMask).NameMinerals;

NamesForSelection = NameMask(2:end);
AutoSelection = zeros(size(NamesForSelection));

CodeTxt = [7,18];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);


[SelectedMasks,OK] = listdlg('ListString',NamesForSelection,'SelectionMode','Multiple','Name','Export','PromptString','Select the masks to be exported');

if ~OK
    CodeTxt = [12,8];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

FinalMaskFile = zeros(size(Mask4Display));
for i=1:length(SelectedMasks)
    WherePx = find(Mask4Display == SelectedMasks(i));
    FinalMaskFile(WherePx) = (i)*ones(size(WherePx));
    
    SelectedName{i} = NamesForSelection{SelectedMasks(i)};
    
    %figure, imagesc(FinalMaskFile), axis image, colorbar
end 

% % if there is any zero we create a new group...
% WhereZero = find(FinalMaskFile(:) == 0);
% if length(WhereZero)
%     disp('Mask Exporting ... (WARNING there are unselected pixels)')
%     disp(['Mask Exporting ... (A new mask [',num2str(length(SelectedMasks)+1),'] has been created with ',num2str(length(WhereZero)),'/',num2str(length(FinalMaskFile(:))),' px)'])
%     disp(' '), disp(' ')
%
%     FinalMaskFile(WhereZero) = (length(SelectedMasks)+1)*ones(size(WhereZero));
%
%     figure, imagesc(FinalMaskFile), axis image, colorbar
% end

%Note: This step is not necessary as the import function deals with zeros...

if length(SelectedMasks) > 1
    NameForFile = Name;
else
    NameForFile = NamesForSelection(SelectedMasks);
end

% Save
CodeTxt = [7,19];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Success,Message,MessageID] = mkdir('Maskfiles');

cd Maskfiles
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'},'Export mask file as',[char(NameForFile),'.txt']);
cd ..

if ~Directory
    CodeTxt = [12,8];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

save([pathname,Directory],'FinalMaskFile', '-ASCII');


Selected = ones(size(SelectedName));  

fid = fopen([char(pathname),'info_',char(Directory)],'w');
    
fprintf(fid,'%s\n','     ---------------------------------------------------');
fprintf(fid,'%s\n','     | Information for maskfile generated by XMapTools |');
fprintf(fid,'%s\n\n','     ---------------------------------------------------');


fprintf(fid,'\n%s\n','>1 Type');
fprintf(fid,'%s\n\n','1        | Maskfile exported from XMapTools');

fprintf(fid,'\n%s\n','>2 Selected masks for import in XMapTools');
for i = 1:length(Selected)
    fprintf(fid,'%.0f\n',Selected(i));
end

fprintf(fid,'\n\n%s\n','>3 Mask names');
for i = 1:length(Selected)
    fprintf(fid,'%s\n',char(SelectedName{i}));
end

fprintf(fid,'\n\n');

fclose(fid);



CodeTxt = [7,20];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);


return


% #########################################################################
%     MERGE/IMPORT MaskFile (3.0.1)
function MaskButton7_Callback(hObject, eventdata, handles)
%

CodeTxt = [7,17];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Success,Message,MessageID] = mkdir('Maskfiles');

cd Maskfiles
[FileName,PathName,FilterIndex] = uigetfile({'*.txt;','Maskfiles (*.txt)';'*.*',  'All Files (*.*)'},'Pick file(s)','MultiSelect', 'on');
cd ..

if ~FilterIndex
    CodeTxt = [7,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

CodeTxt = [7,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

if iscell(FileName)
    % -------- Merge --------
    
    NameMask{1} = 'none';
    
    RawMapSizeRef = size(handles.data.map(1).values);
    NbMask = 0;
    NewMaskFile = zeros(RawMapSizeRef);
    
    XmapWaitBar(0, handles);
    
    ComptMaskFinal = 1;
    
    for i=1:length(FileName)
        
        InfoFile = [];
        
        XmapWaitBar(i/length(FileName), handles);
        
        NameFileI = char(FileName{i});
        
        DataTemp = load([PathName,NameFileI]);
        
        if isequal(exist([PathName,'info_',NameFileI]),2)
            
            % we read the file
            [InfoFile] = ReadInfoMaskFile(PathName,NameFileI);
            
        else
            % Old method (pre 2.5.2)
            InfoFile.Type = 0;    % Old maskfile
            InfoFile.Select = ones(1,max(DataTemp(:)));    % Old maskfile
            
            for j = 1:length(InfoFile.Select)
                InfoFile.Names{j} = [NameFileI(1:end-4),'_Mask',num2str(j)];
            end
            
            %keyboard
        end
            
        
        %keyboard
        
        %NbNewMask = max(DataTemp(:))-1;
        %NbNewMask = max(DataTemp(:));   % corrected (PL 2.5.2)
        
        if ~isequal(size(DataTemp),RawMapSizeRef)
            errordlg({'The size of this maskfile is not the same than the maps!'},'Error');
            
            CodeTxt = [7,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        
        
        
        for j=1:length(InfoFile.Select)
            
            if isequal(InfoFile.Select(j),1)
            
                ComptMaskFinal = ComptMaskFinal+1;
                
                NameMask{ComptMaskFinal} = InfoFile.Names{j};
                
                WhereOK = find(DataTemp == j);
                NewMaskFile(WhereOK) = (ComptMaskFinal-1).*ones(length(WhereOK),1);
            
            end
            
            %WhereOK = find(DataTemp == j+1);    % corrected (PL 2.5.2)
            %WhereOK = find(DataTemp == j);    % corrected (PL 2.5.2)
            %NbMask = NbMask+1;
            
            
            %NameCrunched = FileName{i};
            %NameCrunched = NameCrunched(1:end-4);
            %NameMask{NbMask+1} = [NameCrunched,'-',num2str(j)];
            
            %NewMaskFile(WhereOK) = NbMask.*ones(length(WhereOK),1);
        end
        
        
        %keyboard 
    end
    
    % We are looking for 0 into the new MaskFile
    WhereOK = find(NewMaskFile == 0);
    
    if length(WhereOK)
        ComptMaskFinal = ComptMaskFinal+1;   
        NameMask{ComptMaskFinal} = ['Unselected_pixels'];
        NewMaskFile(WhereOK) = (ComptMaskFinal-1).*ones(length(WhereOK),1);  % -1 added on 14.03.2019; NOT SURE THIS IS CORRECT
        disp(['   ** Check: the unselected pixels have a mask value of ',num2str(ComptMaskFinal-1)]);
    end
    
    CodeTxt = [7,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    Name = inputdlg('Mask file name','define a name',1,{['Merged-Maskfile']});
    
    if length(Name) == 0
        CodeTxt = [7,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(4))]);
        return
    end
    
    %keyboard
else
    % --------  Load --------
    NameMask{1} = 'none';
    
    RawMapSizeRef = size(handles.data.map(1).values);
    ComptMaskFinal = 1;
    NewMaskFile = zeros(RawMapSizeRef);
    
    XmapWaitBar(0, handles);
    XmapWaitBar(0.5, handles); 
    
    DataTemp = load([PathName,FileName]);
    NbNewMask = max(DataTemp(:));%-1;  % I removed -1 because it fails with densities (24.07.16)
    
    if isequal(exist([PathName,'info_',FileName]),2)
        
        % we read the file
        [InfoFile] = ReadInfoMaskFile(PathName,FileName);
        
    else
        % Old method (pre 2.5.2)
        InfoFile.Type = 0;    % Old maskfile
        InfoFile.Select = ones(1,max(DataTemp(:)));    % Old maskfile
        
        for j = 1:length(InfoFile.Select)
            InfoFile.Names{j} = [FileName(1:end-4),'_Mask',num2str(j)];
        end
        
        %keyboard
    end
    
    % Check of the map size (this is quite important)
    
    if ~isequal(size(DataTemp),RawMapSizeRef)
        errordlg({'The maskfile size is not the same than the maps.'},'Error');
        
        CodeTxt = [7,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        return
    end
    
    %keyboard
    
    for j=1:NbNewMask
        
        if isequal(InfoFile.Select(j),1)
           
            ComptMaskFinal = ComptMaskFinal+1;
            
            NameMask{ComptMaskFinal} = InfoFile.Names{j};
            
            WhereOK = find(DataTemp == j);
            NewMaskFile(WhereOK) = (ComptMaskFinal-1).*ones(length(WhereOK),1);
            
        end
        
%         WhereOK = find(DataTemp == j);
%         ComptMaskFinal = ComptMaskFinal+1;
%         
%         NameMask{ComptMaskFinal+1} = InfoFile.Names{j}; % [FileName(1:end-4),'-',num2str(j)];
%         
%         NewMaskFile(WhereOK) = ComptMaskFinal.*ones(length(WhereOK),1);
    end
    
    %keyboard
    
    % We are looking for 0 into the new MaskFile
    WhereOK = find(NewMaskFile == 0);
    
    if length(WhereOK)
        ComptMaskFinal = ComptMaskFinal+1;
        NameMask{ComptMaskFinal} = 'Unselected pixels';
        NewMaskFile(WhereOK) = (ComptMaskFinal-1).*ones(length(WhereOK),1);
    end
    
    %keyboard
    
    XmapWaitBar(1,  handles);
    
    CodeTxt = [7,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    Name = inputdlg('Mask file name','define a name',1,{['Imported-Maskfile']});
    
    if length(Name) == 0
        CodeTxt = [7,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(7).txt(4))]);
        return
    end
    
end

% -------- Save and display the new MaskFile --------

if handles.MaskFile(1).type
    Where = length(handles.MaskFile)+1;
else
    Where = 1;
end

handles.MaskFile(Where).type = 1;
handles.MaskFile(Where).Pixels = [];
handles.MaskFile(Where).Nb = ComptMaskFinal-1;
handles.MaskFile(Where).Name = Name;
handles.MaskFile(Where).Mask = NewMaskFile;
handles.MaskFile(Where).NameMinerals = NameMask;

% --------------------------------------
% Statistics:
for i=2:length(NameMask)
    Temp4Sum = NewMaskFile == i-1;
    NbTot(i-1) = sum(Temp4Sum(:));
end
PerTot = NbTot./(sum(NbTot))*100;

disp(['Mask importing ... (',char(Name),') ...']);
disp(['Mask importing ... (Nb Masks: ',num2str(ComptMaskFinal),')']);
for i=2:length(NameMask)
    disp(['Mask importing ... (Phase: ',num2str(i-1),' name: ',char(NameMask{i}),' < ',num2str(PerTot(i-1)),'% >)']);
end
disp(['Mask importing ... (',char(Name),') ... Done']);
disp(' ');


Compt = 1;
for i=1:length(handles.MaskFile(:))
    if handles.MaskFile(Compt).type == 1
        ListNameMen(Compt) = handles.MaskFile(i).Name;
        Compt = Compt+1;
    end
end
set(handles.PPMenu3,'String',ListNameMen)
set(handles.PPMenu3,'Value',Where) % currently selected.

set(handles.LeftMenuMaskFile,'String',ListNameMen)
set(handles.LeftMenuMaskFile,'Value',Where) % currently selected.

% --------------------------------------
% Update the menu "Mineral":
set(handles.PPMenu2,'String',NameMask)

% --------------------------------------
% DISPLAY MASKS
MaskButton2_Callback(hObject, eventdata, handles);

CodeTxt = [7,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Name),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

XmapWaitBar(1,  handles);
drawnow

guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


function [InfoFile] = ReadInfoMaskFile(PathName,NameFileI)
%

fid = fopen([PathName,'info_',NameFileI],'r');
            
while 1
    TheL = fgetl(fid);
    
    if isequal(TheL,-1)
        break
    end
    
    if length(TheL)
        if isequal(TheL(1),'>')
            Case = str2num(TheL(2));
            
            switch Case
                case 1
                    TheL = fgetl(fid);
                    %keyboard
                    TheStr = strread(TheL,'%s');
                    
                    InfoFile.Type = str2num(TheStr{1});
                    
                case 2
                    Compt = 0;
                    while 1
                        TheL = fgetl(fid);
                        
                        if ~length(TheL)
                            break
                        end
                        Compt = Compt+1;
                        InfoFile.Select(Compt) = strread(TheL,'%f');
                    end
                    
                case 3
                    Compt = 0;
                    while 1
                        TheL = fgetl(fid);
                        
                        if ~length(TheL)
                            break
                        end
                        Compt = Compt+1;
                        InfoFile.Names{Compt} = TheL;
                    end
                    
                    
                    
            end
            
            
        end
        
    end
    
    
end

fclose(fid);
return


% #########################################################################
%     GRAIN BOUNDARY ORIENTATION (New V2.1.3)
function MaskButton8_Callback(hObject, eventdata, handles)
%

% this function is available only if we computed a BRC correction
% TEMPORARY CHECK !!!
if ~handles.corrections(1).value   % BRC
    return
end

TheBoundaries = zeros(size(handles.corrections(1).mask));
WhichOnes = find(handles.corrections(1).mask(:) == 0);
TheBoundaries(WhichOnes) = ones(size(WhichOnes));

SParams = inputdlg({'Half-size (in px; <=4)'},'GBO parameters',1,{'2'});

HalfSize = str2num(SParams{1});


% Initialization
PositionOri = [HalfSize+1,HalfSize+1];
MatrixCompOri = zeros(2*HalfSize+1);
MatrixCompOri(:,HalfSize+1) = ones(2*HalfSize+1,1);

NbComp = HalfSize*(HalfSize+1)/2;
% Here the Gauss method is used to estimate the number of computations that
% should be made for each of the fourth computation blocs. Note that the
% first is horizontal, the second and the third are vertical and the fourth
% is again horizontal (in the other direction).

Indices = 1:4*NbComp; % 0 and 180 are the same

CompType = zeros(size(Indices));
CompType(1:NbComp) = 1*ones(1,NbComp);
CompType(NbComp+1:2*NbComp) = 2*ones(1,NbComp);
CompType(2*NbComp+1:3*NbComp) = 3*ones(1,NbComp);
CompType(3*NbComp+1:4*NbComp) = 4*ones(1,NbComp);

FractD = 180/(4*NbComp);
OrientationsD = (Indices-1)*FractD;

% Computation
% we are working between [Halfsize+1:end-HalfSize,Halfsize+1:end-HalfSize]

FinalMapDegree = zeros(size(TheBoundaries));
FinalMapCounts = zeros(size(TheBoundaries));

% figure
for i=1:length(OrientationsD)
    
    [MatrixComp] = MatrixComTransformMax4(MatrixCompOri,CompType,i);
    
    [TheY,TheX] = find(MatrixComp);
    
    TempMaps = zeros(size(TheBoundaries)); %zeros(size(TheBoundaries,1)-2*HalfSize,size(TheBoundaries,2)-2*HalfSize);
    for iShift = 1:length(TheY)
        
        Xmin = TheX(iShift);
        Xmax = size(TheBoundaries,2)-(length(MatrixComp)-Xmin);
        
        Ymin = TheY(iShift);
        Ymax = size(TheBoundaries,1)-(length(MatrixComp)-Ymin);
        
        TheMapSel = TheBoundaries(Ymin:Ymax,Xmin:Xmax);
        %size(TheMapSel)
        
        TempMaps(HalfSize+1:end-HalfSize,HalfSize+1:end-HalfSize) = TempMaps(HalfSize+1:end-HalfSize,HalfSize+1:end-HalfSize) + TheMapSel;
    end
    
    WhereSolu = find(TempMaps == iShift);
    
    FinalMapDegree(WhereSolu) = FinalMapDegree(WhereSolu)+OrientationsD(i)*ones(size(WhereSolu));
    FinalMapCounts(WhereSolu) = FinalMapCounts(WhereSolu)+ones(size(WhereSolu));
    
    %imagesc(MatrixComp),axis image, colorbar
    %pause(0.2)
    
end

FinalMapDegree(find(FinalMapDegree == 0)) = -10*ones(size(find(FinalMapDegree == 0)));

FinalMapDegree = FinalMapDegree./FinalMapCounts;



figure, imagesc(FinalMapDegree), axis image, colorbar, colormap([[0,0,0];jet(64);[0,0,0]])
caxis([-2 182])

figure, hist(FinalMapDegree(find(FinalMapDegree>=0)),30);



% Here maybe a new interface ???


% if many solutions for a pixel, take the average in degree...






%keyboard


return


function [MatrixComp] = MatrixComTransformMax4(MatrixCompOri,CompType,Ind);
%
%

% Ind is the indice and Typ is the type of transformation (could be
% 1, 2, 3 or 4)
clc
MatrixComp = MatrixCompOri;

HalfSize = (size(MatrixCompOri,1)-1)/2;

% We apply all the transformations
DistY = HalfSize;
DistX = HalfSize;

Ymax = 2*HalfSize+1;
Xmax = Ymax;

Compt = 1;


% CASE 1 // right (+1)

Yi = 1;
while Yi <= DistY
    
    TheHorizVect = MatrixComp(Yi,:);
    OldPos = find(TheHorizVect);
    
    TheNextHorizVect = MatrixComp(Yi+1,:);
    NextHorizPos = find(TheNextHorizVect);
    
    if OldPos < Ymax && OldPos == NextHorizPos
        % we move here
        Compt = Compt+1;
        MatrixComp(Yi,OldPos) = 0;
        MatrixComp(Yi,OldPos+1) = 1;
        
        MatrixComp((Ymax+1)-Yi,(Xmax+1)-OldPos) = 0;
        MatrixComp((Ymax+1)-Yi,(Xmax+1)-OldPos-1) = 1;
        
        
        MatrixComp;
        
        if isequal(Compt,Ind)
            return
        end
        
        Yi = Yi+1;
        
        if MatrixComp(Yi+1,OldPos-1)
            Yi=1;
        end
        
    else
        break
    end
end


% CASE 2 // Bottom (+1)

Xi = Xmax;
while Xi >= DistX
    
    TheVertVect = MatrixComp(:,Xi);
    OldPos = find(TheVertVect);
    
    TheNextVertVect = MatrixComp(:,Xi-1);
    NextVertPos = find(TheNextVertVect);
    
    if OldPos < Xmax-HalfSize && OldPos == NextVertPos-1
        % we move here
        Compt = Compt+1;
        MatrixComp(OldPos,Xi) = 0;
        MatrixComp(OldPos+1,Xi) = 1;
        
        MatrixComp((Ymax+1)-OldPos,(Xmax+1)-Xi) = 0;
        MatrixComp((Ymax+1)-OldPos-1,(Xmax+1)-Xi) = 1;
        
        
        MatrixComp;
        
        if isequal(Compt,Ind)
            return
        end
        
        Xi = Xi-1;
        
        if MatrixComp(OldPos+1,Xi-1)
            Xi = Xmax;
        end
        
    else
        break
    end
end

% CASE 3 // Bottom (+1)

Xi = Xmax;
while Xi >= DistX
    
    TheVertVect = MatrixComp(:,Xi);
    OldPos = find(TheVertVect);
    
    TheNextVertVect = MatrixComp(:,Xi-1);
    NextVertPos = find(TheNextVertVect);
    
    if OldPos < Xmax && OldPos == NextVertPos
        % we move here
        Compt = Compt+1;
        MatrixComp(OldPos,Xi) = 0;
        MatrixComp(OldPos+1,Xi) = 1;
        
        MatrixComp((Ymax+1)-OldPos,(Xmax+1)-Xi) = 0;
        MatrixComp((Ymax+1)-OldPos-1,(Xmax+1)-Xi) = 1;
        
        
        MatrixComp;
        
        if isequal(Compt,Ind)
            return
        end
        
        Xi = Xi-1;
        
        if MatrixComp(OldPos-1,Xi-1)
            Xi=Xmax;
        end
        
    else
        break
    end
end

% CASE 4 // Left (+1)

Yi = Ymax;
while Yi >= DistY+1
    
    TheHorizVect = MatrixComp(Yi,:);
    OldPos = find(TheHorizVect);
    
    TheNextHorizVect = MatrixComp(Yi-1,:);
    NextHorizPos = find(TheNextHorizVect);
    
    if OldPos > HalfSize+1 && OldPos == NextHorizPos+1
        % we move here
        Compt = Compt+1;
        MatrixComp(Yi,OldPos) = 0;
        MatrixComp(Yi,OldPos-1) = 1;
        
        MatrixComp((Ymax+1)-Yi,(Xmax+1)-OldPos) = 0;
        MatrixComp((Ymax+1)-Yi,(Xmax+1)-OldPos+1) = 1;
        
        
        MatrixComp;
        
        if isequal(Compt,Ind)
            return
        end
        
        Yi = Yi-1;
        
        if MatrixComp(Yi-1,OldPos-1)
            Yi=Xmax;
        end
        
    else
        break
    end
end

return



% #########################################################################
%     CORRECTION OF PROBE INTENSITY
function PIButton1_NOTUSED_Callback(hObject, eventdata, handles)
% WARNING, this function is a test version.
%
% SEEMS TO NOT BE USED ANYMORE IN XMAPTOOLS 2...
%
%

ButtonName = questdlg('Temporary test function. Do you want to continue ?', ...
    'Warning');
if length(ButtonName) ~= 3
    return
end

Data = handles.data;
MaskFile = handles.MaskFile;
ListMap = handles.ListMap;

MapRef = get(handles.PPMenu1,'Value');

MapSelected = Data.map(MapRef).values;
RefMapSelected = Data.map(MapRef).ref;
MaskSelected = get(handles.PPMenu3,'Value');

Mineral = get(handles.PPMenu2,'Value');

if Mineral == 1
    warndlg('Please select a mineral','Cancelation');
    return
end

% Just to display, the correction modify the MapSelected value.
if Mineral > 1
    RefMin = Mineral - 1;
    AAfficher = MaskFile(MaskSelected).Mask == RefMin;
    AAfficher = Data.map(MapRef).values .* AAfficher;
    
else
    AAfficher = Data.map(MapRef).values;
end

% --------------------------------
% figure:
figure(5),
imagesc(AAfficher), axis image, colorbar vertical, hold on

zoom on                                                         % New 1.6.2

Min = get(handles.ColorMin,'String');
Max = get(handles.ColorMax,'String');
if str2num(Max) > str2num(Min)
    caxis([str2num(Min) str2num(Max)]);
end
% Value = get(handles.checkbox1,'Value');
% if Value == 1
%     colormap([0,0,0;jet(64)])
% else
%     colormap([jet(64)])
% end


% --------------------------------
% Selection:
clique = 1; ComptSelect = 1;
while clique < 2
    [SelPixel(1),SelPixel(2),clique] = XginputX(1,handles); % On selectionne le pixel
    if clique < 2
        CenterPixels(ComptSelect,:) = round(SelPixel);
        plot(CenterPixels(:,1),CenterPixels(:,2), 'mo','linewidth', 2)
        ComptSelect = ComptSelect+1;
    end
end


% --------------------------------
% Display and select the correction
XAll = CenterPixels(:,2);
for i=1:length(XAll)
    Element(i) = MapSelected(CenterPixels(i,2),CenterPixels(i,1)); % L/C -> Y/X
end

figure(6), plot(XAll,Element,'ok'), hold on


clique = 1; ComptPts = 1;
while clique < 2
    [SelPixel(1),SelPixel(2),clique] = XginputX(1,handles); % On selectionne le pixel
    if clique < 2
        InterpolPixels(ComptPts,:) = round(SelPixel);
        plot(InterpolPixels(:,1),InterpolPixels(:,2), '-+r','linewidth', 2)
        ComptPts = ComptPts+1;
    else
        break
    end
end

close(5),close(6)

% --------------------------------
% Inpertolation
X = InterpolPixels(:,1); Y = InterpolPixels(:,2);
IntX = 1:1:length(AAfficher(:,1));
IntY = interp1(X,Y,IntX,'cubic');

figure(5), plot(XAll,Element,'ok'), hold on, plot(IntX,IntY,'-r');
title('Interpolated deviation');

% --------------------------------
% Correction Factor:
MeanValue = mean(IntY);
CorrFactor = MeanValue ./ IntY; % vector

ProvCorr = Data.map(MapRef).values;


% --------------------------------
% Element selection :
InitVal(1) = MapRef;

ElSelected = listdlg('ListString',ListMap,'SelectionMode','multiple','InitialValue',InitVal,'Name','Select your elements');

for i=1:length(ElSelected)
    OnSelect = ElSelected(i);
    ProvCorr = Data.map(OnSelect).values;
    ProvName = strcat(Data.map(OnSelect).name,'_Corr');
    ProvType = 1; % modification of type maybe in a new version
    for j=1:length(ProvCorr(:,1))
        ProvCorr(j,:) = ProvCorr(j,:) .* CorrFactor(j);
    end
    
    ProvCorr = round(ProvCorr);
    
    % Save:
    OnRemplace = 0;
    for k=1:length(Data.map(:))
        if Data.map(k).type == 0
            OnRemplace = 1;
            break
        end
    end
    if OnRemplace == 0
        k = k+1; % add a new line
    end
    
    Data.map(k).type = ProvType;
    Data.map(k).name = ProvName; % Name
    Data.map(k).values = ProvCorr;
    Data.map(k).ref = RefMapSelected; % Element Ref
    
    Compt = 1;
    for k=1:length(Data.map(:)), if Data.map(k).type == 1, ListMap(Compt) = Data.map(k).name; Compt = Compt + 1; end, end
    
    set(handles.PPMenu1,'string',ListMap);
    set(handles.PPMenu1,'Value',i)
    
    handles.data = Data; % send
    handles.ListMap = ListMap;
    
    SiResidu = Data.map(MapRef).values - ProvCorr;
    SiCorrPercent = (Data.map(MapRef).values - ProvCorr)./(Data.map(MapRef).values.*100);
    
    figure, subplot(1,2,1)
    colormap(jet(64));
    imagesc(SiResidu), axis image, colorbar horizontal
    title('carte des residus')
    subplot(1,2,2)
    imagesc(SiCorrPercent), axis image, colorbar horizontal
    title('Ecart de la carte corrigee pap ? brute (%)')
    
end

% ------------------------------
% Display tools :
close(5)

guidata(hObject,handles);


% #########################################################################
%     OLD LOAD A STD FILE (PROFIL) V1.4.1   SAUVEGARDE
function SAVE___PRButton1_Callback(hObject, eventdata, handles)
NameMaps = handles.NameMaps;
Data = handles.data;

% On supprime les profils pr?c?dement charg?s...
handles.profils = [];

CodeTxt = [8,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(1))]);

[FileName,PathName,FilterIndex] = uigetfile({'*.txt;*.asc;*.dat;','Maps Files (*.txt, *.asc, *.dat)';'*.*',  'All Files (*.*)'},'Pick a file');

if FilterIndex
    CodeTxt = [8,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(3))]);
    fid = fopen(strcat(PathName,FileName));
    DefOrder=[];
    DefProfils=[];
    DefMap = [];
    LectureOrder = 0;
    LectureProfils = 0;
    LectureMap = 0;
    
    ComptLignProfils = 0;
    ComptLignMap = 0;
    
    while 1
        tline = fgets(fid);
        if ~ischar(tline)
            break
        end
        prose = strread(tline,'%s','delimiter','\r');
        AlireMap = ismember('*** Map coordinates ***',prose);
        AlireOrder = ismember('*** Elements order ***',prose);
        AlireProfils = ismember('*** Analysis ***',prose);
        
        if AlireMap, LectureMap = 1; end
        if AlireOrder, LectureOrder = 1; end
        if AlireProfils, LectureProfils = 1; end
        
        if size(tline)<=[1,2], LectureOrder = 0; LectureProfils = 0; LectureMap = 0; end,
        
        if LectureOrder && ~AlireOrder, DefOrder = [DefOrder,prose]; end,
        if LectureProfils && ~AlireProfils,
            ComptLignProfils=ComptLignProfils+1;
            tampon = strread(char(tline),'%f','delimiter','\t');
            DefProfils(ComptLignProfils,:) = tampon(:);
        end
        if LectureMap && ~AlireMap,
            ComptLignMap=ComptLignMap+1;
            tampon = strread(char(tline),'%f','delimiter','\t');
            DefMap(ComptLignMap,:) = tampon(:);
        end
    end
    
    ListPrElements = strread(char(DefOrder),'%s','whitespace',' ');
    
    % first test:
    OkV = 1;
    
else
    CodeTxt = [8,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(2))]);
    return
end


%keyboard

if size(DefProfils,2) == length(ListPrElements)
    
    % work:
    ForDetection = NameMaps.oxydes;
    ForDetection(end+1:end+2) = {'X','Y'};
    
    ForIndexation = NameMaps.elements;
    ForIndexation(end+1:end+2) = {'X','Y'};
    
    [IsM,RefElemPro] = ismember(ListPrElements,ForDetection);
    if sum(IsM) ~= length(IsM)
        % Problem of correspondence between the elements of database and entries of profils...
        set(handles.PRAffichage1,'String',[char(handles.TxtDatabase(8).txt(8))]);
        
        CodeTxt = [8,5];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(5))]);
        guidata(hObject,handles);
        return
    end
    
    ListPrElements = ForIndexation(RefElemPro); % New order
    
    [isX,XRef] = ismember('X',ListPrElements);
    [isY,YRef] = ismember('Y',ListPrElements);
    
    if isX+isY ~= 2
        % Coordinates (X,Y) were not detected
        set(handles.PRAffichage1,'String',[char(handles.TxtDatabase(8).txt(8))]);
        
        CodeTxt = [8,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(6))]);
        guidata(hObject,handles);
        return
    end
    
    handles.profils.coord(:,1) = DefProfils(:,XRef);
    handles.profils.coord(:,2) = DefProfils(:,YRef);
    
    % Organisation des donn?es
    % NameOrder contient la liste de tous les ?l?ments disponibles dans le
    % fichier profil.
    for i=1:length(ListPrElements)
        if i == XRef || i == YRef
            continue
        else
            DataPro(:,i) = DefProfils(:,i);
            NameOrder(i) = ListPrElements(i);
        end
    end
    
    Concat = strcat(' (',NameOrder(1));
    for i=2:length(NameOrder),
        Concat = strcat(Concat,'-',ListPrElements(i));
    end,
    Concat = strcat(Concat,')');
    
    
    
    %keyboard
    
    Xleft = DefMap(1); Xright = DefMap(2); Ybot = DefMap(3); Ytop = DefMap(4);
    SizeMap = size(Data.map(1).values);
    
    SizeXPixel = abs((Xleft - Xright) / (SizeMap(2) -1 )); % x --> col
    SizeYPixel = abs((Ytop - Ybot) / (SizeMap(1) -1 )); % x --> line
    
    % new profile coordonate computation
    if Xleft < Xright
        XCoo = Xleft : SizeXPixel : Xright;
    else
        XCoo = Xleft : -SizeXPixel : Xright;
    end
    if Ytop > Ybot
        YCoo = Ytop : -SizeYPixel : Ybot;
    else
        YCoo = Ytop : SizeYPixel : Ybot;
    end
    
    IdxAllPr = NaN * zeros(length(DefProfils(:,1)), 2);
    
    
    for i = 1 : length(DefProfils(:,1))
        [V(i,1), IdxAllPr(i,1)] = min(abs(XCoo-DefProfils(i,XRef))); % Index X
        [V(i,2), IdxAllPr(i,2)] = min(abs(YCoo-DefProfils(i,YRef))); % Index Y
    end
    
    handles.profils.xcoo = XCoo;
    handles.profils.ycoo = YCoo; % new option (for correction)
    handles.profils.idxallpr = IdxAllPr;
    handles.profils.data = DataPro;
    handles.profils.elemorder = NameOrder;
    handles.profils.display = strcat(FileName,Concat);
    
    disp(['Profile setting ... (',char(FileName),') ...']);
    disp(['Profile setting ... (Elements: ',char(Concat),')']);
    disp(['Profile setting ... (Analysis: ',num2str(length(DataPro)),')']);
    disp(['Profile setting ... (Validity: ',char(num2str(IsM')),')']);
    disp(['Profile setting ... (',char(FileName),') ... Ok']);
    disp(' ')
    
    set(handles.PRAffichage1,'String',strcat(FileName,Concat));
    
    CodeTxt = [8,7];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(FileName),')']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(7)),' (',char(FileName),')']);
    
else
    set(handles.PRAffichage1,'String',[char(handles.TxtDatabase(8).txt(8))]);
    
    CodeTxt = [8,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(4))]);
    return
end

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

% display profils into the map
PRButton3_Callback(hObject, eventdata, handles)
return


% #########################################################################
%     LOAD A FILE (STANDARDS) V2.1.3
function PRButton1_Callback(hObject, eventdata, handles)
NameMaps = handles.NameMaps;
Data = handles.data;

% On supprime les profils pr?c?dement charg?s... si jamais
handles.profils = [];

CodeTxt = [8,1]; % Select a file
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(1))]);

% - - - Update 2.1.4 - Automatic opening of Classification.txt
WhereWheAre = cd;
PathName = [WhereWheAre,'/'];
FileName = 'Standards.txt';

if isequal(exist([PathName,FileName],'file'),2)
    ButtonName = questdlg('Would you like to used Standards.txt?','Standards','Yes');
    switch ButtonName
        case 'Yes'
            Question = 0;
        otherwise
            Question = 1;
    end
else
    Question = 1;
end

if Question
    [FileName,PathName,FilterIndex] = uigetfile({'*.txt;*.asc;*.dat;','Maps Files (*.txt, *.asc, *.dat)';'*.*',  'All Files (*.*)'},'Pick a file');
else
    FilterIndex = 1;
end

% --

if FilterIndex % UPDATED 1.6.1 (P. Lanari - 28/12/12)
    CodeTxt = [8,3]; % Profile file opening
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    Compt = 0;
    
    DefMap = [];
    ListPrElements = [];
    DefProfils = [];
    
    % Load
    fid = fopen(strcat(PathName,FileName));
    while 1
        tline = fgets(fid);
        if ~ischar(tline)   % end of this file...
            break
        end
        
        if isequal(tline(1),'>')
            leCase = str2num(tline(2));
            switch leCase
                
                case 1 % map coordinates
                    tline = fgets(fid);
                    DefMap = strread(tline,'%f')';   % Changed PL
                    
                case 2 % elements order
                    tline = fgets(fid);
                    ListPrElements = strread(tline, '%s');
                    
                case 3 % Point mode analyses
                    while 1
                        tline = fgets(fid);
                        if length(tline) < 3
                            break
                        end
                        Compt = Compt+1;
                        % changed version 2.6.1: added %f to only read
                        % numbers and check the size of the table
                        TheRowOk = strread(tline,'%f')';
                        
                        if Compt > 1
                            if ~isequal(length(TheRowOk),size(DefProfils,2))
                                f = errordlg({'Error while reading the third block of the Standard file (>3): ', ...
                                    'The number of columns is not constant throughout the table', ...
                                    ['Error tracking: check analysis #',num2str(Compt),' (see below)'], ...
                                    tline}, 'XMapTools');
                                
                                CodeTxt = [8,8];
                                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                                
                                return
                            end
                        end
                        
                        DefProfils(Compt,:) = TheRowOk;
                    end
            end
        end
        
        
        
    end
    
else
    CodeTxt = [8,2]; 
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

% Check if all the data were provided (new 2.3.2)
ErrorText{1} = ['Cancellation, it was not possible to import the file ',FileName];
ErrorText{2} = ['  '];
ErrorText{3} = ['XMapTools encountered the following issue(s):'];
ErrorDisp = 0;

if isequal(length(DefMap),0)
    ErrorDisp = 1;
    ErrorText{end+1} = '   -   [>1] Missing or empty map coordinates block';
end

if ~isequal(length(DefMap),4)
    ErrorDisp = 1;
    ErrorText{end+1} = '   -   [>1] Four map coordinates are required (Xmin, Xmax, Ymin, Ymax)';
end

if isequal(length(ListPrElements),0)
    ErrorDisp = 1;
    ErrorText{end+1} = '   -   [>2] Missing or empty oxide order block';
else
    if ~isequal(ListPrElements{end-1},'X') || ~isequal(ListPrElements{end},'Y')
        ErrorDisp = 1;
        ErrorText{end+1} = '   -   [>2] Issue with X and Y coordinates (note X and Y must be the two last labels and must be listed in this order)';
    end
end

if isequal(size(DefProfils,2),0)
    ErrorDisp = 1;
    ErrorText{end+1} = '   -   [>3] Missing or empty spot analyses block';
else
    if ~isequal(size(DefProfils,2),length(ListPrElements))
        ErrorDisp = 1;
        ErrorText{end+1} = '   -   [>2] and [>3] have different sizes';
    end
end

if ErrorDisp
    ErrorText{end+1} = ' ';
    warndlg(ErrorText,'Error Import Function')
    return
end

if size(DefProfils,2) == length(ListPrElements)
    
    % work:
    ForDetection = NameMaps.oxydes;
    ForDetection(end+1:end+2) = {'X','Y'};
    
    ForIndexation = NameMaps.elements;
    ForIndexation(end+1:end+2) = {'X','Y'};
    
    [IsM,RefElemPro] = ismember(ListPrElements,ForDetection);
    if sum(IsM) ~= length(IsM)
        % Problem of correspondence between the elements of database and entries of profils...
        set(handles.PRAffichage1,'String',[char(handles.TxtDatabase(8).txt(8))]);
        
        CodeTxt = [8,5];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(5))]);
        guidata(hObject,handles);
        return
    end
    
    ListPrElements = ForIndexation(RefElemPro); % New order
    
    [isX,XRef] = ismember('X',ListPrElements);
    [isY,YRef] = ismember('Y',ListPrElements);
    
    if isX+isY ~= 2
        % Coordinates (X,Y) were not detected
        set(handles.PRAffichage1,'String',[char(handles.TxtDatabase(8).txt(8))]);
        
        CodeTxt = [8,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(6))]);
        guidata(hObject,handles);
        return
    end
    
    handles.profils.coord(:,1) = DefProfils(:,XRef);
    handles.profils.coord(:,2) = DefProfils(:,YRef);
    
    handles.profils.pointselected = ones(size(handles.profils.coord,1),1);
    
    % Organisation des donn?es
    % NameOrder contient la liste de tous les ?l?ments disponibles dans le
    % fichier profil.
    for i=1:length(ListPrElements)
        if i == XRef || i == YRef
            continue
        else
            DataPro(:,i) = DefProfils(:,i);
            NameOrder(i) = ListPrElements(i);
        end
    end
    
    Concat = strcat(' (',NameOrder(1));
    for i=2:length(NameOrder),
        Concat = strcat(Concat,'-',ListPrElements(i));
    end,
    Concat = strcat(Concat,')');
    
    Xleft = DefMap(1); Xright = DefMap(2); Ybot = DefMap(3); Ytop = DefMap(4);
    SizeMap = size(Data.map(1).values);
    
    SizeXPixel = abs((Xleft - Xright) / (SizeMap(2) -1 )); % x --> col
    SizeYPixel = abs((Ytop - Ybot) / (SizeMap(1) -1 )); % x --> line
    
    % new profile coordonate computation
    if Xleft < Xright
        XCoo = Xleft : SizeXPixel : Xright;
    else
        XCoo = Xleft : -SizeXPixel : Xright;
    end
    if Ytop > Ybot
        YCoo = Ytop : -SizeYPixel : Ybot;
    else
        YCoo = Ytop : SizeYPixel : Ybot;
    end
    
    IdxAllPr = NaN * zeros(length(DefProfils(:,1)), 2);
    
    
    for i = 1 : length(DefProfils(:,1))
        [V(i,1), IdxAllPr(i,1)] = min(abs(XCoo-DefProfils(i,XRef))); % Index X
        [V(i,2), IdxAllPr(i,2)] = min(abs(YCoo-DefProfils(i,YRef))); % Index Y
    end
    
    handles.profils.xcoo = XCoo;
    handles.profils.ycoo = YCoo; % new option (for correction)
    handles.profils.idxallpr = IdxAllPr;
    handles.profils.data = DataPro;
    handles.profils.elemorder = NameOrder;
    handles.profils.display = strcat(FileName,Concat);
    
    disp(['Import standard file ... (File name:',char(FileName),') ...']);
    disp(['Import standard file ... (Elements: ',char(Concat),'']);
    disp(['Import standard file ... (Number of analyses: ',num2str(length(DataPro)),')']);
    disp(['Import standard file ... (Validity: ',char(num2str(IsM')),')']);
    disp(['Import standard file ... (',char(FileName),') ... Ok']);
    disp(' ')
    
    set(handles.PRAffichage1,'String',strcat(FileName,Concat));
    
    CodeTxt = [8,7];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(FileName),')']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(7)),' (',char(FileName),')']);
    
else
    set(handles.PRAffichage1,'String',[char(handles.TxtDatabase(8).txt(8))]);
    
    CodeTxt = [8,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(4))]);
    return
end

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

% display profils into the map
PRButton3_Callback(hObject, eventdata, handles)
return


% #########################################################################
%     CORRECTION OF THE LOCATION.
function PRButton2_Callback(hObject, eventdata, handles)
% ordre obligatoire : X Y (et pas Y X)
% A modifier dans une version future

ButtonName = questdlg('Temporary test function. Do you want to continue ?', ...
    'Warning');
if length(ButtonName) ~= 3
    return
end

% ---------- Maps Selection ----------
Data = handles.data;
for i=1:length(Data.map)
    ListMap(i) = Data.map(i).name;
    ListRefMap(i) = Data.map(i).ref;
end
[SelectionMap] = listdlg('ListString',ListMap,'SelectionMode','multiple','Name','Select Maps');
LesRefsCarte = ListRefMap(SelectionMap); % Creation de LesRefsMap
LesNamesCartes = ListMap(SelectionMap);

for i=1:length(Data.map) % On test pour toutes les cartes
    a = find(LesRefsCarte-i);
    if length(a) < length(LesRefsCarte)-1;
        warndlg('You selected two of the same element...', 'Cancelation');
        return
    end
end


% ---------- Profil ref ----------
Profils = handles.profils;

ProfilsElem = Profils.elemorder;
ListOri = handles.NameMaps.elements;
[Ok,LesRefsPro] = ismember(ProfilsElem,ListOri); % verification et creation de LesRefsPro


% ---------- Xlag & Yag ----------
% setting input:
Lag = inputdlg({'X-Lag','Y-Lag'},'Input',1,{'10','10'});
XLag = str2num(char(Lag(1)));
YLag = str2num(char(Lag(2)));

for i=1:XLag*2+1
    YMapLag(:,i) = [-YLag:1:YLag]';
end
for i=1:YLag*2+1
    XMapLag(i,:) = [-XLag:1:XLag];
end

[LesLin,LesCol] = size(YMapLag);
Xmin = min(Profils.coord(:,1)); Xmax = max(Profils.coord(:,1));
Ymin = min(Profils.coord(:,2)); Ymax = max(Profils.coord(:,2));

XCoo = Profils.xcoo;
YCoo = Profils.ycoo;

% ---------- Processing ----------
h = waitbar(0,'Please wait...');
for iLin = 1:LesLin
    waitbar(iLin/LesLin,h);
    for iCol = 1:LesCol
        % Setting:
        LesCoor(:,1) = Profils.coord(:,1) + XMapLag(iLin,iCol);
        LesCoor(:,2) = Profils.coord(:,2) + YMapLag(iLin,iCol);
        
        % Control:
        for i=1:length(LesCoor(:,1))
            if LesCoor(i,1) < Xmin || LesCoor(i,1) > Xmax || LesCoor(i,2) < Ymin || LesCoor(i,2) > Ymax
                LesCoor(i,:) = [0,0];
            end
        end
        
        % Indexation:
        for i = 1 : length(LesCoor(:,1))
            if LesCoor(i,1) % > 0
                [V(i,1), Idx(i,1)] = min(abs(XCoo-LesCoor(i,1))); % Index X
                [V(i,2), Idx(i,2)] = min(abs(YCoo-LesCoor(i,2))); % Index Y
            else
                Idx(i,:) = [0,0];
            end
        end
        
        % Correlation
        for i=1:length(LesRefsCarte)
            LaMap = LesRefsCarte(i);
            LePro = find(LesRefsPro == LaMap); % warning, empty cell if missmatch.
            
            LesDataPro = Profils.data(:,LePro);
            for j = 1:length(LesDataPro)
                if Idx(j,1)
                    LesDataRaw(j) = Data.map(LaMap).values(Idx(j,2),Idx(j,1)); % X -> Col
                else
                    LesDataRaw(j) = 0;
                end
            end
            Correl = corrcoef(LesDataPro,LesDataRaw);
            
            Correlation(iLin,iCol,i) = Correl(1,2);
            
        end
        
    end
end

% ---------- Best correlation ----------
close(h)
LaSum = zeros(length(Correlation(:,1,1)),length(Correlation(1,:,1)));
for i=1:length(Correlation(1,1,:))
    LaSum = LaSum + Correlation(:,:,i);
end
figure,
imagesc(LaSum./length(Correlation(1,1,:))), axis image, colorbar('vertical')
title('Best Corr. Average (*** left clic to change ***)')

[V,aL] = max(LaSum);
[V,bL] = max(max(LaSum));

CMax = aL(bL);
LMax = bL;

hold on, plot(LMax,CMax,'.k')

[LMaxinput,CMaxinput,Clique] = XginputX(1,handles);
if Clique < 3
    CMax = round(CMaxinput);
    LMax = round(LMaxinput);
end


% ---------- New coordonates ----------
XCorrection = XMapLag(LMax,CMax);
YCorrection = YMapLag(LMax,CMax);

LesCoordProbe(:,1) = Profils.coord(:,1) + XCorrection;
LesCoordProbe(:,2) = Profils.coord(:,2) + YCorrection;

for i=1:length(LesCoordProbe(:,1))
    if LesCoordProbe(i,1) < Xmin || LesCoordProbe(i,1) > Xmax || LesCoordProbe(i,2) < Ymin || LesCoordProbe(i,2) > Ymax
        LesCoordProbe(i,:) = [0,0];
    end
end

for i = 1 : length(LesCoordProbe(:,1))
    if LesCoordProbe(i,1) % > 0
        [V(i,1), IdxNewPr(i,1)] = min(abs(XCoo-LesCoor(i,1))); % Index X
        [V(i,2), IdxNewPr(i,2)] = min(abs(YCoo-LesCoor(i,2))); % Index Y
    else
        IdxNewPr(i,:) = [0,0];
    end
end


% ---------- Comparison ----------
[SelectionMap2] = listdlg('ListString',LesNamesCartes,'SelectionMode','multiple','Name','Select Maps');
Refs4Display = LesRefsCarte(SelectionMap2);
Names4Display = LesNamesCartes(SelectionMap2);

for i=1:length(Refs4Display)
    for j=1:length(IdxNewPr(:,1))
        if IdxNewPr(j,1)
            DataMapN(j) = Data.map(Refs4Display(i)).values(IdxNewPr(j,2),IdxNewPr(j,1));
            if Profils.idxallpr(j,1)
                DataMapO(j) = Data.map(Refs4Display(i)).values(Profils.idxallpr(j,2),Profils.idxallpr(j,1));
            else
                DataMapO(j) = 0;
            end
        elseif Profils.idxallpr(j,1)
            DataMapN(j) = 0;
            DataMapO(j) = Data.map(Refs4Display(i)).values(Profils.idxallpr(j,2),Profils.idxallpr(j,1));
        else
            DataMapN(j) = 0;
            DataMapO(j) = 0;
        end
    end
    LePro = find(LesRefsCarte == Refs4Display(i)); % warning, empty cell if missmatch.
    DataPr = Profils.data(:,LePro);
    
    figure,
    subplot(2,1,1), plot(DataMapN,'+--r'), hold on, plot(DataMapO,'+-b')
    legend('Corrected','Old')
    subplot(2,1,2), plot(DataPr,'o-k')
    title(strcat('Element: ',Names4Display(i)))
    
end

Resp = questdlg('Do you want to keep new coordonates?','Action','yes','no','no');
if length(Resp) > 2
    Profils.idxallpr = IdxNewPr;
end

handles.profils = Profils;

guidata(hObject,handles);
return


% #########################################################################
%     DISPLAY SPECTRUM PROF/QUANTI (V2.1.1)
function PRButton5_Callback(hObject, eventdata, handles)
Data = handles.data;
Profils = handles.profils;

for i=1:length(Profils.elemorder)
    ListElem(i) = Profils.elemorder(i);
end

Selected = get(handles.PPMenu1,'Value');
ListMap = get(handles.PPMenu1,'String');
NameMap = ListMap(Selected);

Map = Data.map(Selected).values;
RefElem = Data.map(Selected).ref; % Element for profile selection
NameSel = Data.map(Selected).name;

if Data.map(Selected).type == 2
    NameSel = NameSel(1:end-4);
end

OKmaps = ismember(NameSel,ListElem);
WhereBad = find(OKmaps == 0);

if length(WhereBad)
    Str = NameSel;
    
    CodeTxt = [8,10];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),char(Str)]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

Position = find(ismember(ListElem,NameSel)); % On travail maintenant su le nom (Dec/10)

if length(Position) < 1 % Alors on est avec une carte corrig?e et il va falloir aller chercher la r?f?rence
    NameSel = handles.NameMaps.elements(RefElem);
    Position = find(ismember(ListElem,NameSel));
end

% update 2.1.1
DataMapSelected = Data.map(Selected).values;

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    DataMapSelected = DataMapSelected.*handles.corrections(1).mask;
end

IdxAllPr = Profils.idxallpr;

for i=1:length(IdxAllPr(:,1))
    ValPro(i) = Profils.data(i,Position);
    ValMap(i) = DataMapSelected(IdxAllPr(i,2),IdxAllPr(i,1));
end

Correlation = corrcoef(ValPro.*Profils.pointselected',ValMap.*Profils.pointselected');  % edited 1.6.2

ValRapportL = [];

% On cherche a appliquer des barres pour comparer les positions
ComptL = 0;
ValMaxOx = max(ValPro) + 0.1*max(ValPro);
ValMaxMa = max(ValMap) + 0.1*max(ValMap);

XOx = [];
XMa = [];

for i=1:length(ValPro)-1 % On bosse sur les poids d'oxyde bien sur
    LesDeux = [ValPro(i),ValPro(i+1)];
    RapportL = max(LesDeux)/min(LesDeux);
    if RapportL > 1.4 && RapportL < 1000 % inf
        ComptL = ComptL+1;
        XOx(ComptL,:) = [i+0.5 i+0.5];
        YOx(ComptL,:) = [0 ValMaxOx];
        XMa(ComptL,:) = [i+0.5 i+0.5];
        YMa(ComptL,:) = [0 ValMaxMa];
        ValRapportL(ComptL) = RapportL;
    end
end

NMaxL = 10;
if length(ValRapportL) > NMaxL
    [LesV,OuV] = sort(ValRapportL,'descend');
    XOx = XOx(OuV(1:NMaxL),:);
    YOx = YOx(OuV(1:NMaxL),:);
    XMa = XMa(OuV(1:NMaxL),:);
    YMa = YMa(OuV(1:NMaxL),:);
end

ValMinOx = min(ValPro) - 0.1*min(ValPro);
ValMinMa = min(ValMap) - 0.1*min(ValMap);
if ValMinOx < 0; ValMinOx = 0; end
if ValMinMa < 0; ValMinMa = 0; end

figure,
subplot(2,1,1), hold on                                      % edited 1.6.2
for i=1:length(ValPro)
    % point
    if Profils.pointselected(i)
        plot(i,ValPro(i),'or','markersize',5,'MarkerFaceColor','r')
    else
        plot(i,ValPro(i),'ok','markersize',5,'MarkerFaceColor','k')
    end
    
    % line
    if i > 1
        if Profils.pointselected(i) && Profils.pointselected(i-1)
            plot([i-1,i],[ValPro(i-1),ValPro(i)],'-r')
        else
            plot([i-1,i],[ValPro(i-1),ValPro(i)],'-k')
        end
    end
end
%plot(ValPro,'*r-'),
ylabel('Standard data (Wt%)'),

for i=1:size(XOx,1)
    plot(XOx(i,:),YOx(i,:),'-k')
end
axis([1 length(ValPro) ValMinOx ValMaxOx])
set(gca,'xtick',[]);
title(['Element: ',char(NameMap)])


subplot(2,1,2), hold on
for i=1:length(ValMap)
    % point
    if Profils.pointselected(i)
        plot(i,ValMap(i),'og','markersize',5,'MarkerFaceColor','g')
    else
        plot(i,ValMap(i),'ok','markersize',5,'MarkerFaceColor','k')
    end
    
    % line
    if i > 1
        if Profils.pointselected(i) && Profils.pointselected(i-1)
            plot([i-1,i],[ValMap(i-1),ValMap(i)],'-g')
        else
            plot([i-1,i],[ValMap(i-1),ValMap(i)],'-k')
        end
    end
end

%plot(ValMap,'*g-')
ylabel('Map data (counts)')

for i=1:size(XMa,1)
    plot(XMa(i,:),YMa(i,:),'-k')
end
axis([1 length(ValMap) ValMinMa ValMaxMa])
set(gca,'xtick',[]);

if get(handles.CorrButtonBRC,'Value')
    title('BRC correction used - the filtered pixels values are zeros')
end

CodeTxt = [8,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(num2str(Correlation(1,2))),' (',char(NameSel),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(8).txt(9)),' ',char(num2str(Correlation(1,2))),' (',char(NameSel),')']);

disp(['Standards testing ... (Element: ',char(NameSel),') ...']);
disp(['Standards testing ... (Correlation: ',num2str(Correlation(1,2)),')']);
disp(['Standards testing ... (Element: ',char(NameSel),') .... Ok']);
disp(' ');

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);
return


% #########################################################################
%     CHECK THE PROFILE/MAP POSITION (V2.1.1)
function PRButton7_Callback(hObject, eventdata, handles)
%

% [1] Calculate the correlation maps relative to the position of profils

disp('Check ... [Quality Check - Standard/Maps positions]')

% ---------- Data and select maps ----------
Data = handles.data;
for i=1:length(Data.map)
    
    NameSel = Data.map(i).name;
    if Data.map(i).type == 2
        NameSel = NameSel(1:end-4);
    end
    
    ListMap{i} = char(NameSel);
    ListRefMap(i) = Data.map(i).ref;
end
%[SelectionMap] = listdlg('ListString',ListMap,'SelectionMode','multiple','Name','Select Maps');
SelectionMap = 1:i;
LesRefsCarte = ListRefMap(SelectionMap);
LesNamesCartes = ListMap(SelectionMap);


% ---------- Standards spot analyses data ----------
Profils = handles.profils;
ProfilsElem = Profils.elemorder;
ListOri = handles.NameMaps.elements;
[Ok,LesRefsPro] = ismember(ProfilsElem,ListOri); % verification et creation de LesRefsPro

OKmaps = ismember(LesNamesCartes,ProfilsElem);
WhereBad = find(OKmaps == 0);

if length(WhereBad)
    Str = '';
    for i=1:length(WhereBad)
        Str=[Str,LesNamesCartes{WhereBad(i)},' - '];
    end
    Str(end-1:end) = '  ';
    
    CodeTxt = [8,10];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),char(Str)]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    disp(['The following maps have no corresponding elements in the standard data: ',char(Str)])
    disp('Check ... CANCELLED')
    disp(' ')
    return
end


% ---------- XShift & YShift ----------
Shift = inputdlg({'X-Shift      [(XY)ref system]','Y-Shift      [(XY)ref system]'},'Input',1,{'10','10'});
if ~length(Shift)
    return
end
XShift = str2num(char(Shift{1}));
YShift = str2num(char(Shift{2}));

[TheCs,TheRs] = meshgrid(-XShift:1:XShift, -YShift:1:YShift);

Xok = Profils.idxallpr(:,1);


xref = Profils.idxallpr(:,1);
yref = Profils.idxallpr(:,2);

%[x,y] = CoordinatesFromRef(xref,yref,handles);
% The transformation above was uncorrect because we are working in the ref
% system (map is not from Fig's data).

x = xref;
y = yref;

Xmin = 1;
Xmax = size(Data.map(1).values,2);
Ymin = 1;
Ymax = size(Data.map(1).values,1);


for iSchift=1:length(TheCs(:))
    
    xTemp = x + TheCs(iSchift);
    yTemp = y + TheRs(iSchift);
    
    WhereOK = find(xTemp > Xmin & xTemp < Xmax & yTemp > Ymin & yTemp < Ymax);
    
    for i=1:length(SelectionMap)
        LaMap = find(ListRefMap == LesRefsCarte(i));
        LePro = find(LesRefsPro == LesRefsCarte(i));
        LesDataPro = Profils.data(:,LePro);
        
        if length(LaMap)  > 1
            warndlg('You have more than one map for an element !!!','Cancelled')
            return
        end
        
        FinalDataPro = LesDataPro(WhereOK);
        
        Coords = (xTemp-1)* Ymax + yTemp;
        FinalDataRaw = Data.map(LaMap).values(Coords(WhereOK));
        
        Correl = corrcoef(FinalDataRaw,FinalDataPro);
        CorrelationCoef(iSchift,i) = Correl(1,2);
    end
    
end

n=5;

if length(SelectionMap) <= 5
    m=1;
elseif length(SelectionMap) <=10
    m=2;
elseif length(SelectionMap) <=15
    m=3;
elseif length(SelectionMap) <=20
    m=4;
elseif length(SelectionMap) <=25
    m=5;
elseif length(SelectionMap) <=30
    m=6;
elseif length(SelectionMap) <=35
    m=7;
end


figure,
for i=1:length(SelectionMap)
    subplot(m,n,i)
    switch handles.rotateFig
        case 0
            imagesc(TheCs(1,:),TheRs(:,1),XimrotateX(reshape(CorrelationCoef(:,i),size(TheCs,1),size(TheCs,2)),0));  % format [X,Y,MAP]
        case 90
            imagesc(TheRs(:,1),TheCs(1,:),XimrotateX(reshape(CorrelationCoef(:,i),size(TheCs,1),size(TheCs,2)),90));  % format [X,Y,MAP]
        case 180
            imagesc(TheCs(1,:),TheRs(:,1),XimrotateX(reshape(CorrelationCoef(:,i),size(TheCs,1),size(TheCs,2)),180));  % format [X,Y,MAP]        case 270
        case 270
            imagesc(TheRs(:,1),TheCs(1,:),XimrotateX(reshape(CorrelationCoef(:,i),size(TheCs,1),size(TheCs,2)),270));  % format [X,Y,MAP]
    end
    
    %imagesc(reshape(CorrelationCoef(:,i),size(TheCs,1),size(TheCs,2)))
    axis image
    colorbar('horizontal');
    hold on,
    plot(0,0,'*k');                       % original position
    hold off
    
    LaMap = find(ListRefMap == LesRefsCarte(i));
    title(Data.map(LaMap).name);
end


figure
switch handles.rotateFig
    case 0
        imagesc(TheCs(1,:),TheRs(:,1),XimrotateX(reshape(sum(CorrelationCoef.^2,2),size(TheCs,1),size(TheCs,2)),0));  % format [X,Y,MAP]
    case 90
        imagesc(TheRs(:,1),TheCs(1,:),XimrotateX(reshape(sum(CorrelationCoef.^2,2),size(TheCs,1),size(TheCs,2)),90));  % format [X,Y,MAP]
    case 180
        imagesc(TheCs(1,:),TheRs(:,1),XimrotateX(reshape(sum(CorrelationCoef.^2,2),size(TheCs,1),size(TheCs,2)),180));  % format [X,Y,MAP]        case 270
    case 270
        imagesc(TheRs(:,1),TheCs(1,:),XimrotateX(reshape(sum(CorrelationCoef.^2,2),size(TheCs,1),size(TheCs,2)),270));  % format [X,Y,MAP]
end
%imagesc(TheCs(1,:),TheRs(:,1),reshape(sum(CorrelationCoef.^2,2),size(TheCs,1),size(TheCs,2)))
axis image
colorbar('horizontal');
hold on,
plot(0,0,'*k');

LaMap = find(ListRefMap == LesRefsCarte(i));
title('sum(corrcoef^2)');





disp('Check ... done');
disp(' ');



return


% #########################################################################
%     TRANSFER TO QUANTI V2.1.1
function Tranfert2Quanti_Callback(hObject, eventdata, handles)
%

% THE BUTTON HAVE BEEN DELETED BUT THE FUNCTION IS STILL USED !!!
% P. Lanari (24.06.14)
%

% New 2.6.1 - Conversion (30.01.19)
% 
Mode = Menu_XMT({'Do you want to apply any conversion to the maps?'},{ ...
    'NO - transfer to quanti', ...
    'YES - convert from wt% of ELEMENT to ppm of element', ...
    'YES - convert from wt% of OXIDE to ppm of element', ...
    'YES - convert from ppm to wt%', ...
    'YES - convert from ppm of ELEMENT to wt% of oxide', ...
    'YES - convert from Wt% of ELEMENT to wt% of oxide'},handles.LocBase);

switch Mode
    case 1
        Factor = 1;
        AddText = '';
        MFP = '';
        
    case 2
        Factor = 10000;
        AddText = '_ppm';
        MFP = '; multipication factor: 10000 [wt% to ppm]';
        
    case 3
        Factor = 0;
        AddText = '_ppm';
        MFP = '; multipication factor: see list above [wt% to ppm]';
        
    case 4
        Factor = 1/10000;
        AddText = '_wt%';
        MFP = '; multipication factor: 1/10000 [ppm to wt%]';
        
    case 5
        Factor = 0;
        AddText = '_wt%';
        MFP = '; multipication factor: see list above [ppm to wt%]';
        
    case 6
        Factor = 0;
        AddText = '';
        MFP = '; multipication factor: see list above [El(wt%) to Ox(wt%)]';
           
end

Quanti = handles.quanti;

Data = handles.data;
MaskFile = handles.MaskFile;
MaskSelected = get(handles.PPMenu3,'Value');
Selected = get(handles.PPMenu1,'Value');

Mineral = get(handles.PPMenu2,'Value'); % 1 is none
MineralList = get(handles.PPMenu2,'String');
MineralName = MineralList(Mineral);

CodeTxt = [9,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

MethodQ = 'TTQuanti';
if Mineral == 1
    MineralName = 'T2Q';
    LeMaskMin = ones(size(Data.map(1).values));
else
    LeMaskMin = zeros(size(MaskFile(MaskSelected).Mask));
    %keyboard
    LeMaskMin(find(MaskFile(MaskSelected).Mask == Mineral-1)) = ones(length(find(MaskFile(MaskSelected).Mask == Mineral-1)),1);
end

%Name4write = inputdlg('Quanti name','define a name',1,{[char(MineralName),'-',char(MethodQ),AddText]});
Name4write = [char(MineralName),'-',char(MethodQ),AddText];

if length(Name4write) == 0
    CodeTxt = [9,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end

% ---------- Where we are ----------
LaBonnePlace = length(Quanti)+1;

Quanti(LaBonnePlace).mineral = Name4write;
Quanti(LaBonnePlace).isoxide = 0;      % changed later...
Quanti(LaBonnePlace).maskfile = 'not used';
Quanti(LaBonnePlace).nbpoints = 1; % for compatibility

% indexation Maps:
for i=1:length(Data.map)
    ListMap{i} = char(Data.map(i).name);
    ListRefMap(i) = Data.map(i).ref;
end

CodeTxt = [9,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);


AutoSelect = [1:1:length(ListMap)];
[SelectionMap] = listdlg('ListString',ListMap,'SelectionMode','multiple','Name','Select Maps','InitialValue',AutoSelect);

if SelectionMap
    LesRefsCarte = ListRefMap(SelectionMap); % Creation de LesRefsMap
    LesNamesCartes = ListMap(SelectionMap);
else
    CodeTxt = [9,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end

if isequal(Data.map(SelectionMap(1)).type,4)
    Quanti(LaBonnePlace).isoxide = 1;
else
    Quanti(LaBonnePlace).isoxide = 2; % SPECIAL
end

% Border Removing Correction:
if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    BRCmask = handles.corrections(1).mask;
else
    BRCmask = ones(size(Data.map(1).values));
end

%LesNomsOxydes = handles.NameMaps.oxydes(LesRefsCarte); % On indexe selon l'ordre des cartes

if isequal(Mode,3)
    
    disp(' ')
    fprintf('\t%s\n','Conversion factors (defined in /Dev/XMap_ConversionFactors.txt):')
    
    ConversionFactor = handles.ConversionFactor;
    ListElemCF = ConversionFactor.ListElem;
    FactorsCF = 1./ConversionFactor.Factors;
    
    FactorList = ones(size(SelectionMap))*10^-4;
    for i = 1:length(LesNamesCartes)
        
        Where = find(ismember(ListElemCF,char(LesNamesCartes{i})));
        
        if isempty(Where)
            fprintf('\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),FactorList(i),'WARNING: isotope not found!');
        else
            FactorList(i) = FactorsCF(Where);
            fprintf('\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),FactorList(i),'Ok');
        end
    end
    disp(' ')
    
    
elseif isequal(Mode,5) % added in 3.3.1 (19.11.19)
    
    disp(' ')
    fprintf('\t%s\n','Conversion factors (defined in /Dev/XMap_ConversionFactors.txt):')
    
    ConversionFactor = handles.ConversionFactor;
    ListElemCF = ConversionFactor.ListElem;
    FactorsCF = ConversionFactor.Factors;
    
    FactorList = ones(size(SelectionMap))*10^-4;
    for i = 1:length(LesNamesCartes)
        
        Where = find(ismember(ListElemCF,char(LesNamesCartes{i})));
        
        if isempty(Where)
            fprintf('\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),FactorList(i),'WARNING: isotope not found!');
        else
            FactorList(i) = FactorsCF(Where);
            fprintf('\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),FactorList(i),'Ok');
        end
    end
    disp(' ')
    
    
elseif isequal(Mode,6) % added in 3.3.2 (18.12.19)
    
    OxideData = handles.OxideData;
    
    disp(' ')
    fprintf('\t%s\n','Conversion factors (defined in /Dev/XMap_OxideData.txt):')
    
    ListElemCF =OxideData.ListElem;
    ListOxide = OxideData.ListOxide;
    
    FactorList = ones(size(SelectionMap));
    NameOxideFinalList = {};
    
    for i = 1:length(LesNamesCartes)
        Where = find(ismember(ListElemCF,char(LesNamesCartes{i})));
        
        if length(Where) > 1
            
            CodeTxt = [9,13];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',LesNamesCartes{i}]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            SmallOxList = ListOxide(Where);
            [SEL,Ok] = listdlg('ListString',SmallOxList,'Name',['Oxide for ',LesNamesCartes{i}]);
            
            if ~Ok
                SEL = 1; % we do not cancel
            end
            
            CodeTxt = [9,14];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            SelCase = Where(SEL);
            FactorList(i) = 1./OxideData.Factors(SelCase);
            NameOxideFinalList{i} = ListOxide{SelCase};
            
            fprintf('\t%s\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),char(NameOxideFinalList{i}),FactorList(i),'OK');
            
        elseif ~isempty(Where)
            SelCase = Where;
            FactorList(i) = 1./OxideData.Factors(SelCase);
            NameOxideFinalList{i} = ListOxide{SelCase};
            
            fprintf('\t%s\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),char(NameOxideFinalList{i}),FactorList(i),'OK');
        else
            NameOxideFinalList{i} = LesNamesCartes{i};
            fprintf('\t%s\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),char(NameOxideFinalList{i}),FactorList(i),'WARNING... Element not found');
        end
       
    end
    
    disp(' ')
    
else
    FactorList = Factor*ones(size(SelectionMap));
end

for i=1:length(LesRefsCarte)
    Quanti(LaBonnePlace).elem(i).ref = LesRefsCarte(i);
    if isequal(Mode,6)
        Quanti(LaBonnePlace).elem(i).name = NameOxideFinalList{i};
    else
        Quanti(LaBonnePlace).elem(i).name = LesNamesCartes{i}; % LesNomsOxydes{i};     %  changed 2.6.1
    end
    Quanti(LaBonnePlace).elem(i).values = 1;
    Quanti(LaBonnePlace).elem(i).coor = [1,1];
    Quanti(LaBonnePlace).elem(i).raw = 1;
    Quanti(LaBonnePlace).elem(i).param = [1,1];
    %if Mineral == 1
    %    Quanti(LaBonnePlace).elem(i).quanti = Data.map(i).values .* BRCmask;
    %else
    Quanti(LaBonnePlace).elem(i).quanti = Data.map(SelectionMap(i)).values .* LeMaskMin .* BRCmask *FactorList(i);
    %fprintf('\t%s\t%.10f\t%s\n',char(LesNamesCartes{i}),FactorList(i),'CHECK');
    %end
end 

if isequal(Mode,6)
    Quanti(LaBonnePlace).listname = NameOxideFinalList;
else
    Quanti(LaBonnePlace).listname = LesNamesCartes; % On va garder les elements
end

%Quanti(LaBonnePlace).listname = LesNomsOxydes;

% - - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% EN DESSOUS LA FIN DE LA FONCTION QUANTI

handles.quanti = Quanti;

% ---------- Update Mineral Menu QUppmenu2 ----------
for i=1:length(Quanti)
    NamesQuanti{i} = char(Quanti(i).mineral);
end

set(handles.QUppmenu2,'String',NamesQuanti);
set(handles.QUppmenu2,'Value',LaBonnePlace);
set(handles.QUtexte1,'String',strcat(num2str(Quanti(LaBonnePlace).nbpoints),' pts'));

% ---------- Update Wt% Menu QUppmenu1 ----------
set(handles.QUppmenu1,'String',Quanti(LaBonnePlace).listname);


% ---------- Display mode 2 ----------
%handles.currentdisplay = 2; % Input change
%set(handles.PPMenu2,'Value',1); % Input Change
%set(handles.REppmenu1,'Value',1); % Input Change

set(handles.FIGbutton1,'Value',0); % median filter

ValMin = get(handles.QUppmenu2,'Value');
AllMin = get(handles.QUppmenu2,'String');
SelMin = AllMin(ValMin);
if char(SelMin) == char('.')
    warndlg('map not yet quantified','cancelation');
    return
end

%
ValOxi = 1;
set(handles.QUppmenu1,'Value',ValOxi);

cla(handles.axes1,'reset');
axes(handles.axes1)
imagesc(Quanti(ValMin).elem(ValOxi).quanti), axis image, colorbar('peer',handles.axes1,'vertical')
set(handles.axes1,'xtick',[], 'ytick',[]);
handles = XMapColorbar('Auto',1,handles);

%zoom on                                                         % New 1.6.2

handles.HistogramMode = 0;
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0;
%cla(handles.axes2);
%axes(handles.axes2), hist(Quanti(ValMin).elem(ValOxi).quanti(find(Quanti(ValMin).elem(ValOxi).quanti(:) ~= 0)),30)

AADonnees = Quanti(ValMin).elem(ValOxi).quanti(:);
Min = min(AADonnees(find(AADonnees(:) > 0)));
Max = max(AADonnees(:));

set(handles.ColorMin,'String',Min);
set(handles.ColorMax,'String',Max);
set(handles.FilterMin,'String',Min);
set(handles.FilterMax,'String',Max);

Value = get(handles.checkbox1,'Value');
axes(handles.axes1);
if Max > Min
    caxis([Min,Max]);
end
% if Value == 1
% 	colormap([0,0,0;jet(64)])
% else
%     colormap([jet(64)])
% end

disp(['Quantification processing ... (',char(MineralName),') ...']);
for i=1:length(LesNamesCartes)
    disp(['Quantification processing ... (',num2str(i),' - ',char(LesNamesCartes(i)),': ',num2str(Quanti(LaBonnePlace).elem(i).param(1)),'/',num2str(Quanti(LaBonnePlace).elem(i).param(2)),MFP,')']);
end
disp(['Quantification processing ... (',char(MineralName),') ... Ok']);
disp(' ');

CodeTxt = [9,6];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Name4write),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(6)),' (',char(Name4write),')']);

% set(handles.OPT,'Value',2); % on passe au panneau 2

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);
handles = AffOPT(2, hObject, eventdata, handles); % Maj 1.4.1
%AffPAN(hObject, eventdata, handles);
OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%     PRECISION MAP (V1.6.2)
function MButton4_Callback(hObject, eventdata, handles)

MaskFile = handles.MaskFile;
MaskSelected = get(handles.PPMenu3,'Value');

% Display
Selected = get(handles.PPMenu1,'Value');
Data = handles.data;

DispName = Data.map(Selected).name;

MineralSelected = get(handles.PPMenu2,'Value');
minName = get(handles.PPMenu2,'String');

if MineralSelected < 2
    MatrixData = Data.map(Selected).values;
    %minName = 'not selected';
else
    RefMin = MineralSelected - 1;
    PourCalcul = MaskFile(MaskSelected).Mask == RefMin;
    MatrixData = Data.map(Selected).values .* PourCalcul;
end

% Initialisations
PrecMap = zeros(size(MatrixData));
[nLin,nCol] = size(MatrixData);

for i=1:length(MatrixData(:))
    if MatrixData(i)
        PrecMap(i) = 2./sqrt(MatrixData(i)).*100;            % edited 1.6.2
    else
        PrecMap(i) = 0;
    end
end

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    PrecMap = PrecMap.*handles.corrections(1).mask;
end

Data2Plot = reshape(PrecMap,nLin,nCol);
DataCMin = min(PrecMap(find(PrecMap)));
DataCMax = max(PrecMap(find(PrecMap)));

figure
imagesc(XimrotateX(Data2Plot,handles.rotateFig)), axis image, hc = colorbar('vertical'); colormap(handles.activecolorbar);

caxis([DataCMin,DataCMax]);
title({['Precision (%, 2sigma) elem: ',char(DispName(1)),' & Min: ',char(minName(MineralSelected))],'LINEAR color scale'});

set(gca,'FontName','Times New Roman')
set(gca,'xtick',[], 'ytick',[]);
set(gca,'FontSize',10)

figure
imagesc(XimrotateX(log(Data2Plot),handles.rotateFig)), axis image, hc = colorbar('vertical'); colormap(handles.activecolorbar);

caxis([log(DataCMin),log(DataCMax)]);
title({['Precision (%, 2sigma) elem: ',char(DispName(1)),' & Min: ',char(minName(MineralSelected))],'LOG color scale'});

set(gca,'FontName','Times New Roman')
set(gca,'xtick',[], 'ytick',[]);
set(gca,'FontSize',10)

Labels = get(hc,'YTickLabel');
for i = 1:length(Labels)
    LabelsOk{i} = num2str(round(exp(str2num(char(Labels(i,:))))),'%.0f');
end
set(hc,'YTickLabel',LabelsOk);

return


% #########################################################################
%     CLEAR THE FIGURE AXES 1 TO EDIT PROFILS (NEW V2.4.1)
function CleanImageAxeForStd(hObject, eventdata, handles)
%

lesInd = get(handles.axes1,'child');
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if ~isequal(leType,'image');
        delete(lesInd(i));
    end
end

drawnow
% axes(handles.axes1);
% set(gcf, 'WindowButtonMotionFcn', @mouseMove);
%
% ActivateZoomFigure1(hObject, eventdata, handles);
%
%
% CleanAxes2(handles);
return


% #########################################################################
%     EDIT PROFILS - SELECT / UNSELECT POINTS (NEW V1.6.2)
function PRButton6_Callback(hObject, eventdata, handles)
%

% Activate the correction mode:
handles.CorrectionMode = 1;
guidata(hObject,handles);

OnEstOu(hObject, eventdata, handles);


% first plot the current selected profils:
CleanImageAxeForStd(hObject, eventdata, handles);
PRButton3_Callback(hObject, eventdata, handles);


CodeTxt = [7,12];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

clique = 1;
axes(handles.axes1); hold on

coordinates = handles.profils.idxallpr;                   % REF coordinates

while clique < 2
    [a,b,clique] = XginputX(1,handles);
    
    % -- Now we are working with the Ref coordinates (For projection)
    
    if clique < 2
        
        sumEcart = abs(coordinates(:,1)-a) + abs(coordinates(:,2)-b);
        selected = find(sumEcart == min(sumEcart));
        
        if handles.profils.pointselected(selected) == 1
            handles.profils.pointselected(selected) = 0;
        else
            handles.profils.pointselected(selected) = 1;
        end
        
        guidata(hObject,handles);
        
        % first plot the current selected profils:
        CleanImageAxeForStd(hObject, eventdata, handles);
        PRButton3_Callback(hObject, eventdata, handles);
        
        
    else
        break
    end
end


CodeTxt = [7,13];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);


%GraphStyle(hObject, eventdata, handles)                % to hide the button
%zoom on
guidata(hObject,handles);

% Activate the correction mode:
handles.CorrectionMode = 0;
guidata(hObject,handles);

OnEstOu(hObject, eventdata, handles);

return


% #########################################################################
%     X-PAD -> UP (NEW V2.1.1)
function ButtonUp_Callback(hObject, eventdata, handles)
%
FunctionXPadDisplacement(hObject, eventdata, handles, 1);
return

% #########################################################################
%     X-PAD -> DOWN (NEW V2.1.1)
function ButtonDown_Callback(hObject, eventdata, handles)
%
FunctionXPadDisplacement(hObject, eventdata, handles, 2);
return

% #########################################################################
%     X-PAD -> RIGHT (NEW V2.1.1)
function ButtonRight_Callback(hObject, eventdata, handles)
%
FunctionXPadDisplacement(hObject, eventdata, handles, 3);
return

% #########################################################################
%     X-PAD -> LEFT (NEW V2.1.1)
function ButtonLeft_Callback(hObject, eventdata, handles)
%
FunctionXPadDisplacement(hObject, eventdata, handles, 4);
return


% #########################################################################
%     X-PAD APPLY BUTTON (NEW V2.1.1)
function ButtonXPadApply_Callback(hObject, eventdata, handles)
%

switch get(handles.ButtonXPadApply,'UserData')
    
    case 1   %  SPC
        
        % We have to check that the spot analyses are in the mapped area
        
        MapXMax = size(handles.data.map(1).values,2);   % rows
        MapYMax = size(handles.data.map(1).values,1);   % columns
        
        % We generate a new profils variable without the rejected points...
        
        Profils = handles.profils;
        
        ThoseOK = find(Profils.idxallpr(:,1) > 0 & Profils.idxallpr(:,1) < MapXMax+1 & Profils.idxallpr(:,2) > 0 & Profils.idxallpr(:,2) < MapYMax+1);
        
        if ~length(ThoseOK)
            return
        end
        
        NewProfils.elemorder = Profils.elemorder;
        NewProfils.display = Profils.display;
        NewProfils.xcoo = Profils.xcoo;
        NewProfils.ycoo = Profils.xcoo;
        
        
        NewProfils.coord = Profils.coord(ThoseOK,:);
        NewProfils.idxallpr = Profils.idxallpr(ThoseOK,:);
        NewProfils.data = Profils.data(ThoseOK,:);
        NewProfils.pointselected = Profils.pointselected(ThoseOK);
        NewProfils.idxallprORI = Profils.idxallprORI(ThoseOK,:);
        
        
        handles.profils = NewProfils;
        guidata(hObject, handles);
        
        % -> Cleaning
        PRButton4_Callback(hObject, eventdata, handles);
        
        % unactivate the mode
        set(handles.ButtonXPadApply,'UserData',0,'visible','off');
        
        disp(['SPC ... X correction of ',num2str(handles.profils.idxallpr(1,1)-handles.profils.idxallprORI(1,1)),' pixels applied ... OK']);
        disp(['SPC ... Y correction of ',num2str(handles.profils.idxallpr(1,2)-handles.profils.idxallprORI(1,2)),' pixels applied ... OK']);
        
        % -> Display the new coordonates Std analyses
        PRButton3_Callback(hObject, eventdata, handles);
        
        ValueDispCoord = get(handles.DisplayCoordinates,'Value');
        axes(handles.axes1)
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',1);
        end
        zoom on
        
        disp('SPC ... Done')
        disp(' ')
        
        CodeTxt = [15,14];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        set(handles.CorrPopUpMenu1,'value',1);
        
        
        guidata(hObject, handles);
        OnEstOu(hObject, eventdata, handles)
        
        ValueDispCoord = get(handles.DisplayCoordinates,'UserData'); % here I used the UserData variable to remember the user choice before the correction mode...
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',1);
        end
        
        return
        
        
    case 2 % MPC
        
        % Changes where made, so just exit the mode...
        
        % unactivate the mode
        set(handles.ButtonXPadApply,'UserData',0,'visible','off');
        
        % Come back to VER_XMapTools_804 normal use:
        ValueDispCoord = get(handles.DisplayCoordinates,'Value');
        axes(handles.axes1)
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',1);
        end
        
        zoom on
        
        disp('MPC ... Done')
        disp(' ')
        
        CodeTxt = [15,21];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        set(handles.CorrPopUpMenu1,'value',1);
        
        
        guidata(hObject, handles);
        OnEstOu(hObject, eventdata, handles)
        return
        
end

return


% #########################################################################
%     X-PAD GENERAL FUNCTION (NEW V2.1.1)
function FunctionXPadDisplacement(hObject, eventdata, handles, Dir)
%
% 1_Up - 2_Down - 3_Right - 4_Left

switch get(handles.ButtonXPadApply,'UserData')
    
    case 1   %  SPC
        
        % -> Cleaning
        PRButton4_Callback(hObject, eventdata, handles);
        
        % we plot the old profils...
        Profils = handles.profils;
        
        
        % Display the original positions...
        
        xrefORI = handles.profils.idxallprORI(:,1);
        yrefORI = handles.profils.idxallprORI(:,2);
        
        [xORI,yORI] = CoordinatesFromRef(xrefORI,yrefORI,handles);
        
        axes(handles.axes1)
        hold on
        for i=1:length(Profils.pointselected)
            if Profils.pointselected(i)
                plot(xORI(i),yORI(i),'+w')
                plot(xORI(i),yORI(i),'ow','markersize',4,'LineWidth',2)
            else
                plot(xORI(i),yORI(i),'+w')
                plot(xORI(i),yORI(i),'ow','markersize',4,'LineWidth',2)
            end
        end
        
        
        % Apply the correction
        
        xref = Profils.idxallpr(:,1);
        yref = Profils.idxallpr(:,2);
        
        [x,y] = CoordinatesFromRef(xref,yref,handles);
        
        switch Dir
            
            case 1 % Up
                NewX = x;
                NewY = y - 1;
                
            case 2 % Down
                NewX = x;
                NewY = y + 1;
                
            case 3 % Right
                NewX = x + 1;
                NewY = y;
                
            case 4 % Left
                NewX = x - 1;
                NewY = y;
                
        end
        
        [Newxref,Newyref] = CoordinatesFromFig(NewX,NewY,handles);
        
        handles.profils.idxallpr(:,1) = Newxref;
        handles.profils.idxallpr(:,2) = Newyref;
        guidata(hObject, handles);
        
        % -> Display the new coordonates Std analyses
        PRButton3_Callback(hObject, eventdata, handles);
        
        set(handles.PRButton6,'enable','off');
        
        
    case 2
        
        %
        Selected = get(handles.PPMenu1,'Value');
        Shift = handles.data.map(Selected).shift;
        
        % Apply the correction
        
        switch Dir
            
            case 1 % Up
                Shift(1) = Shift(1) - 1;
                
            case 2 % Down
                Shift(1) = Shift(1) + 1;
                
            case 3 % Right
                Shift(2) = Shift(2) + 1;
                
            case 4 % Left
                Shift(2) = Shift(2) - 1;
                
        end
        
        [nL,nC] = size(handles.data.map(Selected).valuesORI);
        
        dL = Shift(1);
        dC = Shift(2);
        
        Dmat = zeros(nL+abs(dL),nC+abs(dC));
        
        Dmat(1+abs(dL)+dL:nL+abs(dL)+dL,1+abs(dC)+dC:nC+abs(dC)+dC) = handles.data.map(Selected).valuesORI;
        
        Tmat = Dmat(1+abs(dL):nL+abs(dL),1+abs(dC):nC+abs(dC));
        
        
        % Update the data
        handles.data.map(Selected).values = Tmat;
        handles.data.map(Selected).shift = Shift;
        
        guidata(hObject, handles);
        
        % Update display
        PPMenu1_Callback(hObject, eventdata, handles)
        
end



return


% #########################################################################
%     CORRECTION - RUN (NEW V2.1.1)
function CorrButton1_Callback(hObject, eventdata, handles)
% Run the corrections

LaQuelle = get(handles.CorrPopUpMenu1,'Value');

switch LaQuelle
    
    % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 2     % BORDER REMOVE CORRECTION
        
        CorrTitle= 'BRC';
        
        MaskFile = handles.MaskFile;
        TheSel = get(handles.PPMenu3,'Value');
        
        % Set the correction scheme
        
        CodeTxt = [15,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (BCR)']);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        prompt={'X size of the window (X > 2 in px; odd number):','Q Reject criterion (Q in %)'};
        name='Input for BRC correction';
        numlines=1;
        defaultanswer={'3','100'};
        
        TheAnswers=inputdlg(prompt,name,numlines,defaultanswer);
        
        if ~length(TheAnswers)
            CodeTxt = [14,3];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
        end
        
        
        TheNbPx = str2num(TheAnswers{1});
        TheNbPxOnGarde = str2num(TheAnswers{2});
        
        % TEST for parity
        if ~mod(TheNbPx,2)
            CodeTxt = [15,19];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
        end
        
        
        % Proceed to the correction
        TheLin = size(MaskFile(TheSel).Mask,1);
        TheCol = size(MaskFile(TheSel).Mask,2);
        %CoordMatrice = reshape([1:TheLin*TheCol],TheLin,TheCol);
        
        TheMaskFinal = zeros(size(MaskFile(TheSel).Mask));
        
        Position = round(TheNbPx/2);
        TheNbPxInSel = TheNbPx^2;
        TheCriterion = TheNbPxInSel*TheNbPxOnGarde/100;
        
        for i=1:MaskFile(TheSel).Nb                % for each phase
            
            TheMask = zeros(size(MaskFile(TheSel).Mask));
            VectorOk = find(MaskFile(TheSel).Mask == i);
            
            TheMask(VectorOk) = ones(size(VectorOk));
            
            TheWorkingMat = zeros(size(TheMask,1)*size(TheMask,2),TheNbPxInSel+1);
            
            VectMask = TheMask(:);
            TheWorkingMat(find(VectMask)) = 1000*ones(size(find(VectMask)));
            
            Compt = 1;
            for iLin = 1:TheNbPx
                
                
                for iCol = 1:TheNbPx
                    
                    % SCAN
                    TheTempMat = zeros(size(TheMask));
                    TheTempMat(Position:end-(Position-1),Position:end-(Position-1)) = TheMask(iLin:end-(TheNbPx-iLin),iCol:end-(TheNbPx-iCol));
                    Compt = Compt+1;
                    TheWorkingMat(:,Compt) = TheTempMat(:);
                    
                end
            end
            
            TheSum = sum(TheWorkingMat,2);
            OnVire1 = find(TheSum < 1000+TheCriterion & TheSum > 1000);
            TheMaskFinal(OnVire1) = ones(size(OnVire1));
            
        end
        
        TheMaskFinalInv = ones(size(TheMaskFinal));
        TheMaskFinalInv(find(TheMaskFinal(:) == 1)) = zeros(length(find(TheMaskFinal(:) == 1)),1);
        
        % Save the correction 1
        handles.corrections(1).value = 1;
        handles.corrections(1).mask = TheMaskFinalInv;
        
        %figure, imagesc(TheMaskFinalInv), axis image, colorbar
        
        set(handles.CorrButtonBRC,'Enable','on','Value',1);
        CorrButtonBRC_Callback(hObject, eventdata, handles)
        
        
        
        % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 3    % TOPO-RELATED CORRECTION
        
        CorrTitle = 'TRC';
        
        Data = handles.data.map;
        
        % BRC correction
        if get(handles.CorrButtonBRC,'Value') == 1
            for i=1:length(Data)
                
                % save first the value before replacing them
                WhereWeSave = find(handles.corrections(1).mask == 0);
                SavePxValues(i).values = zeros(size(handles.corrections(1).mask));
                SavePxValues(i).values(WhereWeSave) = Data(i).values(WhereWeSave);Data(i).values(WhereWeSave);
                
                % replace the values by zeros !
                Data(i).values = Data(i).values .*handles.corrections(1).mask;
            end
        end
        
        TheSelMask = get(handles.PPMenu3,'Value');
        MaskFile = handles.MaskFile(TheSelMask);
        
        ValueDispCoord = get(handles.DisplayCoordinates,'Value');
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',0);
        end
        zoom off
        
        PositionXMapTools = get(gcf,'Position');
        
        % New 2.5.1
        zoom off
        handles.CorrectionMode = 1;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles);
        
        [CorrMatrix,OrdoMatrix,OK] = XMTModTRC(Data,MaskFile,PositionXMapTools);
        
        % New 2.5.1
        zoom on
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',1);
        end
        
        % ## Apply the correction to X-ray maps ##
        
        if OK == 1
            
            ListName = '';
            for i=1:length(Data)
                ListName{i} = char(Data(i).name);
            end
            
            WhereIsTopo = find(ismember(ListName,'TOPO'));
            
            
            disp('TRC ... [Topo-Related Correction]')
            
            for iMask=2:size(CorrMatrix,2) % Masks          % here from 2 ! This means that we don't apply the correction to the entire map...
                
                TheMask = zeros(size(MaskFile.Mask));
                VectorOk = find(MaskFile.Mask == iMask-1);
                TheMask(VectorOk) = ones(size(VectorOk));
                
                for iElem = 1:size(CorrMatrix,1); % Elements
                    
                    if CorrMatrix(iElem,iMask) ~= 0
                        Xray = Data(iElem).values .* TheMask;
                        Topo = Data(WhereIsTopo).values .* TheMask;
                        
                        %Ycorr = Yall - CorrMatrix(iElem,iMask)*Xall;
                        
                        OldData = Data(iElem).values;
                        NewXray = Xray - CorrMatrix(iElem,iMask)*Topo;
                        
                        WarnZeros = 0;
                        FindZeros = find(NewXray(:) == 0);
                        if ~isempty(FindZeros)
                            NewXray(FindZeros) = zeros(size(FindZeros));
                            WarnZeros = 1;
                        end
                        
                        Data(iElem).values(find(Xray)) = NewXray(find(Xray));
                        
                        % Here isf you want to display the correction you
                        % should use:
                        %figure, imagesc(Data(iElem).values-OldData), axis image, colorbar
                        
                        disp(['TRC ... (correction of ',num2str(CorrMatrix(iElem,iMask)),' applied to: ',char(ListName{iElem}),' for ',char(MaskFile.NameMinerals{iMask}),') ... Ok']);
                        if WarnZeros
                            disp(['        WARNING: ',char(ListName{iElem}),' There were ',char(num2str(length(FindZeros))),' pixels with negative values that have been replaced by zeros ']);
                        end
                    end
                end
                
            end
            
            % BRC correction
            if get(handles.CorrButtonBRC,'Value') == 1
                for i=1:length(Data)
                    
                    % Add the original values of BRC rims to the corrected
                    % maps and display a warning !!!
                    
                    Data(i).values = Data(i).values + SavePxValues(i).values;
                end
            end
            
            
            handles.data.map = Data;
            handles.corrections(2).value = 1;
            
            guidata(hObject, handles);
            PPMenu1_Callback(hObject, eventdata, handles)
            disp('TRC ... Done')
            disp(' ')
            if get(handles.CorrButtonBRC,'Value') == 1
                disp('     WARNING: BRC was active the filtered pixels have not been corrected ...');
                disp(' ')
            end
        end
        
        
        
        % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 4    % Map Position Correction
        
        disp('MPC ... [Map Position Correction]')
        
        
        ValueDispCoord = get(handles.DisplayCoordinates,'Value');
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',0);
            set(handles.DisplayCoordinates,'UserData',1);
        end
        
        zoom reset
        zoom out
        
        %ButtonName = questdlg({'Would you like to calculate correlation maps','for different spot analyses positions'}, 'SPC', 'Yes');
        ButtonName = 'No';
        
        switch ButtonName
            
            case 'Yes'
                PRButton7_Callback(hObject, eventdata, handles);
                
            case 'No'
                % nothing happend here ...
                
            case 'Cancel'
                set(handles.CorrPopUpMenu1,'value',1)
                
                guidata(hObject, handles);
                OnEstOu(hObject, eventdata, handles)
                return
                
        end
        
        % -> Define the shift variable
        Selected = get(handles.PPMenu1,'Value');
        
        % Here if a correction was done before, this correction and the
        % oridata are saved...
        if ~isfield(handles.data.map(Selected),'shift')
            handles.data.map(Selected).shift = [0,0];
        end
        if ~isfield(handles.data.map(Selected),'valuesORI')
            handles.data.map(Selected).valuesORI = handles.data.map(Selected).values;
        end
        
        if length(handles.data.map(Selected).shift) < 2  % WARNING
            % Here this means that we used the correction for an other
            % map...
            handles.data.map(Selected).shift = [0,0];
            handles.data.map(Selected).valuesORI = handles.data.map(Selected).values;
        end
        
        % Activate the Correction Mode
        set(handles.ButtonXPadApply,'UserData',2,'Visible','on');                 % mode 1
        
        CodeTxt = [15,20];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        drawnow
        guidata(hObject, handles);
        OnEstOu(hObject, eventdata, handles);  % All button will be hidden...
        %set(handles.CorrButton1,'enable','off');
        set(handles.PRButton6,'enable','off');
        guidata(hObject, handles);
        return
        
        % The end of this function is in the APPLY button !!!!
        % We have to activate a editing mode in which all the buttons are
        % unable.
        
        
        % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 5    % Coordinates of Standards spot analyses
        
        % first display the spot analyses
        % -> Cleaning
        %PRButton4_Callback(hObject, eventdata, handles);
        
        % -> I used the function that work to display
        %PRButton3_Callback(hObject, eventdata, handles);
        
        disp('SPC ... [Standard Position Correction]')
        
        ValueDispCoord = get(handles.DisplayCoordinates,'Value');
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',0);
            set(handles.DisplayCoordinates,'UserData',1);
        end
        %zoom off
        
        
        %ButtonName = questdlg({'Would you like to calculate correlation maps','for different spot analyses positions'}, 'SPC', 'Yes');
        ButtonName = 'No';
        
        switch ButtonName
            
            case 'Yes'
                PRButton7_Callback(hObject, eventdata, handles);
                
            case 'No'
                % nothing happend here ...
                
            case 'Cancel'
                set(handles.CorrPopUpMenu1,'value',1)
                
                guidata(hObject, handles);
                OnEstOu(hObject, eventdata, handles)
                return
                
        end
        
        
        % -> Display first the profils
        PRButton3_Callback(hObject, eventdata, handles);
        
        % -> Save the original positions... (last saved)
        handles.profils.idxallprORI = handles.profils.idxallpr;
        
        % Activate the Correction Mode
        set(handles.ButtonXPadApply,'UserData',1,'Visible','on');                 % mode 1
        
        
        CodeTxt = [15,13];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        drawnow
        guidata(hObject, handles);
        OnEstOu(hObject, eventdata, handles);  % All button will be hidden...
        %set(handles.CorrButton1,'enable','off');
        set(handles.PRButton6,'enable','off');
        guidata(hObject, handles);
        return
        
        % The end of this function is in the APPLY button !!!!
        % We have to activate a editing mode in which all the buttons are
        % unable.
        
        
        
        % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 6     % INTENSITY DRIFT CORRECTION
        
        CorrTitle = 'IDC';
        
        Data = handles.data.map;
        
        TheSelMask = get(handles.PPMenu3,'Value');
        MaskFile = handles.MaskFile(TheSelMask);
        
        ValueDispCoord = get(handles.DisplayCoordinates,'Value');
        if ValueDispCoord
            set(handles.DisplayCoordinates,'Value',0);
        end
        zoom off
        
        PositionXMapTools = get(gcf,'Position');
        
        % New 2.5.1
        zoom off
        handles.CorrectionMode = 1;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles);
        
        [CorrData,Correction] = XMTModIDC(Data,MaskFile,PositionXMapTools);
        
        % New 2.5.1
        zoom on
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        
        if isequal(CorrData,0) && isequal(Correction,0)
            CodeTxt = [15,17];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
        end
        
        disp('IDC ... [Intensity Drift Correction]')
        disp(' ')
        
        ButtonName = questdlg({'Would you like to save the corrected X-ray map(s)?','The text files will be stored in .../Corrected-Maps/'}, 'IDC', 'Yes');
        
        switch ButtonName
            case 'Yes'
                
                [Success,Message,MessageID] = mkdir('Corrected-Maps');
                
                cd Corrected-Maps
                for i = 1:length(Correction)
                    if Correction(i) > 0
                        TheMap = CorrData(i).corrvalues;
                        disp(['IDC ... (Saving corrected map: ',[char(CorrData(i).name),'.txt'],') ... Ok'])
                        % keyboard
                        save([char(CorrData(i).name),'.txt'],'TheMap','-ASCII');
                    end
                end
                cd ..
                
                disp(' ')
        end
        
        
        % Save the corrected maps...
        
        for i=1:length(Data)
            if Correction(i) > 0
                Data(i).values = CorrData(i).corrvalues;
                disp(['IDC ... (The map: ',[char(CorrData(i).name),' has been corrected'],') ... Ok'])
            end
        end
        disp(' ')
        
        handles.data.map = Data;
        
        %         if ValueDispCoord
        %             set(handles.DisplayCoordinates,'Value',1);
        %         end
        %
        %         % ## Apply the correction to X-ray maps ##
        %
        %         if OK == 1
        %
        %             ListName = '';
        %             for i=1:length(Data)
        %                 ListName{i} = char(Data(i).name);
        %             end
        %
        %             WhereIsTopo = find(ismember(ListName,'TOPO'));
        %
        %
        %             disp('TRC ... [Topo-Related Correction]')
        %
        %             for iMask=2:size(CorrMatrix,2) % Masks          % here from 2 ! This means that we don't apply the correction to the entire map...
        %
        %                 TheMask = zeros(size(MaskFile.Mask));
        %                 VectorOk = find(MaskFile.Mask == iMask-1);
        %                 TheMask(VectorOk) = ones(size(VectorOk));
        %
        %                 for iElem = 1:size(CorrMatrix,1); % Elements
        %
        %                     if CorrMatrix(iElem,iMask) ~= 0
        %                         Xray = Data(iElem).values .* TheMask;
        %                         Topo = Data(WhereIsTopo).values .* TheMask;
        %
        %                         %Ycorr = Yall - CorrMatrix(iElem,iMask)*Xall;
        %
        %                         OldData = Data(iElem).values;
        %                         NewXray = Xray - CorrMatrix(iElem,iMask)*Topo;
        %
        %                         WarnZeros = 0;
        %                         FindZeros = find(NewXray(:) == 0);
        %                         if ~isempty(FindZeros)
        %                             NewXray(FindZeros) = zeros(size(FindZeros));
        %                             WarnZeros = 1;
        %                         end
        %
        %                         Data(iElem).values(find(Xray)) = NewXray(find(Xray));
        %
        %                         % Here isf you want to display the correction you
        %                         % should use:
        %                         figure, imagesc(Data(iElem).values-OldData), axis image, colorbar
        %
        %                         disp(['TRC ... (correction of ',num2str(CorrMatrix(iElem,iMask)),' applied to: ',char(ListName{iElem}),' for ',char(MaskFile.NameMinerals{iMask}),') ... Ok']);
        %                         if WarnZeros
        %                             disp(['        WARNING: ',char(ListName{iElem}),' There were ',char(num2str(length(FindZeros))),' pixels with negative values that have been replaced by zeros ']);
        %                         end
        %                     end
        %                 end
        %
        %             end
        %
        %             % BRC correction
        %             if get(handles.CorrButtonBRC,'Value') == 1
        %                 for i=1:length(Data)
        %
        %                     % Add the original values of BRC rims to the corrected
        %                     % maps and display a warning !!!
        %
        %                     Data(i).values = Data(i).values + SavePxValues(i).values;
        %                 end
        %             end
        %
        %
        %             handles.data.map = Data;
        %             handles.corrections(2).value = 1;
        %
        %             guidata(hObject, handles);
        %             PPMenu1_Callback(hObject, eventdata, handles)
        %             disp('TRC ... Done')
        %             disp(' ')
        %             if get(handles.CorrButtonBRC,'Value') == 1
        %                 disp('     WARNING: BRC was active the filtered pixels have not been corrected ...');
        %                 disp(' ')
        %             end
        %         end
        %
        %         axes(handles.axes1)
        %         zoom off
        %
        %         CodeTxt = [13,3];
        %         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        %         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %
        %         % < - - - (1) User defines the direction
        %         DirChoice = questdlg('Select the direction','IDC','horizontal','vertical','vertical');
        %
        %         switch DirChoice
        %             case 'horizontal'
        %                 Direction = 2;
        %             case 'vertical'
        %                 Direction = 1;
        %             case ''
        %                 return
        %         end
        %
        %         % < - - - (2) Define plot and extract the rectangle
        %         [FinalData,Coords] = SelectRectangleIntegration(hObject, eventdata, handles);
        %
        %         CodeTxt = [13,3];
        %         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        %         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %
        %         TheMean = zeros(1,size(FinalData,1));
        %         Nb = zeros(1,size(FinalData,1));
        %         for i=1:size(FinalData,1)
        %             TheMean(i) = mean(FinalData(i,find(FinalData(i,:)>1e-19)));
        %             Nb(i) = length(find(FinalData(i,:)>1e-19));
        %         end
        %
        %         if Direction == 2
        %             TheCoor = Coords(:,1);
        %         else
        %             TheCoor = Coords(:,2);
        %         end
        %
        %
        %         % < - - - (3) Define the correction
        %         figure, plot(TheCoor,TheMean,'ok'), hold on
        %         title('Select points for interpolation (right click to exit)');
        %
        %         CodeTxt = [15,18];
        %         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        %         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %
        %         clique = 1; ComptPts = 1;
        %         while clique < 2
        %             [SelPixel(1),SelPixel(2),clique] = ginput(1); % On selectionne le pixel
        %             if clique < 2
        %                 InterpolPixels(ComptPts,:) = round(SelPixel);
        %                 plot(InterpolPixels(:,1),InterpolPixels(:,2), '-+r','linewidth', 2)
        %                 ComptPts = ComptPts+1;
        %             else
        %                 break
        %             end
        %         end
        %
        %         CodeTxt = [13,3];
        %         set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        %         TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %
        %         X = InterpolPixels(:,1); Y = InterpolPixels(:,2);
        %
        %         if Direction == 2
        %             IntX = 1:1:length(handles.data.map(1).values(1,:));
        %         else
        %             IntX = 1:1:length(handles.data.map(1).values(:,1));
        %         end
        %
        %         IntY = interp1(X,Y,IntX,'spline');
        %         figure, plot(TheCoor,TheMean,'ok'), hold on, plot(IntX,IntY,'-r','linewidth',2);
        %         title('Interpolated deviation');
        %
        %         MaxInt = max(IntY);
        %         PivotPoint = find(IntY==MaxInt);
        %         plot([IntX(1),IntX(end)],[MaxInt,MaxInt],'-b')
        %         plot([PivotPoint],[MaxInt],'ob')
        %
        %
        %         % < - - - (5) Which X-ray map ???
        %         TheXMapSel = get(handles.PPMenu1,'Value');
        %         TheXMapData = handles.data.map(TheXMapSel).values;
        %
        %         % Recuperer les data
        %         axes(handles.axes1)
        %         lesInd = get(handles.axes1,'child');
        %
        %         % On extrait l'image...
        %         for i=1:length(lesInd)
        %             leType = get(lesInd(i),'Type');
        %             if length(leType) == 5
        %                 if leType == 'image';
        %                     DataDisp = get(lesInd(i),'CData');
        %                 end
        %             end
        %         end
        %
        %
        %         % < - - - (4) Apply the correction
        %
        %         Corr = 1+(1-(IntY/MaxInt));
        %
        %
        %         if Direction == 2
        %             CorrMatrix = repmat(Corr,size(TheXMapData,1),1);
        %         else
        %             CorrMatrix = repmat(Corr',1,size(TheXMapData,2));
        %         end
        %
        %
        %         figure,
        %         subplot(2,2,1)
        %         imagesc(CorrMatrix), axis image, colorbar
        %         title('correction matrix');
        %
        %         subplot(2,2,2)
        %         imagesc(TheXMapData.*(CorrMatrix-1)), axis image, colorbar
        %         title('Intensity Correction');
        %
        %         subplot(2,2,3)
        %         imagesc(DataDisp.*CorrMatrix), axis image, colorbar, caxis([min(IntY),max(IntY)+50])
        %         title('Corrected Map');
        %
        %         subplot(2,2,4)
        %         imagesc((TheXMapData-(TheXMapData.*(CorrMatrix)))./TheXMapData), axis image, colorbar
        %         title('Residuum Map');
        %
        %         ButtonName = questdlg({'Would you like to apply the corrections to the map','This is an irreversible process'}, 'IDC', 'Yes');
        %
        %         switch ButtonName
        %
        %             case 'Yes'
        %                 DataUncorr = XimrotateX(TheXMapData,handles.rotateFig);
        %                 DataCorr = DataUncorr.*CorrMatrix;
        %                 DataCorrOk = XimrotateX(DataCorr,-handles.rotateFig);
        %
        %                 handles.data.map(TheXMapSel).values = DataCorrOk;
        %                 guidata(hObject, handles);
        %                 PPMenu1_Callback(hObject, eventdata, handles);
        %             case 'No'
        %
        %
        %             case 'Cancel'
        %                 set(handles.CorrPopUpMenu1,'value',1);
        %
        %                 CodeTxt = [15,17];
        %                 set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        %                 TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        %
        %                 return
        %         end
        %
        %         CorrTitle = 'IDC';
        
        
        % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 7     % BACKGROUND CORRECTION
        
        disp('This correction is not available in this version of XMapTools')
        disp('If you are interrested, please contact Pierre Lanari (pierre.lanari@geo.unibe.ch)')
        return
        
        
        
        % # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    case 8     % CLEAN PIXELS
        Data = handles.data;
        
        % Mode Selection
        Mode = Menu_XMT({'Would you like to clean pixels:'},{ ...
            '[1] Inside the region-of-interest', ...
            '[2] Outside the region-of-interest'},handles.LocBase);
        
        % Correction mode on (2.6.1)
        handles.CorrectionMode = 1;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        
        % Selection of area
        CodeTxt = [10,10];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        clique = 1;
        ComptResult = 1;
        axes(handles.axes1); hold on
        
        h = [0];
        
        while clique < 2
            [a,b,clique] = XginputX(1,handles);
            if clique < 2
                h(ComptResult,1) = a;
                h(ComptResult,2) = b;
                
                [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
                
                % new (1.6.2)
                hPlot(ComptResult,1) = aPlot;
                hPlot(ComptResult,2) = bPlot;
                
                plot(floor(hPlot(ComptResult,1)),floor(hPlot(ComptResult,2)),'.w') % point
                if ComptResult >= 2 % start
                    plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-m','linewidth',2)
                    plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-k','linewidth',1)
                end
                ComptResult = ComptResult + 1;
            end
        end
        
        % Trois points minimum...
        if length(h(:,1)) < 3
            CodeTxt = [10,11];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(11))]);
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)

            return
        end
        
        % new V1.4.1
        plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-m','linewidth',2)
        plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-k','linewidth',1)
        
        [LinS,ColS] = size(Data.map(1).values); % first element ref
        MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);
        
        switch Mode
            case 1
                CutNumbers = 1;
            case 2
                CutNumbers = 0;
        end
        
        Pixels2Delete = find(MasqueSel(:)==CutNumbers);
        
        % ButtonName = questdlg({'Do you want to apply this correction?','The pixel values will be cleaned'}, 'IDC', 'Yes');
        
        for i = 1:length(Data.map)
            Data.map(i).values(Pixels2Delete) = zeros(size(Pixels2Delete));
        end
        
        handles.data = Data;
        
        guidata(hObject,handles);
        PPMenu1_Callback(hObject, eventdata, handles);
        
        CorrTitle = 'RM1';
        
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        
end




CodeTxt = [15,2];
set(handles.TxtControl,'String',[char(CorrTitle),' ',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

set(handles.CorrPopUpMenu1,'value',1)

guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles)
return


function chi2 = chiEvalXMap(P,X,Y,sigmaX,sigmaY,TheInternalFunction)
%
%   chi = chiEval(P,X,Y,sigmaX,sigmaY)
%   Objective function for chi^2 minimisation in chiFit.m
%	As in polyval, <<P is a vector of length N+1 whose elements are the coefficients of the polynomial in descending powers. >>
%
%	Benoit.Dubacq@upmc.fr - 20/09/2013


options = optimset('fminsearch');
options=optimset(options,'TolX',0.01,'TolFun',0.1, 'display','none','MaxFunEvals',1000,'MaxIter',1000, 'LargeScale','off');
bestXmodel = NaN * zeros(size(X));
for i = 1 : length(X)
    [bestXmodel(i),distMin] = fminsearch(TheInternalFunction,X(i),options,P,X(i),Y(i),sigmaX(i),sigmaY(i));
end

modelY = polyval(P,bestXmodel);

% chi2 = sum(((Y-modelY)./sigmaY).^2);
chi2 = sum((sqrt(((Y - modelY)./sigmaY).^2 + ((X - bestXmodel)./sigmaX).^2 )).^2);

return


function dist = chiDistXMap(Xmodel,P,Xdata,Ydata,sigmaXdata,sigmaYdata)
%
%   dist = chiDist(P,X,Y,sigmaX,sigmaY);
%   Objective "distance" function for chi^2 minimisation in chiFit.m and chiEval.m
%   This function calculate the distance of the model to the data point in sigma units
%	As in polyval, <<P is a vector of length N+1 whose elements are the coefficients of the polynomial in descending powers. >>
%
%	Benoit.Dubacq@upmc.fr - 20/09/2013

Ymodel =  polyval(P,Xmodel);

dist = sqrt(((Ymodel - Ydata)/sigmaYdata)^2 + ((Xmodel - Xdata)/sigmaXdata)^2 ); % Note that distance is always positive

return


% #########################################################################
%     CORRECTION - SELECTION MENU (NEW V2.1.1)
function CorrPopUpMenu1_Callback(hObject, eventdata, handles)
%

switch get(handles.CorrPopUpMenu1,'Value')
    case 1
        set(handles.CorrButton1,'String','CORRECT','Enable','off');
        
        CodeTxt = [13,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
    case 2  % BRC
        % We need to have a MaskFile...
        if handles.MaskFile(1).type == 0
            set(handles.CorrButton1,'String','APPLY','Enable','off');
            
            CodeTxt = [15,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        else
            set(handles.CorrButton1,'String','APPLY','Enable','on');
            
            CodeTxt = [15,3];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        end
        
    case 3 % TRC
        if sum(ismember(get(handles.PPMenu1,'String'),'TOPO')) && ~handles.MaskFile(1).type == 0
            set(handles.CorrButton1,'String','RUN','Enable','on');
            
            CodeTxt = [15,5];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        else
            set(handles.CorrButton1,'String','RUN','Enable','off');
            
            CodeTxt = [15,6];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        end
        
    case 4
        
        if length(get(handles.PPMenu1,'String')) >= 2 && get(handles.PPMenu2,'Value') == 1
            set(handles.CorrButton1,'String','ACTIVATE','Enable','on');
            
            CodeTxt = [15,7];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        else
            set(handles.CorrButton1,'String','ACTIVATE','Enable','off');
            
            if get(handles.PPMenu2,'Value') > 1
                CodeTxt = [15,8];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            else
                CodeTxt = [15,9];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            end
            
            
            
        end
        
    case 5
        if length(handles.profils) < 1
            set(handles.CorrButton1,'String','ACTIVATE','Enable','off');
            
            CodeTxt = [15,12];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        else
            set(handles.CorrButton1,'String','ACTIVATE','Enable','on');
            
            CodeTxt = [15,10];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        end
        
    case 6 % IDC (Intensity Drift Correction)
        if ~handles.MaskFile(1).type == 0
            set(handles.CorrButton1,'String','RUN','Enable','on');
            
            CodeTxt = [15,15];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        else
            set(handles.CorrButton1,'String','RUN','Enable','off');
            
            CodeTxt = [15,16];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        end
        
    case 7 % BA1 (Background correction using maps)
        
        % we need to scan the maps to see if we have background maps...
        [ElemOK,NamesElemsPeak] = CheckForBackgroundMaps(handles);
        
        if ElemOK
            WereOk = find(ElemOK(:,1));

            if length(WereOk) >= 1
                set(handles.CorrButton1,'String','APPLY','Enable','on');

                StrChain = '';
                for i=1:length(WereOk)
                    StrChain = [StrChain,char(NamesElemsPeak(WereOk(i))),'-'];
                end
                StrChain = StrChain(1:end-1);

                CodeTxt = [15,22];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),': ',char(StrChain)]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

            else
                set(handles.CorrButton1,'String','APPLY','Enable','off');

                CodeTxt = [15,23];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

            end
            
        else
            set(handles.CorrButton1,'String','APPLY','Enable','off');
            
            CodeTxt = [15,23];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        end
        
    case 8
        if length(get(handles.PPMenu1,'String')) >= 2 && get(handles.PPMenu2,'Value') == 1
            set(handles.CorrButton1,'String','SELECT','Enable','on');
            
            CodeTxt = [15,24];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
        else
            set(handles.CorrButton1,'String','SELECT','Enable','off');
            
            if get(handles.PPMenu2,'Value') > 1
                CodeTxt = [15,25];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            else
                CodeTxt = [15,26];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            end
            
            
            
        end
end

%OnEstOu(hObject, eventdata, handles)
return


% #########################################################################
%     CHECK BACKGROUND MAPS (NEW V2.3.1)
function [ElemIndMat,NamesElemsPeak] = CheckForBackgroundMaps(handles)
%
Data = handles.data;

for i=1:length(Data.map)
    Types(i) = Data.map(i).type;
    Names{i} = char(Data.map(i).name);
    BackType(i) = 0;
    switch Types(i)
        case 1
            NamesEl{i} = char(Data.map(i).name);
        case 4
            NamesEl{i} = char(Data.map(i).name(1:end-5));
            
            if isequal(Data.map(i).name(end),'-')
                BackType(i) = 1;
            else
                BackType(i) = 2;
            end
        otherwise
            NamesEl{i} = '';
    end
end


% Classification:
ElemsPeak = find(Types == 1);
ElemsBackL = find(Types == 4 & BackType == 1);
ElemsBackR = find(Types == 4 & BackType == 2);

NamesElemsPeak = NamesEl(ElemsPeak);
NamesElemsBackL = NamesEl(ElemsBackL);
NamesElemsBackR = NamesEl(ElemsBackR);

ElemIndMat = [];

for i=1:length(ElemsPeak)
    % Check each element
    Eli = NamesElemsPeak{i};
    WhereL = find(ismember(NamesElemsBackL,Eli));
    WhereR = find(ismember(NamesElemsBackR,Eli));
    
    if isequal(length(WhereL),1) && isequal(length(WhereR),1)
        ElemIndMat(i,1) = 1;
        ElemIndMat(i,2) = ElemsPeak(i);
        ElemIndMat(i,3) = ElemsBackL(WhereL);
        ElemIndMat(i,4) = ElemsBackR(WhereR);
    else
        ElemIndMat(i,1) = 0;
        ElemIndMat(i,2) = ElemsPeak(i);
        ElemIndMat(i,3) = 0;
        ElemIndMat(i,4) = 0;
    end
end
return


% #########################################################################
%     CORRECTION - BRC (NEW V2.1.1)
function CorrButtonBRC_Callback(hObject, eventdata, handles)
%
axes(handles.axes1)
hcv = colormap;

if size(hcv,1) > 30
    PPMenu1_Callback(hObject, eventdata, handles)
else
    MaskButton2_Callback(hObject, eventdata, handles)
end





return





% -------------------------------------------------------------------------
% 5) QUANTI FUNCTIONS
% -------------------------------------------------------------------------
% goto quanti

% #########################################################################
%       PROCEED TO STANDARIZATION v2.4.3
function QUButton1_Callback(hObject, eventdata, handles)
%

set(gcf, 'WindowButtonMotionFcn', '');

% Methods (V1.4.1)
ModeQuanti = get(handles.QUmethod,'Value');

if ModeQuanti == 4
    Tranfert2Quanti_Callback(hObject, eventdata, handles);
    return
end

Quanti = handles.quanti;
Data = handles.data;
Profils = handles.profils;
Mask = handles.MaskFile;

% ---------- Setting ----------
MaskList = get(handles.PPMenu3,'String');
MaskSelected = get(handles.PPMenu3,'Value');
MaskFile = MaskList(MaskSelected);

Mineral = get(handles.PPMenu2,'Value'); % 1 is none
MineralList = get(handles.PPMenu2,'String');
MineralName = MineralList(Mineral);

MaskValues = Mask(MaskSelected).Mask == (Mineral-1); % first is none

if get(handles.CorrButtonBRC,'Value')
    % there is a BRC correction available
    MaskValues = MaskValues.*handles.corrections(1).mask;
end


% ---------- Check if there is matches between spot analyses and maps ----------
%            New 1.6.4
Compt = 0;
for i=1:length(Profils.idxallpr(:,1))
    if Profils.pointselected(i) && MaskValues(Profils.idxallpr(i,2),Profils.idxallpr(i,1))
        Compt = Compt+1;
    end
end

if Compt == 0
    % no matches
    if ModeQuanti == 3
        CodeTxt = [9,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        return
    end
end

% ---------- Where we are ----------
LaBonnePlace = length(Quanti)+1;

% Name (new V1.4.1)
CodeTxt = [9,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

if ModeQuanti == 1
    MethodQ = 'advanced';
elseif ModeQuanti == 2
    MethodQ = 'homog';
else
    MethodQ = 'auto';
end

if get(handles.CorrButtonBRC,'Value')
    %Name4write = inputdlg('Quanti name','define a name',1,{[char(MineralName),'-',char(MethodQ),'-BRC']});
    Name4write = [char(MineralName),'-',char(MethodQ),'-BRC'];
else
    %Name4write = inputdlg('Quanti name','define a name',1,{[char(MineralName),'-',char(MethodQ)]});
    Name4write = [char(MineralName),'-',char(MethodQ)];
end

if length(Name4write) == 0
    CodeTxt = [9,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end


Quanti(LaBonnePlace).mineral = {Name4write};
Quanti(LaBonnePlace).isoxide = 1;               % to not be confused with Density-corrected
Quanti(LaBonnePlace).maskfile = MaskFile;


% ---------- Setting ----------
% indexation Profils:
ProfilsElem = Profils.elemorder;
ListOri = handles.NameMaps.elements;
[Ok,LesRefsPro] = ismember(ProfilsElem,ListOri); % verification et creation de LesRefsPro

% indexation Maps:
for i=1:length(Data.map)
    ListMap{i} = char(Data.map(i).name);
    ListRefMap(i) = Data.map(i).ref;
end

CodeTxt = [9,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(1))]);

AutoSelect = [1:1:length(ListMap)];
[SelectionMap] = listdlg('ListString',ListMap,'SelectionMode','multiple','Name','Select Maps','InitialValue',AutoSelect);

if SelectionMap
    LesRefsCarte = ListRefMap(SelectionMap); % Creation de LesRefsMap
    LesNamesCartes = ListMap(SelectionMap);
else
    CodeTxt = [9,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(2))]);
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end

for i=1:length(Data.map) % On test pour toutes les cartes
    a = find(LesRefsCarte-i);
    if length(a) < length(LesRefsCarte)-1;
        CodeTxt = [9,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(3))]);
        return
    end
end

% Check for maps that cannot be standardized (0)
WhereZero = find(LesRefsCarte == 0);
if WhereZero
    Concat = '';
    for i = 1:length(WhereZero)
        Concat = [Concat,char(Data.map(WhereZero(i)).name),', '];
    end
    CodeTxt = [9,12];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),Concat(1:end-2)]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    drawnow
    return
end


% La c'est completement tordu mais ca marche bien...
% en fait je joue sur la taille de la reponse de la fonction find.
LesNomsOxydes = handles.NameMaps.oxydes(LesRefsCarte); % On indexe selon l'ordre des cartes


% Si c'est un manuel homogene, il faut des entrees
if ModeQuanti == 2
    for i=1:length(LesNomsOxydes)
        DefautAnsw{i} = '0';
    end
    ValuesSTRQuanti = inputdlg(LesNomsOxydes,'Quanti values',1,DefautAnsw);
    
    if length(ValuesSTRQuanti) == 0
        CodeTxt = [9,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(2))]);
        set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        return
    end
    % traitement
    for i=1:length(ValuesSTRQuanti)
        ValuesQuanti(i) = str2num(ValuesSTRQuanti{i});
    end
end


% We need to check the correspondance between the elements ...
[YesValid,YesInd] = ismember(LesRefsCarte,LesRefsPro);

if ~isequal(sum(YesValid),length(YesValid))
    
    Missmatch = find(YesValid == 0);
    TextPrint = '';
    for i=1:length(Missmatch)
        TextPrint = [TextPrint,char(LesNamesCartes{Missmatch(i)}),'; '];
    end
    TextPrint(end-1) = '.';
    
    waitfor(errordlg(['The following maps have no corresponding elements in the standard data:  ',TextPrint],'Standardization'));
    
    CodeTxt = [9,12];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',TextPrint]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end


if ModeQuanti == 1
    % New advanced standardization function XMapTools 2.3.2 (SWOT 05.02.17)
    
    % New 2.5.1
    %zoom off
    handles.CorrectionMode = 1;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles);
    
    
    PositionXMapTools = get(gcf,'Position');
    
    Quanti = XMTStandardizationTool(Data,Quanti,Profils,LesRefsPro,LesRefsCarte,SelectionMap,LesNomsOxydes,MaskValues,handles.StandardizationParameters,handles.LocBase,handles.activecolorbar,PositionXMapTools);

    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    
    % Moved up (3.2.1)
    if isequal(Quanti,0)
        CodeTxt = [9,9];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        return
    end
    
    % Here we generate a LOD file (new 3.2.1):
    [Success,Message,MessageID] = mkdir('LOD');

    fid = fopen(['LOD/LOD_',char(Name4write),'.txt'],'w');
    fprintf(fid,'%s\n%s\n\n%s\n','*********',[char(Name4write),'.txt'],'>');
    for i = 1:length(Quanti(LaBonnePlace).elem)
        Back = Quanti(LaBonnePlace).elem(i).BackgroundValue - 1;
        if isequal(Back,0)
            Limit = 1;
        else
            Limit = 1/sqrt(Back)*Back;
        end
        Slope = (Quanti(LaBonnePlace).elem(i).param(2)-Back)/Quanti(LaBonnePlace).elem(i).param(1);
        LOD = ((Back+Limit) - Back)/Slope;
    
        fprintf(fid,'%s\t%f\n',char(Quanti(LaBonnePlace).elem(i).name),LOD*3);
 
    end
    fclose(fid);
    % ---
    
    
    
    
    % standardization
    for i=1:length(Quanti(LaBonnePlace).elem)
        
        % Below I use BackgroundValue - 1 because there is a shift of one
        % count; e.g. no background correction has a value of 1.
        if isequal(i,8)
            %keyboard
        end
        
        Y = Data.map(SelectionMap(i)).values.*MaskValues;
        Xb = Quanti(LaBonnePlace).elem(i).param(1);
        Yb = Quanti(LaBonnePlace).elem(i).param(2);
        Back = Quanti(LaBonnePlace).elem(i).BackgroundValue - 1;
        
        % Temporary to fix an issue in XMTStandardization (XMapTools 2.4.3)
        if Back < 0
            Back = 0;
        end
        
        % This is correct (PL, Syros Feb, 10, 2018)
        Quanti(LaBonnePlace).elem(i).quanti = (Y-Back)/((Yb-Back)/Xb);
        
        % This is the previous version that is correct too...
        %Quanti(LaBonnePlace).elem(i).quanti = (Y-Back)*(Xb/(Yb-Back));
        
        % Find and replace negative values...
        WhereNeg = find(Quanti(LaBonnePlace).elem(i).quanti < 0);
        
        if ~isempty(WhereNeg)
            Quanti(LaBonnePlace).elem(i).quanti(WhereNeg) = zeros(size(WhereNeg));
        end
    end
else
    
    % Warning XMapTools 2.6.1
    if isequal(ModeQuanti,3)
        waitfor(warndlg({'Your standardization will continue as soon as you click OK, but note that this method is no longer recommended as the calibration of minor and trace elements requires a background correction (see Lanari et al. 2018, GSL Special Publication)', ...
            ' ','It is strongly recommended to use the "advanced standardization method" instead; the auto method will be removed in a futur release'},'XMapTools'));
    end
    
    
    % ---------- Quantification ----------
    % On va partir des cartes et quantifier avec les profils correspondants
    % l'inverse semble non solide.
    % C'est a dire que le choix des carte est judicieux...
    disp(' ')
    for i=1:length(LesRefsCarte)
        LaMap = LesRefsCarte(i);
        LePro = find(LesRefsPro == LaMap); % warning, empty cell if missmatch.
        
        if ~length(LePro)
            CodeTxt = [9,12];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),char(handles.data.map(i).name)]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            set(gcf, 'WindowButtonMotionFcn', @mouseMove);
            return
        end
        
        Quanti(LaBonnePlace).elem(i).ref = LaMap;
        
        Quanti(LaBonnePlace).elem(i).name = LesNomsOxydes(i); % yet sort
        
        Quanti(LaBonnePlace).elem(i).values = Profils.data(:,LePro);
        Quanti(LaBonnePlace).elem(i).coor = Profils.idxallpr;
        
        for j=1:length(Quanti(LaBonnePlace).elem(i).coor(:,1))
            Line = Quanti(LaBonnePlace).elem(i).coor(j,2); % Y -> L
            Column = Quanti(LaBonnePlace).elem(i).coor(j,1); % X -> C
            if Line && Column
                Quanti(LaBonnePlace).elem(i).raw(j) = MaskValues(Line,Column) * Data.map(SelectionMap(i)).values(Line,Column);
                Quanti(LaBonnePlace).elem(i).values(j) = MaskValues(Line,Column) * Quanti(LaBonnePlace).elem(i).values(j);
            else
                Quanti(LaBonnePlace).elem(i).raw(j) = 0;
                Quanti(LaBonnePlace).elem(i).values(j) = 0;
            end
        end
        
        Ox=[]; Ra=[];
        Compt = 1;
        for j=1:length(Quanti(LaBonnePlace).elem(i).values)
            if Quanti(LaBonnePlace).elem(i).values(j) > 0  && Profils.pointselected(j)    % Edited 1.6.2 (compatible with select/uselect points)
                Ox(Compt) = Quanti(LaBonnePlace).elem(i).values(j);
                Ra(Compt) = Quanti(LaBonnePlace).elem(i).raw(j);
                Compt = Compt+1;
            else
                Quanti(LaBonnePlace).elem(i).values(j) = 0;    % Edited 1.6.2 (compatible with select/uselect points)
                Quanti(LaBonnePlace).elem(i).raw(j) = 0;       % we fixed to zero the unused compositions (for the plots).
                
                % bug correction (1.6.4) resulting from 0 intensity values
                %                        --> no matches between minerals and profils warning
                %
                %                            But now, the softawre doesn't detect
                %                            mask without quantitative
                %                            analyses...
                Ox(Compt) = 0.0000001;
                Ra(Compt) = 1.;
                
            end
            
        end
        
        % For compatibility with the new advanced function for
        % standardization ... (XMapTools 2.3.2 - Feb. 2017)
        
        Quanti(LaBonnePlace).elem(i).Ox = Ox;
        Quanti(LaBonnePlace).elem(i).Ra = Ra;
        
        Quanti(LaBonnePlace).elem(i).Selected = ones(size(Quanti(LaBonnePlace).elem(i).Ox));
        Quanti(LaBonnePlace).elem(i).RaUnc = Quanti(LaBonnePlace).elem(i).Ra.*(2./sqrt(Quanti(LaBonnePlace).elem(i).Ra));
        Quanti(LaBonnePlace).elem(i).param = [];
        
        Quanti(LaBonnePlace).elem(i).plotX = [Quanti(LaBonnePlace).elem(i).Ox;Quanti(LaBonnePlace).elem(i).Ox];
        Quanti(LaBonnePlace).elem(i).plotY = [Quanti(LaBonnePlace).elem(i).Ra-Quanti(LaBonnePlace).elem(i).RaUnc;Quanti(LaBonnePlace).elem(i).Ra+Quanti(LaBonnePlace).elem(i).RaUnc];
        
        Quanti(LaBonnePlace).elem(i).plotXi = [0:0.001:max(Quanti(LaBonnePlace).elem(i).Ox)];
        
        Quanti(LaBonnePlace).elem(i).BackgroundResiduals = [];
        Quanti(LaBonnePlace).elem(i).BackgroundValue = 0;
        
        Quanti(LaBonnePlace).elem(i).Standardization = 0;
        Quanti(LaBonnePlace).elem(i).StandardizationType = 0;
        
        
        if ModeQuanti == 2
            % Manual (homogeneous phase) new 1.4.1
            % ici on a pas besoin de verifier si il y a des correspondances...
            LesDataZero = Data.map(SelectionMap(i)).values.*MaskValues;
            LesData = LesDataZero(find(LesDataZero));
            
            if max(LesData) > 1000
                NbHist = round((max(LesData) - min(LesData))./5);
            else
                NbHist = round((max(LesData) - min(LesData))./1);
            end
            
            % New 3.2.2: 
            [M_N,M_EDGES] = histcounts(LesData,NbHist);
            [M_Val,M_Pos] = max(M_N);
            M_Med = median(LesData);
            M_Hist = M_EDGES(M_Pos) + (M_EDGES(M_Pos+1)-M_EDGES(M_Pos));
            
            if abs(M_Hist-M_Med)/(M_Hist) > 0.01  &&  abs(M_Hist-M_Med) > (M_EDGES(2)-M_EDGES(1))
                hc = figure; 
                plot(M_EDGES(1:end-1)+(M_EDGES(2:end)-M_EDGES(1:end-1)),M_N,'.-')
                hold on
                M_axis = axis;
                plot([M_Hist,M_Hist],[M_axis(3),M_axis(4)],'-b')
                plot([M_Med,M_Med],[M_axis(3),M_axis(4)],'-r')
                xlabel('Intensity')
                ylabel('Density')
                title(LesNomsOxydes{i})
                
                DateStr = char(datestr(now));
                DateStr(find(DateStr == ' ')) = '_';
                
                M_FileName = ['Manual_Check_',char(MineralName),'_',char(LesNomsOxydes(i)),'_',DateStr,'.fig'];
                for kkk=1:length(M_FileName)
                    if isequal(M_FileName(kkk),':')
                        M_FileName(kkk) = '-';
                    end
                end
         
                [Success,Message,MessageID] = mkdir('Standardization');
                
                saveas(hc,['Standardization/',M_FileName],'fig');
                close(hc);
                
                disp([' WARNING - ',char(LesNomsOxydes(i)),' median not selected (figure ',M_FileName,' saved)']);
                
                M_IntensitySel = M_Hist;
            else
                M_IntensitySel = M_Med;
            end
            
            Intensity = [ValuesQuanti(i),M_IntensitySel];
            Quanti(LaBonnePlace).elem(i).param = Intensity;
            Quanti(LaBonnePlace).elem(i).quanti = (Data.map(SelectionMap(i)).values.*MaskValues) ./ (Intensity(2)/Intensity(1));
            
            Quanti(LaBonnePlace).elem(i).StandardizationType = 3;
            
        end
        
        % This mode is no longer available in XMapTools 2.6.1
        if ModeQuanti == 100
            % Manual (New V1.4.1)
            if Ox
                figure(1), hold off
                plot(Ox,Ra,'+k')
                title(char(Quanti(LaBonnePlace).elem(i).name))
                while 1
                    Intensity = ginput(1);
                    
                    if Intensity(1) > 0 && Intensity(2) > 0
                        Quanti(LaBonnePlace).elem(i).param = Intensity;
                        break
                    end
                    
                    ButtonName = questdlg('Oxide and Intensity must be both positive!!!', ...
                        'Error', ...
                        ['Select ',char(Quanti(LaBonnePlace).elem(i).name),' again'], 'Cancel', ['Select ',char(Quanti(LaBonnePlace).elem(i).name),' again']);
                    switch ButtonName
                        case 'Cancel'
                            CodeTxt = [9,2];
                            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                            
                            set(gcf, 'WindowButtonMotionFcn', @mouseMove);
                            return
                    end
                end
                
                Quanti(LaBonnePlace).elem(i).quanti = (Data.map(SelectionMap(i)).values.*MaskValues) ./ (Intensity(2)/Intensity(1));
                
                Quanti(LaBonnePlace).elem(i).StandardizationType = 3;
                
            else
                % Modification 1.6.4
                % This part is no more used (this detection is done above).
                CodeTxt = [9,4];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                % set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(4))]);
                return
            end
            
        elseif ModeQuanti == 3
            % automatique
            if Ox
                Intensity = [median(Ox),median(Ra)];
                
                % <---
                % This has been added in XMapTools 2.4.3 to avoid issues
                % with low count rates < 1 (reported by Stephen Centrella)
                if isequal(Intensity(2),0)
                    if find(Ra)
                        Intensity(2) = median(Ra(find(Ra)));
                    else
                        Intensity(2) = 1;
                    end
                end
                % --->
                
                Quanti(LaBonnePlace).elem(i).param = Intensity;
                Quanti(LaBonnePlace).elem(i).quanti = (Data.map(SelectionMap(i)).values.*MaskValues) ./ (Intensity(2)/Intensity(1));
            else
                % cette phase n'a pas de profils correspondant...
                CodeTxt = [9,4];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                % set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(4))]);
                set(gcf, 'WindowButtonMotionFcn', @mouseMove);
                return
            end
        end
        
    end
    disp(' ')
    
end

% ---------- Save ----------
Quanti(LaBonnePlace).nbpoints = Compt-1; % for display
Quanti(LaBonnePlace).listname = LesNomsOxydes; % Selected maps
% Quanti(LaBonnePlace).listname{length(Quanti(LaBonnePlace).listname) + 1} = 'SUM';
handles.quanti = Quanti;

% ---------- Update Mineral Menu QUppmenu2 ----------
for i=1:length(Quanti)
    NamesQuanti{i} = char(Quanti(i).mineral);
end

set(handles.QUppmenu2,'String',NamesQuanti);
set(handles.QUppmenu2,'Value',LaBonnePlace);
set(handles.QUtexte1,'String',strcat(num2str(Quanti(LaBonnePlace).nbpoints),' pts'));

% ---------- Update Wt% Menu QUppmenu1 ----------
set(handles.QUppmenu1,'String',Quanti(LaBonnePlace).listname);


% ---------- Display mode 2 ----------
%handles.currentdisplay = 2; % Input change
%set(handles.PPMenu2,'Value',1); % Input Change
%set(handles.REppmenu1,'Value',1); % Input Change

set(handles.FIGbutton1,'Value',0); % median filter

ValMin = get(handles.QUppmenu2,'Value');
AllMin = get(handles.QUppmenu2,'String');
SelMin = AllMin(ValMin);
if char(SelMin) == char('.')
    waitfor(warndlg('map not yet quantified','cancelation'));
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end

%
ValOxi = 1;
set(handles.QUppmenu1,'Value',ValOxi);

cla(handles.axes1,'reset');
axes(handles.axes1)
imagesc(XimrotateX(Quanti(ValMin).elem(ValOxi).quanti,handles.rotateFig)), axis image, colorbar('peer',handles.axes1,'vertical')
handles = XMapColorbar('Auto',1,handles);
set(handles.axes1,'xtick',[], 'ytick',[]);

%zoom on                                                         % New 1.6.2

handles.HistogramMode = 0;
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0;
%cla(handles.axes2);
%axes(handles.axes2), hist(Quanti(ValMin).elem(ValOxi).quanti(find(Quanti(ValMin).elem(ValOxi).quanti(:) ~= 0)),30)

AADonnees = Quanti(ValMin).elem(ValOxi).quanti(:);
Min = min(AADonnees(find(AADonnees(:) > 0)));
Max = max(AADonnees(:));

set(handles.ColorMin,'String',Min);
set(handles.ColorMax,'String',Max);
set(handles.FilterMin,'String',Min);
set(handles.FilterMax,'String',Max);

Value = get(handles.checkbox1,'Value');
axes(handles.axes1);
if Max > Min
    caxis([Min,Max]);
end
% if Value == 1
% 	colormap([0,0,0;jet(64)])
% else
%     colormap([jet(64)])
% end

disp(['Standardization processing ... (',char(MineralName),') ...']);
for i=1:length(LesNamesCartes)
    switch Quanti(LaBonnePlace).elem(i).StandardizationType
        case 0
            TextStd = 'AUTO(0)';
            TextBack = 'No background correction';
        case 1
            TextStd = 'AUTO(1)';
            TextBack = 'No background correction';
        case 2
            TextStd = 'AUTO-BACK(2)';
            TextBack = ['** Background correction: ',num2str(Quanti(LaBonnePlace).elem(i).BackgroundValue),' **'];
        case 3
            if Quanti(LaBonnePlace).elem(i).BackgroundValue > 1
                TextStd = 'MANUAL-BACK(3)';
                TextBack = ['** Background correction: ',num2str(Quanti(LaBonnePlace).elem(i).BackgroundValue),' **'];
            else
                TextStd = 'MANUAL(3)';
                TextBack = 'No background correction';
            end
        otherwise
            TextStd = 'not calibrated';
            TextBack = 'not calibrated';
    end
    
    disp(['Standardization processing ... (',num2str(i),' - ',char(LesNamesCartes(i)),': ',TextStd,' ',num2str(Quanti(LaBonnePlace).elem(i).param(1)),'/',num2str(Quanti(LaBonnePlace).elem(i).param(2)),' - ',TextBack,')']);
    
end
disp(['Standardization processing ... (',char(MineralName),') ... Ok']);
disp(' ');

CodeTxt = [9,6];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Name4write),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(6)),' (',char(Name4write),')']);

% set(handles.OPT,'Value',2); % on passe au panneau 2

GraphStyle(hObject, eventdata, handles)
guidata(hObject,handles);
AffOPT(2, hObject, eventdata, handles); % Maj 1.4.1
%AffPAN(hObject, eventdata, handles);
OnEstOu(hObject, eventdata, handles);

set(gcf, 'WindowButtonMotionFcn', @mouseMove);

return


% #########################################################################
%       STANDARDIZATION METHOD LIST
function QUmethod_Callback(hObject, eventdata, handles)
OnEstOu(hObject, eventdata, handles);
return


% #########################################################################
%       PLOT It/Wt% (changed 2.5.1)
function QUbutton11_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;

ValMin = get(handles.QUppmenu2,'Value');

if isempty(Quanti(ValMin).elem(1).plotXi)
    warndlg({'This standardization cannot be plotted as it was standardized with'; ...
        'an old version of XMapTools (before "advanced standardization")'; ...
        ' '; ...
        'If you want to use this function, you must re-standardize '; ...
        'the phase(s).'; ...
        ' '},'WARNING');
    return
end

figure, hold on

Compt = 0;
for i=1:length(Quanti(ValMin).elem)
    
    %     SelectedStd = find(Quanti(ValMin).elem(i).Selected);
    %     UnSelectedStd = find(Quanti(ValMin).elem(i).Selected == 0);
    %
    %     plot(Quanti(ValMin).elem(i).plotX(:,SelectedStd),Quanti(ValMin).elem(i).plotY(:,SelectedStd),'-k')
    %
    %     if ~isempty(UnSelectedStd)
    %         plot(Quanti(ValMin).elem(i).plotX(:,UnSelectedStd),Quanti(ValMin).elem(i).plotY(:,UnSelectedStd),'-r')
    %     end
    
    % Changed 2.5.1 (compatibility with Generator)
    if Quanti(ValMin).elem(i).ref
        Compt = Compt+1;
        
        TempXi = Quanti(ValMin).elem(i).plotXi;
        Back = Quanti(ValMin).elem(i).BackgroundValue - 1;

        Xb = Quanti(ValMin).elem(i).param(1);
        Yb = Quanti(ValMin).elem(i).param(2);

        % Correction
        TempYi = ((Yb-Back)/Xb)*TempXi + Back;

        PlotXi(1:length(TempXi),Compt) = TempXi;
        PlotYi(1:length(TempYi),Compt) = TempYi;

        Oxi(1:length(Quanti(ValMin).elem(i).Ox),Compt) = Quanti(ValMin).elem(i).Ox';
        Rai(1:length(Quanti(ValMin).elem(i).Ox),Compt) = Quanti(ValMin).elem(i).Ra';

        TheNames{Compt} = char(Quanti(ValMin).elem(i).name);
    end
end

WhereZeros = find(PlotXi == 0);
PlotXi(WhereZeros) = nan(size(WhereZeros));
PlotYi(WhereZeros) = nan(size(WhereZeros));

plot(PlotXi,PlotYi)
legend(TheNames,'location','SouthEast')

for i=1:length(Quanti(ValMin).elem)
    
    % Changed 2.5.1 (compatibility with Generator) 
    if Quanti(ValMin).elem(i).ref

        SelectedStd = find(Quanti(ValMin).elem(i).Selected);
        UnSelectedStd = find(Quanti(ValMin).elem(i).Selected == 0);
        
        plot(Quanti(ValMin).elem(i).plotX(:,SelectedStd),Quanti(ValMin).elem(i).plotY(:,SelectedStd),'-k')
        
        if ~isempty(UnSelectedStd)
            plot(Quanti(ValMin).elem(i).plotX(:,UnSelectedStd),Quanti(ValMin).elem(i).plotY(:,UnSelectedStd),'-r')
        end
        
    end
end

plot(Oxi,Rai,'.')

AllMin = get(handles.QUppmenu2,'String');
SelMin = AllMin(ValMin);

xlabel('Weigth percent'), ylabel('Intensity'),
title(['Quantification parameters for ',char(SelMin)]);

guidata(hObject,handles);
return


% #########################################################################
%       TEST THE STANDARDIZATION  V1.6.5
function QUbutton_TEST_Callback(hObject, eventdata, handles)
%


Quanti = handles.quanti;
ValMin = get(handles.QUppmenu2,'Value');

% Standard analyses of the selected Qmineral
lesQuels = find(Quanti(ValMin).elem(1).raw);

ComposFromStd = zeros(length(lesQuels),length(Quanti(ValMin).elem));
ComposFromMaps = zeros(length(lesQuels),length(Quanti(ValMin).elem));

MapUncertainties = zeros(length(lesQuels),length(Quanti(ValMin).elem));


for i = 1:length(Quanti(ValMin).elem)                            % elements
    for j = 1:length(lesQuels)                          % good std analyses
        
        ComposFromStd(j,i) = Quanti(ValMin).elem(i).values(lesQuels(j));
        % Ligne/Coll <-> X and Y
        ComposFromMaps(j,i) = Quanti(ValMin).elem(i).quanti(Quanti(ValMin).elem(1).coor(lesQuels(j),2),Quanti(ValMin).elem(1).coor(lesQuels(j),1));
        
        MapUncertainties(j,i) = 2/sqrt(Quanti(ValMin).elem(i).raw(lesQuels(j))); % in % at 2%
        
    end
    
    figure, plot(ComposFromStd(:,i),ComposFromMaps(:,i),'.')
    hold on
    for k=1:length(MapUncertainties(:,i))
        devMap = ComposFromMaps(k,i)*MapUncertainties(k,i);
        
        if median(ComposFromStd(:,i)) < 0.2
            devStd = ComposFromStd(k,i)* 0.1;   % 1%.
        elseif median(ComposFromStd(:,i)) < 1
            devStd = ComposFromStd(k,i)* 0.05;   % 1%.
        else
            devStd = ComposFromStd(k,i)* 0.01;   % 1%.
        end
        
        devStdSave(k) = devStd;
        devMapSave(k) = devMap;
        
        plot([ComposFromStd(k,i),ComposFromStd(k,i)],[ComposFromMaps(k,i) - devMap, ComposFromMaps(k,i) + devMap],'-')
        plot([ComposFromStd(k,i) - devStd, ComposFromStd(k,i) + devStd],[ComposFromMaps(k,i),ComposFromMaps(k,i)],'-')
        
    end
    plot([0 100],[0 100],'-k')
    
    hold off
    
    title(Quanti(ValMin).elem(i).name);
    xlabel('Standard composition (Wt%) - error (<0.2%=10% <1%=5% else 1%')
    ylabel('Corresponding pixel composition (Wt%) - error 2o')
    
    if median(ComposFromStd(:,i)) < 0.2
        axis([0,0.2,0,0.2])
    elseif median(ComposFromStd(:,i)) < 1
        axis([0,1,0,1])
    elseif median(ComposFromStd(:,i)) < 5
        axis([0,5,0,5])
    elseif median(ComposFromStd(:,i)) < 10
        valueMean = mean(ComposFromStd(:,i));
        axis([round(valueMean-2),round(valueMean+2),round(valueMean-2),round(valueMean+2)])
    else
        valueMean = mean(ComposFromStd(:,i));
        axis([round(valueMean-5),round(valueMean+5),round(valueMean-5),round(valueMean+5)])
    end
    
    % ---------------------------------------------------------------------
    % UNCERTAINTIES: R2 and CHI2
    X = ComposFromStd(:,i);
    Y = ComposFromMaps(:,i);
    
    SigmaX = devStdSave';
    SigmaY = devMapSave';
    
    for i=1:length(SigmaX)
        if ~SigmaX(i)
            SigmaX(i)=0.0001;
        end
    end
    
    P = [1,0];   % slope / intercept of the linear predictor
    
    options = optimset('fminsearch');
    options=optimset(options,'TolX',0.01,'TolFun',0.1, 'display','none','MaxFunEvals',1000,'MaxIter',1000, 'LargeScale','off');
    bestXmodel = NaN * zeros(size(X));
    f = @chiDist;
    
    for i=1:length(X)
        [bestXmodel(i),distMin] = fminsearch(f,X(i),options,P,X(i),Y(i),SigmaX(i),SigmaY(i));
    end
    
    modelY = polyval(P,bestXmodel);
    
    chi2s = sum(((Y-modelY)./SigmaY).^2);
    chi2Ns = chi2s/length(X);
    
    % With X and Y uncertainties (P. Lanari, Septembre 2013 - equation B3 in Dubacq et al., 2013)
    chi2 = sum((sqrt(((Y - modelY)./SigmaY).^2 + ((X - bestXmodel)./SigmaX).^2 )).^2);
    chi2N = chi2/length(X);
    
    % MATLAB version
    R2 = 1 - sum((Y-modelY).^2)/((length(Y)-1)*var(Y));
    
    % BENOIT DUBACQ version
    meanData = sum(Y)/length(Y); meanModel = sum(modelY)/length(modelY);
    R2 = sum((Y-meanData).*(modelY-meanModel)) ./ sqrt(sum((Y-meanData).^2) .* sum((modelY-meanModel).^2));
    
    Xlim = get(gca,'Xlim'); Ylim = get(gca,'Ylim');
    text(Xlim(1)+(Xlim(2)-Xlim(1))/50,Ylim(2)-(Ylim(2)-Ylim(1))/30,['N=',num2str(length(Y)),'; R2=',num2str(R2),'; Chi2=',num2str(chi2N)])
    
    
end

return


% #########################################################################
%       CHI-DISTANCE FUNCTION   (NEW) V1.6.5
function dist = chiDist(Xmodel,P,Xdata,Ydata,sigmaXdata,sigmaYdata);
%
%   dist = chiDist(P,X,Y,sigmaX,sigmaY);
%   Objective "distance" function for chi^2 minimisation in chiFit.m and chiEval.m
%   This function calculate the distance of the model to the data point in sigma units
%	As in polyval, <<P is a vector of length N+1 whose elements are the coefficients of the polynomial in descending powers. >>
%
%	Benoit.Dubacq@upmc.fr - 20/09/2013

Ymodel =  polyval(P,Xmodel);

dist = sqrt(((Ymodel - Ydata)/sigmaYdata)^2 + ((Xmodel - Xdata)/sigmaXdata)^2 ); % Note that distance is always positive

return


% #########################################################################
%       DELETE A QUANTI (2.5.1)
function QUbutton0_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;

Delete = get(handles.QUppmenu2,'Value'); % for "none"

Idx = [1:length(Quanti)];
IdxC = Idx(find(Idx ~= Delete));

Quanti = Quanti(IdxC);

for i=1:length(Quanti) 
    ListName{i} = char(Quanti(i).mineral);
end

if Delete > 2
    Select = Delete-1;
else
    Select = 2;
end

set(handles.QUppmenu2,'String',ListName)
set(handles.QUppmenu2,'Value',Select)  % changed 2.5.1

handles.quanti = Quanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);

QUppmenu2_Callback(hObject, eventdata, handles)



return


switch Delete
    case 2
        NewQuanti(1) = Quanti(1); % the first never change
        NewQuanti(2:length(Quanti)-1) = Quanti(3:end);
        
%         for k = 2:length(Quanti) - 1
%             NewQuanti(k) = Quanti(k+1);
%         end
        Select = 1; % new 2.5.1
        
    case length(Quanti)
        NewQuanti = Quanti(1:Delete-1);
        Select = Delete-1; % new 2.5.1
        
    otherwise
        NewQuanti = Quanti(1:Delete-1);
        NewQuanti(end+1:length(Quanti)-1) = Quanti(Delete+1:end);
        Select = Delete-1;
        
end

% if Delete == 2 % We delete the first (in fact the second) quanti
%     
% end
% if Delete > 2 && Delete < length(Quanti)
%     NewQuanti(1:Delete-1) = Quanti(1:Delete-1);
%     for k = Delete:length(Quanti)-1
%         NewQuanti(k) = Quanti(k+1);
%     end
%     Select = Delete-1; % new 2.5.1
% end
% if Delete == length(Quanti)
%     
% end

for i=1:length(NewQuanti) 
    ListName{i} = char(NewQuanti(i).mineral);
end

set(handles.QUppmenu2,'String',ListName)
set(handles.QUppmenu2,'Value',Select)  % changed 2.5.1

handles.quanti = NewQuanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);

QUppmenu2_Callback(hObject, eventdata, handles)

return


% #########################################################################
%       RENAME A QUANTI (NEW 1.4.1)
function QUbutton4_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;

Selected = get(handles.QUppmenu2,'Value');
ListName = get(handles.QUppmenu2,'String');

Name = ListName(Selected);

CodeTxt = [9,10];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(10))]);
NewName = inputdlg({'New name'},'Rename QUANTI',1,Name);

if ~length(NewName)
    CodeTxt = [9,9];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(9))]);
    return
end

ListName(Selected) = NewName;
Quanti(Selected).mineral = NewName;
handles.quanti = Quanti;

set(handles.QUppmenu2,'String',ListName);

CodeTxt = [9,11];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(NewName),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(9).txt(11)),' (',char(NewName),')']);

guidata(hObject,handles);
return


% #########################################################################
%       DUPLICATE A QUANTI (NEW 2.2.1)
function QUbutton17_Callback(hObject, eventdata, handles)
%
Quanti = handles.quanti;

TheQuanti = get(handles.QUppmenu2,'Value');
TheElem = get(handles.QUppmenu1,'Value');

NewPos = length(Quanti) + 1;
Quanti(NewPos) = Quanti(TheQuanti);

Quanti(NewPos).mineral = {[char(Quanti(NewPos).mineral),'_copy']};

% ---------- Update Mineral Menu QUppmenu2 ----------
for i=1:length(Quanti)
    NamesQuanti{i} = char(Quanti(i).mineral);
end

set(handles.QUppmenu2,'String',NamesQuanti);
set(handles.QUppmenu2,'Value',NewPos);

handles.quanti = Quanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
QUppmenu2_Callback(hObject, eventdata, handles)

return


% #########################################################################
%       MERGE QMINERALS (3.3.1)
function QUbutton5_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;

% (1) Choix des cartes
for i=1:length(Quanti)-1
    ListMaps{i} = char(Quanti(i+1).mineral); % changed 3.2.2
end

CodeTxt = [10,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(1))]);
Init = 1:length(ListMaps);
MapChoice = listdlg('ListString',ListMaps,'SelectionMode','multiple','Initialvalue',Init,'Name','Select quanti');

if ~length(MapChoice)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
    return
end

% We change the coord (including 'none')
MapChoice = MapChoice+1;

if length(MapChoice) < 2
    CodeTxt = [10,44];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

% Check... Number of element for each map + (3.3.1) size 
for i = 1:length(MapChoice)
    NbElemMap(i) = length(Quanti(MapChoice(i)).listname);
    IsOxide(i) = Quanti(MapChoice(i)).isoxide;
    
    Concat{i} = '';
    for j = 1:length(Quanti(MapChoice(i)).listname)
        Concat{i} = [char(Concat{i}),char(Quanti(MapChoice(i)).listname{j})];
    end
    
    % 3.3.1 (Dec. 2019)
    Thesizes(i,:) = size(Quanti(MapChoice(i)).elem(1).quanti);
end

% Last option V 2.2.1 (02.10.2015)
% The second option was added for LA maps (3.0.1 - April 2019)
if sum(IsOxide) ~= length(IsOxide) && sum(IsOxide) ~= 2*length(IsOxide)
    % Error
    CodeTxt = [10,30];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

% Last option V 1.4.1 (01.06.2011)
if sum(NbElemMap) ~= NbElemMap(1)*length(NbElemMap)
    % Error
    CodeTxt = [10,12];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

% Check for elements V 2.5.1 (31.05.2018)
for i = 2:length(Concat)
    if ~isequal(Concat{1},Concat{i})
        % Error
        CodeTxt = [10,12];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
end

% Check for map size (3.3.1 - Dec. 2019)
for i = 2:length(Thesizes)
    if ~isequal(Thesizes(i,:),Thesizes(1,:))
        CodeTxt = [19,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),char(ListMaps{i})]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

        waitfor(errordlg(['At least one map has a different size (check the size of ',ListMaps{i},')'],'XMapTools'));
        return
    end
end

SizeMap = size(Quanti(MapChoice(1)).elem(1).quanti);

% On cree la carte MapQuanti pour chaque element
for i=1:length(Quanti(MapChoice(1)).elem)
    MapQuanti(i).elem(:,:) = zeros(SizeMap);
end


ListElem = Quanti(MapChoice(1)).listname;

if get(handles.MergeInterpBoundaries,'Value');
    CodeTxt = [10,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(2))]);
    
    if find(ismember(ListElem,'SiO2'))
        AutoSelect = find(ismember(ListElem,'SiO2'));
    else
        AutoSelect = 1;
    end
    LaMapRef = listdlg('ListString',ListElem,'SelectionMode','single','InitialValue',AutoSelect);
    if ~length(LaMapRef)
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
        return
    end
end

%keyboard

% (2) Maps -> Map
for i=1:length(MapChoice) % par masque
    LaQuanti = Quanti(MapChoice(i));
    
    for j=1:length(LaQuanti.elem) % par element
        MapQuanti(j).elem = MapQuanti(j).elem + LaQuanti.elem(j).quanti;
    end
end




if get(handles.MergeInterpBoundaries,'Value'); % interpolation
    
    % (3) Verification et on refait les bordures en m?langes simples
    
    Nb = 2;
    PerKeep = 0.5;
    
    CodeTxt = [10,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(3))]);
    Answ = inputdlg({'X-n -> X+n','OnGarde'},'Interpolation',1,{num2str(Nb),num2str(PerKeep)});
    if ~length(Answ)
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
        return
    end
    Nb = str2num(Answ{1});
    PerKeep = str2num(Answ{2});
    
    
    NewMapQuanti = MapQuanti;
    
    XmapWaitBar(0,  handles);
    
    ComptAffich = 20;
    for i=1:length(MapQuanti(LaMapRef).elem(:,1))
        if i == ComptAffich
            ComptAffich = ComptAffich + 20;
            XmapWaitBar(i/length(MapQuanti(LaMapRef).elem(:,1)), handles);
            
            CodeTxt = [10,7];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',num2str(round((i/length(MapQuanti(LaMapRef).elem(:,1)))*100)),' %)']);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(7)),' (',num2str(round((i/length(MapQuanti(LaMapRef).elem(:,1)))*100)),' %)']);
            drawnow
        end
        
        for j=1:length(MapQuanti(LaMapRef).elem(1,:))
            if MapQuanti(LaMapRef).elem(i,j) == 0 % il faut g?r?er un trou
                % i lignes j colones
                if i <= Nb
                    Decali1 = i;
                    Decali2 = i+Nb;
                    Nbi1 = Nb; Nbi2 = 0;
                elseif i >= length(MapQuanti(1).elem(:,1)) - Nb
                    Decali1 = i-Nb;
                    Decali2 = i;
                    Nbi1 = Nb; Nbi2 = 0;
                else % on est au milieu pour i
                    Decali1 = i-Nb;
                    Decali2 = i+Nb;
                    Nbi1 = Nb; Nbi2 = Nb;
                end
                
                if j <= Nb
                    Decalj1 = j;
                    Decalj2 = j+Nb;
                    Nbj1 = Nb; Nbj2 = 0;
                elseif j >= length(MapQuanti(1).elem(1,:)) -5
                    Decalj1 = j-Nb;
                    Decalj2 = j;
                    Nbj1 = Nb; Nbj2 = 0;
                else
                    Decalj1 = j-Nb;
                    Decalj2 = j+Nb;
                    Nbj1 = Nb; Nbj2 = Nb;
                end
                
                % Enfin Correction
                clear LesVals
                LesVals = MapQuanti(LaMapRef).elem(Decali1:Decali2,Decalj1:Decalj2);
                NbOk = length(find(LesVals > 0));
                if NbOk/((Nbi1+Nbi2+1)*(Nbj1+Nbj2+1)) > PerKeep% 80% de definis
                    % On corrige bien
                    for k = 1:length(MapQuanti) % pour chaque element
                        LesVals = MapQuanti(k).elem(Decali1:Decali2,Decalj1:Decalj2);
                        LaMoyenne = mean(LesVals(find(LesVals > 0)));
                        NewMapQuanti(k).elem(i,j) = LaMoyenne;
                    end
                else
                    % On met des NaN pour tous les ?l?ments
                    for k = 1:length(MapQuanti) % pour chaque element
                        NewMapQuanti(k).elem(i,j) = NaN;
                    end
                end
            end
        end
    end
    XmapWaitBar(1,  handles);
    
else
    
    NewMapQuanti = MapQuanti;  % tout simplement
    
end


% Aller il faut sauvegarder maintenant...

CodeTxt = [10,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(5))]);

Name4Bulk =  {'Merged-Map'};
%Name4Bulk = inputdlg({'Name'},'...',1,{Name4Bulk});
if ~length(Name4Bulk)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
    return
end

CombQuanti = length(Quanti)+1;
%Quanti(CombQuanti) = QuantiBulk;

Quanti(CombQuanti).mineral = Name4Bulk;

for i=1:length(ListElem)
    Quanti(CombQuanti).elem(i).ref = Quanti(MapChoice(1)).elem(i).ref;
    Quanti(CombQuanti).elem(i).name = ListElem{i};
    Quanti(CombQuanti).elem(i).values = [0,0];
    Quanti(CombQuanti).elem(i).coor = [0,0];
    Quanti(CombQuanti).elem(i).raw = [0,0];
    Quanti(CombQuanti).elem(i).param = [0,0];
    Quanti(CombQuanti).elem(i).quanti = NewMapQuanti(i).elem;
end

Quanti(CombQuanti).listname = ListElem;
Quanti(CombQuanti).maskfile = {'none BULK-Quanti'};
Quanti(CombQuanti).nbpoints = 0;

Quanti(CombQuanti).isoxide = 1;

for i=1:length(Quanti)
    FListMaps{i} = char(Quanti(i).mineral);   % changed 3.2.2
end

set(handles.QUppmenu2,'String',FListMaps);
set(handles.QUppmenu2,'Value',CombQuanti);

% update
handles.quanti = Quanti;
guidata(hObject,handles);

CodeTxt = [10,6];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Name4Bulk),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(6)),' (',char(Name4Bulk),')']);
% display
QUppmenu2_Callback(hObject, eventdata, handles);
return


% #########################################################################
%       ELIMINATE PIXELS OUTSIDE (2.2.1)
function QUbutton12_Callback(hObject, eventdata, handles)
%
CutNumbers = 0; % outside (zeros in the matrix)
CutOfQuantiMaps(CutNumbers, hObject, eventdata, handles);
return


% #########################################################################
%       ELIMINATE PIXELS INSIDE (2.2.1)
function QUbutton13_Callback(hObject, eventdata, handles)
%
CutNumbers = 1; % inside (ones in the matrix)
CutOfQuantiMaps(CutNumbers, hObject, eventdata, handles);
return


% #########################################################################
%       ELIMINATE FUNCTION (2.2.1)
function CutOfQuantiMaps(CutNumbers, hObject, eventdata, handles)
%
Quanti = handles.quanti;
LaQuelle = get(handles.QUppmenu2,'Value');

ListName = Quanti(LaQuelle).listname;

% Selection of area
CodeTxt = [10,10];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(10))]);
clique = 1;
ComptResult = 1;
axes(handles.axes1); hold on

h = [0];

while clique < 2
    [a,b,clique] = XginputX(1,handles);
    if clique < 2
        h(ComptResult,1) = a;
        h(ComptResult,2) = b;
        
        [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
        
        % new (1.6.2)
        hPlot(ComptResult,1) = aPlot;
        hPlot(ComptResult,2) = bPlot;
        
        plot(floor(hPlot(ComptResult,1)),floor(hPlot(ComptResult,2)),'.w') % point
        if ComptResult >= 2 % start
            plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-m','linewidth',2)
            plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-k','linewidth',1)
        end
        ComptResult = ComptResult + 1;
    end
end

% Trois points minimum...
if length(h(:,1)) < 3
    CodeTxt = [10,11];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(11))]);
    return
end

% new V1.4.1
plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-m','linewidth',2)
plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-k','linewidth',1)

[LinS,ColS] = size(Quanti(LaQuelle).elem(1).quanti); % first element ref
MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);

%
Pixels2Delete = find(MasqueSel(:)==CutNumbers);

%keyboard

for i=1:length(Quanti(LaQuelle).elem)
    Quanti(LaQuelle).elem(i).quanti(Pixels2Delete) = zeros(size(Pixels2Delete));
end

handles.quanti = Quanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
QUppmenu2_Callback(hObject, eventdata, handles)

return


% #########################################################################
%       EXPORT PHASE PROPORTIONS OF THE SELECTED QUANTI (2.3.1)
function QUbutton18_Callback(hObject, eventdata, handles)
%


[Test] = CheckMapAndMaskfileSize(hObject, eventdata, handles); % 3.3.1
if ~Test
    return
end


Quanti = handles.quanti;

ValMin = get(handles.QUppmenu2,'Value');
%AllMin = get(handles.QUppmenu2,'String');
%SelMin = AllMin(ValMin);

lesOxi = get(handles.QUppmenu1,'String');

SumValue = zeros(size(Quanti(ValMin).elem(1).quanti));
for i=1:length(lesOxi);
    SumValue = SumValue + Quanti(ValMin).elem(i).quanti;
end
%keyboard
WhereVal = find(SumValue > 0);
SelectedPx = zeros(size(Quanti(ValMin).elem(1).quanti));
SelectedPx(WhereVal) = ones(length(WhereVal),1);

% MaskFile:
NumMask = get(handles.PPMenu3,'Value');
Liste = get(handles.PPMenu3,'String');
Name = Liste(NumMask);
MaskFile = handles.MaskFile;

Mask4Display = MaskFile(NumMask).Mask;
NbMask = MaskFile(NumMask).Nb;
NameMask = MaskFile(NumMask).NameMinerals;

MaskSelected = Mask4Display.*SelectedPx;


Occurences = zeros(NbMask,1);

for i=1:NbMask
    Occurences(i) = length(find(MaskSelected(:) == i));
end

ModalAdundances = Occurences/sum(Occurences)*100;

% Save
CodeTxt = [7,15];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(12).txt(7))]);

[Success,Message,MessageID] = mkdir('Exported-PhaseProportions');

cd Exported-PhaseProportions
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export file as');
cd ..

if ~Directory
    CodeTxt = [12,8];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end


fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Phase proportions (wt.%) from XMapTools');
fprintf(fid,'%s\n',date);
fprintf(fid,'%s\n\n\n',['Maskfile: ',char(Name)]);

fprintf(fid,'%s\n','---------------------------------');
fprintf(fid,'%s\t\t%s\t%s\n','Phase','Prop (%)','Nb Pixels');
fprintf(fid,'%s\n','---------------------------------');
for i = 1:length(ModalAdundances)
    if length(char(NameMask{i+1})) > 4
        fprintf(fid,'%s%s\t%.2f\t\t%.0f\n',char(NameMask{i+1}),': ',ModalAdundances(i),Occurences(i));
    else
        fprintf(fid,'%s%s\t\t%.2f\t\t%.0f\n',char(NameMask{i+1}),': ',ModalAdundances(i),Occurences(i));
    end
end
fprintf(fid,'%s\n','---------------------------------');

fprintf(fid,'\n\n');
fclose(fid);

CodeTxt = [7,16];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);


function [Test] = CheckMapAndMaskfileSize(hObject, eventdata, handles)
%

MaskFile = handles.MaskFile;
SelectedMaskFile = get(handles.PPMenu3,'Value');

% Check size (3.3.1)
Quanti = handles.quanti;
Selected = get(handles.QUppmenu2,'Value');
SelEl = get(handles.QUppmenu1,'Value');
TheSizeMap = size(Quanti(Selected).elem(SelEl).quanti);
TheSizeMaks = size(MaskFile(SelectedMaskFile).Mask);
if ~isequal(TheSizeMap,TheSizeMaks)
    CodeTxt = [10,45];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    waitfor(errordlg([char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))],'XMapTools'));
    Test = 0;
else
    Test = 1;
end

return


% #########################################################################
%       GENERATE A DENSITY MAP (2.2.1)
function QUbutton14_Callback(hObject, eventdata, handles)
%

MaskFile = handles.MaskFile;
SelectedMaskFile = get(handles.PPMenu3,'Value');
%SelectedMaskFile = get(handles.PPMenu1,'Value');

[Test] = CheckMapAndMaskfileSize(hObject, eventdata, handles); % 3.3.1
if ~Test
    return
end

NbPhases = MaskFile(SelectedMaskFile).Nb;

InputDensityData = 2900*ones(NbPhases,1);

Compt = 0;

MineralNameList = MaskFile(SelectedMaskFile).NameMinerals(2:end);

if isequal(exist('Classification.txt','file'),2)
    ButtonName = questdlg('Would you like to used density data stored in Classification.txt?','Classification','Yes');
    
    switch ButtonName
        
        case 'Cancel'
            CodeTxt = [10,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
            
        case 'Yes'
            fid = fopen(['Classification.txt'],'r');
            
            while 1
                LaLign = fgetl(fid);
                
                if isequal(LaLign,-1)
                    break
                end
                
                
                if ~isequal(LaLign,'') & length(LaLign) > 1
                    if isequal(LaLign(1:2),'>2')
                        
                        Compt = 0;
                        while 1
                            LaLign = fgetl(fid);
                            
                            if isequal(LaLign,-1) || isequal(LaLign,'')
                                break
                            end
                            
                            Compt = Compt+1;
                            LaLignPropre = strread(LaLign,'%f');
                            
                            InputDensityData(Compt) = LaLignPropre(1);
                        end
                        
                        
                    end
                end
            end
            fclose(fid);
            
            if ~isequal(length(MineralNameList),Compt)
                CodeTxt = [10,29];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                return
            end
    end
end

DefaultDensity = cell(size(InputDensityData));
for i=1:length(DefaultDensity)
    DefaultDensity{i} = num2str(InputDensityData(i));
end


OutputFinalDensity = inputdlg(MineralNameList,'Density data',1,DefaultDensity);

if isempty(OutputFinalDensity)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

FinalDensity = zeros(size(OutputFinalDensity));
for i=1:length(OutputFinalDensity)
    FinalDensity(i) = str2num(OutputFinalDensity{i});
end



% Generate a density map:
TheMask = MaskFile(SelectedMaskFile).Mask;
DensityMap = zeros(size(TheMask));

for i=1:length(FinalDensity)
    WhichOnes = find(TheMask == i);
    DensityMap(WhichOnes) = FinalDensity(i).*ones(size(WhichOnes));
end

AverageDensity = mean(DensityMap(find(DensityMap)));

MaskFile(SelectedMaskFile).DensityMap = DensityMap;
MaskFile(SelectedMaskFile).AverageDensity = AverageDensity;

handles.MaskFile = MaskFile;

guidata(hObject,handles);
QUbutton15_Callback(hObject, eventdata, handles)
return


% #########################################################################
%       DISPLAY THE DENSITY MAP (2.5.1)
function QUbutton15_Callback(hObject, eventdata, handles)
%

[Test] = CheckMapAndMaskfileSize(hObject, eventdata, handles); % 3.3.1
if ~Test
    return
end

MaskFile = handles.MaskFile;
SelectedMaskFile = get(handles.PPMenu3,'Value');

DensityMap = MaskFile(SelectedMaskFile).DensityMap;


% using the plot function (2.5.1)
XPlot(DensityMap,hObject, eventdata, handles);

CodeTxt = [10,28];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

GraphStyle(hObject, eventdata, handles)
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles)
return


% #########################################################################
%       GENERATE A DENSITY-CORRECTED OXIDE MAP (2.3.1)
function QUbutton16_Callback(hObject, eventdata, handles)
%

[Test] = CheckMapAndMaskfileSize(hObject, eventdata, handles); % 3.3.1
if ~Test
    return
end

MaskFile = handles.MaskFile;
SelectedMaskFile = get(handles.LeftMenuMaskFile,'Value');
%SelectedMaskFile = get(handles.PPMenu1,'Value');

Quanti = handles.quanti;
MapChoice = get(handles.QUppmenu2,'Value');

ListElem = Quanti(MapChoice).listname;

WhereDoWeWrite = length(Quanti)+1;

TheName = Quanti(MapChoice).mineral;
NewQuantiName = strcat('*DCM-',char(TheName));

DensityMap = MaskFile(SelectedMaskFile).DensityMap;
AverageDensityOri = MaskFile(SelectedMaskFile).AverageDensity;


% We recalculate the average density for the pixels we have ...
SumMap = zeros(size(Quanti(MapChoice).elem(1).quanti));
for i=1:length(Quanti(MapChoice).elem)
    SumMap = SumMap + Quanti(MapChoice).elem(i).quanti;
end
PixelsUsed = find(SumMap>0 & DensityMap>0);
AverageDensity = mean(DensityMap(PixelsUsed));

disp(['DCM ... (Density corrected map) ... processing']);
disp(['DCM ...   - Maskfile: ',char(MaskFile(SelectedMaskFile).Name)]);
disp(['DCM ...   - Map average density: ',num2str(AverageDensityOri)]);
disp(['DCM ...   - Selected pixels: ',num2str(length(PixelsUsed)),'/',num2str(size(Quanti(MapChoice).elem(i).quanti,1)*size(Quanti(MapChoice).elem(i).quanti,2))]);
disp(['DCM ...   - Local average density: ',num2str(AverageDensity)]);
disp(['DCM ...   - New Quanti file: ',char(NewQuantiName)]);
disp(['DCM ... (Density corrected map) ... done']);
disp(' ');

CodeTxt = [10,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

NewQuantiName = inputdlg({'Name'},'...',1,{NewQuantiName});
if ~length(NewQuantiName)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

CombQuanti = length(Quanti)+1;
%Quanti(CombQuanti) = QuantiBulk;

Quanti(CombQuanti).mineral = NewQuantiName;

for i=1:length(ListElem)
    Quanti(CombQuanti).elem(i).ref = Quanti(MapChoice).elem(i).ref;
    Quanti(CombQuanti).elem(i).name = ListElem{i};
    Quanti(CombQuanti).elem(i).values = [0,0];
    Quanti(CombQuanti).elem(i).coor = [0,0];
    Quanti(CombQuanti).elem(i).raw = [0,0];
    Quanti(CombQuanti).elem(i).param = [0,0];
    Quanti(CombQuanti).elem(i).quanti = (Quanti(MapChoice).elem(i).quanti.*DensityMap)./AverageDensity;
end

Quanti(CombQuanti).listname = ListElem;
Quanti(CombQuanti).maskfile = {'none BULK-Quanti (DC)'};
Quanti(CombQuanti).nbpoints = 0;
Quanti(CombQuanti).isoxide = 0;


for i=1:length(Quanti)
    FListMaps(i) = Quanti(i).mineral;
end

set(handles.QUppmenu2,'String',FListMaps);
set(handles.QUppmenu2,'Value',CombQuanti);

% update
handles.quanti = Quanti;
guidata(hObject,handles);

CodeTxt = [10,6];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(NewQuantiName),')']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

QUppmenu2_Callback(hObject, eventdata, handles);
return


% #########################################################################
%       BULK MAP (1.6.4)
function QUbutton6_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;
LaQuelle = get(handles.QUppmenu2,'Value');

ListName = Quanti(LaQuelle).listname;


% Preparation to detect Pixels values of zero (MasqueFilter variable)     % New 1.6.4
TheSumMaps = zeros(size(Quanti(LaQuelle).elem(1).quanti,1),size(Quanti(LaQuelle).elem(1).quanti,2));
MasqueFilter = zeros(size(Quanti(LaQuelle).elem(1).quanti,1),size(Quanti(LaQuelle).elem(1).quanti,2));
for i=1:length(Quanti(LaQuelle).elem)
    TheSumMaps= TheSumMaps + Quanti(LaQuelle).elem(i).quanti;
end

MasqueFilter(find(TheSumMaps > 0)) = ones(length(find(TheSumMaps > 0)),1);


for i=1:length(Quanti(LaQuelle).elem)
    LesVals = Quanti(LaQuelle).elem(i).quanti(:);
    LesVals = LesVals + 0.0000001;
    LesValsOk = LesVals .* MasqueFilter(:);
    LaMoy(i) = mean(LesValsOk(find(LesValsOk > 0))); % NaNs are rejected.
end

CodeTxt = [10,8];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(8))]);

[Success,Message,MessageID] = mkdir('Exported-LocalCompos');

cd Exported-LocalCompos
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export Bulk-compo as');
cd ..

if ~Directory
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
    return
end


fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Local composition (Map) from XMapTools');
fprintf(fid,'%s\n\n',date);

for i = 1:length(ListName)
    fprintf(fid,'%s\t',[char(ListName(i))]);
    fprintf(fid,'%s\n',[num2str(LaMoy(i))]);
end

fprintf(fid,'\n');

fprintf(fid,'%s\t',['SUM']);
fprintf(fid,'%s\n',[num2str(sum(LaMoy))]);

fclose(fid);

CodeTxt = [10,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(9))]);

WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
return


% #########################################################################
%       BULK AREA (1.6.4)
function QUbutton7_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;
LaQuelle = get(handles.QUppmenu2,'Value');

ListName = Quanti(LaQuelle).listname;

% Selection of area
CodeTxt = [10,10];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(10))]);
clique = 1;
ComptResult = 1;
axes(handles.axes1); hold on

h = [0];

while clique < 2
    [a,b,clique] = XginputX(1,handles);
    if clique < 2
        h(ComptResult,1) = a;
        h(ComptResult,2) = b;
        
        [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
        
        % new (1.6.2)
        hPlot(ComptResult,1) = aPlot;
        hPlot(ComptResult,2) = bPlot;
        
        plot(floor(hPlot(ComptResult,1)),floor(hPlot(ComptResult,2)),'.w') % point
        if ComptResult >= 2 % start
            plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-m','linewidth',2)
            plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-k','linewidth',1)
        end
        ComptResult = ComptResult + 1;
    end
end

% Trois points minimum...
if length(h(:,1)) < 3
    CodeTxt = [10,11];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(11))]);
    return
end

% new V1.4.1
plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-m','linewidth',2)
plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-k','linewidth',1)

[LinS,ColS] = size(Quanti(LaQuelle).elem(1).quanti); % first element ref

% Calculate the average:

[LaMoy] = ExtractCompoFromSurface(h,Quanti,LaQuelle,LinS,ColS);

ButtonName = questdlg('Do you want to estimate the uncertainty using Monte-Carlo?','LBC','Yes');

UncEstimate = 0;
switch ButtonName
    case 'Cancel'
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        return
        
    case 'Yes'
        UncEstimate = 1;
end

if UncEstimate
    
    Answer = inputdlg({'Permutations','Size (px)'},'LBC',1,{'100','10'});
    
    if isempty(Answer)
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        return
    end
    
    NbPerm = str2num(Answer{1});
    Sensibility = str2num(Answer{2})/2; % half of the value
    
    LesStd = zeros(NbPerm,size(LaMoy,2));
    
    CodeTxt = [10,31];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    
    XmapWaitBar(0,  handles);
    
    Compt = 0;
    for i=1:NbPerm
        Compt = Compt+1;
        if Compt > NbPerm*0.05
            XmapWaitBar(i/NbPerm,  handles);
        end
        
        Coord = h+Sensibility.*randn(size(h));
        
        [LesStd(i,:)] = ExtractCompoFromSurface(Coord,Quanti,LaQuelle,LinS,ColS);
        
        axes(handles.axes1);
        plot([Coord(:,1);Coord(1,1)],[Coord(:,2);Coord(1,2)],'.-k')
        drawnow
    end
    
    plot(hPlot(:,1),hPlot(:,2),'.w');
    plot([h(:,1);h(1,1)],[h(:,2);h(1,2)],'-m','linewidth',2)
    plot([h(:,1);h(1,1)],[h(:,2);h(1,2)],'-w','linewidth',1)
    
    XmapWaitBar(1, handles);
    
    CodeTxt = [10,32];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    LaStd = std(LesStd,1);
end

CodeTxt = [10,8];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(8))]);

[Success,Message,MessageID] = mkdir('Exported-LocalCompos');

cd Exported-LocalCompos
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export Bulk-compo as');
cd ..

if ~Directory
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
    return
end


fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Local composition (Area) from XMapTools');
fprintf(fid,'%s\n\n',date);

if UncEstimate
    fprintf(fid,'%s\t%s\t%s\n','Elem.','Mean','Std');
end
for i = 1:length(ListName)
    fprintf(fid,'%s\t',[char(ListName(i))]);
    if UncEstimate
        fprintf(fid,'%s\t',[num2str(LaMoy(i))]);
        fprintf(fid,'%s\n',[num2str(LaStd(i))]);
    else
        fprintf(fid,'%s\n',[num2str(LaMoy(i))]);
    end
    
end

fprintf(fid,'\n');

fprintf(fid,'%s\t',['SUM']);
fprintf(fid,'%s\n',[num2str(sum(LaMoy))]);

fclose(fid);

CodeTxt = [10,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(9))]);

WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
return


% #########################################################################
%       EXTRACT COMPOSITION FROM A GIVEN SURFACE (1.6.4)
function [LaMoy] = ExtractCompoFromSurface(h,Quanti,LaQuelle,LinS,ColS)
%
MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);

% if 1
%     figure(1), imagesc(MasqueSel), axis image, colorbar, drawnow
%     pause(0.1)
% end

% Preparation to detect Pixels values of zero (MasqueFilter variable)     % New 1.6.4
TheSumMaps = zeros(size(Quanti(LaQuelle).elem(1).quanti,1),size(Quanti(LaQuelle).elem(1).quanti,2));
MasqueFilter = zeros(size(Quanti(LaQuelle).elem(1).quanti,1),size(Quanti(LaQuelle).elem(1).quanti,2));
for i=1:length(Quanti(LaQuelle).elem)
    TheSumMaps= TheSumMaps + Quanti(LaQuelle).elem(i).quanti;
end

MasqueFilter(find(TheSumMaps > 0)) = ones(length(find(TheSumMaps > 0)),1);

for i=1:length(Quanti(LaQuelle).elem)
    LesVals = Quanti(LaQuelle).elem(i).quanti(:);
    LesVals = LesVals + 0.0000001;
    LesValsOk = LesVals .* MasqueSel(:).*MasqueFilter(:);
    LaMoy(i) = mean(LesValsOk(find(LesValsOk > 0))); % NaNs are rejected.
end

return


% #########################################################################
%       BULK VARIABLE SIZE RECTANGLE (2.2.3)
function QUbutton13rec_Callback(hObject, eventdata, handles)
%

% This function is not compatible with the rotate images ...
TestRotate = TestRotateFigure(hObject, eventdata, handles);

if ~TestRotate
    return
end

Quanti = handles.quanti;
LaQuelle = get(handles.QUppmenu2,'Value');

[LinS,ColS] = size(Quanti(LaQuelle).elem(1).quanti); % first element ref

ListName = Quanti(LaQuelle).listname;

% Define the reference rectangle...
axes(handles.axes1), hold on

for i=1:2
    CodeTxt = [10,32+i];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [a,b,clique] = XginputX(1,handles);
    if clique < 2
        h(i,1) = a;
        h(i,2) = b;
        
        [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
        
        % new (1.6.2)
        hPlot(i,1) = aPlot;
        hPlot(i,2) = bPlot;
        
        plot(floor(hPlot(i,1)),floor(hPlot(i,2)),'.w') % point
    else
        CodeTxt = [10,23];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
end

XMin = min(h(:,1));
XMax = max(h(:,1));
YMin = min(h(:,2));
YMax = max(h(:,2));

[XMinPlot,YMinPlot] = CoordinatesFromRef(XMin,YMin,handles);
[XMaxPlot,YMaxPlot] = CoordinatesFromRef(XMax,YMax,handles);

plot([XMinPlot,XMaxPlot],[YMinPlot,YMinPlot],'-m','linewidth',2), plot([XMinPlot,XMaxPlot],[YMinPlot,YMinPlot],'-k','linewidth',1)
plot([XMinPlot,XMaxPlot],[YMaxPlot,YMaxPlot],'-m','linewidth',2), plot([XMinPlot,XMaxPlot],[YMaxPlot,YMaxPlot],'-k','linewidth',1)
plot([XMinPlot,XMinPlot],[YMinPlot,YMaxPlot],'-m','linewidth',2), plot([XMinPlot,XMinPlot],[YMinPlot,YMaxPlot],'-k','linewidth',1)
plot([XMaxPlot,XMaxPlot],[YMinPlot,YMaxPlot],'-m','linewidth',2), plot([XMaxPlot,XMaxPlot],[YMinPlot,YMaxPlot],'-k','linewidth',1)

CodeTxt = [10,35];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% Here the strategy does not work...
if isequal(handles.rotateFig,0)
    %     if handles.MatlabVersion>=7.14
    %         Mode = menuX('XMapTools','top-left corner','top-right corner','bottom-left corner','bottom-right corner');
    %     else
    %         Mode = menu('XMapTools','top-left corner','top-right corner','bottom-left corner','bottom-right corner');
    %     end
    
    % New Menu Alice Vho - 6.07.2017
    Mode = Menu_XMT({'XMapTools'},{'top-left corner','top-right corner','bottom-left corner','bottom-right corner'},handles.LocBase);
    
elseif isequal(handles.rotateFig,90)
    %     if handles.MatlabVersion>=7.14
    %         Mode = menuX('XMapTools','bottom-left corner','bottom-right corner','top-left corner','top-right corner');
    %     else
    %         Mode = menu('XMapTools','bottom-left corner','bottom-right corner','top-left corner','top-right corner');
    %     end
    
    % New Menu Alice Vho - 6.07.2017
    Mode = Menu_XMT({'XMapTools'},{'bottom-left corner','bottom-right corner','top-left corner','top-right corner'},handles.LocBase);
    
end

switch Mode
    case 1
        plot(XMinPlot,YMinPlot,'.w')
    case 2
        plot(XMaxPlot,YMinPlot,'.w')
    case 3
        plot(XMinPlot,YMaxPlot,'.w')
    case 4
        plot(XMaxPlot,YMaxPlot,'.w')
end

CodeTxt = [10,35+Mode];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[XSmall,YSmall,clique] = XginputX(1,handles);
if clique < 2
    %XSmall = a;
    %YSmall = b;
    
    [XSmallPlot,YSmallPlot] = CoordinatesFromRef(XSmall,YSmall,handles);
    
    plot(floor(XSmallPlot),floor(YSmallPlot),'.w') % point
else
    CodeTxt = [10,40];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

switch Mode
    case 1
        plot([XMinPlot,XSmallPlot],[YSmallPlot,YSmallPlot],'-m','linewidth',2), plot([XMinPlot,XSmallPlot],[YSmallPlot,YSmallPlot],'-k','linewidth',1)
        plot([XSmallPlot,XSmallPlot],[YMinPlot,YSmallPlot],'-m','linewidth',2), plot([XSmallPlot,XSmallPlot],[YMinPlot,YSmallPlot],'-k','linewidth',1)
    case 2
        plot([XSmallPlot,XMaxPlot],[YSmallPlot,YSmallPlot],'-m','linewidth',2), plot([XSmallPlot,XMaxPlot],[YSmallPlot,YSmallPlot],'-k','linewidth',1)
        plot([XSmallPlot,XSmallPlot],[YMinPlot,YSmallPlot],'-m','linewidth',2), plot([XSmallPlot,XSmallPlot],[YMinPlot,YSmallPlot],'-k','linewidth',1)
    case 3
        plot([XMinPlot,XSmallPlot],[YSmallPlot,YSmallPlot],'-m','linewidth',2), plot([XMinPlot,XSmallPlot],[YSmallPlot,YSmallPlot],'-k','linewidth',1)
        plot([XSmallPlot,XSmallPlot],[YMaxPlot,YSmallPlot],'-m','linewidth',2), plot([XSmallPlot,XSmallPlot],[YMaxPlot,YSmallPlot],'-k','linewidth',1)
    case 4
        plot([XSmallPlot,XMaxPlot],[YSmallPlot,YSmallPlot],'-m','linewidth',2), plot([XSmallPlot,XMaxPlot],[YSmallPlot,YSmallPlot],'-k','linewidth',1)
        plot([XSmallPlot,XSmallPlot],[YMaxPlot,YSmallPlot],'-m','linewidth',2), plot([XSmallPlot,XSmallPlot],[YMaxPlot,YSmallPlot],'-k','linewidth',1)
end


% Define the shape ...
CodeTxt = [10,43];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

NbSteps = str2num(char(inputdlg({'Steps'},'XMapTools',1,{'30'})));

% The order of the corners is
%
%  1-----------2
%  |           |
%  |           |
%  |           |
%  |           |
%  4-----------3
%

switch Mode
    case 1
        dX = (XMax-XSmall)/(NbSteps-1);
        dY = (YMax-YSmall)/(NbSteps-1);
        
        Xtemp = [XMin,XSmall,XSmall,XMin];
        Ytemp = [YMin,YMin,YSmall,YSmall];
        
        Xupd = [0,1,1,0];
        Yupd = [0,0,1,1];
    case 2
        dX = -(XSmall-XMin)/(NbSteps-1);
        dY = (YMax-YSmall)/(NbSteps-1);
        
        Xtemp = [XSmall,XMax,XMax,XSmall];
        Ytemp = [YMin,YMin,YSmall,YSmall];
        
        Xupd = [1,0,0,1];
        Yupd = [0,0,1,1];
        
    case 3
        dX = (XMax-XSmall)/(NbSteps-1);
        dY = -(YSmall-YMin)/(NbSteps-1);
        
        Xtemp = [XMin,XSmall,XSmall,XMin];
        Ytemp = [YSmall,YSmall,YMax,YMax];
        
        Xupd = [0,1,1,0];
        Yupd = [1,1,0,0];
    case 4
        dX = -(XSmall-XMin)/(NbSteps-1);
        dY = -(YSmall-YMin)/(NbSteps-1);
        
        Xtemp = [XSmall,XMax,XMax,XSmall];
        Ytemp = [YSmall,YSmall,YMax,YMax];
        
        Xupd = [1,0,0,1];
        Yupd = [1,1,0,0];
end

CodeTxt = [10,41];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

XmapWaitBar(0, handles);

IncSurf = zeros(1,NbSteps);
for i=1:NbSteps
    
    XmapWaitBar(i/NbSteps, handles);
    
    if i>1
        Xtemp = Xtemp + dX.*Xupd;
        Ytemp = Ytemp + dY.*Yupd;
    end
    
    IncSurf(i) = (max(Xtemp)-min(Xtemp)) * (max(Ytemp)-min(Ytemp)); % in px^2
    
    [XtempPlot,YtempPlot] = CoordinatesFromRef(Xtemp,Ytemp,handles);
    
    axes(handles.axes1);
    plot(XtempPlot,YtempPlot,'.k')
    drawnow
    
    Compos(i,:) = ExtractCompoFromSurface([Xtemp',Ytemp'],Quanti,LaQuelle,LinS,ColS);
end

CodeTxt = [10,42];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

RelSurf = IncSurf/IncSurf(end);
RefC = repmat(Compos(end,:),NbSteps,1);
RelCompos = (Compos-RefC)./RefC*100;
DifCompos = Compos-RefC;

% ColorCodes = 0.3*ones(length(ListName),3);
% ColorCodes(:,2) = [0:(1/(length(ListName)-1)):1]';

Colorcodes(:,1) = randperm(length(ListName))/length(ListName);
Colorcodes(:,2) = randperm(length(ListName))/length(ListName);
Colorcodes(:,3) = randperm(length(ListName))/length(ListName);

figure, hold on
for i = 1:length(ListName)
    plot(RelSurf,RelCompos(:,i),'o-','Color',Colorcodes(i,:)); %rand(1,3))
end
legend(ListName)
xlabel('Surface fraction'), ylabel('Relative variation (%)')

figure, hold on
for i = 1:length(ListName)
    plot(RelSurf,Compos(:,i),'o-','Color',Colorcodes(i,:)); %rand(1,3))
end
legend(ListName)
xlabel('Surface fraction'), ylabel('Absolute variation (Wt-%)')

figure, hold on
for i = 1:length(ListName)
    plot(RelSurf,DifCompos(:,i),'o-','Color',Colorcodes(i,:)); %rand(1,3))
end
legend(ListName)
xlabel('Surface fraction'), ylabel('Composition (Wt-%)')

return

% Save ...
CodeTxt = [10,8];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Success,Message,MessageID] = mkdir('Exported-LocalCompos');

cd Exported-LocalCompos
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export Bulk-compo as');
cd ..

if ~Directory
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
    return
end


fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Local composition (Variable size rectangle) from XMapTools');
fprintf(fid,'%s\n\n',date);

RefComposition = Compos(end,:);

fprintf(fid,'%s\n','(1) REFERENCE COMPOSITION (domain)');
for i = 1:length(ListName)
    fprintf(fid,'%s\t',[char(ListName(i))]);
    fprintf(fid,'%s\n',[num2str(RefComposition(i))]);
end

fprintf(fid,'\n');

fprintf(fid,'%s\t',['SUM']);
fprintf(fid,'%s\n',[num2str(sum(RefComposition))]);


fprintf(fid,'\n\n');

fprintf(fid,'%s\n','(2) SURFACES % SURFACE FRACTIONS');
fprintf(fid,'%s\t','Surface    (px^2)');
for i=1:length(IncSurf)
    fprintf(fid,'%s\t',num2str(IncSurf(i)));
end
fprintf(fid,'\n');
fprintf(fid,'%s\t','Surface fractions');
for i=1:length(RelSurf)
    fprintf(fid,'%s\t',num2str(RelSurf(i)));
end
fprintf(fid,'\n');


fprintf(fid,'\n\n');

fprintf(fid,'%s\n','(3) ALL LOCAL COMPOSITIONS (RAW DATA)');
for i=1:size(Compos,1)
    for j=1:size(Compos,2)
        fprintf(fid,'%s\t',num2str(Compos(i,j)));
    end
    fprintf(fid,'\n');
end

fprintf(fid,'\n\n');

fprintf(fid,'%s\n','(4) DIFFERENCES (%)');
for i=1:size(RelCompos,1)
    for j=1:size(RelCompos,2)
        fprintf(fid,'%s\t',num2str(RelCompos(i,j)));
    end
    fprintf(fid,'\n');
end

fclose(fid);

CodeTxt = [10,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(9))]);

WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
return


% #########################################################################
%       BULK ELLIPSE - VOLUME (2.1.7)
function QUbutton10_Callback(hObject, eventdata, handles)
%
Quanti = handles.quanti;
LaQuelle = get(handles.QUppmenu2,'Value');
SelElement = get(handles.QUppmenu1,'Value');

TheDisplayedMap = Quanti(LaQuelle).elem(SelElement).quanti;

ListName = Quanti(LaQuelle).listname;

Cmin = str2num(get(handles.ColorMin,'String'));
Cmax = str2num(get(handles.ColorMax,'String'));


while 1
    [RefEllipseData] = DefineAnEllipse(hObject, eventdata, handles);
    
    if ~length(RefEllipseData)
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    
    CodeTxt = [10,21];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    ButtonName = questdlg('Are you happy with this ellipse?','Ellipse','Yes');
    
    
    switch ButtonName
        case 'Cancel'
            CodeTxt = [10,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
            
        case 'No'
            % Clean axes
            QUppmenu2_Callback(hObject, eventdata, handles);
            axes(handles.axes1);
            if Cmax > Cmin
                caxis([Cmin,Cmax]);
            end
            
        case 'Yes'
            break
    end
end

while 1
    % Here we have the final Ellipse...
    [RefsIntEllipse] = DefineIntegrationsOfEllipse(RefEllipseData,hObject, eventdata, handles);
    
    if ~length(RefsIntEllipse)
        return
    end
    
    CodeTxt = [10,26];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    ButtonName = questdlg('Are you happy with the integrations?','Ellipse','Yes');
    
    switch ButtonName
        case 'Cancel'
            CodeTxt = [10,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
            
        case 'No'
            % Clean axes
            Cmin = str2num(get(handles.ColorMin,'String'));
            Cmax = str2num(get(handles.ColorMax,'String'));
            QUppmenu2_Callback(hObject, eventdata, handles);
            axes(handles.axes1);
            if Cmax > Cmin
                caxis([Cmin,Cmax]);
            end
            % plot the ellipse
            hold on
            plot(RefEllipseData.XY4plot(1,:),RefEllipseData.XY4plot(2,:),'m','linewidth',2);
            plot(RefEllipseData.XY4plot(3,:),RefEllipseData.XY4plot(4,:),'m');
            PlotEllipse(RefEllipseData,1,handles,1);
            
        case 'Yes'
            break
    end
end

if ~length(RefsIntEllipse)
    return % the message was defined before ...
end

% Extra figures
DispExtraFigs = 0;
% Answer = questdlg('Would you like to display the extra-figures?','XMapTools','No');
% switch Answer
%     case 'Yes'
%         DispExtraFigs = 1;
% end

% Calculate the composition in 3D from the integrations:
RefsIntEllipse(end+1) = 1;
NbInt = length(RefsIntEllipse);

[LinS,ColS] = size(Quanti(LaQuelle).elem(1).quanti); % first element ref

RadiusMaj = RefEllipseData.RadiusMaj;
RadiusMin = RefEllipseData.RadiusMin;
Radius3D = RadiusMaj;

% *** Radius3D = RadiusMaj; ***
% This is an assumption to calculate the volume but it does not matter for
% the volume fractions, the ones used for the computation...

% [1] HD volume vs pixels relationship: WE DO NOT PLOT...
RefsIntEllipseHD = 0:0.02:1;
NbIntHD = length(RefsIntEllipseHD);

CodeTxt = [10,27];
set(handles.TxtControl,'String',[,char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[EllipsoidPropHD] = EllipsoidVolumes(0,RadiusMaj,RadiusMin,Radius3D,NbIntHD,RefsIntEllipseHD,RefEllipseData,LinS,ColS,Cmin,Cmax,TheDisplayedMap,hObject,eventdata,handles);

% [2] volume vs pixels fractions for RefsIntEllipse...
if DispExtraFigs
    [EllipsoidProp] = EllipsoidVolumes(1,RadiusMaj,RadiusMin,Radius3D,NbInt,RefsIntEllipse,RefEllipseData,LinS,ColS,Cmin,Cmax,TheDisplayedMap,hObject,eventdata,handles);
else
    [EllipsoidProp] = EllipsoidVolumes(0,RadiusMaj,RadiusMin,Radius3D,NbInt,RefsIntEllipse,RefEllipseData,LinS,ColS,Cmin,Cmax,TheDisplayedMap,hObject,eventdata,handles);
end
figure, hold on
plot(cumsum(EllipsoidProp.SurfaceFractionsPx),cumsum(EllipsoidProp.SurfaceFractions),'--ok','MarkerEdgeColor','k','MarkerFaceColor','r','markersize',5)
plot(cumsum(EllipsoidPropHD.SurfaceFractionsPx),cumsum(EllipsoidPropHD.VolumeFractions),'-b','linewidth',1);
plot(cumsum(EllipsoidProp.SurfaceFractionsPx),cumsum(EllipsoidProp.VolumeFractions),'o','MarkerEdgeColor','b','MarkerFaceColor','r','markersize',5);
xlabel('Cumulative pixel fraction')
ylabel('Cumulative volume (blue) or surface (black) fraction')
axis([0,1,0,1])

% Preparation to detect Pixels values of zero (MasqueFilter variable)     % New 1.6.4
TheSumMaps = zeros(size(Quanti(LaQuelle).elem(1).quanti,1),size(Quanti(LaQuelle).elem(1).quanti,2));
MasqueFilter = zeros(size(Quanti(LaQuelle).elem(1).quanti,1),size(Quanti(LaQuelle).elem(1).quanti,2));
for i=1:length(Quanti(LaQuelle).elem)
    TheSumMaps= TheSumMaps + Quanti(LaQuelle).elem(i).quanti;
end

MasqueFilter(find(TheSumMaps > 0)) = ones(length(find(TheSumMaps > 0)),1);

for i=1:length(Quanti(LaQuelle).elem)
    LesVals = Quanti(LaQuelle).elem(i).quanti(:);
    LesVals = LesVals + 0.0000001;
    for j=1:NbInt
        LesValsOk = LesVals .* EllipsoidProp.Masks(j).MasqueSel(:).*MasqueFilter(:);
        %figure, imagesc(EllipsoidProp.Masks(j).MasqueSel), axis image
        LaMoy(i,j) = mean(LesValsOk(find(LesValsOk > 0))); % NaNs are rejected.
    end
end

TheBulkCompo = EllipsoidProp.VolumeFractions*LaMoy';

CodeTxt = [10,8];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Success,Message,MessageID] = mkdir('Exported-LocalCompos');

cd Exported-LocalCompos
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export local-compo as');
cd ..

if ~Directory
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(4))]);
    return
end

fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Local composition (Ellipsoid) from XMapTools');
fprintf(fid,'%s\n\n',date);

fprintf(fid,'%s\n','Reference ellipse information:');
fprintf(fid,'%s\t%.2f\t%.2f\n','   Center position (X,Y)',RefEllipseData.XAc,RefEllipseData.XAc);
fprintf(fid,'%s\t%.2f\n','   Slope Major axis',RefEllipseData.SlopeMaj);
fprintf(fid,'%s\t%.2f\n','   Radius Major axis',RefEllipseData.RadiusMaj);
fprintf(fid,'%s\t%.2f\n','   Radius Minor axis',RefEllipseData.RadiusMin);
fprintf(fid,'%s\t%.2f\n','   Surface (Nb of pixels)',EllipsoidProp.NbPixelsEllipse);
fprintf(fid,'%s\t%.2f\n\n','   Surface (in px^2)',EllipsoidProp.SurfaceEllipse);

fprintf(fid,'%s\n','Integrations:');
fprintf(fid,'%s\t%.2f\t\n','   Number of integrations',NbInt);

CaraString = '%s\t';
CaraString0 = '%s\t';
for i=1:NbInt
    CaraString = [CaraString,'%.6f\t'];
    CaraString0 = [CaraString0,'%.0f\t'];
end
CaraString = [CaraString,'\n'];
CaraString0 = [CaraString0,'\n'];

fprintf(fid,char(CaraString),'   Integration values       ',RefsIntEllipse);
fprintf(fid,char(CaraString0),'   Volumes integrations (px^3)',EllipsoidProp.VolumesInt);
fprintf(fid,char(CaraString),'   Volumes fractions        ',EllipsoidProp.VolumeFractions);
fprintf(fid,char(CaraString0),'   Nb pixels integrations    ',EllipsoidProp.NumberOfPixels);
fprintf(fid,char(CaraString0),'   Surface integrations (px^2)',EllipsoidProp.SurfaceInt);
fprintf(fid,char(CaraString),'   Surface fraction (from px)',EllipsoidProp.SurfaceFractionsPx);
fprintf(fid,char([CaraString,'\n']),'   Surface fraction (in px^2)',EllipsoidProp.SurfaceFractions);

fprintf(fid,'%s\n','Compositions integrations:');
for i = 1:length(ListName)
    fprintf(fid,'%s\t',[char(ListName(i))]);
    for j=1:NbInt
        fprintf(fid,'%.3f\t',LaMoy(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');

fprintf(fid,'%s\n','Extrapolated (ellipsoid) local Compositions:');
for i = 1:length(ListName)
    fprintf(fid,'%s\t',[char(ListName(i))]);
    fprintf(fid,'%.3f\n',TheBulkCompo(i));
end
fprintf(fid,'\n');

fprintf(fid,'%s\t',['SUM']);
fprintf(fid,'%s\n',[num2str(sum(TheBulkCompo))]);

fclose(fid);

CodeTxt = [10,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(10).txt(9))]);

WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
return


% #########################################################################
%       DEFINE AN ELLIPSE (V2.1.7)
function [RefEllipseData] = DefineAnEllipse(hObject, eventdata, handles)
%
RefEllipseData = [];

% Extract the image to get the coordinates
axes(handles.axes1)
axis image
lesInd = get(handles.axes1,'child');

for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            Data = get(lesInd(i),'CData');
        end
    end
end

% Select the three pixels used to define an ellipse
for iS = 1:2
    
    if iS == 1
        CodeTxt = [10,18];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    else
        CodeTxt = [10,19];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    end
    
    [Xref,Yref,Clique] = XginputX(1,handles);
    
    % We work in the normal (xref,yref) system...
    X(iS) = Xref;
    Y(iS) = Yref;
    
    [XPlot(iS),YPlot(iS)] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
    
    if Clique == 3
        CodeTxt = [12,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
    %     X(iS) = round(X(iS));
    %     Y(iS) = round(Y(iS));
    
    if i==2 % Horizontal and vertical lines doesn't work
        if X(2) == X(1)
            X(2) = X(2)+0.01;
        end
        if Y(2) == Y(1)
            Y(2) = Y(2)+0.01;
        end
    end
    
    axes(handles.axes1)
    hold on, plot(XPlot(iS),YPlot(iS),'o','MarkerEdgeColor','r','MarkerFaceColor','w')
end

% Coordinates of the image
XMin = 0;
XMax = size(Data,2);
YMin = 0;
YMax = size(Data,1);


% Coordinates of the point A1:
XA1 = X(1);
YA1 = Y(1);

% Coordinates of the point A2:
XA2 = X(2);
YA2 = Y(2);

% Coordinates of the center Ac point:
XAc = min([XA1,XA2]) + abs(XA1-XA2)/2;
YAc = min([YA1,YA2]) + abs(YA1-YA2)/2;

axes(handles.axes1)
[XAcPlot,YAcPlot] = CoordinatesFromRef(XAc,YAc,handles);
hold on, plot(XAcPlot,YAcPlot,'o','MarkerEdgeColor','r','MarkerFaceColor','w');

[XA1Plot,YA1Plot] = CoordinatesFromRef(XA1,YA1,handles);
[XA2Plot,YA2Plot] = CoordinatesFromRef(XA2,YA2,handles);
plot([XA1Plot,XA2Plot],[YA1Plot,YA2Plot],'-m')

% Equation of A1-A2
if XA2>XA1
    SlopeA12 = (YA2-YA1)/(XA2-XA1);
else
    SlopeA12 = (YA1-YA2)/(XA1-XA2);
end
InterA12 = YA1 - SlopeA12*(XA1);

SlopeB12 = -(1/SlopeA12);
InterB12 = YAc - SlopeB12*(XAc);

if InterA12 >= 0
    YB1 = YMin;
    XB1 = (YB1-InterB12)/SlopeB12;
    
    YB2 = YMax;
    XB2 = (YB2-InterB12)/SlopeB12;
else
    XB1 = 0;
    YB1 = InterB12;
    
    XB2 = XMax;
    YB2 = SlopeB12*XB2+InterB12;
end

[XB1Plot,YB1Plot] = CoordinatesFromRef(XB1,YB1,handles);
[XB2Plot,YB2Plot] = CoordinatesFromRef(XB2,YB2,handles);
plot([XB1Plot,XB2Plot],[YB1Plot,YB2Plot],'-m')

% Select the tird point:
CodeTxt = [10,20];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Xref,Yref,Clique] = XginputX(1,handles);

XSelBs = Xref;
YSelBs = Yref;
%[XSelBs,YSelBs] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX

% Closest Bs on the B12 line:
a=SlopeB12;
b=-1;
c=InterB12;

XBs = (b*(b*XSelBs-a*YSelBs)-a*c)/(a^2+b^2);
YBs = (a*(-b*XSelBs+a*YSelBs)-b*c)/(a^2+b^2);

% second Axe:
SlopeBsm = (YAc-YBs)/(XAc-XBs);  % Just to check consistency... should be SlopeB12
InterBsm = YBs - SlopeBsm*(XBs); % Just to check consistency... should be InterB12

if SlopeBsm > 0
    if XBs < XAc
        XBm = min([XBs,XAc]) + 2*abs(XBs-XAc);  % OK
        YBm = min([YBs,YAc]) + 2*abs(YBs-YAc);  % OK
    else
        XBm = max([XBs,XAc]) - 2*abs(XBs-XAc);
        YBm = max([YBs,YAc]) - 2*abs(YBs-YAc);
    end
else
    if XBs > XAc
        XBm = max([XBs,XAc]) - 2*abs(XBs-XAc);  % OK
        YBm = min([YBs,YAc]) + 2*abs(YBs-YAc);  % OK
    else
        XBm = min([XBs,XAc]) + 2*abs(XBs-XAc);  % OK
        YBm = max([YBs,YAc]) - 2*abs(YBs-YAc);  % OK
    end
end

[XBsPlot,YBsPlot] = CoordinatesFromRef(XBs,YBs,handles);
[XBmPlot,YBmPlot] = CoordinatesFromRef(XBm,YBm,handles);

hold on, plot(XBsPlot,YBsPlot,'o','MarkerEdgeColor','r','MarkerFaceColor','w');
hold on, plot(XBmPlot,YBmPlot,'o','MarkerEdgeColor','r','MarkerFaceColor','w');
drawnow

% Select the major axis and apply the correct case...
DistA = sqrt(abs(XA1-XA2)^2+abs(YA1-YA2)^2);
DistB = sqrt(abs(XBs-XBm)^2+abs(YBs-YBm)^2);

if DistA > DistB
    % Major axis is A
    SlopeMaj = SlopeA12;
    RadiusMaj = DistA;
    RadiusMin = DistB;
    IntMaj = InterA12;
    
    XY4plot = [XA1Plot,XA2Plot;YA1Plot,YA2Plot;XBsPlot,XBmPlot;YBsPlot,YBmPlot];
    
    plot([XA1Plot,XA2Plot],[YA1Plot,YA2Plot],'-m','linewidth',2)
else
    SlopeMaj = SlopeBsm;
    RadiusMaj = DistB;
    RadiusMin = DistA;
    IntMaj = InterBsm;
    
    XY4plot = [XBsPlot,XBmPlot;YBsPlot,YBmPlot;XA1Plot,XA1Plot;YA1Plot,YA2Plot];
    
    plot([XBsPlot,XBmPlot],[YBsPlot,YBmPlot],'-m','linewidth',2)
end

StrFact = 1;

RefEllipseData.XAc = XAc;
RefEllipseData.YAc = YAc;
RefEllipseData.SlopeMaj = SlopeMaj;
RefEllipseData.RadiusMaj = RadiusMaj;
RefEllipseData.RadiusMin = RadiusMin;
RefEllipseData.MajorAxisabc = [SlopeMaj,-1,IntMaj];
RefEllipseData.XY4plot = XY4plot;

PlotEllipse(RefEllipseData,StrFact,handles,1);


return


% #########################################################################
%       DEFINE INTEGRATIONS OF ELLIPSES (V2.1.7)
function [RefsIntEllipse] = DefineIntegrationsOfEllipse(RefEllipseData,hObject, eventdata, handles)
%
RefsIntEllipse = [];

% Definition of the Major axis ...
a = RefEllipseData.MajorAxisabc(1);
b = RefEllipseData.MajorAxisabc(2);
c = RefEllipseData.MajorAxisabc(3);


iS = 0;
while 1
    CodeTxt = [10,22];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [Xref,Yref,Clique] = XginputX(1,handles);
    
    if Clique == 3
        break
    end
    
    iS = iS+1;
    %[X,Y] = CoordinatesFromRef(Xref,Yref,handles);   % update 1.6.2 XimrotateX
    
    Xfit(iS) = (b*(b*Xref-a*Yref)-a*c)/(a^2+b^2);
    Yfit(iS) = (a*(-b*Xref+a*Yref)-b*c)/(a^2+b^2);
    
    [XfitPlot(iS),YfitPlot(iS)] = CoordinatesFromRef(Xfit(iS),Yfit(iS),handles);
    
    hold on, plot(XfitPlot(iS),YfitPlot(iS),'o','MarkerEdgeColor','r','MarkerFaceColor','w');
    
    Dist(iS) = sqrt((Xfit(iS)-RefEllipseData.XAc)^2 + (Yfit(iS)-RefEllipseData.YAc)^2);
    StrFactor(iS) = 2*Dist(iS)/RefEllipseData.RadiusMaj;
    
    PlotEllipse(RefEllipseData,StrFactor(iS),handles,1);
end

% Check the quality of results ...
if length(StrFactor) < 2
    CodeTxt = [10,23];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

for i=2:length(StrFactor)
    if StrFactor(i) < StrFactor(i-1)
        CodeTxt = [10,24];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
end

if length(find(StrFactor>=1))
    CodeTxt = [10,25];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

RefsIntEllipse = StrFactor;

return


% #########################################################################
%       PLOT AND CURVES OF AN ELLIPSE (V2.1.7)
function [EllipseCoor] = PlotEllipse(RefEllipseData,StrFact,handles,DoWePlot);
%

XAc = RefEllipseData.XAc;
YAc = RefEllipseData.YAc;
SlopeMaj = RefEllipseData.SlopeMaj;
RadiusMaj = RefEllipseData.RadiusMaj;
RadiusMin = RefEllipseData.RadiusMin;

xpos = XAc;
ypos = YAc;
radm = StrFact*(RadiusMaj/2);
radn = StrFact*(RadiusMin/2);
an = atan(SlopeMaj);

Nb=150;

co=cos(an);
si=sin(an);
the=linspace(0,2*pi,Nb+1);
x=radm*cos(the)*co-si*radn*sin(the)+xpos;
y=radm*cos(the)*si+co*radn*sin(the)+ypos;

if DoWePlot
    axes(handles.axes1), hold on
    [xPlot,yPlot]=CoordinatesFromRef(x,y,handles);
    plot(xPlot,yPlot,'-m');
end

EllipseCoor = [x;y]';
drawnow;
return


% #########################################################################
%       SURFACE AND VOLUMES OF ELLIPSOIDS (V2.1.7)
function [EllipsoidProp] = EllipsoidVolumes(DoWeDisp,RadiusMaj,RadiusMin,Radius3D,NbInt,RefsIntEllipse,RefEllipseData,LinS,ColS,Cmin,Cmax,TheDisplayedMap,hObject,eventdata,handles);
%
VolumeEllipse = 4/3*pi*RadiusMaj*RadiusMin*Radius3D; %in px^3
SurfaceEllipse = pi*RadiusMaj*RadiusMin;

% We calculate the number of pixels in the ref ellipse:
[EllipseCoor1] = PlotEllipse(RefEllipseData,1,handles,0);
MasqueSel = Xpoly2maskX(EllipseCoor1(:,1),EllipseCoor1(:,2),LinS,ColS);

NbPixelsEllipse = length(find(MasqueSel));

if DoWeDisp
    figure, imagesc(MasqueSel.*TheDisplayedMap), axis image, colorbar vertical
    colormap([0,0,0;jet(64)]);
    caxis([Cmin,Cmax]);
    title(['reference ellipse (',num2str(NbPixelsEllipse),' pixels)']);
end


for i=1:NbInt
    
    XmapWaitBar(i/NbInt, handles);
    drawnow
    
    AllCoor=[];
    
    if isequal(i,1) % first integration
        [EllipseCoor1] = PlotEllipse(RefEllipseData,RefsIntEllipse(i),handles,0);
        
        AllCoor = EllipseCoor1;
        
        VolumesInt(i) = 4/3*pi*RadiusMaj*RadiusMin*Radius3D*RefsIntEllipse(i)^3; % in px^3
        SurfaceInt(i) = pi*RadiusMaj*RadiusMin*RefsIntEllipse(i)^2;
        
    else % otherwise...
        [EllipseCoor1] = PlotEllipse(RefEllipseData,RefsIntEllipse(i-1),handles,0);
        [EllipseCoor2] = PlotEllipse(RefEllipseData,RefsIntEllipse(i),handles,0);
        
        AllCoor = [EllipseCoor1;EllipseCoor2];
        
        VolumeSmall = 4/3*pi*RadiusMaj*RadiusMin*Radius3D*RefsIntEllipse(i-1)^3;
        VolumeBig = 4/3*pi*RadiusMaj*RadiusMin*Radius3D*RefsIntEllipse(i)^3;
        
        SurfaceSmall = pi*RadiusMaj*RadiusMin*RefsIntEllipse(i-1)^2;
        SurfaceBig = pi*RadiusMaj*RadiusMin*RefsIntEllipse(i)^2;
        
        VolumesInt(i) = VolumeBig-VolumeSmall;
        SurfaceInt(i) = SurfaceBig-SurfaceSmall;
    end
    
    VolumeFractions(i) = VolumesInt(i)/VolumeEllipse;
    SurfaceFractions(i) = SurfaceInt(i)/SurfaceEllipse;
    
    % Now we select the corresponding pixels
    MasqueSel = Xpoly2maskX(AllCoor(:,1),AllCoor(:,2),LinS,ColS);
    
    EllipsoidProp.Masks(i).MasqueSel = MasqueSel;
    
    NumberOfPixels(i) = length(find(MasqueSel));
    SurfaceFractionsPx(i) = NumberOfPixels(i)/NbPixelsEllipse;
    
    if DoWeDisp
        figure, imagesc(MasqueSel.*TheDisplayedMap), axis image, colorbar vertical
        colormap([0,0,0;jet(64)]);
        caxis([Cmin,Cmax]);
        title({['Integration [',num2str(i),']'], ...
            ['volume: ',num2str(VolumesInt(i)),' px^3; volume fraction: ',num2str(VolumeFractions(i))], ...
            ['pixels: ',num2str(NumberOfPixels(i)),' px; pixel fraction: ',num2str(SurfaceFractionsPx(i))]});
    end
end

EllipsoidProp.VolumeEllipse = VolumeEllipse;
EllipsoidProp.NbPixelsEllipse = NbPixelsEllipse;
EllipsoidProp.SurfaceEllipse = SurfaceEllipse;
EllipsoidProp.VolumesInt = VolumesInt;
EllipsoidProp.VolumeFractions = VolumeFractions;
EllipsoidProp.NumberOfPixels = NumberOfPixels;
EllipsoidProp.SurfaceInt = SurfaceInt;
EllipsoidProp.SurfaceFractionsPx = SurfaceFractionsPx;
EllipsoidProp.SurfaceFractions = SurfaceFractions;


XmapWaitBar(1, handles);
drawnow

return


% #########################################################################
%       EXPORT OXIDE COMPOSITIONS                          
function QUbutton2_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;
ValMin = get(handles.QUppmenu2,'Value');
if ValMin == 1, return, end

ListName = Quanti(ValMin).listname;


% - - - - - - - - - - SELECT THE MODE - - - - - - - - - -

CodeTxt = [11,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(1))]);

% if handles.MatlabVersion>=7.14
%     Mode = menuX('Export Wt.% compositions of',{ ...
%                                '[1] All pixels', ...
%                                '[2] Selection of pixels (area)', ...
%                                '[3] Random pixels', ...
%                                '[4] Average of groups (MaskFile)', ...
%                                '[5] All of a group (MaskFile)', ...
%                                '[6] Average of a group (MaskFile)', ...
%                                '[7] Average of all pixels' ...
%                                '[8] Average + std of selected pixels (area)'});
% else
%     Mode = menu('Export Wt.% compositions of',{ ...
%                                '[1] All pixels', ...
%                                '[2] Selection of pixels (area)', ...
%                                '[3] Random pixels', ...
%                                '[4] Average of groups (MaskFile)', ...
%                                '[5] All of a group (MaskFile)', ...
%                                '[6] Average of a group (MaskFile)', ...
%                                '[7] Average of all pixels' ...
%                                '[8] Average + std of selected pixels (area)'});
%
% end

% New Menu Alice Vho - 6.07.2017
Mode = Menu_XMT({'Export Wt.% compositions of'},{ ...
    '[1] All pixels', ...
    '[2] Selection of pixels (area)', ...
    '[3] Random pixels', ...
    '[4] Average of groups (maskfile)', ...
    '[5] All of a group (maskfile)', ...
    '[6] Average of a group (maskfile)', ...
    '[7] Average of all pixels' ...
    '[8] Average + std of selected pixels (area)'},handles.LocBase);


% WARNING NEW ORDER VER_XMAPTOOLS_804 2.1.1

%[Mode,Ok] = listdlg('ListString',Mode,'name','Mode','SelectionMode','Single','InitialValue',5);

if ~Mode
    CodeTxt = [11,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
    return
end


% - - - - -  SELECT THE ELEMENT ORDER (in exported file) - - - - -

CodeTxt = [11,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(3))]);
% Default:
Order = {'Ref','SiO2','TiO2','Al2O3','FeO','Fe2O3','MnO','MgO','CaO','Na2O','K2O','Fe3'};

Text='';
for i =1:length(Order)
    Text = strcat(Text,Order(i),'-');
end
options.Resize='on';
Text = inputdlg('Order to export','Input',8,Text,options);

if ~length(Text)
    CodeTxt = [11,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
    return
end

if ~isequal(Text{1}(1:3),'Ref')
    CodeTxt = [11,14];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end


% The seperated oxydes
Order = strread(char(Text),'%s','delimiter','-');

% find in database the solutions             (saved into the variable 'ou')
[Est,Ou] = ismember(Order,ListName);

% Size of map
[LinS,ColS] = size(Quanti(ValMin).elem(1).quanti);

ForSuite = 1;


% - - - - - - - - - - IF MODE - - - - - - - - - -


switch Mode
    
    case 1 % All pixels
        MasqueSel = ones(LinS,ColS);
        
        
        
    case {2,8} % Area (selection)
        CodeTxt = [11,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(4))]);
        clique = 1;
        ComptResult = 1;
        axes(handles.axes1); hold on
        
        h=0;
        
        while clique < 2
            [a,b,clique] = XginputX(1,handles);
            [aFig,bFig] = CoordinatesFromRef(a,b,handles);
            if clique < 2
                h(ComptResult,1) = a;
                h(ComptResult,2) = b;
                hPlot(ComptResult,1) = aFig;             % for display (Fig coordinate system)
                hPlot(ComptResult,2) = bFig;                                       % new 1.6.2
                plot(floor(hPlot(ComptResult,1)),floor(hPlot(ComptResult,2)),'.w') % New 1.6.2
                %plot(floor(h(ComptResult,1)),floor(h(ComptResult,2)),'.w') % point
                if ComptResult >= 2 % start
                    plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-k')
                end
                ComptResult = ComptResult + 1;
            end
        end
        
        % Trois points minimum...
        if length(h(:,1)) < 3
            CodeTxt = [11,5];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(5))]);
            return
        end
        
        % new V1.4.1
        plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-k')
        MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);
        
        NbPixelsSelected = length(find(MasqueSel(:)>0));
        ThePixelsSelected = find(MasqueSel(:)>0);
        
        
        if isequal(Mode,8) % New 2.1.8
            
            StructuralFormulaComp = 0;
            DoWeStructForm = questdlg('Would you like to apply the selected external function','What do we do?','Yes');
            
            switch DoWeStructForm
                
                case 'Cancel'
                    CodeTxt = [11,2];
                    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                    return
                    
                case 'Yes'
                    StructuralFormulaComp = 1;
            end
            
            
            Vals2Export = zeros(length(Order),NbPixelsSelected);
            
            for i = 2:length(Order)
                if Est(i)
                    Vals2Export(i,:) = Quanti(ValMin).elem(Ou(i)).quanti(ThePixelsSelected);
                end
            end
            
            TheOKSums = find(sum(Vals2Export,1) > 10);
            Export(:,1) = mean(Vals2Export(:,TheOKSums),2);
            Export(:,2) = std(Vals2Export(:,TheOKSums),0,2);
            
            Export(end+1,1) = sum(Export(:,1));
            Export(end,2) = sqrt(sum(Export(1:end-1,2).^2));
            Order{end+1} = 'Total';
            
            NbPixelsSelectedOK = length(TheOKSums);
            
            %             % reference
            %             Export(1,1) = 0; % here the reference is zero (no ref)
            %             Export(1,2) = 0;
            %
            %             for i = 2:length(Order)                  % each elements to be exported
            %                 if Est(i)
            %                     Vals2Export = Quanti(ValMin).elem(Ou(i)).quanti(ThePixelsSelected);
            %                     % [1] Mean
            %                     Export(i,1) = mean(Vals2Export);
            %                     % [2] Standard deviation
            %                     Export(i,2) = std(Vals2Export);
            %                 else
            %                     % unknow element
            %                     Export(i,1) = 0;
            %                     Export(i,2) = 0;
            %                 end
            %             end
            %
            
            if StructuralFormulaComp
                [Export,Order,PixelsMC] = ApplyExternalFunction(Export,Order,NbPixelsSelected,hObject, eventdata,handles);
            end
            
            % SAVE THE RESULT...
            CodeTxt = [11,8];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            [Success,Message,MessageID] = mkdir('Exported-Oxides');
            
            cd Exported-Oxides
            [Directory, pathname] = uiputfile({'*.txt', 'TEXT File (*.txt)'}, 'Save results as');
            cd ..
            
            if ~Directory
                CodeTxt = [11,2];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                return
            end
            
            fid = fopen(strcat(pathname,Directory),'w');
            
            CodeTxt = [11,9];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % Print out the data: updated in XMapTools 2.1.8
            
            fprintf(fid,'%s\n','Oxide mineral composition [average+std+median] from selected pixels in XMapTools');
            fprintf(fid,'%s\n',date);
            fprintf(fid,'%s\n',['Standardized phase: ',char(Quanti(ValMin).mineral)]);
            
            if StructuralFormulaComp
                
                externalFunctions = handles.externalFunctions;
                weAreType = get(handles.THppmenu3,'Value');
                minRef = get(handles.THppmenu1,'Value');
                methodeRef = get(handles.THppmenu2,'Value');
                
                selectedFunction = externalFunctions(weAreType).minerals(minRef).method(methodeRef);
                
                fprintf(fid,'%s\n\n',['______________________________________________________________']);
                fprintf(fid,'%s\n',['External function: ',char(selectedFunction.name)]);
                fprintf(fid,'%s\n',['Monte-Carlo: ',char(num2str(PixelsMC(3))),' permutations and ',char(num2str(PixelsMC(2))),' results used (',char(num2str(PixelsMC(1))),'%)']);
                fprintf(fid,'%s\n\n',['______________________________________________________________']);
            end
            fprintf(fid,'%s\n\n\n',['Nb of pixels used/selected: ',char(num2str(NbPixelsSelectedOK)),'/',char(num2str(NbPixelsSelected))]);
            
            fprintf(fid,'%s\t%s\t%s\n','...','[Mean]','[Std]');
            for i=1:length(Export(:,1))
                %                 if length(Order{i}) > 3
                fprintf(fid,'%s\t%.3f\t%.3f\n',Order{i},Export(i,1),Export(i,2));
                %                 else
                %                     fprintf(fid,'%s\t\t%.2f\t%.2f\n',Order{i},Export(i,1),Export(i,2));
                %                 end
            end
            
            fclose(fid);
            
            CodeTxt = [11,10];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Quanti(ValMin).mineral),') ']);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(10)),' (',char(Quanti(ValMin).mineral),') ']);
            guidata(hObject,handles);
            
            WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);
            
            return
        end
        
    case 3 % Random pixels
        CodeTxt = [11,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(6))]);
        
        NbPoints = inputdlg('How many ?','Input',1,{'50'});
        
        if ~length(NbPoints)
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
            return
        end
        
        NbPoints =  str2num(char(NbPoints));
        
        MasqueSel = zeros(LinS,ColS); % defaut
        Compt = 0;
        
        axes(handles.axes1);
        while Compt <= NbPoints
            RandCoor =[round(rand*LinS),round(rand*ColS)];
            
            if RandCoor(1) < 1, RandCoor(1) =1; end
            if RandCoor(2) < 1, RandCoor(2) =1; end
            
            LaSum = 0;
            for i=1:length(Quanti(ValMin).elem)
                LaSum = LaSum + Quanti(ValMin).elem(i).quanti(RandCoor(1),RandCoor(2));
            end
            
            if LaSum > 50 && LaSum < 105
                Compt=Compt+1;
                MasqueSel(RandCoor(1),RandCoor(2)) = 1;
                [DispCoor(2),DispCoor(1)] = CoordinatesFromRef(RandCoor(2),RandCoor(1),handles);   % new 1.6.2
                hold on, plot(DispCoor(2),DispCoor(1),'o','linewidth',2,'MarkerEdgeColor','w','MarkerFaceColor','k','markersize',8);
            end
        end
        
        
    case 4 % Average of groups (maskfile)
        
        % ------- Load a MaskFile -------
        
        % New 2.1.1 - Users must now use a mask file !!!
        % That's stupid to generate one using kmeans when Chemical modules
        % can be used in all the workspaces in 2.1.
        
        CodeTxt = [11,13];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(13))]);
        
        [Success,Message,MessageID] = mkdir('Maskfiles');
        
        cd Maskfiles
        [Directory, pathname] = uigetfile({'*.txt', 'TXT Files (*.txt)'}, 'Select a maskfile');
        cd ..
        
        if Directory
            Groups = load([char(pathname),'/',char(Directory)]);
            NbMask = max(max(Groups));
            SizeMap = size(Groups);
        else
            CodeTxt = [11,15];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        
        for i = 1:length(Quanti(ValMin).elem)
            Chemic(:,i) = Quanti(ValMin).elem(i).quanti(:);
            SizeMap = size(Quanti(ValMin).elem(i).quanti);
        end
        
        hold off
        cla(handles.axes1)
        axes(handles.axes1)
        imagesc(XimrotateX(Groups,handles.rotateFig)), axis image
        GraphStyle(hObject, eventdata, handles);
        set(handles.axes1,'xtick',[], 'ytick',[]);
        
        for i=1:NbMask
            NameMask{i} = num2str(i);
        end
        
        colormap([0,0,0;hsv(NbMask-1)]);
        
        hcb = colorbar('YTickLabel',NameMask(:)); caxis([1 NbMask+1]);
        set(hcb,'YTickMode','manual','YTick',[1.5:1:NbMask+1]);
        
        
        % Il faut r?cup?rer les moyennes
        for i=1:NbMask
            
            for j = 1:length(Chemic(1,:)) % Elements
                LeMulti = Groups == i;
                LesData = LeMulti .* Quanti(ValMin).elem(j).quanti;
                LesGoodData = LesData(find(LesData > 0.001));
                if LesGoodData
                    LaMoy(i,j) = median(LesGoodData);
                    %keyboard
                else
                    LaMoy(i,j) = 0;
                end
            end
        end
        
        % POUR AFFICHER
        %     figure
        %     plot(LesGoodData,LesGoodData+randn(length(LesGoodData),1).*1,'.','markersize',1), hold on
        %     plot(LaMoy(i,j),LaMoy(i,j),'+r')
        
        Compt = 0;
        for iAna = 1:length(LaMoy(:,1))
            Compt = Compt+1;
            for j = 1:length(Order)
                if Est(j)
                    Export(Compt,j) = LaMoy(iAna,Ou(j));
                else
                    Export(Compt,j) = 0;
                end
                
                Export(Compt,1) = iAna;
            end
        end
        
        ForSuite = 0;
        
        
        
    case 5 % All of a group (maskfile)
        
        % ------- Load  a MaskFile -------
        
        CodeTxt = [11,13];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        [Success,Message,MessageID] = mkdir('Maskfiles');
        
        cd Maskfiles
        [Directory, pathname] = uigetfile({'*.txt', 'TXT Files (*.txt)'}, 'Select a maskfile');
        cd ..
        
        if Directory
            Groups = load([char(pathname),'/',char(Directory)]);
            NbMask = max(max(Groups));
            SizeMap = size(Groups);
        else
            CodeTxt = [11,15];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        
        for i = 1:length(Quanti(ValMin).elem)
            Chemic(:,i) = Quanti(ValMin).elem(i).quanti(:);
            SizeMap = size(Quanti(ValMin).elem(i).quanti);
        end
        
        hold off
        cla(handles.axes1)
        axes(handles.axes1)
        imagesc(XimrotateX(Groups,handles.rotateFig)), axis image
        GraphStyle(hObject, eventdata, handles);
        set(handles.axes1,'xtick',[], 'ytick',[]);
        
        for i=1:NbMask
            NameMask{i} = num2str(i);
        end
        
        colormap([0,0,0;hsv(NbMask-1)]);
        
        hcb = colorbar('YTickLabel',NameMask(:)); caxis([1 NbMask+1]);
        set(hcb,'YTickMode','manual','YTick',[1.5:1:NbMask+1]);
        
        
        % User must select a mask
        
        
        [s,v] = listdlg('PromptString','Select a phase:',...
            'SelectionMode','single',...
            'ListString',NameMask);
        
        if ~v
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        
        MasqueSel = zeros(LinS,ColS);
        MasqueSel(find(Groups(:) == s)) = ones(length(find(Groups(:) == s)),1);
        
        
    case 6 % Average of a group (maskfile)
        
        CodeTxt = [11,13];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        [Success,Message,MessageID] = mkdir('Maskfiles');
        
        cd Maskfiles
        [Directory, pathname] = uigetfile({'*.txt', 'TXT Files (*.txt)'}, 'Select a maskfile');
        cd ..
        
        if Directory
            Groups = load([char(pathname),'/',char(Directory)]);
            NbMask = max(max(Groups));
            SizeMap = size(Groups);
            MaskFileName = Directory;
        else
            CodeTxt = [11,15];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        
        for i = 1:length(Quanti(ValMin).elem)
            Chemic(:,i) = Quanti(ValMin).elem(i).quanti(:);
            SizeMap = size(Quanti(ValMin).elem(i).quanti);
        end
        
        hold off
        cla(handles.axes1)
        axes(handles.axes1)
        imagesc(XimrotateX(Groups,handles.rotateFig)), axis image
        GraphStyle(hObject, eventdata, handles);
        set(handles.axes1,'xtick',[], 'ytick',[]);
        
        for i=1:NbMask
            NameMask{i} = num2str(i);
        end
        
        colormap([0,0,0;hsv(NbMask-1)]);
        
        hcb = colorbar('YTickLabel',NameMask(:)); caxis([1 NbMask+1]);
        set(hcb,'YTickMode','manual','YTick',[1.5:1:NbMask+1]);
        
        
        [s,v] = listdlg('PromptString','Select a phase:',...
            'SelectionMode','single',...
            'ListString',NameMask);
        
        if ~v
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        end
        
        MasqueSel = zeros(LinS,ColS);
        MasqueSel(find(Groups(:) == s)) = ones(length(find(Groups(:) == s)),1);
        
        for i = 1:length(Order)                  % each elements to be exported
            if Est(i)
                
                % [1] Mean
                Export(i,1) = mean(Quanti(ValMin).elem(Ou(i)).quanti(find(MasqueSel)));
                % [2] Standard deviation
                Export(i,2) = std(Quanti(ValMin).elem(Ou(i)).quanti(find(MasqueSel)));
                % [3] Median
                Export(i,3) = median(Quanti(ValMin).elem(Ou(i)).quanti(find(MasqueSel)));
                
            else
                
                % unknow element
                Export(i,1) = 0;
                Export(i,2) = 0;
                Export(i,3) = 0;
                
            end
            
            
            % reference
            
            Export(1,1) = 0;             % here the reference is zero (average)
            Export(1,2) = 0;             % here the reference is zero (average)
            Export(1,3) = 0;             % here the reference is zero (average)
        end
        
        
        % SAVE THE RESULT...                      (paste and edited from above)
        CodeTxt = [11,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        [Success,Message,MessageID] = mkdir('Exported-Oxides');
        
        cd Exported-Oxides
        [Directory, pathname] = uiputfile({'*.txt', 'TEXT File (*.txt)'}, 'Save results as');
        cd ..
        
        if ~Directory
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
        end
        
        fid = fopen(strcat(pathname,Directory),'w');
        
        CodeTxt = [11,9];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(9))]);
        SepList = {'Blank','Tabulation'};
        [Sel,Ok] = listdlg('ListString',SepList,'name','delimiter','SelectionMode','Single','InitialValue',2);
        if ~Ok
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
            return
        end
        
        
        fprintf(fid,'%s\n','Oxide [Average] group compositions (Wt%) from XMapTools');
        fprintf(fid,'%s\n',date);
        fprintf(fid,'%s\n',['Standardized phase: ',char(Quanti(ValMin).mineral)]);
        fprintf(fid,'%s\n',['Maskfile: ',char(MaskFileName)]);
        fprintf(fid,'%s\n',['Selected group: ',char(num2str(s))]);
        fprintf(fid,'%s\n\n\n',['Nb analyses: ',char(num2str(length(find(MasqueSel(:)))))]);
        
        %fprintf(fid,'%s\n\n',['Order: ',char(Text)]);    % MAJ 1.6.1 -- 4.01.13
        
        fprintf(fid,'%s\n','        [Mean]  [Std]   [Median]');
        for i=1:length(Export(:,1))
            switch Sel
                case 1
                    fprintf(fid,'%s %.2f %.2f %.2f\n',Order{i},Export(i,1),Export(i,2),Export(i,3));
                case 2
                    if length(Order{i}) > 3
                        fprintf(fid,'%s\t%.2f\t%.2f\t%.2f\n',Order{i},Export(i,1),Export(i,2),Export(i,3));
                    else
                        fprintf(fid,'%s\t\t%.2f\t%.2f\t%.2f\n',Order{i},Export(i,1),Export(i,2),Export(i,3));
                    end
            end
            
        end
        
        fclose(fid);
        
        CodeTxt = [11,10];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Quanti(ValMin).mineral),') ']);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(10)),' (',char(Quanti(ValMin).mineral),') ']);
        guidata(hObject,handles);
        
        return
        
        
    case 7  % Average of all pixels
        
        % New 1.6.2 (P. Lanari 28.02.13)
        
        % This method is better than only one group in meth. [4] (used before).
        
        % We calculate the values, write the file and return in this loop...
        % Because this mode is strongly different than the other in the same
        % function...
        
        MasqueSel = ones(LinS,ColS);                 % we select all the pixels
        
        for i = 1:length(Order)                  % each elements to be exported
            if Est(i)
                
                % [1] Mean
                Export(i,1) = mean(Quanti(ValMin).elem(Ou(i)).quanti(find(Quanti(ValMin).elem(Ou(i)).quanti(:))));
                % [2] Standard deviation
                Export(i,2) = std(Quanti(ValMin).elem(Ou(i)).quanti(find(Quanti(ValMin).elem(Ou(i)).quanti(:))));
                % [3] Median
                Export(i,3) = median(Quanti(ValMin).elem(Ou(i)).quanti(find(Quanti(ValMin).elem(Ou(i)).quanti(:))));
                
            else
                
                % unknow element
                Export(i,1) = 0;
                Export(i,2) = 0;
                Export(i,3) = 0;
                
            end
            
            
            % reference
            
            Export(1,1) = 0;             % here the reference is zero (average)
            Export(1,2) = 0;             % here the reference is zero (average)
            Export(1,3) = 0;             % here the reference is zero (average)
        end
        
        
        % SAVE THE RESULT...                      (paste and edited from above)
        CodeTxt = [11,8];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        [Success,Message,MessageID] = mkdir('Exported-Oxides');
        
        cd Exported-Oxides
        [Directory, pathname] = uiputfile({'*.txt', 'TEXT File (*.txt)'}, 'Save results as');
        cd ..
        
        if ~Directory
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            return
        end
        
        fid = fopen(strcat(pathname,Directory),'w');
        
        CodeTxt = [11,9];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(9))]);
        SepList = {'Blank','Tabulation'};
        [Sel,Ok] = listdlg('ListString',SepList,'name','delimiter','SelectionMode','Single','InitialValue',2);
        if ~Ok
            CodeTxt = [11,2];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
            return
        end
        
        
        fprintf(fid,'%s\n','Oxide [Average] mineral compositions (Wt%) from XMapTools');
        fprintf(fid,'%s\n',date);
        fprintf(fid,'%s\n\n\n',['Standardized phase: ',char(Quanti(ValMin).mineral)]);
        %fprintf(fid,'%s\n\n',['Order: ',char(Text)]);    % MAJ 1.6.1 -- 4.01.13
        
        fprintf(fid,'%s\n','        [Mean]  [Std]   [Median]');
        for i=1:length(Export(:,1))
            switch Sel
                case 1
                    fprintf(fid,'%s %.2f %.2f %.2f\n',Order{i},Export(i,1),Export(i,2),Export(i,3));
                case 2
                    if length(Order{i}) > 3
                        fprintf(fid,'%s\t%.2f\t%.2f\t%.2f\n',Order{i},Export(i,1),Export(i,2),Export(i,3));
                    else
                        fprintf(fid,'%s\t\t%.2f\t%.2f\t%.2f\n',Order{i},Export(i,1),Export(i,2),Export(i,3));
                    end
            end
            
        end
        
        fclose(fid);
        
        CodeTxt = [11,10];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Quanti(ValMin).mineral),') ']);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(10)),' (',char(Quanti(ValMin).mineral),') ']);
        guidata(hObject,handles);
        
        return
        
end



if ForSuite
    
    % Here new procedure VER_XMapTools_804 2.1
    
    % (1) Create MatCompo from the good quanti
    for i = 1:length(Quanti(ValMin).elem)
        MatCompo(:,i) = Quanti(ValMin).elem(i).quanti(:);
    end
    
    MatCompo = MatCompo .* repmat(MasqueSel(:),1,length(Quanti(ValMin).elem));
    
    % (2) Generate the Sum and find the good ones
    TheSum = sum(MatCompo,2);
    TheOK = find(TheSum(:) > 50 & TheSum(:) < 200);
    
    Export = zeros(length(TheOK),length(Order));
    
    Export(:,find(Ou)) = MatCompo(TheOK,Ou(find(Ou)));
    Export(:,1) = TheOK;
    
    % if ForSuite & 0
    %
    %     WaitBarPerso(0, hObject, eventdata, handles);
    %
    %     howMuch = length(find(Quanti(ValMin).elem(1).quanti));
    %     Export = zeros(howMuch,length(Order));
    %
    %     hCompt =0;
    %     Compt = 0;
    %     for i = 1:length(Quanti(ValMin).elem(1).quanti(:))
    %         hCompt = hCompt+1;
    %         if hCompt == 750
    %             WaitBarPerso(i/length(Quanti(ValMin).elem(1).quanti(:)), hObject, eventdata, handles)
    %
    %             CodeTxt = [11,7];
    %             set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',num2str(round(i/length(Quanti(ValMin).elem(1).quanti(:))*100)),'%)']);
    %             TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    %
    %             % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(7)),' (',num2str(round(i/length(Quanti(ValMin).elem(1).quanti(:))*100)),'%)']);
    %             drawnow;
    %             hCompt = 0;
    %         end
    %         SumI = 0;
    %         for k = 1:length(Quanti(ValMin).elem)
    %             SumI = SumI + Quanti(ValMin).elem(k).quanti(i)*MasqueSel(i);
    %         end
    %
    %         if SumI > 50 && SumI < 105
    %             Compt = Compt + 1;
    %             % good analysis
    %             for j=1:length(Order)
    %
    %                 if Est(j)
    %                     Export(Compt,j) = Quanti(ValMin).elem(Ou(j)).quanti(i);
    %                 else
    %                     Export(Compt,j) = 0;
    %                 end
    %
    %                 Export(Compt,1) = i; % reference
    %
    %             end
    %         end
    %
    %     end
    %
    %     WaitBarPerso(1, hObject, eventdata, handles)
    %     CodeTxt = [11,7];
    %     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (100 %)']);
    %     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    %
    %     %set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(7)),' (100 %)']);
    
    
else
    % Alors on peut enregistrer un fichier masque pour
    % pouvoir le charger dans les modules 3D et 2D
    % C'est je pense la solution la plus simple pour l'instant
    % car c'est compliqu? de g?rer un fichier masque en plus (et pas
    % forcement utile). A finir ici
    
    if ~Directory
        CodeTxt = [11,12];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(12))]);
        
        [Success,Message,MessageID] = mkdir('Maskfiles');
        
        cd Maskfiles
        [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export maskfile as');
        cd ..
        
        if Directory
            save([char(pathname),'/',char(Directory)],'Groups','-ASCII');
        end
    end
    
end

% Pour corriger certains bugs, temporaire...
%ExportFinal = Export(1:Compt,:);
%clear Export
%Export = ExportFinal;

% NEW 1.4.1
CodeTxt = [11,8];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Success,Message,MessageID] = mkdir('Exported-Oxides');

cd Exported-Oxides
[Directory, pathname] = uiputfile({'*.txt', 'TEXT File (*.txt)'}, 'Save results as');
cd ..

if ~Directory
    CodeTxt = [11,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

% CodeTxt = [11,8];
% set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
% TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%
% % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(8))]);
%
% %Save a file:
% [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export as');
% if ~Directory
%     CodeTxt = [11,2];
%     set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
%     TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
%
%     % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
%     return
% end

fid = fopen(strcat(pathname,Directory),'w');

CodeTxt = [11,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(9))]);
SepList = {'Blank','Tabulation'};
[Sel,Ok] = listdlg('ListString',SepList,'name','Delimiter','SelectionMode','Single','InitialValue',1);
if ~Ok
    CodeTxt = [11,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(2))]);
    return
end

fprintf(fid,'%s\n','Oxide mineral compositions (Wt%) from XMapTools');
fprintf(fid,'%s\n',date);
fprintf(fid,'%s\n',['Analyses: ',char(num2str(length(Export(:,1)))),]);
fprintf(fid,'%s\n',['Standardized phase: ',char(Quanti(ValMin).mineral)]);
fprintf(fid,'%s\n\n',['Order: ',char(Text)]);    % MAJ 1.6.1 -- 4/01/13

XmapWaitBar(0, handles);
hCompt = 0;
if Sel == 1
    for i =1:length(Export(:,1))
        
        hCompt = hCompt+1;
        if hCompt == 2000;
            XmapWaitBar(i/length(Export(:,1)),handles);
            
            CodeTxt = [11,7];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',num2str(round(i/length(Export(:,1))*100)),'%)']);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(7)),' (',num2str(round(i/length(Quanti(ValMin).elem(1).quanti(:))*100)),'%)']);
            drawnow;
            hCompt = 0;
        end
        
        fprintf(fid,'%.2f \b',Export(i,1:end-1));
        fprintf(fid,'%.2f\n',Export(i,end));
        
    end
else
    for i =1:length(Export(:,1))
        
        hCompt = hCompt+1;
        if hCompt == 2000;
            XmapWaitBar(i/length(Export(:,1)), handles);
            
            CodeTxt = [11,7];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',num2str(round(i/length(Export(:,1))*100)),'%)']);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(7)),' (',num2str(round(i/length(Quanti(ValMin).elem(1).quanti(:))*100)),'%)']);
            drawnow;
            hCompt = 0;
        end
        
        fprintf(fid,'%.2f\t',Export(i,1:end-1));
        fprintf(fid,'%.2f\n',Export(i,end));
        
    end
end
XmapWaitBar(1, handles);

fclose(fid);

CodeTxt = [11,10];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Quanti(ValMin).mineral),') ']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

WouldYouLike2SaveTheFigure(strcat(pathname,Directory),hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(10)),' (',char(Quanti(ValMin).mineral),') ']);
guidata(hObject,handles);
return


% #########################################################################
%       APPLY EXTERNAL FUNCTION TO SELECTED ANALYSES (New 2.1.8)
function [Export,Order,PixelsMC] = ApplyExternalFunction(Export,Order,NbPixelsSelected,hObject, eventdata,handles);
%

NbSimul = 30000;

% ----------- Loaded external functions -----------
externalFunctions = handles.externalFunctions;

weAreType = get(handles.THppmenu3,'Value');
minRef = get(handles.THppmenu1,'Value');
methodeRef = get(handles.THppmenu2,'Value');

selectedFunction = externalFunctions(weAreType).minerals(minRef).method(methodeRef);


% ----------- Input -----------
ComptAbsMap = 0;
ListAbsMap = {};

ListInput = selectedFunction.input;
Valeur2Therm = zeros(NbSimul,length(ListInput));

for iElem = 1:length(ListInput)
    LeElem = ListInput(iElem);
    
    [oui,ou] = ismember(LeElem,Order); % map order
    
    % New test: have you this map ? (10/10)
    if oui
        DataElem = Export(ou,1);
        StdElem = Export(ou,2);
    else
        ComptAbsMap = ComptAbsMap+1;
        DataElem = 0;
        StdElem = 0;
        
        ListAbsMap{ComptAbsMap} = LeElem;
    end
    
    Valeur2Therm(:,iElem) = DataElem.*ones(NbSimul,1) + StdElem.*randn(NbSimul,1);
end

% ----------- Warning -----------
if length(ListAbsMap) > 0
    % Some elements haven't maps...
    ListText = '';
    for i=1:length(ListAbsMap)
        ListText = strcat(ListText,char(ListAbsMap{i}),',');
    end
    
    TextIn = strcat('This thermometer uses elements: ',char(ListText),' for which data are not available. Continue ?');
    ButtonName = questdlg(TextIn,'Warning','Yes','No','Yes');
    if length(ButtonName) < 3
        CodeTxt = [14,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        axes(handles.axes1);
        set(gcf, 'WindowButtonMotionFcn', @mouseMove);
        return % end of run
    end
end


% ----------- Calculation -----------
ListOutput = selectedFunction.output;
b = char(ListOutput);

for i=1:size(b,1) % rows
    for j=1:size(b,2) % columns
        if i == 1 & j == 1
            Text = '[';
            Text = strcat(Text,b(i,j));
        elseif i ~= 1 & j == 1
            Text = strcat(Text,',',b(i,j));
        elseif j ~= 1
            Text = strcat(Text,b(i,j));
        end
    end
end

Text = strcat(Text,']');
Commande = char(strcat(Text,' = ',selectedFunction.file,'(Valeur2Therm,handles);'));


CodeTxt = [14,1];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),': ',char(selectedFunction.name),'']);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(handles.TxtDatabase(14).txt(1)),' - ',char(Thermometers.name),'']);

% New 2.1.3 (11.03.2015)
zoom off
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

eval(Commande);

zoom on
handles.CorrectionMode = 0;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)

% ----------- Extraction -----------
for i=1:length(Text)
    if Text(i) == ','
        Text(i) = ';';
    end
end

eval(char(strcat('LesResultats = ',Text,';')));

TheSums = sum(LesResultats,1);
TheOK = find(TheSums>0);
NbOk = length(TheOK);

PixelsMC(1) = NbOk/NbSimul*100;
PixelsMC(2) = NbOk;
PixelsMC(3) = NbSimul;

TheSFmeans = mean(LesResultats(:,TheOK),2);
TheSFstd = std(LesResultats(:,TheOK),0,2);

NbExport = size(Export,1);
NbAdd = size(TheSFmeans,1);

Export(NbExport+1:NbExport+NbAdd,1) = TheSFmeans;
Export(NbExport+1:NbExport+NbAdd,2) = TheSFstd;

for i=NbExport+1:NbExport+NbAdd
    Order{i} = ListOutput{i-NbExport};
end

return


% #########################################################################
%       BULK PROPORTIONS (1.6.2)
function QUbutton9_Callback(hObject, eventdata, handles)


Quanti = handles.quanti;

% Liste des noms de carte
for i=1:length(Quanti)-1
    ListMaps(i) = Quanti(i+1).mineral;
end

CodeTxt = [10,13];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

UserNbMin = str2num(char(inputdlg('Number of minerals','Input',1,{'3'})));

if ~length(UserNbMin)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

for i=1:UserNbMin
    ListMin{i} = ['mineral ',char(num2str(i))];
    ListProp{i} = char(int2str((100/UserNbMin)));
end
ListProp{end} = num2str(100-round(100/UserNbMin)*(UserNbMin-1));

CodeTxt = [10,14];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

ListMin = inputdlg(ListMin,'Input',1,ListMin);

if ~length(ListMin)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

CodeTxt = [10,15];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

ListProp = str2num(char(inputdlg(ListMin,'wt%',1,ListProp)));

while sum(ListProp) ~= 100
    % new sum required...
    LaSum = sum(ListProp);
    for i = 1:length(ListProp)
        ListProp(i) = round(ListProp(i)/LaSum*100);
    end
    ListProp(end) = 100-(sum(ListProp(1:end-1)));
    
    for i=1:length(ListProp)
        DefListProp{i} = num2str(ListProp(i));
    end
    
    CodeTxt = [10,17];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    ListProp = str2num(char(inputdlg(ListMin,'Proportions',1,DefListProp)));
    
    if ~length(ListProp)
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
end

if ~length(ListProp)
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

% Selection des points de d?part...
for i = 1:UserNbMin
    
    CodeTxt = [10,16];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(ListMin(i))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [lesLin(i),lesCol(i)] = XginputX(1,handles);
    
    [aPlot,bPlot] = CoordinatesFromRef(lesLin(i),lesCol(i),handles);
    
    axes(handles.axes1), hold on
    plot(aPlot,bPlot, 'mo','linewidth', 2)
    
end
lesLin = round(lesLin);
lesCol = round(lesCol);

hold off

% Chemical system
laQuanti = get(handles.QUppmenu2,'Value');

for i = 1:length(Quanti(laQuanti).elem)
    % for each element
    lesNamesQuanti{i} = Quanti(laQuanti).elem(i).name;
    
    for j = 1:length(lesLin)
        lesData(i,j) = Quanti(laQuanti).elem(i).quanti(lesCol(j),lesLin(j));
    end
end

ListProp = ListProp/100;
% good scale,

BulkCompo = zeros(length(lesData(:,1)),1);

for i=1:length(lesData(:,1)) % ielem
    for j = 1:length(lesData(1,:)) % iCompos
        BulkCompo(i) = BulkCompo(i) + ListProp(j)*lesData(i,j);
    end
end

ListElems = Quanti(laQuanti).listname;

% Save
CodeTxt = [10,8];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Success,Message,MessageID] = mkdir('Exported-LocalCompos');

cd Exported-LocalCompos
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export Local-compo as');
cd ..

if ~Directory
    CodeTxt = [10,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

%keyboard

fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n\n','Local composition (Proportions) from XMapTools');

fprintf(fid,'%s\n','(1) Mineral proportions (wt%):');
for i =1:length(ListMin)
    fprintf(fid,'%s\t',[char(ListMin(i))]);
    fprintf(fid,'%s\n',[num2str(ListProp(i)*100)]);
end

fprintf(fid,'\n\n');

fprintf(fid,'%s\n','(2) Mineral compositions:');
fprintf(fid,'\t');
for i = 1:length(ListMin)
    fprintf(fid,'%s\t',[char(ListMin{i})]);
end
fprintf(fid,'\n');

for i=1:length(ListElems)
    fprintf(fid,'%s\t',[char(ListElems{i})]);
    
    for j = 1:UserNbMin
        fprintf(fid,'%s\t',[char(num2str(lesData(i,j)))]);
    end
    fprintf(fid,'\n');
end

fprintf(fid,'\n\n');

fprintf(fid,'%s\n','(3) Local Composition:');

for i =1:length(ListElems)
    fprintf(fid,'%s\t',[char(ListElems{i})]);
    fprintf(fid,'%s\n',[num2str(BulkCompo(i))]);
end

fclose(fid);

CodeTxt = [10,9];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);



return


% #########################################################################
%       INTERPLOATION BOUNDARIES OR NOT ??? (NEW 1.6.1)
function MergeInterpBoundaries_Callback(hObject, eventdata, handles)
return


% #########################################################################
%       THERMOMETRY MINERAL LIST V1.4.1
function THppmenu1_Callback(hObject, eventdata, handles)

externalFunctions = handles.externalFunctions;
weAreType = get(handles.THppmenu3,'Value');
minRef = get(handles.THppmenu1,'Value');

set(handles.THppmenu2,'String',externalFunctions(weAreType).minerals(minRef).listMeth);
set(handles.THppmenu2,'Value',1);

guidata(hObject,handles);
return


% #########################################################################
%       SELECT THE TYPE OF CALCULATION (NEW 1.6.5)
function THppmenu3_Callback(hObject, eventdata, handles)
externalFunctions = handles.externalFunctions;

set(handles.THbutton1,'visible','on','enable','on','String','APPLY');

weAreGoingTo = get(handles.THppmenu3,'Value');

if weAreGoingTo == 7
%     
%     
%     set(handles.THppmenu1,'visible','off');
%     set(handles.THppmenu2,'visible','off');
%     %set(handles.text28,'visible','off');
%     %set(handles.text29,'visible','off');
%     set(handles.THbutton1,'visible','off');
%     set(handles.THbutton2,'visible','off');
%     
%     % Activate the menus for XThermoTools...
%     
%     % XThermoTools is available only if there is more than 3 Qminerals and
%     % at least one MaskFile and density
%     if handles.XThermoToolsACTIVATION
%         
%         IsDensity = 0;
%         if isfield(handles.MaskFile(get(handles.PPMenu3,'Value')),'AverageDensity')
%             if handles.MaskFile(get(handles.PPMenu3,'Value')).AverageDensity > 0
%                 IsDensity = 1;
%             end
%         end
%         
%         if length(get(handles.QUppmenu2,'String')) > 3 && handles.MaskFile(1).type && IsDensity
%             %set(handles.text28,'visible','on','String','MaskFile','enable','on');
%             set(handles.LeftMenuMaskFile,'visible','on','String',get(handles.PPMenu3,'String'),'Value',get(handles.PPMenu3,'Value'),'enable','on');
%             set(handles.THbutton3,'visible','on','enable','on','String','XTHERMOTOOLS');
%         else
%             %set(handles.text28,'visible','on','String','MaskFile','enable','off');
%             set(handles.LeftMenuMaskFile,'visible','on','String',get(handles.PPMenu3,'String'),'Value',get(handles.PPMenu3,'Value'),'enable','off');
%             set(handles.THbutton3,'visible','on','enable','off');
%             
%         end
%         
%     else
%         set(handles.text_XThermoTools,'visible','on');
%     end
%     % Message XThermoTools is not available...
%     %set(handles.text_XThermoTools,'visible','on');
%     
%     % Here will be the calling function to XThermoTools
%     
elseif weAreGoingTo == 6
    set(handles.THppmenu1,'visible','off');
    set(handles.THppmenu2,'visible','off');
    set(handles.THbutton1,'visible','off');
    set(handles.THbutton2,'visible','off');
    
    %set(handles.LeftMenuMaskFile,'visible','off');
    %set(handles.THbutton3,'visible','on')
    
    
    Quanti = handles.quanti;
    
    if length(Quanti) > 1
        set(handles.THbutton1,'visible','on','enable','on','String','TRANSFER');
    end
    
else
    
    set(handles.THppmenu1,'visible','on');
    set(handles.THppmenu2,'visible','on');
    %set(handles.text28,'visible','on','String','Mineral');
    %set(handles.text29,'visible','on');
    set(handles.THbutton1,'visible','on');
    set(handles.THbutton2,'visible','on');
    set(handles.text_XThermoTools,'visible','off');
    
    %set(handles.LeftMenuMaskFile,'visible','off');
    %set(handles.THbutton3,'visible','off')
    
    oldListMineralName = get(handles.THppmenu1,'String');
    selectedMineralName = oldListMineralName(get(handles.THppmenu1,'value'));
    
    listMinDestination = externalFunctions(weAreGoingTo).listMin;
    
    Ou = find(ismember(listMinDestination,selectedMineralName));
    if isempty(Ou)
        minDestination = 1;
    else
        minDestination = Ou;  % same mineral
    end
    
    set(handles.THppmenu1,'String',listMinDestination)
    set(handles.THppmenu1,'Value',minDestination);
    
    set(handles.THppmenu2,'String',externalFunctions(weAreGoingTo).minerals(minDestination).listMeth);
    %set(handles.THppmenu2,'Value',1);
    % REMOVED v2.1.1 because this change the Function selected when we
    % change the Qmineral !!!
    
end

guidata(hObject, handles);
return


% #########################################################################
%       CALCULATION INFOS
function THbutton2_Callback(hObject, eventdata, handles)

externalFunctions = handles.externalFunctions;
weAreType = get(handles.THppmenu3,'Value');
minRef = get(handles.THppmenu1,'Value');
methRef = get(handles.THppmenu2,'Value');

PositionXMapTools = get(gcf,'Position');

XMTFunctionsInfos(externalFunctions,weAreType,minRef,methRef,PositionXMapTools);

return


% #########################################################################
%       FILTER
function QUbutton8_Callback(hObject, eventdata, handles)
Quanti = handles.quanti;

TheQuanti = get(handles.QUppmenu2,'Value'); % for "none"
TheElem = get(handles.QUppmenu1,'Value');

Min = str2num(get(handles.ColorMin,'String'));
Max = str2num(get(handles.ColorMax,'String'));

Answer = questdlg({['Do you want to generate a map *',[char(Quanti(TheQuanti).mineral),'_filter'],'* based on:'],[num2str(Min),' < ',char(Quanti(TheQuanti).elem(TheElem).name),' > ',num2str(Max)]},'Yes');

switch Answer
    case 'Yes'

    NewPos = length(Quanti) + 1;
    Quanti(NewPos) = Quanti(TheQuanti);


    Quanti(NewPos).mineral = {[char(Quanti(NewPos).mineral),'_filter']};

    LaMapRef = Quanti(NewPos).elem(TheElem).quanti;

    LaMatTriage = zeros(size(LaMapRef));

    lesGood = find(LaMapRef > Min & LaMapRef < Max);

    LaMatTriage(lesGood) = ones(length(lesGood),1);

    for i = 1:length(Quanti(NewPos).elem)
        Quanti(NewPos).elem(i).quanti = Quanti(NewPos).elem(i).quanti .* LaMatTriage;

    end

    % ---------- Update Mineral Menu QUppmenu2 ----------
    for i=1:length(Quanti)
        NamesQuanti{i} = char(Quanti(i).mineral);
    end

    set(handles.QUppmenu2,'String',NamesQuanti);
    set(handles.QUppmenu2,'Value',NewPos);

    handles.quanti = Quanti;

    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles);
    QUppmenu2_Callback(hObject, eventdata, handles)
    
    otherwise
        CodeTxt = [11,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
end
return


% #########################################################################
%       BUTTON: XTHERMOTOOLS OR TRANSFER2QUANTI (v2.3.1)
function [handles] = THbutton3_Callback(hObject, eventdata, handles)
%
weAreGoingTo = get(handles.THppmenu3,'Value');

if weAreGoingTo == 6
    set(gcf, 'WindowButtonMotionFcn', '');
    zoom off
    handles.CorrectionMode = 1;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    
    set(gcf, 'WindowButtonMotionFcn', '');
    
    Quanti = handles.quanti;
    Results = handles.results;
    
    WhereResult = length(Results)+1;
    
    TheQuanti = handles.quanti(get(handles.QUppmenu2,'Value'));
    
    for i=1:length(TheQuanti.elem)
        Values(:,i) = TheQuanti.elem(i).quanti(:);
    end
    
    %Results(WhereResult).coord = 0;
    Results(WhereResult).type = 5;            % New 2.3.1 (transfer2result)
    Results(WhereResult).mineral = 'Transfer2Result';
    Results(WhereResult).method = {TheQuanti.mineral};
    Results(WhereResult).labels = TheQuanti.listname;
    Results(WhereResult).values = Values;
    Results(WhereResult).reshape = size(TheQuanti.elem(1).quanti);
    
    handles.results = Results;
    %guidata(hObject,handles);
    
    % ----------- Update -----------
    ListTher(1) = {'none'};
    for i=1:length(Results)
        ListTher(i+1) = Results(i).method;   
    end
    
    Onest = length(ListTher);
    
    set(handles.REppmenu1,'String',ListTher);
    set(handles.REppmenu1,'Value',Onest);
    set(handles.REppmenu2,'String',Results(Onest-1).labels);
    
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
        
    % ---------- Display ----------    
    REppmenu1_Callback(hObject, eventdata, handles);
    
    %GraphStyle(hObject, eventdata, handles)
    %axes(handles.axes1);
    %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    %XmapWaitBar(1,handles);
    
    % Moved here 3.4.1 to fix a display issue
    AffOPT(3, hObject, eventdata, handles); % Maj 1.4.1
    %OnEstOu(hObject, eventdata, handles);
    
end

% 
% if weAreGoingTo == 7
%     % (1) check if XThermoTools is available on this computer...
%     TheAnswer = exist('XThermoTools');
%     
%     if TheAnswer ~= 2 && TheAnswer ~= 6
%         warndlg({'XThermoTools is not installed on this computer.','This is normal because this XThermoTools is not yet available for public use'},'Warning')
%         return
%     end
%     
%     % Data to be sended
%     
%     TheMaskFile = handles.MaskFile(get(handles.PPMenu3,'Value'));
%     TheQuanti = handles.quanti(get(handles.QUppmenu2,'Value'));
%     
%     TheQuanti.listname = upper(TheQuanti.listname);   % XThermoTools use UPPERCASE
%     
%     
%     % Run VER_XMapTools_804 with the values from VER_XMapTools_804
%     XThermoTools(TheQuanti,TheMaskFile)
%     
%     % So here ver_xmaptools_804 is still active and can be use in parallel with XThermoTools.
%     % This is a good news.
%     % P. Lanari (17.07.13).
% end
% 


%
return


% #########################################################################
%       BUTTON: INTERACTION VOLUME
function QUbutton20_Callback(hObject, eventdata, handles)
% 

[Test] = CheckMapAndMaskfileSize(hObject, eventdata, handles); % 3.3.1
if ~Test
    return
end

axes(handles.axes1)
Clim = caxis;

MaskFile = handles.MaskFile;
SelectedMaskFile = get(handles.LeftMenuMaskFile,'Value');
%SelectedMaskFile = get(handles.PPMenu1,'Value');

Quanti = handles.quanti;
Selected = get(handles.QUppmenu2,'Value');
SelectedMap = get(handles.QUppmenu1,'Value');

Elements = Quanti(Selected).listname;


% Data for estimating analytical voume (see Lanari & Piccoli 2019)

ElData = {'SiO2','TIO2','Al2O3','FeO','Fe2O3','MnO','MgO','CaO','Na2O','K2O','H2O'};
Nb_Cat = [1,1,2,1,2,1,1,1,2,2,2]; % Nb cations
Nb_O= [2,2,3,1,3,1,1,1,1,1,1]; % Nb Oxygenes
Z_Cat = [14, 22, 13, 26, 26, 25, 12, 20, 11, 19, 1];
Z_O = 8*ones(1,length(Nb_Cat));
Mm_Cat = [28.0855, 47.867, 26.981539, 55.845, 55.845, 54.938045, 24.305, 40.078, 22.989769, 39.0983, 1.00794];
Mm_O = 15.999*ones(1,length(Nb_O));
Mm_Ox = Mm_Cat.*Nb_Cat+Mm_O.*Nb_O;


DataOxideRef = zeros(numel(Quanti(Selected).elem(1).quanti),numel(ElData));

ElRej = {};
Compt = 0;
for i = 1:length(Elements)
    [Check,Where] = ismember(Elements{i},ElData);
    
    if ~Check
        Compt = Compt+1;
        ElRej{Compt} = Elements{i};
    else
        DataOxideRef(:,Where) = Quanti(Selected).elem(i).quanti(:);
        
        
    end
end

if isequal(sum(DataOxideRef(:,end)),0)
    Choice = questdlg('Would you like to use (100 - SumOx) = H2O?','MAN','Yes','No','Yes');
    switch Choice
        case 'Yes'
            SumNoH2O = sum(DataOxideRef(:,1:end-1),2);
            WhereComp = find(SumNoH2O > 0 & SumNoH2O < 100); 
            DataOxideRef(WhereComp,end) = 100 - SumNoH2O(WhereComp);
    end
end

WhereComp = find(sum(DataOxideRef,2) > 0);
NbRow = length(WhereComp);

Z_Ox = zeros(size(DataOxideRef));
Z_mean = zeros(size(DataOxideRef,1),1);

Z_Ox(WhereComp,:) = DataOxideRef(WhereComp,:).*(repmat(Z_Cat,NbRow,1).*repmat(Mm_Cat,NbRow,1).*repmat(Nb_Cat,NbRow,1)./repmat(Mm_Ox,NbRow,1)+repmat(Z_O,NbRow,1).*repmat(Mm_O,NbRow,1).*repmat(Nb_O,NbRow,1)./repmat(Mm_Ox,NbRow,1));

Z_mean(WhereComp,1) = sum(Z_Ox(WhereComp,:),2)./sum(DataOxideRef(WhereComp,:),2);
Ro = MaskFile(SelectedMaskFile).DensityMap(:);

IntDiameter = zeros(size(Z_mean));


% Equation Lanari & Piccoli | WARNING density is in g/cm3

if max(Ro) > 100
    % Fixing an issue with the units - the equation uses g/cm3
    Ro = Ro/1000;
    disp(' * Warning *')
    disp('   Density values were converted to g/cm3 to be compatible with')
    disp('   the equation in Lanari & Piccoli (2019).')
    disp(' ')
end

a = 4.034;
b = -0.02139;
c = 1.548;
d = -0.0006457;

Xi = Z_mean.*Ro.^2;

IntDiameter(WhereComp) = a*exp(b*Xi(WhereComp))+c*exp(d*Xi(WhereComp));

OnPlot = reshape(IntDiameter,size(Quanti(Selected).elem(1).quanti,1),size(Quanti(Selected).elem(1).quanti,2));

figure,  
imagesc(OnPlot), axis image, colorbar
colormap(handles.activecolorbar)
set(gca,'XTick',[],'YTick',[])

figure, 
histogram(IntDiameter(WhereComp),60);
xlabel('Diameter (mu)')

Res = inputdlg({'Pixel size (in um)'},'XMapTools',1,{'1'});

if length(Res)
    Res = str2num(char(Res));
else
    return
end

TheMap4Plotting = Quanti(Selected).elem(SelectedMap).quanti;

MapSize = size(TheMap4Plotting);

Xrange = repmat([1:MapSize(2)],MapSize(1),1);
Yrange = repmat([1:MapSize(1)]',1,MapSize(2));

figure, hold on
imagesc(TheMap4Plotting), axis image, colorbar, caxis(Clim)
set(gca,'Ydir','reverse')
colormap(handles.activecolorbar)
title('Select an area-of-interest (polygon max 300*300 px) to plot the real pixel sizes')


% Selection
clique = 1;
ComptResult = 1;

h = [0];
while clique < 2
    [a,b,clique] = ginput(1);
    if clique < 2
        h(ComptResult,1) = a;
        h(ComptResult,2) = b;
        
        [aPlot,bPlot] = CoordinatesFromRef(a,b,handles);
        
        % new (1.6.2)
        hPlot(ComptResult,1) = a;
        hPlot(ComptResult,2) = b;
        
        plot(floor(hPlot(ComptResult,1)),floor(hPlot(ComptResult,2)),'.w') % point
        if ComptResult >= 2 % start
            plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-m','linewidth',2)
            plot([floor(hPlot(ComptResult-1,1)),floor(hPlot(ComptResult,1))],[floor(hPlot(ComptResult-1,2)),floor(hPlot(ComptResult,2))],'-k','linewidth',1)
        end
        ComptResult = ComptResult + 1;
    end
end

% Trois points minimum...
if length(h(:,1)) < 3
    return
end

% new V1.4.1
plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-m','linewidth',2)
plot([floor(hPlot(1,1)),floor(hPlot(end,1))],[floor(hPlot(1,2)),floor(hPlot(end,2))],'-k','linewidth',1)

MasqueSel = Xpoly2maskX(h(:,1),h(:,2),MapSize(1),MapSize(2));
WherePlot = find(MasqueSel(:) > 0 & sum(DataOxideRef,2) > 0 & sum(IntDiameter > 0));

MinX = min(Xrange(WherePlot));
MaxX = max(Xrange(WherePlot));
dX = 0.1*(MaxX-MinX);

MinY = min(Yrange(WherePlot));
MaxY = max(Yrange(WherePlot));
dY = 0.1*(MaxY-MinY);

axis([MinX-dX MaxX+dX MinY-dY MaxY+dY])
drawnow

CB = handles.activecolorbar;
CRange = [Clim(1):(Clim(2)-Clim(1))/(size(CB,1)-1):Clim(2)];

figure, hold on
rectangle('Position',[0,0,MapSize(2),MapSize(1)],'Facecolor','w')
axis image
axis([MinX-dX MaxX+dX MinY-dY MaxY+dY])
title('This might take some time - be patient')
set(gca,'Ydir','reverse')
drawnow
for i = 1:length(WherePlot) %length(WhereComp)
    
    Value = TheMap4Plotting(Yrange(WherePlot(i)),Xrange(WherePlot(i)));
    Poss = find(CRange < Value);
    
    if isempty(Poss)
        Poss = 1;
    end
    
    %disp([WherePlot(i)]);
    rectangle('Position',[Xrange(WherePlot(i)),Yrange(WherePlot(i)),IntDiameter(WherePlot(i))/Res,IntDiameter(WherePlot(i))/Res],'Curvature',[1,1],'Facecolor',CB(Poss(end),:),'EdgeColor','none');

end
axis([MinX-dX MaxX+dX MinY-dY MaxY+dY])
title(' ') 
drawnow

return
keyboard




% ColorPlots = zeros(length(WherePlot),3);
% for i = 1:length(WherePlot)
%     Value = TheMap4Plotting(Yrange(WherePlot(i)),Xrange(WherePlot(i)));
%     if isempty(Poss)
%         Poss = 1;
%     end
%     Poss = find(CRange < Value);
%     ColorsPlots(i,:) = CB(Poss(end),:);
% end

% figure,
% rectangle('Position',[0,0,MapSize(2),MapSize(1)],'Facecolor','w')
% ax = gca;
% axis image
% axis([MinX-dX MaxX+dX MinY-dY MaxY+dY])
% CurrentUnit = get(ax,'Units');
% set(ax,'Units','Points');
% pos = get(ax,'Position');
% set(gca,'Units',CurrentUnit);
% XL = xlim(ax);
% points_per_unit = pos(3)/(XL(2)-XL(1));
% marker_size = (points_per_unit*IntDiameter(WherePlot)/Res).^2 * pi /4;
% scatter(Xrange(WherePlot),Yrange(WherePlot),marker_size,ColorsPlots)
% axis image
% axis([MinX-dX MaxX+dX MinY-dY MaxY+dY])
% set(gca,'Ydir','reverse')




%keyboard





return



% #########################################################################
%       BUTTON: FILTER LOD
function QUbutton21_Callback(hObject, eventdata, handles)
% 

ListQuanti = get(handles.QUppmenu2,'String');
SelQuanti = get(handles.QUppmenu2,'Value');
QuantiName = char(ListQuanti(SelQuanti));
SelElem = get(handles.QUppmenu1,'Value');

% Read LOD.txt
[LOD] = ReadLODfile(handles,QuantiName);

if isempty(LOD)
    CodeTxt = [18,1];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

    return
end

CodeTxt = [18,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

Quanti = handles.quanti;
Selected = get(handles.QUppmenu2,'Value');
SelectedMap = get(handles.QUppmenu1,'Value');

Elements = Quanti(Selected).listname;

NewQuanti = Quanti(Selected);

NewQuanti.mineral = {[char(NewQuanti.mineral),'_LOD']};

fprintf('\n\n\t%s\n\n',['*** LOD Filter for phase: ',char(NewQuanti.mineral)])

fprintf('\t%s\t%s\t\t%s\t%s\n','Elem','LOD','Rejected Px','Fraction (%)')
for i = 1:length(NewQuanti.elem)
    
    Where = find(ismember(LOD.ListElem,Elements{i}));
    
    if ~Where
        fprintf('\t%s\t%s\n',Elements{i},'not found (skiped)')
    else
        LODspec = LOD.Factors(Where);
        BelowLOD = find(NewQuanti.elem(i).quanti < LODspec);
        
        % Better statistics:
        PxDefined = numel(find(NewQuanti.elem(i).quanti));
        PxAboveDL = numel(find(NewQuanti.elem(i).quanti > LODspec));
        
        if length(BelowLOD)
            NewQuanti.elem(i).quanti(BelowLOD) = zeros(size(BelowLOD));
        end
        if isequal(PxDefined-PxAboveDL,0)
            fprintf('\t%s\t%.9f\t%.3f%s%.0f\t%.5f\n',Elements{i},LODspec,PxDefined-PxAboveDL,'/',PxDefined,(PxDefined-PxAboveDL)/PxDefined*100);
        elseif PxDefined-PxAboveDL < 100
            fprintf('\t%s\t%.9f\t%.2f%s%.0f\t%.5f\n',Elements{i},LODspec,PxDefined-PxAboveDL,'/',PxDefined,(PxDefined-PxAboveDL)/PxDefined*100);
            elseif PxDefined-PxAboveDL < 1000
            fprintf('\t%s\t%.9f\t%.1f%s%.0f\t%.5f\n',Elements{i},LODspec,PxDefined-PxAboveDL,'/',PxDefined,(PxDefined-PxAboveDL)/PxDefined*100);
        else
            fprintf('\t%s\t%.9f\t%.0f%s%.0f\t%.4f\n',Elements{i},LODspec,PxDefined-PxAboveDL,'/',PxDefined,(PxDefined-PxAboveDL)/PxDefined*100);
        end
    end
end

% Update:
Quanti(end+1) = NewQuanti;

disp(' '), disp(' ')

% ---------- Update Mineral Menu QUppmenu2 ----------
for i=1:length(Quanti)
    NamesQuanti{i} = char(Quanti(i).mineral);
end

set(handles.QUppmenu2,'String',NamesQuanti);
set(handles.QUppmenu2,'Value',length(Quanti));

handles.quanti = Quanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
QUppmenu2_Callback(hObject, eventdata, handles)

return


% #########################################################################
%    READ FILE: LOD (NEW 3.2.1)
function [LOD] = ReadLODfile(handles,QuantiName)

if ~exist('LOD.txt')
    
    if ~exist(['LOD/LOD_',QuantiName,'.txt'])
    
        LOD = [];
        errordlg('This function requires the file ''LOD.txt'' or ''/LOD/LOD_QuantiName.txt''','Error XMapTools');
        return
    
    else
        fid = fopen(['LOD/LOD_',QuantiName,'.txt'],'r');
    end
        
else
     fid = fopen('LOD.txt','r');   
end


Compt = 0;

LOD.ListElem = '';
LOD.Factors = [];

while 1
    tline = fgetl(fid);
    
    if isequal(tline,-1)
        break
    end
    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            
            while 1
                tline = fgetl(fid);
                
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                
                Compt = Compt + 1;
                
                TheStr = strread(tline,'%s');
                LOD.ListElem{Compt} = TheStr{1};
                LOD.Factors(Compt) = str2num(TheStr{2});
            end
        end
        
    end
end

return


% #########################################################################
%       BUTTON: APPLY MAGIC FILTER
function QUbutton22_Callback(hObject, eventdata, handles)


Quanti = handles.quanti;
Selected = get(handles.QUppmenu2,'Value');

NewQuanti = Quanti(Selected);

NewQuanti.mineral = {[char(NewQuanti.mineral),'_*']};

SumCOMP = zeros(size(NewQuanti.elem(1).quanti));

for i = 1:length(NewQuanti.elem)
    SumCOMP = SumCOMP + NewQuanti.elem(i).quanti;
end

Idx = find(SumCOMP(:));

MaxSum = max(SumCOMP(Idx));
MinSum = min(SumCOMP(Idx));

MeanSum = mean(SumCOMP(Idx));
MedSum = median(SumCOMP(Idx));
Sigma1 = std(SumCOMP(Idx));

Idx2 = find(SumCOMP(:) > MedSum-3*Sigma1 & SumCOMP(:) < MedSum+3*Sigma1);   % First 3s filter

MeanSum2 = mean(SumCOMP(Idx2));
MedSum2 = median(SumCOMP(Idx2));
Sigma2 = std(SumCOMP(Idx2));

RecommendedCutoff = MedSum2+3*Sigma2;

FilterIdx = find(SumCOMP>RecommendedCutoff);

CodeTxt = [18,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

Answer = questdlg(['Do you want to correct ',num2str(numel(FilterIdx)),'/',num2str(numel(Idx)),' pixels (',num2str(numel(FilterIdx)/numel(Idx)*100),' %) with a total above ',num2str(RecommendedCutoff),' to median = ',num2str(MedSum2)],'XMapTools','Yes');

switch Answer
    
    case 'Yes'
        Cutoff = RecommendedCutoff;
        Correction = MedSum2;
        
    case 'Cancel'
        CodeTxt = [18,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
        
    case 'No'
        Values = inputdlg({['Thresold on the SUM (min=',num2str(MinSum),'; max=',num2str(MaxSum),'; mean=',num2str(MeanSum),'; med=',num2str(MedSum),'; std=',num2str(Sigma1),')'],'Corrected total'},'XMapTools',1,{num2str(RecommendedCutoff),num2str(MedSum2)});
        if isempty(Values)
            CodeTxt = [18,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            return
        else
            Cutoff = str2num(Values{1});
            Correction = str2num(Values{2});
        end
end

CorrIdx = find(SumCOMP(:) > Cutoff);
CorrMtx = ones(size(SumCOMP));
CorrMtx(CorrIdx) = Correction./SumCOMP(CorrIdx);

for i = 1:length(NewQuanti.elem)
    NewQuanti.elem(i).quanti = NewQuanti.elem(i).quanti .* CorrMtx;
end

Quanti(Selected) = NewQuanti;


%figure, imagesc(CorrMtx), axis image, colorbar

% figure, imagesc(SumCOMP), axis image, colorbar
%figure, hist(SumCOMP(Idx),150);


% ---------- Update Mineral Menu QUppmenu2 ----------
for i=1:length(Quanti)
    NamesQuanti{i} = char(Quanti(i).mineral);
end

set(handles.QUppmenu2,'String',NamesQuanti);
set(handles.QUppmenu2,'Value',length(Quanti));

handles.quanti = Quanti;

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
QUppmenu2_Callback(hObject, eventdata, handles)

return









% -------------------------------------------------------------------------
% 6) RESULT FONCTIONS
% -------------------------------------------------------------------------
% goto results

% #########################################################################
%       EXTERNAL FUNCTION COMPUTATION (3.3.1)
function THbutton1_Callback(hObject, eventdata, handles)

% Add a general structural function (all elements) in 3.4.1
%   - No external function (detected here)

% Minor issues fixed in 3.3.1
%   - Correction mode activated for all external functions

% Updated in the version 1.6.4
%   - Compatible with area selection for: P, T and P-T spot mode.

set(gcf, 'WindowButtonMotionFcn', '');

% -- Inserted in XMapTools 3.3.1
% ZoomButtonReset_Callback(hObject, eventdata, handles); 
% -- and removed as it causes troubles with the maps having a different resolution. 
zoom off
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)


% ----------- Loaded external functions -----------
externalFunctions = handles.externalFunctions;

weAreType = get(handles.THppmenu3,'Value');
minRef = get(handles.THppmenu1,'Value');
methodeRef = get(handles.THppmenu2,'Value');

if isequal(weAreType,6)
    handles = THbutton3_Callback(hObject, eventdata, handles);
    % Inserted in XMapTools 3.3.1
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    return
end

selectedFunction = externalFunctions(weAreType).minerals(minRef).method(methodeRef);


%Choice = 1;
%Thermo = handles.thermo;
%ThermoMin = get(handles.THppmenu1,'Value'); % mineral
%ThermoMet = get(handles.THppmenu2,'Value'); % method
%Thermometers = Thermo(ThermoMin).thermometers(ThermoMet);

if ~handles.quanti(get(handles.QUppmenu2,'Value')).isoxide
    ButtonName = questdlg('You are using a density-corrected map, would you like to continue?', 'WARNING', 'No');
    switch ButtonName
        case {'Cancel','No'}
            CodeTxt = [10,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            % Inserted in XMapTools 3.3.1
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            return
    end
end


if weAreType == 3         % two or more minerals (spot mode)
    NbMin = 2;            % automatic setting 1.6.2
    
    %NbMin = Thermometers.type; % = number of mins
    
    CodeTxt = [14,11];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %     if handles.MatlabVersion>=7.14
    %         ChoiceMenu = menuX('method to select analyses:', 'Spot (single estimate)', 'Area (average estimate)'); % 1.6.4
    %     else
    %         ChoiceMenu = menu('method to select analyses:', 'Spot (single estimate)', 'Area (average estimate)'); % 1.6.4
    %     end
    
    % New Menu Alice Vho - 6.07.2017
    ChoiceMenu = Menu_XMT({'method to select analyses:'}, {'Spot (single estimate)', 'Area (average estimate)'},handles.LocBase); % 1.6.4
    
    if ~ChoiceMenu
        CodeTxt = [14,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % Inserted in XMapTools 3.3.1
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
    
    %1) On affiche la bonne carte quanti avec les deux min?raux...
    lesElems = get(handles.QUppmenu1,'String');
    leElem = get(handles.QUppmenu1,'Value');
    
    CodeTxt = [14,8];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    [SelectedElem,Ok] = listdlg('ListString',lesElems,'SelectionMode','Single','InitialValue',leElem);
    
    if ~Ok
        CodeTxt = [14,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % Inserted in XMapTools 3.3.1
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
    
    lesMaps = get(handles.QUppmenu2,'String');
    for i=2:length(lesMaps)
        lesMapsOk{i-1} = lesMaps{i};
    end
    leMap = get(handles.QUppmenu2,'Value');
    
    NamesMin = externalFunctions(weAreType).minerals(minRef).name;
    
    %NamesMin = Thermometers.mineral;
    lesNamesMin = strread(char(NamesMin),'%s','delimiter','+');
    
    for i=1:NbMin
        CodeTxt = [14,9];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(lesNamesMin{i})]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        [TheSelectedMap,Ok] = listdlg('ListString',lesMapsOk,'SelectionMode','Single','InitialValue',leMap-1);
        
        if ~Ok
            CodeTxt = [14,3];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % Inserted in XMapTools 3.3.1
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            return
        end
        SelectedMaps(i) = TheSelectedMap;
    end
    
    
    if length(SelectedMaps) < NbMin %number of minerals
        CodeTxt = [14,10];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % Inserted in XMapTools 3.3.1
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
    
    SelectedMaps = SelectedMaps + 1; % required for indexation
    
    % Go building the newmap
    Quanti = handles.quanti;
    
    TheMap = zeros(size(Quanti(2).elem(1).quanti));
    for i=1:length(SelectedMaps)
        TheMap = TheMap + Quanti(SelectedMaps(i)).elem(SelectedElem).quanti;
    end
    
    CodeTxt = [11,17];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    FigH = figure;
    set(FigH,'units','normalized','outerposition',[0 0 1 1]);
    imagesc(TheMap), colorbar vertical, axis image, colormap([colormap(handles.activecolorbar)])
    set(gca,'XTick',[]); set(gca,'YTick',[]);
    hold on,
    
    % Preparation a l'indexation pour toutes les maps
    ListInput = selectedFunction.input;
    
    %ListInput = Thermometers.input;
    
    ComptAbsMap = 0;
    
    for i = 1:length(SelectedMaps)
        lesElemsDispo = Quanti(SelectedMaps(i)).listname;
        leMinTraite = Quanti(SelectedMaps(i)).mineral;
        
        for iElem = 1:length(ListInput)
            LeElem = ListInput(iElem);
            
            [oui,ou] = ismember(LeElem,lesElemsDispo); % map order
            
            % New test: have you this map ? (10/10)
            if oui
                DataElem = Quanti(SelectedMaps(i)).elem(ou).quanti(:);
            else
                ComptAbsMap = ComptAbsMap+1;
                DataElem = zeros(length(Quanti(SelectedMaps(i)).elem(1).quanti(:)),1);
                % En fait on cree une matrice de zeros sur la taille de
                % LaQuanti.elem(1) ou on est sur d'avoir une map.
                ListAbsMap{ComptAbsMap} = LeElem;
            end
            Valeurs2Thermo(i).val(:,iElem) = DataElem;
        end
    end
    
    % Bon on a maintenant deux tableaux avec les analyses au bon format de
    % la fonction... Cool
    
    % 2) Preparation de la fonction eval pour pas le faire dans chaque
    % boucle
    
    % Eval to apply the thermometer...
    ListOutput = selectedFunction.output;
    
    %ListOutput = Thermometers.output;
    b = char(ListOutput);
    
%     for i=1:size(b,1) % lines
%         for j=1:size(b,2) % columns
%             if i == 1 & j == 1
%                 Text = '[';
%                 Text = strcat(Text,b(i,j));
%             elseif i ~= 1 & j == 1
%                 Text = strcat(Text,',',b(i,j));
%             elseif i ~= 1 & j ~= 1
%                 Text = strcat(Text,b(i,j));
%             end
%         end
%     end
%     
%     Text = strcat(Text,']');
    
    % Version 3.3.1 (error with single variables with the original version above)
    Text = '[';
    for i = 1:size(b,1)
        Text = [Text,b(i,:),','];
    end
    Text(end) = ']';
    WhereSpace = find(~ismember(Text,' '));
    Text = Text(WhereSpace);
    
    Commande = char(strcat(Text,' = ',selectedFunction.file,'(CompoMin,handles,InputVariables);'));
    
    % from 1.6.4 we need to define InputVariables
    
    % 3) Selection des points
    
    % Decal en fonction taille image
    if length(TheMap(1,:)) > 700
        Decal(1) = 20;
    elseif length(TheMap(1,:)) > 400
        Decal(1) = 10;
    else
        Decal(1) = 5;
    end
    
    if length(TheMap(:,1)) > 700
        Decal(2) = 20;
    elseif length(TheMap(:,1)) > 400
        Decal(2) = 10;
    else
        Decal(2) = 5;
    end
    
    % Preparation de la sauvegarde...
    
    lesResults.method = selectedFunction.name;
    lesResults.minerals = NamesMin;
    
    %lesResults.method = Thermometers.name;
    %lesResults.minerals = Thermometers.mineral;
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    if ChoiceMenu == 1                                  % spot mode (1.6.4)
        
        hold on,
        % New version 1.5.1 for selection and output... nbmin can be > 2...
        OnEnSelect = 1;
        ComptCouples = 0;
        
        while OnEnSelect
            
            % First mineral...
            title(['Select a ',char(lesNamesMin{1}),' or rigth clic to exit...'])
            [x,y,button] = ginput(1);  % here ginput because we are not in the GUI (Lanari 11/2012)
            
            Ou = (round(x)-1)*length(TheMap(:,1)) + round(y);    % this works because x are columns and y rows
            CompoMin(1,:) =  Valeurs2Thermo(1).val(Ou,:);
            
            if button == 3
                break
            else
                ComptCouples = ComptCouples+1;
                disp(['* * * Selection: ',num2str(ComptCouples)]);
                disp([char(lesNamesMin{1}),' (Compo)']);
                disp(num2str(CompoMin(1,:)));
                
                %             X1(ComptCouples) = x;
                %             Y1(ComptCouples) = y;
                
                leTxt = text(x-Decal(1),y-Decal(2),['C',num2str(ComptCouples)]);
                set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',8)
                hold on, plot(x,y,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
                
                for iMin = 2:NbMin
                    
                    title(['Select a ',char(lesNamesMin{iMin}),'...'])
                    [x,y] = ginput(1); % here ginput because we are not in the GUI (Lanari 11/2012)
                    
                    Ou = (round(x)-1)*length(TheMap(:,1)) + round(y);
                    CompoMin(iMin,:) = Valeurs2Thermo(2).val(Ou,:); % A changer par la suite...
                    
                    disp([char(lesNamesMin{iMin}),' (Compo)']);
                    disp(num2str(CompoMin(iMin,:)));
                    
                    %                 X2(ComptCouples) = x;
                    %                 Y2(ComptCouples) = y;
                    
                    leTxt = text(x-Decal(1),y-Decal(2),['C',num2str(ComptCouples)]);
                    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',8)
                    hold on, plot(x,y,'o','MarkerEdgeColor','r','MarkerFaceColor','w')
                    
                    if iMin == NbMin % Alors on peut calculer...
                        
                        % Ask for input variables (1.6.4)
                        if length(char(selectedFunction.variables))
                            InputVariables = str2num(char(inputdlg(selectedFunction.variables,'Input',1,selectedFunction.varvals)));
                            
                            % Change the default answer
                            for k = 1:length(selectedFunction.varvals)
                                selectedFunction.varvals{k} = num2str(InputVariables(k));
                            end
                        else
                            InputVariables = [];
                        end
                        
                        % - - - - - - - - - - - - - - - - - - - - - - - - -
                        XmapWaitBar(0, handles);
                        eval(Commande);
                        XmapWaitBar(1, handles);
                        
                        figure(FigH); % new 3.2.2 otherwise the interface takes the control
                        % - - - - - - - - - - - - - - - - - - - - - - - - -
                         
                        % Liste des variables de sortie (new 1.5.1)
                        TextAffich0 = ['Results (Test ',char(num2str(ComptCouples)),')'];
                        TextAffich = '... ';
                        for i=1:length(ListOutput)
                            eval(['LaValeur = ',num2str(ListOutput{i}),';']);
                            if LaValeur > 1
                                TextAffich = [char(TextAffich),char(ListOutput{i}),' = ',int2str(LaValeur),' ... '];
                            else
                                TextAffich = [char(TextAffich),char(ListOutput{i}),' = ',num2str(LaValeur,3),' ... '];
                            end
                        end
                        
                        %xlabel(['Couple ',num2str(ComptCouples),' - Temperature = ',num2str(T),' - ln(Kd) = ',num2str(ln_Kd)]);
                        xlabel({TextAffich0,TextAffich});
                        
                        % Sauvegarde des resultats
                        lesResults.test(ComptCouples).oxides = CompoMin;
                        lesResults.test(ComptCouples).first = TextAffich0;
                        lesResults.test(ComptCouples).second = TextAffich;
                    end
                    
                end
                
            end
            
        end
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    else
        % Choice Menu = 2                                    % area mode...
        
        [LinS,ColS] = size(Quanti(2).elem(1).quanti);
        
        hold on,
        OnEnSelect = 1;
        ComptCouples = 1;
        
        % Ask for input variables (1.6.4)
        if length(char(selectedFunction.variables))
            InputVariables = str2num(char(inputdlg(selectedFunction.variables,'Input',1,selectedFunction.varvals)));
            
            % Change the default answer
            for k = 1:length(selectedFunction.varvals)
                selectedFunction.varvals{k} = num2str(InputVariables(k));
            end
        else
            InputVariables = [];
        end
        
        % while OnEnSelect    % Only one in this mode...
        
        % First mineral...
        title(['Select an area in ',char(lesNamesMin{1}),' or rigth clic to exit...'])
        
        h = [0];
        clique = 1;
        ComptResult = 1;
        while clique < 2
            [a,b,clique] = ginput(1);          % here ginput because we are not in the GUI !!!
            if clique < 2
                h(ComptResult,1) = a;
                h(ComptResult,2) = b;
                plot(floor(h(ComptResult,1)),floor(h(ComptResult,2)),'.w')
                if ComptResult >= 2 % start
                    plot([floor(h(ComptResult-1,1)),floor(h(ComptResult,1))],[floor(h(ComptResult-1,2)),floor(h(ComptResult,2))],'-k')
                end
                ComptResult = ComptResult + 1;
            end
        end
        
        % Trois points minimum...
        if length(h(:,1)) < 3
            CodeTxt = [11,5];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(5))]);
            
            % Inserted in XMapTools 3.3.1
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            return
        end
        
        plot([floor(h(1,1)),floor(h(end,1))],[floor(h(1,2)),floor(h(end,2))],'-k');
        MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);
        
        
        % Extract the data...
        
        [TheListY,TheListX] = find(MasqueSel == 1);    % in row / column format
        Ou = (round(TheListX)-1)*length(TheMap(:,1)) + round(TheListY);
        
        Compt = 0;
        
        
        % We select only the pixels with a 'valid' composition
        for i=1:length(Ou)
            if sum(Valeurs2Thermo(1).val(Ou(i),:))
                Compt = Compt+1;
                TheDataShorted(1).Compos(Compt,:) = Valeurs2Thermo(1).val(Ou(i),:);
            end
        end
        
        
        for iMin = 2:NbMin
            
            title(['Select an area in ',char(lesNamesMin{iMin}),'...'])
            
            h = [];
            clique = 1;
            ComptResult = 1;
            while clique < 2
                [a,b,clique] = ginput(1);          % here ginput because we are not in the GUI !!!
                if clique < 2
                    h(ComptResult,1) = a;
                    h(ComptResult,2) = b;
                    plot(floor(h(ComptResult,1)),floor(h(ComptResult,2)),'.w')
                    if ComptResult >= 2 % start
                        plot([floor(h(ComptResult-1,1)),floor(h(ComptResult,1))],[floor(h(ComptResult-1,2)),floor(h(ComptResult,2))],'-k')
                    end
                    ComptResult = ComptResult + 1;
                end
            end
            
            % Trois points minimum...
            if length(h(:,1)) < 3
                CodeTxt = [11,5];
                set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
                TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
                
                % set(handles.TxtControl,'String',[char(handles.TxtDatabase(11).txt(5))]);
                return
            end
            
            plot([floor(h(1,1)),floor(h(end,1))],[floor(h(1,2)),floor(h(end,2))],'-k');
            MasqueSel = Xpoly2maskX(h(:,1),h(:,2),LinS,ColS);
            drawnow
            
            % Extract the data...
            [TheListY,TheListX] = find(MasqueSel == 1);   % in row / column format
            Ou = (round(TheListX)-1)*length(TheMap(:,1)) + round(TheListY);
            
            
            % We select only the pixels with a 'valid' composition
            Compt = 0;
            for i=1:length(Ou)
                if sum(Valeurs2Thermo(iMin).val(Ou(i),:))
                    Compt = Compt+1;
                    TheDataShorted(iMin).Compos(Compt,:) = Valeurs2Thermo(iMin).val(Ou(i),:);
                end
            end
            
            if iMin == NbMin % Alors on peut calculer...
                
                for i=1:NbMin
                    NbAna(i) = length(TheDataShorted(i).Compos(:,1));
                end
                
                LesCombi = AllCombi(NbAna);
                NbIter2Calc = length(LesCombi(:,1));
                
                % First test to see the number of output variables (in
                % order to define the variable TheValeurs)
                i=1;
                for j=1:NbMin
                    CompoMin(j,:) = TheDataShorted(j).Compos(LesCombi(i,j),:);
                end
                
                %set(gcf, 'WindowButtonMotionFcn', '');
                eval(Commande);
                %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
                
                TheValeurs = zeros(length(LesCombi(:,1)),length(ListOutput));
                
                % Approximate the computation time (new 3.3.1)
                if NbIter2Calc > 10
                    tic
                    for i = 1:10
                        for j=1:NbMin
                            CompoMin(j,:) = TheDataShorted(j).Compos(LesCombi(i,j),:);
                        end
                        
                        eval(Commande);
                
                        for j=1:length(ListOutput)
                            eval(['TheValeurs(i,j) = ',char(ListOutput{j}),';']);
                        end
                    end
                    TimeFor10 =toc;
                    TimeForAll = TimeFor10/10*NbIter2Calc;
                    Answer = questdlg(['Would you like to compute ',num2str(NbIter2Calc),' couples in ~ ',num2str(TimeForAll/60), ' minutes?'],'XMapTools');
                    
                    if ~isequal(Answer,'Yes')
                        handles.CorrectionMode = 0;
                        guidata(hObject,handles);
                        OnEstOu(hObject, eventdata, handles)
                    end
                        
                end

                LimWBdisp = NbIter2Calc/100;
                
                % Computation
                ComptWait = 0;
                h = waitbar(0,'XMapTools is running numbers - please wait...');
                
                for i=1:NbIter2Calc
                    for j=1:NbMin
                        CompoMin(j,:) = TheDataShorted(j).Compos(LesCombi(i,j),:);
                    end
                    ComptWait = ComptWait + 1;
                    
                    if ComptWait > LimWBdisp
                        ComptWait = 0;
                        waitbar(i/NbIter2Calc,h);
                    end
                    
                    %set(gcf, 'WindowButtonMotionFcn', '');
                    eval(Commande);
                    %set(gcf, 'WindowButtonMotionFcn', @mouseMove);
                    
                    for j=1:length(ListOutput)
                        eval(['TheValeurs(i,j) = ',char(ListOutput{j}),';']);
                    end
                    
                end
                close(h);
                
                TextAffich0 = ['Results (Pairs: ',char(num2str(length(LesCombi(:,1)))),')'];
                TextAffich = '... ';
                for i=1:length(ListOutput)
                    ValuesOK = find(~isnan(TheValeurs(:,i)));
                    if ValuesOK
                        LaMeanFin = mean(TheValeurs(ValuesOK,i));   % added find in
                        LaStdFin = std(TheValeurs(ValuesOK,i));
                        if LaMeanFin > 5
                            TextAffich = [char(TextAffich),char(ListOutput{i}),' = ',int2str(LaMeanFin),' +/- ',int2str(LaStdFin),' (1o) ',' ... '];
                        else
                            TextAffich = [char(TextAffich),char(ListOutput{i}),' = ',num2str(LaMeanFin,3),' +/- ',num2str(LaStdFin,3),' (1o) ',' ... '];
                        end
                    else
                        TextAffich = 'no result';
                    end
                end
                
                xlabel({TextAffich0,TextAffich});
                title('');
                
                figure
                hist(TheValeurs(:,1),30)
                
                % Sauvegarde des resultats
                for i=1:NbMin
                    lesResults.test(ComptCouples).oxides(i,:) = mean(TheDataShorted(i).Compos(:,:),1);
                end
                
                lesResults.test(ComptCouples).first = TextAffich0;
                lesResults.test(ComptCouples).second = TextAffich;
                
            end
            
        end
        
    end
    
    if ComptCouples
        % On propose une sauvegarde
        
        [Success,Message,MessageID] = mkdir('Results');
        
        cd Results
        [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export results as...');
        cd ..
        
        if Directory
            fid = fopen([char(pathname),char(Directory)],'w');
            fprintf(fid,'%s\n','Results from XMapTools');
            fprintf(fid,'%s\n',['Method: ',char(lesResults.method)]);
            fprintf(fid,'%s\n\n',['Minerals: ',char(lesResults.minerals)]);
            
            for i=1:length(lesResults.test)
                fprintf(fid,'%s\n',['* * * * * * * * Couple ',num2str(i),' * * * * * * * * ']);
                for iMin = 1:length(lesResults.test(i).oxides(:,1))
                    fprintf(fid,'%s\n',[char(lesNamesMin{iMin}),' composition: ',num2str(lesResults.test(i).oxides(iMin,:),5)]);
                end
                fprintf(fid,'%s\n\n',char(lesResults.test(i).second));
                %                 fprintf(fid,'%s\n',[char(lesNamesMin{1}),' composition: ',num2str(lesResults.test(i).oxides(1,:))]);
                %                 fprintf(fid,'%s\n',[char(lesNamesMin{2}),' composition: ',num2str(lesResults.test(i).oxides(2,:))]);
                %                 fprintf(fid,'%s\n\n',['T (C) = ',num2str(lesResults.test(i).T),' with ln(Kd) = ',num2str(lesResults.test(i).Kd)]);
            end
            fclose(fid);
        end
    end
    
    % fin ici, on n'envoie pas vers Results...
    % Note temporairement, il n'y a pas de sauvegarde Matlab, mais d'un
    % autre cote tout est dans le fichier .txt
    
    CodeTxt = [11,16];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    
%     axes(handles.axes1);
%     set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    XmapWaitBar(1,handles);
    
    % Inserted in XMapTools 3.3.1
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    
    return
end


if weAreType == 6
    axes(handles.axes1);
    set(gcf, 'WindowButtonMotionFcn', @mouseMove);
    return
end



% ----------- Input -----------
Quanti = handles.quanti;
ValMin = get(handles.QUppmenu2,'Value');
LaQuanti = Quanti(ValMin);

Results = handles.results;


if isequal(char(selectedFunction.name),'StructForm (all elem.)')
    
    % Special Case
    [ListOx_Temp,ListEl_Temp] = XMF_StructuralFormulaDefinitions(1);
    
    [lia,loc] = ismember(LaQuanti.listname,ListOx_Temp);
    
    selectedFunction.input = LaQuanti.listname;
    selectedFunction.output = ListEl_Temp(loc);
    
    
    MatrixOxide = zeros(numel(LaQuanti.elem(1).quanti(:)),length(LaQuanti.elem));
    % Create MatriXOxide
    for i = 1:length(LaQuanti.elem)
        MatrixOxide(:,i) = LaQuanti.elem(i).quanti(:);
    end
    
    WhereMin = find(sum(MatrixOxide,2) > 1);
    
    [OxBasis,Ok] = str2num(char(inputdlg('Oxygen basis','Input',1,{'10'})));
    if ~Ok
        OxBasis = 1;
    end
    
    [MatrixSF,ListOutput] = XMT_StructuralFormula(MatrixOxide(WhereMin,:),selectedFunction.input,OxBasis);
    
    LesResultats = zeros(size(MatrixOxide));
    LesResultats(WhereMin,:) = MatrixSF;
    
    handles.CorrectionMode = 0;
    handles.AutoContrastActiv = 0;  %reset auto-contrast (v2.6.1)
    
    guidata(hObject,handles);
    
else

    ListInput = selectedFunction.input;
    
    %ListInput = Thermometers.input;
    ListAbsMap = []; % if we haven't any map.
    
    Valeur2Therm = zeros(length(LaQuanti.elem(1).quanti(:)),length(ListInput));
    ComptAbsMap = 0; % for elements without map.
    
    for iElem = 1:length(ListInput)
        LeElem = ListInput(iElem);
        
        [oui,ou] = ismember(LeElem,LaQuanti.listname); % map order
        
        % New test: have you this map ? (10/10)
        if oui
            DataElem = LaQuanti.elem(ou).quanti(:);
        else
            ComptAbsMap = ComptAbsMap+1;
            DataElem = zeros(length(LaQuanti.elem(1).quanti(:)),1);
            % En fait on cree une matrice de zeros sur la taille de
            % LaQuanti.elem(1) ou on est sur d'avoir une map.
            ListAbsMap{ComptAbsMap} = LeElem;
        end
        
        for iNb = 1:length(DataElem)
            Valeur2Therm(iNb,iElem) = DataElem(iNb);
        end
    end
    
    
    % ----------- Warning -----------
    if length(ListAbsMap) > 0
        % Some elements haven't maps...
        ListText = '';
        for i=1:length(ListAbsMap)
            ListText = strcat(ListText,char(ListAbsMap{i}),',');
        end
        
        TextIn = strcat('This thermometer uses elements: ',char(ListText),' for which data are not available. Continue ?');
        ButtonName = questdlg(TextIn,'Warning','Yes','No','Yes');
        if length(ButtonName) < 3
            CodeTxt = [14,3];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            axes(handles.axes1);
            set(gcf, 'WindowButtonMotionFcn', @mouseMove);
            return % end of run
        end
    end
    
    % ----------- Calculation -----------
    ListOutput = selectedFunction.output;
    b = char(ListOutput);
    
    for i=1:size(b,1) % rows
        for j=1:size(b,2) % columns
            if i == 1 & j == 1
                Text = '[';
                Text = strcat(Text,b(i,j));
            elseif i ~= 1 & j == 1
                Text = strcat(Text,',',b(i,j));
            elseif j ~= 1
                Text = strcat(Text,b(i,j));
            end
        end
    end
    
    Text = strcat(Text,']');
    Commande = char(strcat(Text,' = ',selectedFunction.file,'(Valeur2Therm,handles);'));
    
    
    CodeTxt = [14,1];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),': ',char(selectedFunction.name),'']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(14).txt(1)),' - ',char(Thermometers.name),'']);
    
    % % New 2.1.3 (11.03.2015)
    % ZoomButtonReset_Callback(hObject, eventdata, handles);
    % zoom off
    % handles.CorrectionMode = 1;
    % guidata(hObject,handles);
    % OnEstOu(hObject, eventdata, handles)
    
    eval(Commande);
    
    %zoom on
    handles.CorrectionMode = 0;
    handles.AutoContrastActiv = 0;  %reset auto-contrast (v2.6.1)
    
    guidata(hObject,handles);
    
    %keyboard
    
%     AffOPT(3, hObject, eventdata, handles); % Maj 1.4.1
%     OnEstOu(hObject, eventdata, handles)
    
    % ----------- Extraction -----------
    for i=1:length(Text)
        if Text(i) == ','
            Text(i) = ';';
        end
    end
    
    eval(char(strcat('LesResultats = ',Text,';')));
    LesResultats = LesResultats';
    
end
    
    % ----------- Save -----------
    Icila = length(Results)+1;
    
    %if Choice == 2 % points coord
    %    Results(Icila).coord = [SelLinOk(:),SelColOk(:)];
    %else
    Results(Icila).coord = 0;
    %end
    
    %keyboard
    
    Results(Icila).type = weAreType;
    Results(Icila).mineral = externalFunctions(weAreType).minerals(minRef).name; %Thermometers.mineral;
    Results(Icila).method = selectedFunction.name;
    Results(Icila).labels = ListOutput;
    Results(Icila).values = LesResultats;
    Results(Icila).reshape = size(LaQuanti(1).elem(1).quanti);


handles.results = Results;

% ----------- Update -----------
ListTher(1) = {'none'};
for i=1:length(Results)
    ListTher(i+1) = Results(i).method;
end

Onest = length(ListTher);

set(handles.REppmenu1,'String',ListTher);
set(handles.REppmenu1,'Value',Onest);
set(handles.REppmenu2,'String',Results(Onest-1).labels);

guidata(hObject,handles);

% ---------- Display ----------
REppmenu1_Callback(hObject, eventdata, handles)

GraphStyle(hObject, eventdata, handles)
axes(handles.axes1);
set(gcf, 'WindowButtonMotionFcn', @mouseMove);
XmapWaitBar(1,handles);

% Moved here 3.4.1 to fix a display issue
AffOPT(3, hObject, eventdata, handles); % Maj 1.4.1
OnEstOu(hObject, eventdata, handles);

return


% #########################################################################
%       THERMOMETERS LIST V1.4.1
function THppmenu2_Callback(hObject, eventdata, handles)

return


% #########################################################################
%       FUNCTION TO FIND ALL THE COMPO COMBINATIONS V1.6.4
function LesCombi = AllCombi(NbAna)
% This function compute all the combinations (vector) between different
% list of index of compositions. NbAna is just a vector with the number of
% compositions of each mineral.
%
% P. Lanari (2.08.13)

SystSize = length(NbAna);
Concat1 = '[';
Concat2 = '(';
Concat3 = '[';

for i=1:SystSize
    VariableName{i} = ['A',char(num2str(i))];
    eval([char(VariableName{i}),' = [1:NbAna(i)];']);
    
    Concat1 = [Concat1,'B',char(num2str(i)),','];
    Concat2 = [Concat2,char(VariableName{i}),','];
    
    Concat3 = [Concat3,'B',char(num2str(i)),'(:),'];
end

Concat1(end) = ']';
Concat2(end) = ')';
Concat3(end) = ']';

eval([Concat1,' = ndgrid',Concat2,';']);
eval(['LesCombi = ',Concat3,';']);
return


% #########################################################################
%       RENAME RESULT V1.4.1
function REbutton1_Callback(hObject, eventdata, handles)
Results = handles.results;
Onest = get(handles.REppmenu1,'Value') - 1; % 1 is none

if Onest
    CodeTxt = [14,2];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    % set(handles.TxtControl,'String',[char(handles.TxtDatabase(14).txt(2))]);
    
    Text = Results(Onest).method;
    Text = inputdlg({'new name'},'Name',1,Text);
    
    if ~length(Text)
        CodeTxt = [14,3];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        % set(handles.TxtControl,'String',[char(handles.TxtDatabase(14).txt(3))]);
        return
    end
    Results(Onest).method = Text;
    
    ListTher(1) = {'none'};
    for i=1:length(Results)
        ListTher(i+1) = Results(i).method;
    end
    set(handles.REppmenu1,'String',ListTher);
    
    handles.results = Results;
    CodeTxt = [14,4];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' (',char(Text),')']);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    %set(handles.TxtControl,'String',[char(handles.TxtDatabase(14).txt(4)),' (',char(Text),')']);
end

guidata(hObject,handles);
return


% #########################################################################
%       DELETE RESULT V1.4.1
function REbutton2_Callback(hObject, eventdata, handles)

Results = handles.results;


Onest = get(handles.REppmenu1,'Value') - 1;
if Onest < 1
    return
end

% ---------- Delete ----------
if Onest == 1
    for i=2:length(Results)
        NewResults(i-1) = Results(i);
    end
elseif Onest ==length(Results)
    for i=1:length(Results)-1
        NewResults(i) = Results(i);
    end
else
    for i=1:Onest-1
        NewResults(i) = Results(i);
    end
    for i=Onest+1:length(Results)
        NewResults(i-1) = Results(i);
    end
end

handles.results = NewResults;

ListTher(1) = {'none'};
for i=1:length(NewResults)
    ListTher(i+1) = NewResults(i).method;
end

set(handles.REppmenu1,'String',ListTher) % New list
set(handles.REppmenu1,'Value',2) % Lastresult

% Display
REppmenu1_Callback(hObject, eventdata, handles);

guidata(hObject,handles);
return


% #########################################################################
%       EXPORT RESULTS V1.4.1
function REbutton3_Callback(hObject, eventdata, handles)
% the folder: Export-Not-Saved

Onest = get(handles.REppmenu1,'Value') - 1;
if Onest < 1
    return
end

Results = handles.results; % good location
LaListe = Results((Onest)).labels;
OnExporte = [1:length(LaListe)];

CodeTxt = [14,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

OnExporte = listdlg('ListString',LaListe,'SelectionMode','multiple','InitialValue',OnExporte,'Name','Data to export');

if ~length(OnExporte)
    CodeTxt = [14,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

[Success,Message,MessageID] = mkdir('Exported-Results');

cd Exported-Results
[Directory, pathname] = uiputfile({'*.txt', 'TEXT File (*.txt)'}, 'Save results as');
cd ..

if ~Directory
    CodeTxt = [14,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

disp(['Export ... (RESULTS in ascii format) ...']);
disp(['Export ... (mineral: ',char(Results(Onest).mineral),') ...']);
disp(['Esport ... (method: ',char(Results(Onest).method),') ...']);
disp(['Export ... (reshape: ',num2str(Results(Onest).reshape(1)),'/',num2str(Results(Onest).reshape(2)),') ...']);

Compt = 1;
for i=1:length(Results(Onest).labels)
    if Compt <= length(OnExporte)
        if i == OnExporte(Compt)
            ForSave = strcat(pathname,Directory(1:end-4),'-',Results(Onest).labels(i),'.txt');
            
            LesRes = Results(Onest).values(:,i);
            LesRes = reshape(LesRes,Results(Onest).reshape(1),Results(Onest).reshape(2));
            
            save(char(ForSave),'LesRes','-ASCII');
            disp(['Export ... (',char(Results(Onest).labels(i)),' was saved [',char(ForSave),']) ...'])
            Compt = Compt+1;
        else
            disp(['Export ... (',char(Results(Onest).labels(i)),' has not been saved ** User Request **) ...'])
        end
    else
        disp(['Export ... (',char(Results(Onest).labels(i)),' has not been saved ** User Request **) ...'])
    end
end

disp(['Export ... (RESULTS in ascii format) ... Ok']);

NbExported = length(OnExporte);

if NbExported == 1
    CodeTxt = [14,6];
    set(handles.TxtControl,'String',[char(num2str(NbExported)),char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
else
    CodeTxt = [14,7];
    set(handles.TxtControl,'String',[char(num2str(NbExported)),char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
end

return


% #########################################################################
%       FILTER RESULT V1.5.1
function REbutton4_Callback(hObject, eventdata, handles)
Results = handles.results;
% Median filter
set(handles.FIGbutton1,'Value',0);

SelMin = str2num(get(handles.FilterMin,'String'));
SelMax = str2num(get(handles.FilterMax,'String'));

SelResult = get(handles.REppmenu1,'Value') - 1;
SelAff = get(handles.REppmenu2,'Value');

Answer = questdlg({['Do you want to generate a map *',[char(Results(SelResult).mineral),'_filter'],'* based on:'],[num2str(SelMin),' < ',char(Results(SelResult).labels(SelAff)),' > ',num2str(SelMax)]},'Yes')

switch Answer
    case 'Yes'
        
        Data4Filtre = Results(SelResult).values(:,SelAff);
        
        MaskSelected = zeros(length(Data4Filtre),1);
        LesGood = find(Data4Filtre >= SelMin & Data4Filtre <= SelMax);
        MaskSelected(LesGood) = ones(size(LesGood));
        
        % Update
        OuOk = length(Results)+1;
        Results(OuOk) = Results(SelResult);
        Results(OuOk).method = {[char(Results(OuOk).method),'_Filter']};
        
        
        for i=1:length(Results(OuOk).values(1,:)) % ielem
            Results(OuOk).values(:,i) = Results(OuOk).values(:,i).*MaskSelected;
        end
        
        % add in the main list
        ListTher(1) = {'none'};
        for i=1:length(Results)
            ListTher(i+1) = Results(i).method;
        end
        
        set(handles.REppmenu1,'String',ListTher);
        set(handles.REppmenu1,'Value',OuOk+1);
        
        handles.results = Results;
        guidata(hObject,handles);
        
        REppmenu1_Callback(hObject, eventdata, handles);
        
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        set(handles.axes1,'xtick',[], 'ytick',[]);
        GraphStyle(hObject, eventdata, handles)
        
    otherwise
        CodeTxt = [11,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
end


return


% #########################################################################
%       REMOVE A VARIABLE FROM RESULT  V1.6.5
function REbutton8_Callback(hObject, eventdata, handles)
Results = handles.results;

SelResult = get(handles.REppmenu1,'Value') - 1;
Vari2Remove = get(handles.REppmenu2,'Value');

NbVari = length(Results(SelResult).labels);

if isequal(Vari2Remove,1)
    Results(SelResult).values = Results(SelResult).values(:,2:end);
    Results(SelResult).labels = Results(SelResult).labels(2:end);
end

if isequal(Vari2Remove,NbVari)
    Results(SelResult).values = Results(SelResult).values(:,1:Vari2Remove-1);
    Results(SelResult).labels = Results(SelResult).labels(1:Vari2Remove-1);
end

if Vari2Remove > 1 && Vari2Remove < NbVari
    Results(SelResult).values = [Results(SelResult).values(:,1:Vari2Remove-1),Results(SelResult).values(:,Vari2Remove+1:end)];
    Results(SelResult).labels = [Results(SelResult).labels(1:Vari2Remove-1);Results(SelResult).labels(Vari2Remove+1:end)];
end


handles.results = Results;
guidata(hObject,handles);

REppmenu1_Callback(handles.REppmenu1, eventdata, handles);

guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);
set(handles.axes1,'xtick',[], 'ytick',[]);
GraphStyle(hObject, eventdata, handles);
return


% #########################################################################
%       RELATIVE MAP (PERCENTAGE AND ABSOLUTE) New 2.3.1
function REbutton9_Callback(hObject, eventdata, handles)
%
Results = handles.results;
SelRes = get(handles.REppmenu1,'Value') - 1; % 1 is none
SelVari = get(handles.REppmenu2,'Value');

CodeTxt = [14,14];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

axes(handles.axes1);
[a,b,clique] = XginputX(1,handles);
[aFig,bFig] = CoordinatesFromRef(a,b,handles);
if clique < 2
    h = [a,b];
    hold on
    plot(floor(aFig),floor(bFig),'o','MarkerFaceColor','w','MarkerEdgeColor','m');
else
    CodeTxt = [14,15];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

X = round(a);
Y = round(b);

TheMap = reshape(Results(SelRes).values(:,SelVari),Results(SelRes).reshape);
RefValue = TheMap(Y,X);

MapDiffRel = TheMap/RefValue;
MapDiffPer = (TheMap-RefValue)./RefValue*100;

% MapDiffPer = zeros(size(MapDiffRel));                       % changed 2.5.1
% WhereData = find(MapDiffRel > 0.000000001);
% MapDiffPer(WhereData) = (TheMap(WhereData)-RefValue)./RefValue*100;

% we generate a new result file
WhereNew = length(Results) + 1;

Results(WhereNew).coord = 0;
Results(WhereNew).type = 10;  % density
Results(WhereNew).method = {['REL_',char(Results(SelRes).method)]};
Results(WhereNew).labels = {'Diff_rel','Diff_per'};
Results(WhereNew).values = [MapDiffRel(:),MapDiffPer(:)];
Results(WhereNew).reshape = Results(SelRes).reshape;


% Update ...
handles.results = Results;

ListTher(1) = {'none'};
for i=1:length(Results)
    ListTher(i+1) = Results(i).method;
end

set(handles.REppmenu1,'String',ListTher) % New list
set(handles.REppmenu1,'Value',WhereNew+1) % Lastresult

% Display
REppmenu1_Callback(hObject, eventdata, handles);

guidata(hObject,handles);



CodeTxt = [14,16];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

return


% #########################################################################
%       MENU OF NEW VARIABLE COMBINATIONS New 2.3.1
function REppmenu3_Callback(hObject, eventdata, handles)
%

WhichOne = get(handles.REppmenu3,'Value');
set(handles.FieldVARI,'String',handles.ResultsVariables(WhichOne).code);

guidata(hObject,handles);

return


% #########################################################################
%       NEW VARI FIELD  New 2.3.1
function FieldVARI_Callback(hObject, eventdata, handles)
%

return


% #########################################################################
%       COMPUTE NEW VARIABLE FROM LIST  (v2.3.1)
function REbutton7_Callback(hObject, eventdata, handles)
Results = handles.results;

SelResult = get(handles.REppmenu1,'Value') - 1;
SelAff = get(handles.REppmenu2,'Value');

ListAff = get(handles.REppmenu2,'String');

CodeTxt = [14,12];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

WhichOne = get(handles.REppmenu3,'Value');
DefName = handles.ResultsVariables(WhichOne).name;
DefCode = handles.ResultsVariables(WhichOne).code;

prompt={'<1> Enter the new variable name','<2> Enter the MATLAB code (using ./ and .* and .^)                    .'};
name='Create a new variable';
numlines=1;
defaultanswer={DefName,DefCode};

options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='none';

Theanswer=inputdlg(prompt,name,numlines,defaultanswer,options);

VarName = Theanswer{1};
ElCode4Display = Theanswer{2};

TheElement4DisplayClean = ElCode4Display;
TheLetters = isstrprop(TheElement4DisplayClean,'alpha')+isstrprop(TheElement4DisplayClean,'digit');   % alpha + digit

for i=1:length(TheElement4DisplayClean)
    if isequal(TheElement4DisplayClean(i),'_')         % _ is widely used in the names
        TheLetters(i) = 1;
    end
end

for i=1:length(TheLetters)
    if ~TheLetters(i)
        TheElement4DisplayClean(i) = ' ';
    end
end

TheElementsInCode = strread(TheElement4DisplayClean,'%s');

[Ok,Ou] = ismember(TheElementsInCode,ListAff);

% We change Ok for the Digits number which are not tested (see after).
for i=1:length(Ok)
    if ~Ok(i)
        ThisOne = TheElementsInCode{i};
        TheDigits = isstrprop(ThisOne,'digit');
        
        if sum(TheDigits) == length(TheDigits)
            Ok(i) = 1;
        end
    end
end

if sum(Ok) ~= length(Ok)
    warndlg({'Element display Error. No corresponding map for the following elements:',char(TheElementsInCode{find(abs(Ok-1))})},'Warning');
    
    CodeTxt = [14,13];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    return
end

% If the variable name starts with a number, add p_
ElCode4DisplayUpdated = ElCode4Display;
for i=1:length(TheElementsInCode)
    ElCode = TheElementsInCode{i};
    if isstrprop(ElCode(1),'digit')
        ElCodeUpdated = ['p_',ElCode];
        
        % Find the position in ElCode4Display
        [lia locb] = ismember(ElCode4DisplayUpdated,ElCode);
        WhereOnes = find(locb==1);
        % Check them one by one ...
        for i=1:length(WhereOnes)
            if WhereOnes(i)+length(ElCode)-1 <= length(locb)
                for j=2:length(ElCode)
                    if ~isequal(locb(WhereOnes(i)+j-1),j)
                        break
                    else
                        if j == length(ElCode)
                            Found = WhereOnes(i);
                        end
                    end
                end
            end
        end
        
        Part1 = ElCode4DisplayUpdated(1:Found-1);
        Part2 = ElCode4DisplayUpdated(Found:end);
        
        ElCode4DisplayUpdated = [Part1,'p_',Part2];
    end
end

set(gcf, 'WindowButtonMotionFcn', '');

% Prepare the element variables run ElCode4Display
for i = 1:length(ListAff)
    ElName = char(ListAff{i});
    if isstrprop(ElName(1),'digit')
        ElName = ['p_',ElName];
    end
    eval([ElName,' = reshape(Results(SelResult).values(:,i),Results(SelResult).reshape(1),Results(SelResult).reshape(2));']);
end

TheCodeToEval = ['TheNewVariable = ',char(ElCode4DisplayUpdated),';'];


disp(['-> Create a new variable (',VarName,')'])
disp(['   Eval: ',TheCodeToEval]);
disp(' ')

eval(TheCodeToEval);

% We replace the NAN by 0
for i=1:length(TheNewVariable(:))
    if isnan(TheNewVariable(i))
        TheNewVariable(i) = 0;
    end
    if isinf(TheNewVariable(i))
        TheNewVariable(i) = 0;
    end
end

set(gcf, 'WindowButtonMotionFcn', @mouseMove);

% Update
Where = size(Results(SelResult).values,2) + 1;

Results(SelResult).values(:,Where) = TheNewVariable(:);
Results(SelResult).labels{Where} = VarName;

set(handles.REppmenu2,'String',Results(SelResult).labels);
set(handles.REppmenu2,'Value',Where);

handles.results = Results;
guidata(hObject,handles);


%REppmenu1_Callback(handles.REppmenu1, eventdata, handles);
% this doesn't work and I don't know why !!!
% The first variable is automatically selected. Impossible to change.

Onest = get(handles.REppmenu1,'Value') - 1; % 1 is none$
if Onest == 0
    return
end
Onaff = get(handles.REppmenu2,'Value');

ListResult = get(handles.REppmenu1,'String');
ListDispl = get(handles.REppmenu2,'String');

CodeTxt = [3,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' - ',char(ListResult(Onest+1)),' - ',char(ListDispl(Onaff))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

%set(handles.TxtControl,'String',[char(handles.TxtDatabase(3).txt(3)),' - ',char(ListResult(Onest+1)),' - ',char(ListDispl(Onaff))]);

AAfficher = reshape(Results(Onest).values(:,Onaff),Results(Onest).reshape(1),Results(Onest).reshape(2));

cla(handles.axes1,'reset');
axes(handles.axes1)
imagesc(XimrotateX(AAfficher,handles.rotateFig)), axis image, colorbar('peer',handles.axes1,'vertical')
handles = XMapColorbar('Auto',1,handles);
set(handles.axes1,'xtick',[], 'ytick',[]);

zoom on                                                         % New 1.6.2

handles.HistogramMode = 0;
handles.AutoContrastActiv = 0;
handles.MedianFilterActiv = 0;
%cla(handles.axes2);
%axes(handles.axes2), hist(AAfficher(find(AAfficher(:) ~= 0)),30)

Min = min(AAfficher(find(AAfficher(:) > 0)));
Max = max(AAfficher(:));

if length(Min) < 1
    Min = Max;
end

set(handles.ColorMin,'String',Min);
set(handles.ColorMax,'String',Max);
set(handles.FilterMin,'String',Min);
set(handles.FilterMax,'String',Max);

% Value = get(handles.checkbox1,'Value');

% Attention, les 4 lignes suivantes font des lags sur ma version.

axes(handles.axes1);
if Max > Min
    caxis([Min,Max]);
end

% if Value == 1
%     colormap([0,0,0;jet(64)])
% else
% 	colormap([jet(64)])
% end




guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)
set(handles.axes1,'xtick',[], 'ytick',[]);
GraphStyle(hObject, eventdata, handles)
return


% #########################################################################
%       MERGE RESULTS  (v2.6.4)
function REbutton10_Callback(hObject, eventdata, handles)
% 

Results = handles.results;
Where2Write = length(Results)+1;

ResList = get(handles.REppmenu1,'String');
ResList = ResList(2:end);

CodeTxt = [14,17];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

[Selected,OK] = listdlg('ListString',ResList,'SelectionMode','Multiple','Name','XMapTools');

if ~OK
    CodeTxt = [14,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

if length(Selected) < 2
    CodeTxt = [14,18];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
end

% Check Size
for i = 1:length(Selected)
    ListMaps{i} = char(Results(Selected(i)).method);
    SizeRes(i,:) = Results(Selected(i)).reshape;
end

for i = 2:length(SizeRes)
    if ~isequal(SizeRes(i,:),SizeRes(1,:))
        CodeTxt = [19,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),char(ListMaps{i})]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

        waitfor(errordlg(['At least one map has a different size (check the size of ',ListMaps{i},')'],'XMapTools'));
        return
    end
end


TheNewResult.coord = 0;
TheNewResult.type = 1;
TheNewResult.mineral = 'Merged_Result';
TheNewResult.method = {'Merged_Result'};
TheNewResult.labels = '';
TheNewResult.values = [];
TheNewResult.reshape = Results(Selected(1)).reshape;

Labels = {};
Values = [];
Compt = 0; 
for i = 1:length(Selected)
    TheResult = Results(Selected(i));
    for j = 1:length(TheResult.labels)
        Compt = Compt +1;
        Labels{Compt} = [char(TheResult.method),'_',char(TheResult.labels{j})];
        Values(:,Compt) = TheResult.values(:,j);
    end
end

TheNewResult.labels = Labels';
TheNewResult.values = Values;
    
Results(Where2Write) = TheNewResult;

LabelMenu{1} = 'none';
for i = 1:length(Results)
    LabelMenu{i+1} = char(Results(i).method);
end

set(handles.REppmenu1,'String',LabelMenu,'Value',length(Results)+1);

handles.results = Results;
guidata(hObject,handles);

REppmenu1_Callback(hObject, eventdata, handles);
return





% -------------------------------------------------------------------------
% 7) CHEMICAL MODULES
% -------------------------------------------------------------------------



% #########################################################################
%       BINARY CALL v2.1.1
function Module_Chem2D_Callback(hObject, eventdata, handles)
%

if get(handles.OPT1,'Value')
    
    MapsLabel = get(handles.PPMenu1,'String');
    MapsReshape = size(handles.data.map(get(handles.PPMenu1,'Value')).values);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    if get(handles.PPMenu2,'Value') > 1
        AllMask = handles.MaskFile(get(handles.PPMenu3,'Value')).Mask;
        TheMask = zeros(MapsReshape);
        
        TheMask(find(AllMask == get(handles.PPMenu2,'Value')-1)) = ones(length(find(AllMask == get(handles.PPMenu2,'Value')-1)),1);
        
    else
        TheMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.data.map(i).values(:).*TheMask(:).*BRCMask(:);
    end
end

if get(handles.OPT2,'Value')
    
    MapsLabel = handles.quanti(get(handles.QUppmenu2,'Value')).listname;
    MapsReshape = size(handles.quanti(get(handles.QUppmenu2,'Value')).elem(get(handles.QUppmenu1,'Value')).quanti);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.quanti(get(handles.QUppmenu2,'Value')).elem(i).quanti(:).*BRCMask(:);
    end
    
end


if get(handles.OPT3,'Value')
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    if Onest < 1
        warndlg('No result selected')
        return
    end
    
    MapsLabel = Results(Onest).labels;
    MapsReshape = Results(Onest).reshape;
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    NbVar = length(Results(Onest).labels);
    for i = 1:NbVar
        Export(:,i) = Results(Onest).values(:,i).*BRCMask(:);
    end
    %Export = Results(Onest).values;
    
    
    
end

PositionXMapTools = get(gcf,'Position');

Seq = 'XMTModBinary(';
for i=1:NbVar
    Seq = strcat(Seq,'Export(:,',num2str(i),'),');
end
Seq = strcat(Seq,'MapsLabel,MapsReshape,PositionXMapTools);');

eval(Seq);

return


% #########################################################################
%       TRIPLOT CALL V2.1.1
function Module_TriPlot3D_Callback(hObject, eventdata, handles)
%
if get(handles.OPT1,'Value')
    
    MapsLabel = get(handles.PPMenu1,'String');
    MapsReshape = size(handles.data.map(get(handles.PPMenu1,'Value')).values);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    if get(handles.PPMenu2,'Value') > 1
        AllMask = handles.MaskFile(get(handles.PPMenu3,'Value')).Mask;
        TheMask = zeros(MapsReshape);
        
        TheMask(find(AllMask == get(handles.PPMenu2,'Value')-1)) = ones(length(find(AllMask == get(handles.PPMenu2,'Value')-1)),1);
        
    else
        TheMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.data.map(i).values(:).*TheMask(:).*BRCMask(:);
    end
end

if get(handles.OPT2,'Value')
    
    MapsLabel = handles.quanti(get(handles.QUppmenu2,'Value')).listname;
    MapsReshape = size(handles.quanti(get(handles.QUppmenu2,'Value')).elem(get(handles.QUppmenu1,'Value')).quanti);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.quanti(get(handles.QUppmenu2,'Value')).elem(i).quanti(:).*BRCMask(:);
    end
    
end


if get(handles.OPT3,'Value')
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    if Onest < 1
        warndlg('No result selected')
        return
    end
    
    MapsLabel = Results(Onest).labels;
    MapsReshape = Results(Onest).reshape;
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    NbVar = length(Results(Onest).labels);
    for i = 1:NbVar
        Export(:,i) = Results(Onest).values(:,i).*BRCMask(:);
    end
    %Export = Results(Onest).values;
    
end

PositionXMapTools = get(gcf,'Position');

Seq = 'XMTModTriPlot(';
for i=1:NbVar
    Seq = strcat(Seq,'Export(:,',num2str(i),'),');
end
Seq = strcat(Seq,'MapsLabel,MapsReshape,PositionXMapTools);');

eval(Seq);

%keyboard
% Results = handles.results;
%
% Onest = get(handles.REppmenu1,'Value') - 1;
% if Onest < 1
%     warndlg('No result selected')
%     return
% end
%
%
% Export = Results(Onest).values;
% NbVar = length(Results(Onest).labels);
%
% Seq = 'XMTModTriPlot(';
%
% for i=1:NbVar
%     Seq = strcat(Seq,'Export(:,',num2str(i),'),');
% end
%
% Seq = strcat(Seq,'Results(Onest).labels,Results(Onest).reshape);');
%
% eval(Seq);

return


% #########################################################################
%       RGB CALL v2.3.1
function Module_RGB_Callback(hObject, eventdata, handles)
%

if get(handles.OPT1,'Value')
    
    MapsLabel = get(handles.PPMenu1,'String');
    MapsReshape = size(handles.data.map(get(handles.PPMenu1,'Value')).values);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    if get(handles.PPMenu2,'Value') > 1
        AllMask = handles.MaskFile(get(handles.PPMenu3,'Value')).Mask;
        TheMask = zeros(MapsReshape);
        
        TheMask(find(AllMask == get(handles.PPMenu2,'Value')-1)) = ones(length(find(AllMask == get(handles.PPMenu2,'Value')-1)),1);
        
    else
        TheMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.data.map(i).values(:).*TheMask(:).*BRCMask(:);
    end
end

if get(handles.OPT2,'Value')
    
    MapsLabel = handles.quanti(get(handles.QUppmenu2,'Value')).listname;
    MapsReshape = size(handles.quanti(get(handles.QUppmenu2,'Value')).elem(get(handles.QUppmenu1,'Value')).quanti);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.quanti(get(handles.QUppmenu2,'Value')).elem(i).quanti(:).*BRCMask(:);
    end
    
end


if get(handles.OPT3,'Value')
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    if Onest < 1
        warndlg('No result selected')
        return
    end
    
    MapsLabel = Results(Onest).labels;
    MapsReshape = Results(Onest).reshape;
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    NbVar = length(Results(Onest).labels);
    for i = 1:NbVar
        Export(:,i) = Results(Onest).values(:,i).*BRCMask(:);
    end
    %Export = Results(Onest).values;
end

PositionXMapTools = get(gcf,'Position');

Seq = 'XMTModRGB(';
for i=1:NbVar
    Seq = strcat(Seq,'Export(:,',num2str(i),'),');
end
Seq = strcat(Seq,'MapsLabel,MapsReshape,handles.LocBase,PositionXMapTools);');

eval(Seq);

return


% #########################################################################
%       GENERATOR CALL (new 2.5.1)
function Module_Generator_Callback(hObject, eventdata, handles)
%

zoom off
handles.CorrectionMode = 1;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles);


GeneratorVariables = handles.GeneratorVariables;

if get(handles.OPT1,'Value')
    
    MapsLabel = get(handles.PPMenu1,'String');
    MapsReshape = size(handles.data.map(get(handles.PPMenu1,'Value')).values);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    if get(handles.PPMenu2,'Value') > 1
        AllMask = handles.MaskFile(get(handles.PPMenu3,'Value')).Mask;
        TheMask = zeros(MapsReshape);
        
        TheMask(find(AllMask == get(handles.PPMenu2,'Value')-1)) = ones(length(find(AllMask == get(handles.PPMenu2,'Value')-1)),1);
        
    else
        TheMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        %Export(:,i) = handles.data.map(i).values(:).*TheMask(:).*BRCMask(:);
        Export(i).map = handles.data.map(i).values.*TheMask.*BRCMask;
    end
end

if get(handles.OPT2,'Value')
    
    Message = questdlg({'Are you working with a duplicated Quanti file?','If you generate new variables, it may not be possible anymore to merge the maps. Keep in mind that variables cannot be deleted in Quanti'},'','Yes (Continue)','No (Cancel)','Yes (Continue)');
    
    if ~length(Message)
        CodeTxt = [10,4];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
        zoom on
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
    
    switch Message
        case 'No (Cancel)'
            CodeTxt = [10,4];
            set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
            TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
            
            zoom on
            handles.CorrectionMode = 0;
            guidata(hObject,handles);
            OnEstOu(hObject, eventdata, handles)
            return
    end
    
    MapsLabel = handles.quanti(get(handles.QUppmenu2,'Value')).listname;
    MapsReshape = size(handles.quanti(get(handles.QUppmenu2,'Value')).elem(get(handles.QUppmenu1,'Value')).quanti);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        %Export(:,i) = handles.quanti(get(handles.QUppmenu2,'Value')).elem(i).quanti(:).*BRCMask(:);
        Export(i).map = handles.quanti(get(handles.QUppmenu2,'Value')).elem(i).quanti.*BRCMask;
    end
    
end


if get(handles.OPT3,'Value')
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    if Onest < 1
        warndlg('No result selected')
        
        zoom on
        handles.CorrectionMode = 0;
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles)
        return
    end
    
    MapsLabel = Results(Onest).labels;
    MapsReshape = Results(Onest).reshape;
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    NbVar = length(Results(Onest).labels);
    for i = 1:NbVar
        %Export(:,i) = Results(Onest).values(:,i).*BRCMask(:);
        Export(i).map = reshape(Results(Onest).values(:,i),MapsReshape).*BRCMask;
    end
    %Export = Results(Onest).values;
end

PositionXMapTools = get(gcf,'Position');

Seq = 'Output = XMTModGenerator(Export,MapsLabel,MapsReshape,GeneratorVariables,handles.LocBase,handles.activecolorbar,PositionXMapTools);';
% for i=1:NbVar
%     Seq = strcat(Seq,'Export(:,',num2str(i),'),');
% end
% Seq = strcat(Seq,'MapsLabel,MapsReshape,handles.LocBase,PositionXMapTools);');

eval(Seq);

if isequal(Output,0)
    CodeTxt = [16,3];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    zoom on
    handles.CorrectionMode = 0;
    guidata(hObject,handles);
    OnEstOu(hObject, eventdata, handles)
    return
end

if get(handles.OPT1,'Value')
    
    Data = handles.data;
    Where = length(Data.map)+1;
    
    Compt = 0;
    ConcatF = '';
    
    for i = 1:length(Output)
        switch Output(i).type
            case 'output'
                Compt = Compt+1;
                
                Data.map(Where).type = 5;                   % Generated Map
                Data.map(Where).name = Output(i).label;
                Data.map(Where).values = Output(i).values;
                Data.map(Where).ref = 0;
                Data.map(Where).corr = [mean(Output(i).values(:))];
                
                Where = Where+1;
                ConcatF = [ConcatF,Output(i).label,', '];
        end
    end
    
    if Compt
        % Update LIST for display
        Compt = 1;
        for i=1:length(Data.map(:))
            if Data.map(i).type > 0
                ListMap{Compt} = char(Data.map(i).name);
                Compt = Compt + 1;
            end
        end

        set(handles.PPMenu1,'string',ListMap);
        set(handles.PPMenu1,'Value',Where-1) 

        handles.data = Data; % send
        handles.ListMap = ListMap;

        % PLOT
        guidata(hObject,handles);
        PPMenu1_Callback(hObject, eventdata, handles);

        GraphStyle(hObject, eventdata, handles)
        guidata(hObject,handles);
        OnEstOu(hObject, eventdata, handles);
        
        CodeTxt = [16,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(ConcatF(1:end-2))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
    else
        CodeTxt = [16,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles); 
    end
end


if get(handles.OPT2,'Value')
    
    Quanti = handles.quanti;
    Where = get(handles.QUppmenu2,'Value');
    WhereMap = length(Quanti(Where).elem)+1;
    
    Compt = 0;
    ConcatF = '';
    
    %keyboard 
    
    for i = 1:length(Output)
        switch Output(i).type
            case 'output'
                Compt = Compt+1; 
                
                Quanti(Where).listname{WhereMap} = char(Output(i).label);
                
                Quanti(Where).elem(WhereMap).name = char(Output(i).label);
                Quanti(Where).elem(WhereMap).quanti = Output(i).values;
                
                WhereMap = WhereMap+1;
                ConcatF = [ConcatF,Output(i).label,', '];
        end
    end
    
    if Compt
        % Update the list for display
        set(handles.QUppmenu1,'String',Quanti(Where).listname);
        set(handles.QUppmenu1,'Value',WhereMap-1)
        
        handles.quanti = Quanti;
        
        guidata(hObject,handles);
        QUppmenu1_Callback(hObject, eventdata, handles)
        
        CodeTxt = [16,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(ConcatF(1:end-2))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
    else
        
        CodeTxt = [16,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles); 
        
    end
    
    
end


if get(handles.OPT3,'Value')
    
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    
    WhereMap = length(Results(Onest).labels)+1;
    
    
    Compt = 0;
    ConcatF = '';
    
    %keyboard 
    
    for i = 1:length(Output)
        switch Output(i).type
            case 'output'
                Compt = Compt+1; 
                
                Results(Onest).labels{WhereMap} = char(Output(i).label);
                Results(Onest).values(:,WhereMap) = Output(i).values(:);
                
                WhereMap = WhereMap+1;
                ConcatF = [ConcatF,Output(i).label,', '];
        end
    end
    
    if Compt
        % Update the list for display
        set(handles.REppmenu2,'String',Results(Onest).labels);
        set(handles.REppmenu2,'Value',WhereMap-1)
        
        handles.results = Results;
        
        guidata(hObject,handles); 
        REppmenu2_Callback(hObject, eventdata, handles)
        
        CodeTxt = [16,1];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2))),' ',char(ConcatF(1:end-2))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        
    else
        
        CodeTxt = [16,2];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles); 
        
    end
    
    
end

%keyboard

zoom on
handles.CorrectionMode = 0;
guidata(hObject,handles);
OnEstOu(hObject, eventdata, handles)
return


% #########################################################################
%       SPIDER CALL v3.1.2
function Module_Spider_Callback(hObject, eventdata, handles)
%

% --------------------
% Spider List setting:
handles = ReadSpiderFileNORM(handles);


% -------------
% SpiderColors: 
handles = ReadSpiderFileCOLORS(handles);
disp(' ')




if get(handles.OPT1,'Value')
    
    %SelectedMap = get(handles.PPMenu1,'Value');
    ListMaps = get(handles.PPMenu1,'String');
    
    SelectedPhase = get(handles.PPMenu2,'Value');
    
    DataAll = handles.data;
    MaskFile = handles.MaskFile;
    
    MaskSelected = get(handles.PPMenu3,'Value');
    
    MapsLabel = ListMaps;
    MapsReshape = size(DataAll.map(1).values);
    
    NbVar = length(ListMaps);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i = 1:NbVar
        if SelectedPhase > 1
            AAfficher = MaskFile(MaskSelected).Mask == SelectedPhase-1;
        else
            AAfficher = ones(MapsReshape);
        end
        Export(:,i) = DataAll.map(i).values(:) .* AAfficher(:) .*BRCMask(:);
    end    
end

if get(handles.OPT2,'Value')
    SelectedMap = get(handles.QUppmenu1,'Value');
    ListMaps = get(handles.QUppmenu1,'String');
    
    SelectedQuanti = get(handles.QUppmenu2,'Value');
    
    QuantiAll = handles.quanti;
    
    MapsLabel = ListMaps;
    MapsReshape = size(QuantiAll(SelectedQuanti).elem(SelectedMap).quanti);
    
    NbVar = length(ListMaps);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i = 1:NbVar
        Export(:,i) = QuantiAll(SelectedQuanti).elem(i).quanti(:) .*BRCMask(:);
    end
    
end

if get(handles.OPT3,'Value')
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    if Onest < 1
        warndlg('No result selected')
        return
    end
    
    MapsLabel = Results(Onest).labels;
    MapsReshape = Results(Onest).reshape;
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    NbVar = length(Results(Onest).labels);
    for i = 1:NbVar
        Export(:,i) = Results(Onest).values(:,i).*BRCMask(:);
    end
    %Export = Results(Onest).values;
end

PositionXMapTools = get(gcf,'Position');

Seq = 'XMTModSpider(';
for i=1:NbVar
    Seq = strcat(Seq,'Export(:,',num2str(i),'),');
end
Seq = strcat(Seq,'MapsLabel,MapsReshape,handles.LocBase,handles.SpiderData,handles.SpiderColorData,handles.activecolorbar,PositionXMapTools);');

eval(Seq);

return




% -------------------------------------------------------------------------
% 8) ADD-ONS
% -------------------------------------------------------------------------


% #########################################################################
%       RUN AN ADD-ON (v 3.2.1)
function Button_AddonRun_Callback(hObject, eventdata, handles)
%

set(gcf, 'WindowButtonMotionFcn', '');

% Create info:
if get(handles.OPT1,'Value')
    Infos.Mode = 1;
elseif get(handles.OPT2,'Value')
    Infos.Mode = 2;
else
    Infos.Mode = 3;
end

Infos.Xray.ListMaps = get(handles.PPMenu1,'String');
Infos.Xray.SelectedMap = get(handles.PPMenu1,'Value');
Infos.Xray.ListPhases = get(handles.PPMenu2,'String');
Infos.Xray.SelectedPhase = get(handles.PPMenu2,'Value');
Infos.Xray.ListMaskFiles = get(handles.PPMenu3,'String');
Infos.Xray.SelectedMaskFile = get(handles.PPMenu3,'Value');

Infos.Quanti.ListQuantis = get(handles.QUppmenu2,'String');
Infos.Quanti.SelectedQuanti = get(handles.QUppmenu2,'Value');
Infos.Quanti.ListElems = get(handles.QUppmenu1,'String');
Infos.Quanti.SelectedElem = get(handles.QUppmenu1,'Value');

Infos.Result.ListResults = get(handles.REppmenu1,'String');
Infos.Result.SelectedResult = get(handles.REppmenu1,'Value');
Infos.Result.ListElems = get(handles.REppmenu2,'String');
Infos.Result.SelectedElem = get(handles.REppmenu2,'Value');

% Prepare the data:
RawData = handles.data;
MaskFile = handles.MaskFile;
Quanti = handles.quanti;
Results = handles.results;
ColorMap = handles.activecolorbar;

% Send the data:
SelectedAddon = get(handles.Menu_AddonsList,'Value');
Name = handles.Addons(SelectedAddon).name;

% Add add-on to path (otherwise the path does not exist in case of update)
addpath([handles.LocBase(1:end-7),'Addons/',Name]);

% Check the installation:
eval(['Valid = ',Name,'_Install(handles.Addons(SelectedAddon).path);']);

if Valid
    % Check for updates (new 3.2.1):
    
    clear([Name,'_Update']);   % clear first the function (in case of already updated)...
    
    eval(['UpdateState = ',Name,'_Update(handles.Addons(SelectedAddon).path);']);
    
    % Output varibale "UpdateState":
    %   [-1]        No update system                        Continue
    %   [0]         Server cannot be reached                Continue
    %   [1]         This add-on is up-to-date               Continue
    %   [2]         An update has been installed            Call again
    %   [3]         An update is available but skiped       Stop
    %   [4]         An update is available but skiped       Continue
    %   [5]         Abord the call                          Stop

    switch UpdateState
        case 5
            return
        
        case 3
            warndlg({['You decided to skip a mandatory update. Consequently, ',Name,' cannot be used.']},'Warning');
            return
            
        case 2
            
            path(path);
            
            % try to run again the add-on:
            Button_AddonRun_Callback(hObject, eventdata, handles);
            return
    end
    
    
    
    % Run the add-on:
    eval([Name,'(Infos,RawData,MaskFile,Quanti,Results,ColorMap);']);
else
    warndlg({'The add-on is not correctly installed and cannot be called by XMapTools'},'Warning');
end

return




% -------------------------------------------------------------------------
% 9) ADVANCED-USER FONCTIONS
% -------------------------------------------------------------------------


% #########################################################################
%       DEBUG MODE V1.4.1
function DebugMode_Callback(hObject, eventdata, handles)
%
% ButtonSettings_Callback(hObject, eventdata, handles)
% Not anymore used (I moved this button to the admin window)

disp(' ')
disp('- XMapTools [ADMIN] - ')
disp('Debug mode in the command windows')
disp('All variables are saved into the global variable handles')
disp('Use "return" to exit (handles variables will be updated');
disp(' ')


keyboard


guidata(hObject,handles);
return





% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%                           MATLAB-LIKE FUNCTIONS
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


% #########################################################################
%       IS FIELD RESULT (for loading function)  (V1.6.2)
function isFieldResult = myIsField (inStruct, fieldName)
% inStruct is the name of the structure or an array of structures to search
% fieldName is the name of the field for which the function searches
isFieldResult = 0;
f = fieldnames(inStruct(1));
for i=1:length(f)
    if(strcmp(f{i},strtrim(fieldName)))
        isFieldResult = 1;
        return;
    elseif isstruct(inStruct(1).(f{i}))
        isFieldResult = myIsField(inStruct(1).(f{i}), fieldName);
        if isFieldResult
            return;
        end
    end
end


% #########################################################################
%       XginputX function  (V1.6.2)
function [out1,out2,out3] = XginputX(arg1,handles)
%XginputX Graphical input from mouse for VER_XMapTools_804
%   [X,Y] = XGINPUT(N) gets N points from the current axes and returns
%   the X- and Y-coordinates in the REF system (without rotate).
%
%   P. Lanari (20.03.2013)

out1 = []; out2 = []; out3 = []; y = [];
c = computer;
if ~strcmp(c(1:2),'PC')
    tp = get(0,'TerminalProtocol');
else
    tp = 'micro';
end

if ~strcmp(tp,'none') && ~strcmp(tp,'x') && ~strcmp(tp,'micro'),
    if nargout == 1,
        if nargin == 1,
            out1 = trmginput(arg1);
        else
            out1 = trmginput;
        end
    elseif nargout == 2 || nargout == 0,
        if nargin == 1,
            [out1,out2] = trmginput(arg1);
        else
            [out1,out2] = trmginput;
        end
        if  nargout == 0
            out1 = [ out1 out2 ];
        end
    elseif nargout == 3,
        if nargin == 1,
            [out1,out2,out3] = trmginput(arg1);
        else
            [out1,out2,out3] = trmginput;
        end
    end
else
    
    % Update Lanari (11:2012)
    %set(handles.TxtSelection,'String', 'selection on');
    %set(handles.TxtSelection,'ForegroundColor', [1 0 0]);
    
    fig = gcf;
    figure(gcf);
    
    
    if nargin == 0
        how_many = -1;
        b = [];
    else
        how_many = arg1;
        b = [];
        if  ischar(how_many) ...
                || size(how_many,1) ~= 1 || size(how_many,2) ~= 1 ...
                || ~(fix(how_many) == how_many) ...
                || how_many < 0
            error('MATLAB:ginput:NeedPositiveInt', 'Requires a positive integer.')
        end
        if how_many == 0
            ptr_fig = 0;
            while(ptr_fig ~= fig)
                ptr_fig = get(0,'PointerWindow');
            end
            scrn_pt = get(0,'PointerLocation');
            loc = get(fig,'Position');
            pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
            out1 = pt(1); y = pt(2);
        elseif how_many < 0
            error('MATLAB:ginput:InvalidArgument', 'Argument must be a positive integer.')
        end
    end
    
    
    %keyboard
    
    
    % Suspend figure functions
    state = uisuspend(fig);
    
    
    % Display coordinates new 1.5.4 (11/2012)
    axes(handles.axes1);
    set(gcf, 'WindowButtonMotionFcn', @mouseMOVEginput);
    
    
    toolbar = findobj(allchild(fig),'flat','Type','uitoolbar');
    if ~isempty(toolbar)
        ptButtons = [uigettool(toolbar,'Plottools.PlottoolsOff'), ...
            uigettool(toolbar,'Plottools.PlottoolsOn')];
        ptState = get (ptButtons,'Enable');
        set (ptButtons,'Enable','off');
    end
    
    %axes(handles.axes1);
    set(fig,'pointer','cross');
    fig_units = get(fig,'units');
    char = 0;
    
    % We need to pump the event queue on unix
    % before calling WAITFORBUTTONPRESS
    drawnow
    
    
    while how_many ~= 0
        
        % Use no-side effect WAITFORBUTTONPRESS
        waserr = 0;
        try
            keydown = wfbp;
        catch
            waserr = 1;
        end
        if(waserr == 1)
            if(ishghandle(fig))
                set(fig,'units',fig_units);
                uirestore(state);
                error('MATLAB:ginput:Interrupted', 'Interrupted');
            else
                error('MATLAB:ginput:FigureDeletionPause', 'Interrupted by figure deletion');
            end
        end
        % g467403 - ginput failed to discern clicks/keypresses on the figure it was
        % registered to operate on and any other open figures whose handle
        % visibility were set to off
        figchildren = allchild(0);
        if ~isempty(figchildren)
            ptr_fig = figchildren(1);
        else
            error('MATLAB:ginput:FigureUnavailable','No figure available to process a mouse/key event');
        end
        %         old code -> ptr_fig = get(0,'CurrentFigure'); Fails when the
        %         clicked figure has handlevisibility set to callback
        
        if(ptr_fig == fig)
            if keydown
                char = get(fig, 'CurrentCharacter');
                button = abs(get(fig, 'CurrentCharacter'));
                scrn_pt = get(0, 'PointerLocation');
                set(fig,'units','pixels')
                loc = get(fig, 'Position');
                % We need to compensate for an off-by-one error:
                pt = [scrn_pt(1) - loc(1) + 1, scrn_pt(2) - loc(2) + 1];
                set(fig,'CurrentPoint',pt);
            else
                button = get(fig, 'SelectionType');
                if strcmp(button,'open')
                    button = 1;
                elseif strcmp(button,'normal')
                    button = 1;
                elseif strcmp(button,'extend')
                    button = 2;
                elseif strcmp(button,'alt')
                    button = 3;
                else
                    error('MATLAB:ginput:InvalidSelection', 'Invalid mouse selection.')
                end
            end
            pt = get(gca, 'CurrentPoint');
            
            how_many = how_many - 1;
            
            if(char == 13) % & how_many ~= 0)
                % if the return key was pressed, char will == 13,
                % and that's our signal to break out of here whether
                % or not we have collected all the requested data
                % points.
                % If this was an early breakout, don't include
                % the <Return> key info in the return arrays.
                % We will no longer count it if it's the last input.
                break;
            end
            
            out1 = [out1;pt(1,1)];
            y = [y;pt(1,2)];
            b = [b;button];
        end
    end
    
    uirestore(state);
    if ~isempty(toolbar) && ~isempty(ptButtons)
        set (ptButtons(1),'Enable',ptState{1});
        set (ptButtons(2),'Enable',ptState{2});
    end
    set(fig,'units',fig_units);
    
    if nargout > 1
        out2 = y;
        if nargout > 2
            out3 = b;
        end
    else
        out1 = [out1 y];
    end
    
    
    % The folowing seems to work
    
    
    laSize = size(XimrotateX(handles.data.map(1).values,handles.rotateFig));
    
    lesX = [0 laSize(2)]; %get(handles.axes1,'XLim');
    lesY = [0 laSize(1)]; %get(handles.axes1,'YLim');
    
    xLength = lesX(2)-lesX(1);
    yLength = lesY(2)-lesY(1);
    
    
    switch handles.rotateFig
        
        case 0
            xFor = out1;
            yFor = out2;
            
            out1 = xFor;
            out2 = yFor;
            
            %set(handles.text47, 'string', round(C(1,1))); %abscisse
            %set(handles.text48, 'string', round(C(1,2))); %ordonn?e
            
        case 90
            xFor = out1;
            yFor = out2;
            
            out1 = yLength - yFor;
            out2 = xFor;
            
            %set(handles.text47, 'string', round(yLength - C(1,2))); %abscisse
            %set(handles.text48, 'string', round(C(1,1))); %ordonn?e
            
        case 180
            xFor = out1;
            yFor = out2;
            
            out1 = xLength - xFor;
            out2 = yLength - yFor;
            
            %set(handles.text47, 'string', round(xLength - C(1,1))); %abscisse
            %set(handles.text48, 'string', round(yLength - C(1,2))); %ordonn?e
            
            
        case 270
            xFor = out1;
            yFor = out2;
            
            out1 = yFor;
            out2 = xLength - xFor;
            
            %set(handles.text47, 'string', round(C(1,2))); %abscisse
            %set(handles.text48, 'string', round(xLength - C(1,1))); %ordonn?e
            
            
    end
    
    % Update Lanari (11/12)
    %set(handles.TxtSelection,'String', 'selection off');
    %set(handles.TxtSelection,'ForegroundColor', [0 0 0]);
    
end

function mouseMOVEginput(hObject, eventdata)   % PL 11/2012

handles = guidata(hObject);

lesX = get(handles.axes1,'XLim');
lesY = get(handles.axes1,'YLim');

xLength = lesX(2)-lesX(1);
yLength = lesY(2)-lesY(1);

%set(gcf,'Units','characters');
C = get(gca,'CurrentPoint');%'CurrentPoint');

if C(1,1) >= 0 && C(1,1) <= lesX(2) && C(1,2) >= 0 && C(1,2) <= lesY(2)
    
    
    switch handles.rotateFig
        
        case 0
            %set(gcf,'pointer','crosshair');
            set(handles.text47, 'string', round(C(1,1))); %abscisse
            set(handles.text48, 'string', round(C(1,2))); %ordonn?e
            
        case 90
            %set(gcf,'pointer','crosshair');
            set(handles.text47, 'string', round(yLength - C(1,2))); %abscisse
            set(handles.text48, 'string', round(C(1,1))); %ordonn?e
            
        case 180
            %set(gcf,'pointer','crosshair');
            set(handles.text47, 'string', round(xLength - C(1,1))); %abscisse
            set(handles.text48, 'string', round(yLength - C(1,2))); %ordonn?e
            
            
        case 270
            %set(gcf,'pointer','crosshair');
            set(handles.text47, 'string', round(C(1,2))); %abscisse
            set(handles.text48, 'string', round(xLength - C(1,1))); %ordonn?e
            
            %set(handles.text47, 'string', round(C(1,1))); %abscisse
            %set(handles.text48, 'string', round(C(1,2))); %ordonn?e
            
    end
    
else
    
    set(handles.text47, 'string', '...'); %abscisse
    set(handles.text48, 'string', '...'); %ordonn?e
    
end

%set(gcf,'Units','characters');

return

function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = [];

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
    h=findall(fig,'type','uimenu','accel','C');   % Disabling ^C for edit menu so the only ^C is for
    set(h,'accel','');                            % interrupting the function.
    keydown = waitforbuttonpress;
    current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
    if~isempty(current_char) && (keydown == 1)           % If the character was generated by the
        if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
            waserr = 1;                             % so that it errors out.
        end
    end
    
    set(h,'accel','C');                                 % Set back the accelerator for edit menu.
catch
    waserr = 1;
end
drawnow;
if(waserr == 1)
    set(h,'accel','C');                                % Set back the accelerator if it errored out.
    error('MATLAB:ginput:Interrupted', 'Interrupted');
end

if nargout>0, key = keydown; end



% #########################################################################
%       XkmeansX function  (V1.6.2)
function [idx, C, sumD, D] = XkmeansX(X, k, varargin)
%
% k-means for VER_XMapTools_804
% P. Lanari (Sept 2012)
%
%
%

if nargin < 2
    error('At least two input arguments required.');
end

% n points in p dimensional space
[n, p] = size(X);
Xsort = []; Xord = [];

pnames = {   'distance'  'start' 'replicates' 'maxiter' 'emptyaction' 'display'};
dflts =  {'sqeuclidean' 'sample'          []       100        'error'  'notify'};
[errmsg,distance,start,reps,maxit,emptyact,display] ...
    = statgetargs(pnames, dflts, varargin{:});
error(errmsg);

if ischar(distance)
    distNames = {'sqeuclidean','cityblock','cosine','correlation','hamming'};
    i = strmatch(lower(distance), distNames);
    if length(i) > 1
        error(sprintf('Ambiguous ''distance'' parameter value:  %s.', distance));
    elseif isempty(i)
        error(sprintf('Unknown ''distance'' parameter value:  %s.', distance));
    end
    distance = distNames{i};
    switch distance
        case 'cityblock'
            [Xsort,Xord] = sort(X,1);
        case 'cosine'
            Xnorm = sqrt(sum(X.^2, 2));
            if any(min(Xnorm) <= eps * max(Xnorm))
                error(['Some points have small relative magnitudes, making them ', ...
                    'effectively zero.\nEither remove those points, or choose a ', ...
                    'distance other than ''cosine''.'], []);
            end
            X = X ./ Xnorm(:,ones(1,p));
        case 'correlation'
            X = X - repmat(mean(X,2),1,p);
            Xnorm = sqrt(sum(X.^2, 2));
            if any(min(Xnorm) <= eps * max(Xnorm))
                error(['Some points have small relative standard deviations, making them ', ...
                    'effectively constant.\nEither remove those points, or choose a ', ...
                    'distance other than ''correlation''.'], []);
            end
            X = X ./ Xnorm(:,ones(1,p));
        case 'hamming'
            if ~all(ismember(X(:),[0 1]))
                error('Non-binary data cannot be clustered using Hamming distance.');
            end
    end
else
    error('The ''distance'' parameter value must be a string.');
end

if ischar(start)
    startNames = {'uniform','sample','cluster'};
    i = strmatch(lower(start), startNames);
    if length(i) > 1
        error(sprintf('Ambiguous ''start'' parameter value:  %s.', start));
    elseif isempty(i)
        error(sprintf('Unknown ''start'' parameter value:  %s.', start));
    elseif isempty(k)
        error('You must specify the number of clusters, K.');
    end
    start = startNames{i};
    if strcmp(start, 'uniform')
        if strcmp(distance, 'hamming')
            error('Hamming distance cannot be initialized with uniform random values.');
        end
        Xmins = min(X,1);
        Xmaxs = max(X,1);
    end
elseif isnumeric(start)
    CC = start;
    start = 'numeric';
    if isempty(k)
        k = size(CC,1);
    elseif k ~= size(CC,1);
        error('The ''start'' matrix must have K rows.');
    elseif size(CC,2) ~= p
        error('The ''start'' matrix must have the same number of columns as X.');
    end
    if isempty(reps)
        reps = size(CC,3);
    elseif reps ~= size(CC,3);
        error('The third dimension of the ''start'' array must match the ''replicates'' parameter value.');
    end
    
    % Need to center explicit starting points for 'correlation'. (Re)normalization
    % for 'cosine'/'correlation' is done at each iteration.
    if isequal(distance, 'correlation')
        CC = CC - repmat(mean(CC,2),[1,p,1]);
    end
else
    error('The ''start'' parameter value must be a string or a numeric matrix or array.');
end

if ischar(emptyact)
    emptyactNames = {'error','drop','singleton'};
    i = strmatch(lower(emptyact), emptyactNames);
    if length(i) > 1
        error(sprintf('Ambiguous ''emptyaction'' parameter value:  %s.', emptyact));
    elseif isempty(i)
        error(sprintf('Unknown ''emptyaction'' parameter value:  %s.', emptyact));
    end
    emptyact = emptyactNames{i};
else
    error('The ''emptyaction'' parameter value must be a string.');
end

if ischar(display)
    i = strmatch(lower(display), strvcat('off','notify','final','iter'));
    if length(i) > 1
        error(sprintf('Ambiguous ''display'' parameter value:  %s.', display));
    elseif isempty(i)
        error(sprintf('Unknown ''display'' parameter value:  %s.', display));
    end
    display = i-1;
else
    error('The ''display'' parameter value must be a string.');
end

if k == 1
    error('The number of clusters must be greater than 1.');
elseif n < k
    error('X must have more rows than the number of clusters.');
end

% Assume one replicate
if isempty(reps)
    reps = 1;
end

%
% Done with input argument processing, begin clustering
%

dispfmt = '%6d\t%6d\t%8d\t%12g';
D = repmat(NaN,n,k);   % point-to-cluster distances
Del = repmat(NaN,n,k); % reassignment criterion
m = zeros(k,1);

totsumDBest = Inf;
for rep = 1:reps
    switch start
        case 'uniform'
            C = unifrnd(Xmins(ones(k,1),:), Xmaxs(ones(k,1),:));
            % For 'cosine' and 'correlation', these are uniform inside a subset
            % of the unit hypersphere.  Still need to center them for
            % 'correlation'.  (Re)normalization for 'cosine'/'correlation' is
            % done at each iteration.
            if isequal(distance, 'correlation')
                C = C - repmat(mean(C,2),1,p);
            end
        case 'sample'
            C = double(X(randsample(n,k),:)); % X may be logical
        case 'cluster'
            Xsubset = X(randsample(n,floor(.1*n)),:);
            [dum, C] = kmeans(Xsubset, k, varargin{:}, 'start','sample', 'replicates',1);
        case 'numeric'
            C = CC(:,:,rep);
    end
    changed = 1:k; % everything is newly assigned
    idx = zeros(n,1);
    totsumD = Inf;
    
    if display > 2 % 'iter'
        disp(sprintf('  iter\t phase\t     num\t         sum'));
    end
    
    %
    % Begin phase one:  batch reassignments
    %
    
    converged = false;
    iter = 0;
    while true
        % Compute the distance from every point to each cluster centroid
        D(:,changed) = distfun(X, C(changed,:), distance, iter);
        
        % Compute the total sum of distances for the current configuration.
        % Can't do it first time through, there's no configuration yet.
        if iter > 0
            totsumD = sum(D((idx-1)*n + (1:n)'));
            % Test for a cycle: if objective is not decreased, back out
            % the last step and move on to the single update phase
            if prevtotsumD <= totsumD
                idx = previdx;
                [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance, Xsort, Xord);
                iter = iter - 1;
                break;
            end
            if display > 2 % 'iter'
                disp(sprintf(dispfmt,iter,1,length(moved),totsumD));
            end
            if iter >= maxit, break; end
        end
        
        % Determine closest cluster for each point and reassign points to clusters
        previdx = idx;
        prevtotsumD = totsumD;
        [d, nidx] = min(D, [], 2);
        
        if iter == 0
            % Every point moved, every cluster will need an update
            moved = 1:n;
            idx = nidx;
            changed = 1:k;
        else
            % Determine which points moved
            moved = find(nidx ~= previdx);
            if length(moved) > 0
                % Resolve ties in favor of not moving
                moved = moved(D((previdx(moved)-1)*n + moved) > d(moved));
            end
            if length(moved) == 0
                break;
            end
            idx(moved) = nidx(moved);
            
            % Find clusters that gained or lost members
            changed = unique([idx(moved); previdx(moved)])';
        end
        
        % Calculate the new cluster centroids and counts.
        [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance, Xsort, Xord);
        iter = iter + 1;
        
        % Deal with clusters that have just lost all their members
        empties = changed(m(changed) == 0);
        if ~isempty(empties)
            switch emptyact
                case 'error'
                    error(sprintf('Empty cluster created at iteration %d.',iter));
                case 'drop'
                    % Remove the empty cluster from any further processing
                    D(:,empties) = NaN;
                    changed = changed(m(changed) > 0);
                    if display > 0
                        warning(sprintf('Empty cluster created at iteration %d.',iter));
                    end
                case 'singleton'
                    if display > 0
                        warning(sprintf('Empty cluster created at iteration %d.',iter));
                    end
                    
                    for i = empties
                        % Find the point furthest away from its current cluster.
                        % Take that point out of its cluster and use it to create
                        % a new singleton cluster to replace the empty one.
                        [dlarge, lonely] = max(d);
                        from = idx(lonely); % taking from this cluster
                        C(i,:) = X(lonely,:);
                        m(i) = 1;
                        idx(lonely) = i;
                        d(lonely) = 0;
                        
                        % Update clusters from which points are taken
                        [C(from,:), m(from)] = gcentroids(X, idx, from, distance, Xsort, Xord);
                        changed = unique([changed from]);
                    end
            end
        end
    end % phase one
    
    % Initialize some cluster information prior to phase two
    switch distance
        case 'cityblock'
            Xmid = zeros([k,p,2]);
            for i = 1:k
                if m(i) > 0
                    % Separate out sorted coords for points in i'th cluster,
                    % and save values above and below median, component-wise
                    Xsorted = reshape(Xsort(idx(Xord)==i), m(i), p);
                    nn = floor(.5*m(i));
                    if mod(m(i),2) == 0
                        Xmid(i,:,1:2) = Xsorted([nn, nn+1],:)';
                    elseif m(i) > 1
                        Xmid(i,:,1:2) = Xsorted([nn, nn+2],:)';
                    else
                        Xmid(i,:,1:2) = Xsorted([1, 1],:)';
                    end
                end
            end
        case 'hamming'
            Xsum = zeros(k,p);
            for i = 1:k
                if m(i) > 0
                    % Sum coords for points in i'th cluster, component-wise
                    Xsum(i,:) = sum(X(idx==i,:), 1);
                end
            end
    end
    
    %
    % Begin phase two:  single reassignments
    %
    changed = find(m' > 0);
    lastmoved = 0;
    nummoved = 0;
    iter1 = iter;
    while iter < maxit
        % Calculate distances to each cluster from each point, and the
        % potential change in total sum of errors for adding or removing
        % each point from each cluster.  Clusters that have not changed
        % membership need not be updated.
        %
        % Singleton clusters are a special case for the sum of dists
        % calculation.  Removing their only point is never best, so the
        % reassignment criterion had better guarantee that a singleton
        % point will stay in its own cluster.  Happily, we get
        % Del(i,idx(i)) == 0 automatically for them.
        switch distance
            case 'sqeuclidean'
                for i = changed
                    mbrs = (idx == i);
                    sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
                    if m(i) == 1
                        sgn(mbrs) = 0; % prevent divide-by-zero for singleton mbrs
                    end
                    Del(:,i) = (m(i) ./ (m(i) + sgn)) .* sum((X - C(repmat(i,n,1),:)).^2, 2);
                end
            case 'cityblock'
                for i = changed
                    if mod(m(i),2) == 0 % this will never catch singleton clusters
                        ldist = Xmid(repmat(i,n,1),:,1) - X;
                        rdist = X - Xmid(repmat(i,n,1),:,2);
                        mbrs = (idx == i);
                        sgn = repmat(1-2*mbrs, 1, p); % -1 for members, 1 for nonmembers
                        Del(:,i) = sum(max(0, max(sgn.*rdist, sgn.*ldist)), 2);
                    else
                        Del(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2);
                    end
                end
            case {'cosine','correlation'}
                % The points are normalized, centroids are not, so normalize them
                normC(changed) = sqrt(sum(C(changed,:).^2, 2));
                if any(normC < eps) % small relative to unit-length data points
                    error(sprintf('Zero cluster centroid created at iteration %d.',iter));
                end
                % This can be done without a loop, but the loop saves memory allocations
                for i = changed
                    XCi = X * C(i,:)';
                    mbrs = (idx == i);
                    sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
                    Del(:,i) = 1 + sgn .*...
                        (m(i).*normC(i) - sqrt((m(i).*normC(i)).^2 + 2.*sgn.*m(i).*XCi + 1));
                end
            case 'hamming'
                for i = changed
                    if mod(m(i),2) == 0 % this will never catch singleton clusters
                        % coords with an unequal number of 0s and 1s have a
                        % different contribution than coords with an equal
                        % number
                        unequal01 = find(2*Xsum(i,:) ~= m(i));
                        numequal01 = p - length(unequal01);
                        mbrs = (idx == i);
                        Di = abs(X(:,unequal01) - C(repmat(i,n,1),unequal01));
                        Del(:,i) = (sum(Di, 2) + mbrs*numequal01) / p;
                    else
                        Del(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2) / p;
                    end
                end
        end
        
        % Determine best possible move, if any, for each point.  Next we
        % will pick one from those that actually did move.
        previdx = idx;
        prevtotsumD = totsumD;
        [minDel, nidx] = min(Del, [], 2);
        moved = find(previdx ~= nidx);
        if length(moved) > 0
            % Resolve ties in favor of not moving
            moved = moved(Del((previdx(moved)-1)*n + moved) > minDel(moved));
        end
        if length(moved) == 0
            % Count an iteration if phase 2 did nothing at all, or if we're
            % in the middle of a pass through all the points
            if (iter - iter1) == 0 | nummoved > 0
                iter = iter + 1;
                if display > 2 % 'iter'
                    disp(sprintf(dispfmt,iter,2,nummoved,totsumD));
                end
            end
            converged = true;
            break;
        end
        
        % Pick the next move in cyclic order
        moved = mod(min(mod(moved - lastmoved - 1, n) + lastmoved), n) + 1;
        
        % If we've gone once through all the points, that's an iteration
        if moved <= lastmoved
            iter = iter + 1;
            if display > 2 % 'iter'
                disp(sprintf(dispfmt,iter,2,nummoved,totsumD));
            end
            if iter >= maxit, break; end
            nummoved = 0;
        end
        nummoved = nummoved + 1;
        lastmoved = moved;
        
        oidx = idx(moved);
        nidx = nidx(moved);
        totsumD = totsumD + Del(moved,nidx) - Del(moved,oidx);
        
        % Update the cluster index vector, and rhe old and new cluster
        % counts and centroids
        idx(moved) = nidx;
        m(nidx) = m(nidx) + 1;
        m(oidx) = m(oidx) - 1;
        switch distance
            case 'sqeuclidean'
                C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
                C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
            case 'cityblock'
                for i = [oidx nidx]
                    % Separate out sorted coords for points in each cluster.
                    % New centroid is the coord median, save values above and
                    % below median.  All done component-wise.
                    Xsorted = reshape(Xsort(idx(Xord)==i), m(i), p);
                    nn = floor(.5*m(i));
                    if mod(m(i),2) == 0
                        C(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
                        Xmid(i,:,1:2) = Xsorted([nn, nn+1],:)';
                    else
                        C(i,:) = Xsorted(nn+1,:);
                        if m(i) > 1
                            Xmid(i,:,1:2) = Xsorted([nn, nn+2],:)';
                        else
                            Xmid(i,:,1:2) = Xsorted([1, 1],:)';
                        end
                    end
                end
            case {'cosine','correlation'}
                C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
                C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
            case 'hamming'
                % Update summed coords for points in each cluster.  New
                % centroid is the coord median.  All done component-wise.
                Xsum(nidx,:) = Xsum(nidx,:) + X(moved,:);
                Xsum(oidx,:) = Xsum(oidx,:) - X(moved,:);
                C(nidx,:) = .5*sign(2*Xsum(nidx,:) - m(nidx)) + .5;
                C(oidx,:) = .5*sign(2*Xsum(oidx,:) - m(oidx)) + .5;
        end
        changed = sort([oidx nidx]);
    end % phase two
    
    if (~converged) & (display > 0)
        warning(sprintf('Failed to converge in %d iterations.', maxit));
    end
    
    % Calculate cluster-wise sums of distances
    nonempties = find(m(:)'>0);
    D(:,nonempties) = distfun(X, C(nonempties,:), distance, iter);
    d = D((idx-1)*n + (1:n)');
    sumD = zeros(k,1);
    for i = 1:k
        sumD(i) = sum(d(idx == i));
    end
    if display > 1 % 'final' or 'iter'
        disp(sprintf('%d iterations, total sum of distances = %g',iter,totsumD));
    end
    
    % Save the best solution so far
    if totsumD < totsumDBest
        totsumDBest = totsumD;
        idxBest = idx;
        Cbest = C;
        sumDBest = sumD;
        if nargout > 3
            Dbest = D;
        end
    end
end

% Return the best solution
idx = idxBest;
C = Cbest;
sumD = sumDBest;
if nargout > 3
    D = Dbest;
end

function D = distfun(X, C, dist, iter)
%DISTFUN Calculate point to cluster centroid distances.
[n,p] = size(X);
D = zeros(n,size(C,1));
clusts = 1:size(C,1);

switch dist
    case 'sqeuclidean'
        for i = clusts
            D(:,i) = sum((X - C(repmat(i,n,1),:)).^2, 2);
        end
    case 'cityblock'
        for i = clusts
            D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2);
        end
    case {'cosine','correlation'}
        % The points are normalized, centroids are not, so normalize them
        normC = sqrt(sum(C.^2, 2));
        if any(normC < eps) % small relative to unit-length data points
            error(sprintf('Zero cluster centroid created at iteration %d.',iter));
        end
        % This can be done without a loop, but the loop saves memory allocations
        for i = clusts
            D(:,i) = 1 - (X * C(i,:)') ./ normC(i);
        end
    case 'hamming'
        for i = clusts
            D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2) / p;
        end
end

function [centroids, counts] = gcentroids(X, index, clusts, dist, Xsort, Xord)
%GCENTROIDS Centroids and counts stratified by group.
[n,p] = size(X);
num = length(clusts);
centroids = repmat(NaN, [num p]);
counts = zeros(num,1);
for i = 1:num
    members = find(index == clusts(i));
    if length(members) > 0
        counts(i) = length(members);
        switch dist
            case 'sqeuclidean'
                centroids(i,:) = sum(X(members,:),1) / counts(i);
            case 'cityblock'
                % Separate out sorted coords for points in i'th cluster,
                % and use to compute a fast median, component-wise
                Xsorted = reshape(Xsort(index(Xord)==clusts(i)), counts(i), p);
                nn = floor(.5*counts(i));
                if mod(counts(i),2) == 0
                    centroids(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
                else
                    centroids(i,:) = Xsorted(nn+1,:);
                end
            case {'cosine','correlation'}
                centroids(i,:) = sum(X(members,:),1) / counts(i); % unnormalized
            case 'hamming'
                % Compute a fast median for binary data, component-wise
                centroids(i,:) = .5*sign(2*sum(X(members,:), 1) - counts(i)) + .5;
        end
    end
end

function [emsg,varargout]=statgetargs(pnames,dflts,varargin)
%STATGETARGS Process parameter name/value pairs for statistics functions
%   [EMSG,A,B,...]=STATGETARGS(PNAMES,DFLTS,'NAME1',VAL1,'NAME2',VAL2,...)
%   accepts a cell array PNAMES of valid parameter names, a cell array
%   DFLTS of default values for the parameters named in PNAMES, and
%   additional parameter name/value pairs.  Returns parameter values A,B,...
%   in the same order as the names in PNAMES.  Outputs corresponding to
%   entries in PNAMES that are not specified in the name/value pairs are
%   set to the corresponding value from DFLTS.  If nargout is equal to
%   length(PNAMES)+1, then unrecognized name/value pairs are an error.  If
%   nargout is equal to length(PNAMES)+2, then all unrecognized name/value
%   pairs are returned in a single cell array following any other outputs.
%
%   EMSG is empty if the arguments are valid, or the text of an error message
%   if an error occurs.  STATGETARGS does not actually throw any errors, but
%   rather returns an error message so that the caller may throw the error.
%   Outputs will be partially processed after an error occurs.
%
%   This utility is used by some Statistics Toolbox functions to process
%   name/value pair arguments.
%
%   Example:
%       pnames = {'color' 'linestyle', 'linewidth'}
%       dflts  = {    'r'         '_'          '1'}
%       varargin = {{'linew' 2 'nonesuch' [1 2 3] 'linestyle' ':'}
%       [emsg,c,ls,lw] = statgetargs(pnames,dflts,varargin{:})    % error
%       [emsg,c,ls,lw,ur] = statgetargs(pnames,dflts,varargin{:}) % ok

%   Copyright 1993-2002 The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 2002/02/04 19:25:45 $

% We always create (nparams+1) outputs:
%    one for emsg
%    nparams varargs for values corresponding to names in pnames
% If they ask for one more (nargout == nparams+2), it's for unrecognized
% names/values

% Initialize some variables
emsg = '';
nparams = length(pnames);
varargout = dflts;
unrecog = {};
nargs = length(varargin);

% Must have name/value pairs
if mod(nargs,2)~=0
    emsg = sprintf('Wrong number of arguments.');
else
    % Process name/value pairs
    for j=1:2:nargs
        pname = varargin{j};
        if ~ischar(pname)
            emsg = sprintf('Parameter name must be text.');
            break;
        end
        i = strmatch(lower(pname),pnames);
        if isempty(i)
            % if they've asked to get back unrecognized names/values, add this
            % one to the list
            if nargout > nparams+1
                unrecog((end+1):(end+2)) = {varargin{j} varargin{j+1}};
                
                % otherwise, it's an error
            else
                emsg = sprintf('Invalid parameter name:  %s.',pname);
                break;
            end
        elseif length(i)>1
            emsg = sprintf('Ambiguous parameter name:  %s.',pname);
            break;
        else
            varargout{i} = varargin{j+1};
        end
    end
end

varargout{nparams+1} = unrecog;



% #########################################################################
%       Xpoly2maskX function  (V1.6.2)
function BW = Xpoly2maskX(x,y,M,N)
%POLY2MASK-like function for VER_XMAPTOOLS_804 that
%   Convert region-of-interest polygon to mask.


%narginchk(4,4);

% This function narginchk to validate the number of arguments is not
% compatible with the old version of Matlab.
% Removed 1.6.5 (We don't need to check this here).


validateattributes(x,{'double'},{},mfilename,'X',1);
validateattributes(y,{'double'},{},mfilename,'Y',2);
if length(x) ~= length(y)
    error(message('images:poly2mask:vectorSizeMismatch'));
end
if isempty(x)
    BW = false(M,N);
    return;
end
validateattributes(x,{'double'},{'real','vector','finite'},mfilename,'X',1);
validateattributes(y,{'double'},{'real','vector','finite'},mfilename,'Y',2);
validateattributes(M,{'double'},{'real','integer','nonnegative'},mfilename,'M',3);
validateattributes(N,{'double'},{'real','integer','nonnegative'},mfilename,'N',4);

if (x(end) ~= x(1)) || (y(end) ~= y(1))
    x(end+1) = x(1);
    y(end+1) = y(1);
end

[xe,ye] = Xpoly2edgelistX(x,y);
BW = Xedgelist2maskX(M,N,xe,ye);

return

function [xe, ye] = Xpoly2edgelistX(x,y,scale)

if nargin < 3
    scale = 5;
end

% Scale and quantize (x,y) locations to the higher resolution grid.
x = round(scale*(x - 0.5) + 1);
y = round(scale*(y - 0.5) + 1);

num_segments = length(x) - 1;
x_segments = cell(num_segments,1);
y_segments = cell(num_segments,1);
for k = 1:num_segments
    [x_segments{k},y_segments{k}] = XintlineX(x(k),x(k+1),y(k),y(k+1));
end

% Concatenate segment vertices.
x = cat(1,x_segments{:});
y = cat(1,y_segments{:});

% Horizontal edges are located where the x-value changes.
d = diff(x);
edge_indices = find(d);
xe = x(edge_indices);

% Wherever the diff is negative, the x-coordinate should be x-1 instead of
% x.
shift = find(d(edge_indices) < 0);
xe(shift) = xe(shift) - 1;

% In order for the result to be the same no matter which direction we are
% tracing the polynomial, the y-value for a diagonal transition has to be
% biased the same way no matter what.  We'll always chooser the smaller
% y-value associated with diagonal transitions.
ye = min(y(edge_indices), y(edge_indices+1));


return

function BW = Xedgelist2maskX(M,N,xe,ye,scale)

if nargin < 5
    scale = 5;
end

shift = (scale - 1)/2;

% Scale x values, throwing away edgelist points that aren't on a pixel's
% center column.
xe = (xe+shift)/5;
idx = xe == floor(xe);
xe = xe(idx);
ye = ye(idx);

% Scale y values.
ye = ceil((ye + shift)/scale);

% Throw away horizontal edges that are too far left, too far right, or below the image.
bad_indices = find((xe < 1) | (xe > N) | (ye > M));
xe(bad_indices) = [];
ye(bad_indices) = [];

% Treat horizontal edges above the top of the image as they are along the
% upper edge.
ye = max(1,ye);

% Insert the edge list locations into a sparse matrix, taking
% advantage of the accumulation behavior of the SPARSE function.
S = sparse(ye,xe,1,M,N);

% We reduce the memory consumption of edgelist2mask by processing only a
% group of columns at a time (g274577); this does not compromise speed.
BW = false(size(S));
numCols = size(S,2);
columnChunk = 50;
for k = 1:columnChunk:numCols
    firstColumn = k;
    lastColumn = min(k + columnChunk - 1, numCols);
    columns = full(S(:, firstColumn:lastColumn));
    BW(:, firstColumn:lastColumn) = parityscan(columns);
end

function [BW] = parityscan(F)
% F is a two-dimensional matrix containing nonnegative integers

nR = size(F,1);
nC = size(F,2);

BW = false(nR,nC);

for c=1:nC
    
    somme = 0;
    for r=1:nR
        somme = somme+F(r,c);
        if mod(somme,2) == 1
            
            BW(r,c) = 1;
        end
    end
    
    
    %if length(find(F(:,c))) > 0
    %    keyboard
    %end
    
end


return

function [x,y] = XintlineX(x1, x2, y1, y2)
dx = abs(x2 - x1);
dy = abs(y2 - y1);

% Check for degenerate case.
if ((dx == 0) && (dy == 0))
    x = x1;
    y = y1;
    return;
end

flip = 0;
if (dx >= dy)
    if (x1 > x2)
        % Always "draw" from left to right.
        t = x1; x1 = x2; x2 = t;
        t = y1; y1 = y2; y2 = t;
        flip = 1;
    end
    m = (y2 - y1)/(x2 - x1);
    x = (x1:x2).';
    y = round(y1 + m*(x - x1));
else
    if (y1 > y2)
        % Always "draw" from bottom to top.
        t = x1; x1 = x2; x2 = t;
        t = y1; y1 = y2; y2 = t;
        flip = 1;
    end
    m = (x2 - x1)/(y2 - y1);
    y = (y1:y2).';
    x = round(x1 + m*(y - y1));
end

if (flip)
    x = flipud(x);
    y = flipud(y);
end

return



% #########################################################################
%       MenuX function  (V1.6.2)
function k = menuX(xHeader,varargin)
%MENU   Generate a menu of choices for user input.
%   CHOICE = MENU(HEADER, ITEM1, ITEM2, ... ) displays the HEADER
%   string followed in sequence by the menu-item strings: ITEM1, ITEM2,
%   ... ITEMn. Returns the number of the selected menu-item as CHOICE,
%   a scalar value. There is no limit to the number of menu items.
%
%   CHOICE = MENU(HEADER, ITEMLIST) where ITEMLIST is a string, cell
%   array is also a valid syntax.
%
%   On most graphics terminals MENU will display the menu-items as push
%   buttons in a figure window, otherwise they will be given as a numbered
%   list in the command window (see example, below).
%
%   Example:
%       K = menu('Choose a color','Red','Blue','Green')
%       %creates a figure with buttons labeled 'Red', 'Blue' and 'Green'
%       %The button clicked by the user is returned as K (i.e. K = 2
%       implies that the user selected Blue).
%
%   See also UICONTROL, UIMENU, GUIDE.

%   Copyright 1984-2010 The MathWorks, Inc.
%   $Revision: 5.21.4.8 $  $Date: 2011/09/08 23:36:10 $

%=========================================================================
% Check input
%-------------------------------------------------------------------------
if nargin < 2,
    disp(getString(message('MATLAB:uistring:menu:NoMenuItemsToChooseFrom')))
    k=0;
    return;
elseif nargin==2 && iscell(varargin{1}),
    ArgsIn = varargin{1}; % a cell array was passed in
else
    ArgsIn = varargin;    % use the varargin cell array
end

%-------------------------------------------------------------------------
% Check computer type to see if we can use a GUI
%-------------------------------------------------------------------------
useGUI   = 1; % Assume we can use a GUI

if isunix,     % Unix?
    useGUI = length(getenv('DISPLAY')) > 0;
end % if

%-------------------------------------------------------------------------
% Create the appropriate menu
%-------------------------------------------------------------------------
if useGUI,
    % Create a GUI menu to acquire answer "k"
    k = local_GUImenu( xHeader, ArgsIn );
else
    % Create an ascii menu to acquire answer "k"
    k = local_ASCIImenu( xHeader, ArgsIn );
end % if

function k = local_ASCIImenu( xHeader, xcItems )

% local function to display an ascii-generated menu and return the user's
% selection from that menu as an index into the xcItems cell array

%-------------------------------------------------------------------------
% Calculate the number of items in the menu
%-------------------------------------------------------------------------
numItems = length(xcItems);

%-------------------------------------------------------------------------
% Continuous loop to redisplay menu until the user makes a valid choice
%-------------------------------------------------------------------------
while 1,
    % Display the header
    disp(' ')
    disp(['----- ',xHeader,' -----'])
    disp(' ')
    % Display items in a numbered list
    for n = 1 : numItems
        disp( [ '      ' int2str(n) ') ' xcItems{n} ] )
    end
    disp(' ')
    % Prompt for user input
    k = input('Select a menu number: ');
    % Check input:
    % 1) make sure k has a value
    if isempty(k), k = -1; end;
    % 2) make sure the value of k is valid
    if  (k < 1) || (k > numItems) ...
            || ~strcmp(class(k),'double') ...
            || ~isreal(k) || (isnan(k)) || isinf(k),
        % Failed a key test. Ask question again
        disp(' ')
        disp(getString(message('MATLAB:uistring:menu:SelectionOutOfRangeTryAgain')))
    else
        % Passed all tests, exit loop and return k
        return
    end % if k...
end % while 1

function k = local_GUImenu( xHeader, xcItems )

% local function to display a Handle Graphics menu and return the user's
% selection from that menu as an index into the xcItems cell array

%=========================================================================
% SET UP
%=========================================================================
% Set spacing and sizing parameters for the GUI elements
%-------------------------------------------------------------------------
MenuUnits   = 'pixels'; % units used for all HG objects
textPadding = [22 12];   % extra [Width Height] on uicontrols to pad text
uiGap       = 5;       % space between uicontrols
uiBorder    = 10;       % space between edge of figure and any uicontol
winTopGap   = 60;       % gap between top of screen and top of figure **
winLeftGap  = 30;       % gap between side of screen and side of figure **
winWideMin  = 140;      % minimin window width necessary to show title

% ** "figure" ==> viewable figure. You must allow space for the OS to add
% a title bar (aprx 42 points on Mac and Windows) and a window border
% (usu 2-6 points). Otherwise user cannot move the window.

%-------------------------------------------------------------------------
% Calculate the number of items in the menu
%-------------------------------------------------------------------------
numItems = length( xcItems );

%=========================================================================
% BUILD
%=========================================================================
% Create a generically-sized invisible figure window
%------------------------------------------------------------------------
menuFig = figure( 'Units'       ,MenuUnits, ...
    'Visible'     ,'off', ...
    'NumberTitle' ,'off', ...
    'Name'        ,getString(message('MATLAB:uistring:menu:MENU')), ...
    'Resize'      ,'off', ...
    'Colormap'    ,[], ...
    'MenuBar'     ,'none',...
    'ToolBar' 	,'none' ...
    );

%------------------------------------------------------------------------
% Add generically-sized header text with same background color as figure
%------------------------------------------------------------------------
hText = uicontrol( ...
    'Style'       ,'text', ...
    'String'      ,xHeader, ...
    'Units'       ,MenuUnits, ...
    'Position'    ,[ 100 100 100 20 ], ...
    'HorizontalAlignment'  ,'center',...
    'BackgroundColor'  ,get(menuFig,'Color') );

% Record extent of text string
maxsize = get( hText, 'Extent' );
textWide  = maxsize(3);
textHigh  = maxsize(4);

%------------------------------------------------------------------------
% Add generically-spaced buttons below the header text
%------------------------------------------------------------------------
% Loop to add buttons in reverse order (to automatically initialize numitems).
% Note that buttons may overlap, but are placed in correct position relative
% to each other. They will be resized and spaced evenly later on.

hBtn = zeros(numItems, 1);
for idx = numItems : -1 : 1; % start from top of screen and go down
    n = numItems - idx + 1;  % start from 1st button and go to last
    % make a button
    hBtn(n) = uicontrol( ...
        'Units'          ,MenuUnits, ...
        'Position'       ,[uiBorder uiGap*idx textHigh textWide], ...
        'Callback'       , {@menucallback, n}, ...
        'String'         ,xcItems{n} );
end % for

%=========================================================================
% TWEAK
%=========================================================================
% Calculate Optimal UIcontrol dimensions based on max text size
%------------------------------------------------------------------------
cAllExtents = get( hBtn, {'Extent'} );  % put all data in a cell array
AllExtents  = cat( 1, cAllExtents{:} ); % convert to an n x 3 matrix
maxsize     = max( AllExtents(:,3:4) ); % calculate the largest width & height
maxsize     = maxsize + textPadding;    % add some blank space around text
btnHigh     = maxsize(2);
btnWide     = maxsize(1);

%------------------------------------------------------------------------
% Retrieve screen dimensions (in correct units)
%------------------------------------------------------------------------
screensize = get(0,'ScreenSize');  % record screensize

%------------------------------------------------------------------------
% How many rows and columns of buttons will fit in the screen?
% Note: vertical space for buttons is the critical dimension
% --window can't be moved up, but can be moved side-to-side
%------------------------------------------------------------------------
openSpace = screensize(4) - winTopGap - 2*uiBorder - textHigh;
numRows = min( floor( openSpace/(btnHigh + uiGap) ), numItems );
if numRows == 0; numRows = 1; end % Trivial case--but very safe to do
numCols = ceil( numItems/numRows );

%------------------------------------------------------------------------
% Resize figure to place it in top left of screen
%------------------------------------------------------------------------
% Calculate the window size needed to display all buttons
winHigh = numRows*(btnHigh + uiGap) + textHigh + 2*uiBorder;
winWide = numCols*(btnWide) + (numCols - 1)*uiGap + 2*uiBorder;

% Make sure the text header fits
if winWide < (2*uiBorder + textWide),
    winWide = 2*uiBorder + textWide;
end

% Make sure the dialog name can be shown
if winWide < winWideMin %pixels
    winWide = winWideMin;
end

% Determine final placement coordinates for bottom of figure window
bottom = screensize(4) - (winHigh + winTopGap);

% Set figure window position
set( menuFig, 'Position', [winLeftGap bottom winWide winHigh] );

%------------------------------------------------------------------------
% Size uicontrols to fit everyone in the window and see all text
%------------------------------------------------------------------------
% Calculate coordinates of bottom-left corner of all buttons
xPos = ( uiBorder + (0:numCols-1)'*( btnWide + uiGap )*ones(1,numRows) )';
xPos = xPos(1:numItems); % [ all 1st col; all 2nd col; ...; all nth col ]
yPos = ( uiBorder + (numRows-1:-1:0)'*( btnHigh + uiGap )*ones(1,numCols) );
yPos = yPos(1:numItems); % [ rows 1:m; rows 1:m; ...; rows 1:m ]

% Combine with desired button size to get a cell array of position vectors
allBtn   = ones(numItems,1);
uiPosMtx = [ xPos(:), yPos(:), btnWide*allBtn, btnHigh*allBtn ];
cUIPos   = num2cell( uiPosMtx( 1:numItems, : ), 2 );

% adjust all buttons
set( hBtn, {'Position'}, cUIPos );

%------------------------------------------------------------------------
% Align the Text and Buttons horizontally and distribute them vertically
%------------------------------------------------------------------------

% Calculate placement position of the Header
textWide = winWide - 2*uiBorder;

% Move Header text into correct position near the top of figure
set( hText, ...
    'Position', [ uiBorder winHigh-uiBorder-textHigh textWide textHigh ] );

%=========================================================================
% ACTIVATE
%=========================================================================
% Make figure visible
%------------------------------------------------------------------------
movegui(menuFig,'center');
set( menuFig, 'Visible', 'on' );

%------------------------------------------------------------------------
% Wait for choice to be made (i.e UserData must be assigned)...
%------------------------------------------------------------------------
waitfor(menuFig,'userdata')

%------------------------------------------------------------------------
% Selection has been made or figure has been deleted.
% Assign k and delete the Menu figure if it is still valid.
%------------------------------------------------------------------------
if ishghandle(menuFig)
    k = get(menuFig,'UserData');
    delete(menuFig)
else
    % The figure was deletd without a selection. Return 0.
    k = 0;
end

function menucallback(btn, evd, index)                                 %#ok
set(gcbf, 'UserData', index);





% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%                            CREATE FONCTIONS
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


% #########################################################################
%     MINERAL LIST FOR THERMOMETERS
function THppmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
return


% #########################################################################
%     THERMOMETERS LIST
function THppmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
return


% #########################################################################
%     COMPUTATION MODES LIST
function THppmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% #########################################################################
%     ELEMENT SELECTION FOR DISPLAY
function PPMenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Menu_AddonsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_AddonsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function PopUpColormap_LEFT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpColormap_LEFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%                             OTHERS FUNCTIONS
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



% --- Executes during object creation, after setting all properties.
function FIGtext1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FIGtext1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in REbutton4.
% function REbutton4_Callback(hObject, eventdata, handles)
% Results = handles.results;
%
% Onest = get(handles.REppmenu1,'Value') - 1;
% Lamap = get(handles.REppmenu2,'Value');
% if Onest < 1
%     return
% end
%
% LesRes = Results(Onest).values(:,Lamap);
% LesRes = reshape(LesRes,Results(Onest).reshape(1),Results(Onest).reshape(2));
%
% Clique = 1;
%
% while Clique <= 2
%     [X,Y,Clique] = XginputX(1);
%     X = round(X);
%     Y = round(Y);
%     set(handles.REtext1,'String',num2str(LesRes(Y,X),3));
%     axes(handles.axes1)
%     hold on, plot(X,Y,'+k')
% end
%
% set(handles.axes1,'xtick',[], 'ytick',[]);
% GraphStyle(hObject, eventdata, handles)
% return


% --- Executes on button press in Module_Chem2D.
% %     2D-TREATMENT BUTTON
% function REbutton5_Callback(hObject, eventdata, handles)
% Results = handles.results;
%
% Onest = get(handles.REppmenu1,'Value') - 1;
% if Onest < 1
%     warndlg('No result selected')
%     return
% end
%
%
% Export = Results(Onest).values;
% NbVar = length(Results(Onest).labels);
%
% Seq = 'XMTMod2DTreatment(';
%
% for i=1:NbVar
%     Seq = strcat(Seq,'Export(:,',num2str(i),'),');
% end
%
% Seq = strcat(Seq,'Results(Onest).labels,Results(Onest).reshape);');
%
% eval(Seq);
%
% return
%








% --- Executes on selection change in OPT.
% Cette fonction n'est plus utilis?e depuis la version 1.4.1
function OPT_Callback(hObject, eventdata, handles)
%AffPAN(hObject, eventdata, handles);
%guidata(hObject,handles);
return


% --- Executes during object creation, after setting all properties.
function OPT_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PPMaskMeth.
function PPMaskMeth_Callback(hObject, eventdata, handles)
% hObject    handle to PPMaskMeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PPMaskMeth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPMaskMeth


% --- Executes during object creation, after setting all properties.
function PPMaskMeth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPMaskMeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function QUmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QUmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% UNUSED CREATING-FUNCTIONS :


% --- Executes during object creation, after setting all properties.
function ColorMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
return

function ColorMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
return

% --- Executes during object creation, after setting all properties.
function PPMenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% A SUPPRIMER PAR LA SUITE

% #########################################################################
%     OPEN THE MAP IN A NEW WINDOW V ant?rieure
function MapWindow_Callback(hObject, eventdata, handles)
% ValueMedian = get(handles.FIGbutton1,'Value');
%
% if ValueMedian == 1
%     MedianSize = str2num(get(handles.FIGtext1,'String'));
%     Onfaitquoi = handles.currentdisplay; % Input change
%
%     if Onfaitquoi == 1 % for type 1 (Elem + Mask)
%         Data = handles.data;
%         MaskFile = handles.MaskFile;
%
%         MaskSelected = get(handles.PPMenu3,'Value');
%         Selected = get(handles.PPMenu1,'Value');
%         Mineral = get(handles.PPMenu2,'Value');
%         Value = get(handles.checkbox1,'Value');
%
%         if Mineral > 1
%             RefMin = Mineral - 1;
%             AAfficher = MaskFile(MaskSelected).Mask == RefMin;
%             AAfficher = Data.map(Selected).values .* AAfficher;
%
%         else
%             AAfficher = Data.map(Selected).values;
%         end
%
%         figure, imagesc(medfilt2(AAfficher,[MedianSize,MedianSize])), axis image, colorbar horizontal
%         set(gca,'xtick',[], 'ytick',[]);
%
%         Max = str2num(get(handles.ColorMax,'String'));
%         Min = str2num(get(handles.ColorMin,'String'));
%
%         if Max > Min
%             caxis([Min,Max]);
%         end
%         if Value == 1
%             colormap([0,0,0;jet(64)])
%         else
%             colormap([jet(64)])
%         end
%
%     elseif Onfaitquoi == 2 % for type 2 (elem + Mask)
%         Quanti = handles.quanti;
%
%         ValMin = get(handles.QUppmenu2,'Value');
%         AllMin = get(handles.QUppmenu2,'String');
%         SelMin = AllMin(ValMin);
%         if char(SelMin) == char('.')
%             warndlg('map not yet quantified','cancelation');
%             return
%         end
%
%         ValOxi = get(handles.QUppmenu1,'Value');
%
%         figure,
%         imagesc(medfilt2(Quanti(ValMin).elem(ValOxi).quanti,[MedianSize,MedianSize])),
%         axis image, colorbar horizontal
%         set(gca,'xtick',[], 'ytick',[]);
%
%         Value = get(handles.checkbox1,'Value');
%
%         Max = str2num(get(handles.ColorMax,'String'));
%         Min = str2num(get(handles.ColorMin,'String'));
%
%         if Max > Min
%             caxis([Min,Max]);
%         end
%         if Value == 1
%             colormap([0,0,0;jet(64)])
%         else
%             colormap([jet(64)])
%         end
%
%     elseif Onfaitquoi == 3 % for type 3 (results)
%         Results = handles.results;
%
%         Onest = get(handles.REppmenu1,'Value') - 1; % 1 is none$
%         Onaff = get(handles.REppmenu2,'Value'); % T, Aliv ...
%
%         AAfficher = reshape(Results(Onest).values(:,Onaff),Results(Onest).reshape(1),Results(Onest).reshape(2));
%
%         figure,
%         imagesc(medfilt2(AAfficher,[MedianSize,MedianSize])), colorbar('horizontal'), axis image
%         set(gca,'xtick',[], 'ytick',[]);
%
%         Max = str2num(get(handles.ColorMax,'String'));
%         Min = str2num(get(handles.ColorMin,'String'));
%
%         Value = get(handles.checkbox1,'Value');
%         if Max > Min
%             caxis([Min,Max]);
%         end
%         if Value == 1
%             colormap([0,0,0;jet(64)])
%         else
%             colormap([jet(64)])
%         end
%
%     end
% else
%     Onfaitquoi = handles.currentdisplay; % Input change
%
%     if Onfaitquoi == 1 % for type 1 (Elem + Mask)
%         Data = handles.data;
%         MaskFile = handles.MaskFile;
%
%         MaskSelected = get(handles.PPMenu3,'Value');
%         Selected = get(handles.PPMenu1,'Value');
%         Mineral = get(handles.PPMenu2,'Value');
%         Value = get(handles.checkbox1,'Value');
%
%         if Mineral > 1
%             RefMin = Mineral - 1;
%             AAfficher = MaskFile(MaskSelected).Mask == RefMin;
%             AAfficher = Data.map(Selected).values .* AAfficher;
%
%         else
%             AAfficher = Data.map(Selected).values;
%         end
%
%         figure, imagesc(AAfficher), axis image, colorbar horizontal
%         set(gca,'xtick',[], 'ytick',[]);
%
%         Max = str2num(get(handles.ColorMax,'String'));
%         Min = str2num(get(handles.ColorMin,'String'));
%
%         if Max > Min
%             caxis([Min,Max]);
%         end
%         if Value == 1
%             colormap([0,0,0;jet(64)])
%         else
%             colormap([jet(64)])
%         end
%
%     elseif Onfaitquoi == 2 % for type 2 (elem + Mask)
%         Quanti = handles.quanti;
%
%         ValMin = get(handles.QUppmenu2,'Value');
%         AllMin = get(handles.QUppmenu2,'String');
%         SelMin = AllMin(ValMin);
%         if char(SelMin) == char('.')
%             warndlg('map not yet quantified','cancelation');
%             return
%         end
%
%         ValOxi = get(handles.QUppmenu1,'Value');
%
%         figure,
%         imagesc(Quanti(ValMin).elem(ValOxi).quanti),
%         axis image, colorbar horizontal
%         set(gca,'xtick',[], 'ytick',[]);
%
%         Value = get(handles.checkbox1,'Value');
%
%         Max = str2num(get(handles.ColorMax,'String'));
%         Min = str2num(get(handles.ColorMin,'String'));
%
%         if Max > Min
%             caxis([Min,Max]);
%         end
%         if Value == 1
%             colormap([0,0,0;jet(64)])
%         else
%             colormap([jet(64)])
%         end
%
%     elseif Onfaitquoi == 3 % for type 3 (results)
%         Results = handles.results;
%
%         Onest = get(handles.REppmenu1,'Value') - 1; % 1 is none$
%         Onaff = get(handles.REppmenu2,'Value'); % T, Aliv ...
%
%         AAfficher = reshape(Results(Onest).values(:,Onaff),Results(Onest).reshape(1),Results(Onest).reshape(2));
%
%         figure,
%         imagesc(AAfficher), colorbar('horizontal'), axis image
%         set(gca,'xtick',[], 'ytick',[]);
%
%         Max = str2num(get(handles.ColorMax,'String'));
%         Min = str2num(get(handles.ColorMin,'String'));
%
%         Value = get(handles.checkbox1,'Value');
%         if Max > Min
%             caxis([Min,Max]);
%         end
%         if Value == 1
%             colormap([0,0,0;jet(64)])
%         else
%             colormap([jet(64)])
%         end
%
%     end
% end
%
% guidata(hObject,handles);
return



function QUppmenu1_CreateFcn(hObject, eventdata, handles)
return
% --- Executes during object creation, after setting all properties.


function QUppmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
return

% --- Executes during object creation, after setting all properties.
function REppmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REppmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function REppmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REppmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MenXray3_Callback(hObject, eventdata, handles)
% hObject    handle to MenXray3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenQuanti2_Callback(hObject, eventdata, handles)
% hObject    handle to MenQuanti2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function FilterMin_Callback(hObject, eventdata, handles)
% hObject    handle to FilterMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterMin as text
%        str2double(get(hObject,'String')) returns contents of FilterMin as a double


% --- Executes during object creation, after setting all properties.
function FilterMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FilterMax_Callback(hObject, eventdata, handles)
% hObject    handle to FilterMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterMax as text
%        str2double(get(hObject,'String')) returns contents of FilterMax as a double


% --- Executes during object creation, after setting all properties.
function FilterMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in 
function LeftMenuMaskFile_Callback(hObject, eventdata, handles)
MaskFile = handles.MaskFile;

WhereLoc = get(hObject,'Value');
Liste = get(hObject,'String');
Name = Liste(WhereLoc);

ListeMin = handles.MaskFile(WhereLoc).NameMinerals;
set(handles.PPMenu2,'String',ListeMin);
set(handles.PPMenu2,'Value',1);

set(handles.PPMenu3,'Value',WhereLoc);

CodeTxt = [7,8];
set(handles.TxtControl,'String',[char(Name),' ',char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

% set(handles.TxtControl,'String',[char(Name),' ',char(handles.TxtDatabase(7).txt(8))]);
%MaskButton2_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return




% --- Executes during object creation, after setting all properties.
function LeftMenuMaskFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaskFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
return

% --- Executes during object creation, after setting all properties.
%function OnSenTape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OnSenTape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end


% --- Executes on selection change in PPMaskFrom.
function PPMaskFrom_Callback(hObject, eventdata, handles)
% hObject    handle to PPMaskFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PPMaskFrom contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPMaskFrom


% --- Executes during object creation, after setting all properties.
function PPMaskFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPMaskFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PopUpColormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function CorrPopUpMenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CorrPopUpMenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function REppmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REppmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function FieldVARI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FieldVARI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Menu_AddonsList.
function Menu_AddonsList_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_AddonsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Menu_AddonsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu_AddonsList


% --- Executes on button press in ButtonLogo.
function ButtonLogo_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function EditColorDef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditColorDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% MENU

% --------------------------------------------------------------------
function Menu_File_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Button2_Callback(hObject, eventdata, handles)
%
Button2_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Button3_Callback(hObject, eventdata, handles)
handles.save = 1;
Button3_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Button5_Callback(hObject, eventdata, handles)
Button5_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_ExportWindow_Callback(hObject, eventdata, handles)
ExportFigureInNewWindow(1,hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_MaskButton4_Callback(hObject, eventdata, handles)
MaskButton4_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_ButtonSettings_Callback(hObject, eventdata, handles)
ButtonSettings_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Button1_Callback(hObject, eventdata, handles)
Button1_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Button4_Callback(hObject, eventdata, handles)
Button4_Callback(hObject, eventdata, handles)
return


% --------------------------------------------------------------------
function Menu_Modules_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Modules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_Module_Histogram_Callback(hObject, eventdata, handles)
%
% Copy of Chem2D

if get(handles.OPT1,'Value')
    
    MapsLabel = get(handles.PPMenu1,'String');
    MapsReshape = size(handles.data.map(get(handles.PPMenu1,'Value')).values);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    if get(handles.PPMenu2,'Value') > 1
        AllMask = handles.MaskFile(get(handles.PPMenu3,'Value')).Mask;
        TheMask = zeros(MapsReshape);
        
        TheMask(find(AllMask == get(handles.PPMenu2,'Value')-1)) = ones(length(find(AllMask == get(handles.PPMenu2,'Value')-1)),1);
        
    else
        TheMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.data.map(i).values(:).*TheMask(:).*BRCMask(:);
    end
end

if get(handles.OPT2,'Value')
    
    MapsLabel = handles.quanti(get(handles.QUppmenu2,'Value')).listname;
    MapsReshape = size(handles.quanti(get(handles.QUppmenu2,'Value')).elem(get(handles.QUppmenu1,'Value')).quanti);
    
    NbVar = length(MapsLabel);
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    for i=1:NbVar
        Export(:,i) = handles.quanti(get(handles.QUppmenu2,'Value')).elem(i).quanti(:).*BRCMask(:);
    end
    
end


if get(handles.OPT3,'Value')
    Results = handles.results;
    
    Onest = get(handles.REppmenu1,'Value') - 1;
    if Onest < 1
        warndlg('No result selected')
        return
    end
    
    MapsLabel = Results(Onest).labels;
    MapsReshape = Results(Onest).reshape;
    
    if get(handles.CorrButtonBRC,'Value')
        % there is a BRC correction available
        BRCMask = handles.corrections(1).mask;
    else
        BRCMask = ones(MapsReshape);
    end
    
    NbVar = length(Results(Onest).labels);
    for i = 1:NbVar
        Export(:,i) = Results(Onest).values(:,i).*BRCMask(:);
    end
    %Export = Results(Onest).values;
    
    
    
end

PositionXMapTools = get(gcf,'Position');

Seq = 'XMTModHistTool(';
for i=1:NbVar
    Seq = strcat(Seq,'Export(:,',num2str(i),'),');
end
Seq = strcat(Seq,'MapsLabel,MapsReshape,handles.activecolorbar,PositionXMapTools);');

eval(Seq);

return


% --------------------------------------------------------------------
function Menu_Module_Chem2D_Callback(hObject, eventdata, handles)
Module_Chem2D_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Module_TriPlot3D_Callback(hObject, eventdata, handles)
Module_TriPlot3D_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Module_RGB_Callback(hObject, eventdata, handles)
Module_RGB_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Module_Generator_Callback(hObject, eventdata, handles)
Module_Generator_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_Module_Spider_Callback(hObject, eventdata, handles)
Module_Spider_Callback(hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_About_Callback(hObject, eventdata, handles)
AboutXMapTools_Callback(hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_CleanFigure_Callback(hObject, eventdata, handles)
lesInd = get(handles.axes1,'child');
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if ~isequal(leType,'image');
        delete(lesInd(i));
    end   
end
return


% --------------------------------------------------------------------
function Menu_Copy_Callback(hObject, eventdata, handles)
%f = figure('visible','off');
hf1 = ExportFigureInNewWindow(2,hObject, eventdata, handles);
print(hf1,'-noui','-opengl','-clipboard','-dbitmap')
close(hf1)
warndlg('The image has been copied to the clipboard')
return


% --------------------------------------------------------------------
function Menu_Sampling_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Sampling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_SamplingLine_Callback(hObject, eventdata, handles)
GeneralSamplingFunction(2, hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_SamplingPath_Callback(hObject, eventdata, handles)
GeneralSamplingFunction(1, hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_SamplingArea_Callback(hObject, eventdata, handles)
GeneralSamplingFunction(3, hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_SamplingIntLine_Callback(hObject, eventdata, handles)
GeneralSamplingFunction(4, hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_SamplingSlideWin_Callback(hObject, eventdata, handles)
GeneralSamplingFunction(5, hObject, eventdata, handles);
return

% --------------------------------------------------------------------
function Menu_SamplingSaveFile_Callback(hObject, eventdata, handles)
Val = get(hObject,'Checked');
switch Val
    case 'on'
        set(hObject,'Checked','off');
        set(handles.Menu_SamplingSaveFig,'Enable','off','Checked','off');
    case 'off'
        set(hObject,'Checked','on');
        set(handles.Menu_SamplingSaveFig,'Enable','on','Checked','on');
end
return


% --------------------------------------------------------------------
function Menu_SamplingSaveFig_Callback(hObject, eventdata, handles)
Val = get(hObject,'Checked');
switch Val
    case 'on'
        set(hObject,'Checked','off');
    case 'off'
        set(hObject,'Checked','on'); 
end
return


% --------------------------------------------------------------------
function Menu_SamplingMultiple_Callback(hObject, eventdata, handles)
Val = get(hObject,'Checked');
switch Val
    case 'on'
        set(hObject,'Checked','off');
    case 'off'
        set(hObject,'Checked','on'); 
end


% --------------------------------------------------------------------
function Menu_SamplingColor_Callback(hObject, eventdata, handles)
Val = get(hObject,'Checked');
switch Val
    case 'on'
        set(hObject,'Checked','off');
    case 'off'
        set(hObject,'Checked','on'); 
end
return


% --------------------------------------------------------------------
function Menu_SamplingClean_Callback(hObject, eventdata, handles)
Val = get(hObject,'Checked');
switch Val
    case 'on'
        set(hObject,'Checked','off');
    case 'off'
        set(hObject,'Checked','on'); 
end
return


% --------------------------------------------------------------------
function Menu_Import_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Import_Maps_Callback(hObject, eventdata, handles)
MButton1_Callback(hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_Import_Mosaic_Callback(hObject, eventdata, handles)

% Select the directory containing the maps
MosaicDirectory = [cd,'/Mosaic'];

if ~isequal(exist(MosaicDirectory),7) 
    
    CodeTxt = [17,1];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    MosaicDirectory = uigetdir(cd, 'Mosaic Directory');
    
    if ~MosaicDirectory
        
        CodeTxt = [17,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
end


DIR = dir(MosaicDirectory);
DIR_Flags = [DIR.isdir];

CountMapSet = 0;

ElList = [];
MapSizes = [];


CodeTxt = [17,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

XmapWaitBar(0, handles);

for i = 1:length(DIR_Flags)
    
    if DIR_Flags(i) && ~isequal(DIR(i).name,'.') && ~isequal(DIR(i).name,'..') && ~isequal(DIR(i).name(1),'-')
        
        CountMapSet = CountMapSet + 1;
        
        Directory4Map = [MosaicDirectory,'/',DIR(i).name];
        
        MAPFILES = dir([Directory4Map,'/*.txt']);
        if isempty(MAPFILES)
            MAPFILES = dir([Directory4Map,'/*.csv']);
        end
        NamesTemp = {MAPFILES.name};

        Index = zeros(size(NamesTemp));
        
        for j = 1:length(NamesTemp)
            [Is,Where] = ismember(ElList,NamesTemp{j});
            
            if isempty(Is)
                ElList{end+1} = NamesTemp{j};
                [Is,Where] = ismember(ElList,NamesTemp{j});
            end
            if ~Is
                ElList{end+1} = NamesTemp{j};
                [Is,Where] = ismember(ElList,NamesTemp{j});
            end
            
            
            Where = find(Where);
            
            MapData = load([Directory4Map,'/',NamesTemp{j}],'-ASCII');
            Map4Mosaic(CountMapSet).MapSize = size(MapData);
            Map4Mosaic(CountMapSet).Maps(Where).Name = NamesTemp{j};
            Map4Mosaic(CountMapSet).Maps(Where).Data = MapData;
        end 
        MapSizes(CountMapSet,:) = Map4Mosaic(CountMapSet).MapSize;
       
    end
    XmapWaitBar(i/length(DIR_Flags), handles);
end

CodeTxt = [17,2];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

NbCol = inputdlg({'Number of columns'},'XMapTools',1,{'4'});

if isempty(NbCol)
    CodeTxt = [17,6];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    return
else
    NbCol = str2num(char(NbCol));
end

CodeTxt = [17,4];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

X = [];
Y = [];
MapIdx = [];

CountCol = 0;
CountRow = 1;
for i = 1:size(MapSizes,1)
    CountCol = CountCol+1;
    if CountCol > NbCol
        CountCol = 1;
        CountRow = CountRow +1;
    end
    X(CountRow,CountCol) = MapSizes(i,2);
    Y(CountRow,CountCol) = MapSizes(i,1);
    MapIdx(CountRow,CountCol) = i;
end

NbLinTest = size(MapIdx,1);
NbColTest = size(MapIdx,2);

Xgrid = max(X);
if isequal(NbLinTest,1)   % Only one colomn
    Xgrid = X;
end
Ygrid = max(Y');
if isequal(NbColTest,1)   % Only one colomn
    Ygrid = Y;
end

NewMapSize = [sum(Ygrid),sum(Xgrid)];

NewMaps = zeros([NewMapSize,length(ElList)]);

XmapWaitBar(0, handles);
for i = 1:size(MapSizes,1)
    
    [Lin,Col] = find(MapIdx == i);
    
    Xmin = sum(Xgrid(1:Col-1)) + 1;
    Xmax = sum(Xgrid(1:Col)) ;
    
    Ymin = sum(Ygrid(1:Lin-1)) + 1;
    Ymax = sum(Ygrid(1:Lin)) ;
    
    dX = Xmax-Xmin+1;
    dY = Ymax-Ymin+1;
    
    MapX = MapSizes(i,2);
    MapY = MapSizes(i,1);
    
    ShiftX = floor((dX-(MapX-1))/2);
    ShiftY = floor((dY-(MapY-1))/2);
    
    PosCol(1) = Xmin+ShiftX;
    PosCol(2) = PosCol(1) + MapX - 1;
    PosLin(1) = Ymin+ShiftY;
    PosLin(2) = PosLin(1) + MapY - 1;
    
    for j = 1:size(NewMaps,3)
       NewMaps(PosLin(1):PosLin(2),PosCol(1):PosCol(2),j) = Map4Mosaic(i).Maps(j).Data;
    end
    XmapWaitBar(i/size(MapSizes,1), handles);
end

CodeTxt = [17,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

XmapWaitBar(0, handles);
for i = 1:length(ElList)
    Map4Save = NewMaps(:,:,i);
    save([cd,'/',ElList{i}],'Map4Save','-ASCII');
    XmapWaitBar(i/length(ElList), handles);
end

MButton1_Callback(hObject, eventdata, handles);

return


% --------------------------------------------------------------------
function Menu_Import_Mosaic_Std_Callback(hObject, eventdata, handles)


MosaicDirectory = [cd,'/Mosaic'];

if ~isequal(exist(MosaicDirectory),7) 
    
    CodeTxt = [17,1];
    set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
    TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
    
    MosaicDirectory = uigetdir(cd, 'Mosaic Directory');
    
    if ~MosaicDirectory
        
        CodeTxt = [17,6];
        set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
        TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);
        return
    end
end

DIR = dir(MosaicDirectory);
DIR_Flags = [DIR.isdir];

CountMapSet = 0;

ElList = [];
MapSizes = [];


CodeTxt = [17,3];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

XmapWaitBar(0, handles);

for i = 1:length(DIR_Flags)
    
    if DIR_Flags(i) && ~isequal(DIR(i).name,'.') && ~isequal(DIR(i).name,'..') && ~isequal(DIR(i).name(1),'-')
        
        CountMapSet = CountMapSet + 1;
        
        Directory4Map = [MosaicDirectory,'/',DIR(i).name];
        
        MAPFILES = dir([Directory4Map,'/*.txt']);
        if isempty(MAPFILES)
            MAPFILES = dir([Directory4Map,'/*.csv']);
        end
        NamesTemp = {MAPFILES.name};

        Index = zeros(size(NamesTemp));
        
        for j = 1:length(NamesTemp)
            
            switch NamesTemp{j}
                case 'Classification.txt'
                    
                    % in this version we just skip it
                    
                case 'Standards.txt'
                    
                    % We need to read the map coordinates
                    fid = fopen([Directory4Map,'/Standards.txt'],'r');
                    
                    while 1
                        TheLine = fgetl(fid);
                        
                        if isequal(TheLine,-1)
                            break
                        end
                        
                        if length(TheLine) >= 2
                            if isequal(TheLine(1:2),'>1')
                                TheLine = fgetl(fid);
                                MapCoordinates(CountMapSet,:) = strread(TheLine,'%f');
                                break
                            end
                        end
                        
                    end
                    fclose(fid);                 

                otherwise
                    [Is,Where] = ismember(ElList,NamesTemp{j});

                    if isempty(Is)
                        ElList{end+1} = NamesTemp{j};
                        [Is,Where] = ismember(ElList,NamesTemp{j});
                    end
                    if ~Is
                        ElList{end+1} = NamesTemp{j};
                        [Is,Where] = ismember(ElList,NamesTemp{j});
                    end


                    Where = find(Where);

                    MapData = load([Directory4Map,'/',NamesTemp{j}],'-ASCII');
                    Map4Mosaic(CountMapSet).MapSize = size(MapData);
                    Map4Mosaic(CountMapSet).Maps(Where).Name = NamesTemp{j};
                    Map4Mosaic(CountMapSet).Maps(Where).Data = MapData;
            end
        end 
        MapSizes(CountMapSet,:) = Map4Mosaic(CountMapSet).MapSize;
        
    end
    XmapWaitBar(i/length(DIR_Flags), handles);
end

SizeX = MapCoordinates(:,2)-MapCoordinates(:,1);
SizeY = MapCoordinates(:,3)-MapCoordinates(:,4);

StepX = SizeX./MapSizes(:,2);
StepY = SizeY./MapSizes(:,1);

NewRes = min([StepX;StepY]);

MinX = min(MapCoordinates(:,1));
MaxX = max(MapCoordinates(:,2));
MinY = min(MapCoordinates(:,4));
MaxY = max(MapCoordinates(:,3));

Xsteps = [MinX:NewRes:MaxX];
Ysteps = [MinY:NewRes:MaxY];

Xmtx = repmat(Xsteps,length(Ysteps),1);
Ymtx = repmat(Ysteps',1,length(Xsteps));

NewMapSize = [length(Ysteps),length(Xsteps)];
MapIndex = reshape([1:NewMapSize(1)*NewMapSize(2)],NewMapSize(2),NewMapSize(1));

NewMaps = zeros([NewMapSize,length(ElList)]);

XmapWaitBar(0, handles);
for i = 1:size(MapSizes,1)

    MapRes = StepX(i);
    
    if isequal(MapRes,NewRes)
        TheMapSizes = MapSizes(i,:);
    else
        TheMapSizes = round(MapSizes(i,:).*(MapRes/NewRes));
    end
    
    % The Diff will always be smaller than the pixel size, which means that
    % the projection is good ? less than the pixel size!
    
    [DiffY,WhereY] = min(abs(Ymtx(:)-MapCoordinates(i,4)));
    ValY = Ymtx(WhereY);
    [DiffX,WhereX] = min(abs(Xmtx(:)-MapCoordinates(i,1)));
    ValX = Xmtx(WhereX);
    
    Therow = find(ismember(Ysteps,ValY));
    Thecol = find(ismember(Xsteps,ValX));
    
    Val1 = Therow;
    Val2 = Therow+TheMapSizes(1)-1;
    Val3 = Thecol;
    Val4 = Thecol+TheMapSizes(2)-1;
    
    for j = 1:size(NewMaps,3)
        if isequal(MapRes,NewRes)
            NewMaps(Val1:Val2,Val3:Val4,j) = Map4Mosaic(i).Maps(j).Data;
        else
            ResampledMap = ResampleMapFct(Map4Mosaic(i).Maps(j).Data,MapRes,NewRes);
            
            NewMaps(Val1:Val1+size(ResampledMap,1)-1,Val3:Val3+size(ResampledMap,2)-1,j) = ResampledMap;
        end
    end
    
    
    XmapWaitBar(i/size(MapSizes,1), handles);
end

CodeTxt = [17,5];
set(handles.TxtControl,'String',[char(handles.TxtDatabase(CodeTxt(1)).txt(CodeTxt(2)))]);
TxtColorControl_Callback(CodeTxt, hObject, eventdata, handles);

fid = fopen('Standards.txt','w');
fprintf(fid,'\n%s\n%f\t%f\t%f\t%f\n\n','>1',Xsteps(1),Xsteps(end),Ysteps(end),Ysteps(1));
fclose(fid);

XmapWaitBar(0,  handles);
for i = 1:length(ElList)
    Map4Save = NewMaps(:,:,i);
    save([cd,'/',ElList{i}],'Map4Save','-ASCII');
    XmapWaitBar(i/length(ElList), handles);
end

MButton1_Callback(hObject, eventdata, handles);


return


function [ ResampledMap ] = ResampleMapFct( Matrix, SizePixelIni, SizePixelFinal )
%[ ResampledMap ] = ResampleMap( Matrix, SizePixelIni, SizePixelFinal )
%   Resample a Map of pixel size SizePixelIni in order to get a map with
%   SizePixelFinal

F = griddedInterpolant(double(Matrix));
Ratio=SizePixelIni/SizePixelFinal; %nb pixels equivalent to 1 initial pixel

[sx,sy]=size(Matrix);
xq=(0:1/Ratio:sx)';
yq=(0:1/Ratio:sy)';
vq=(F({xq,yq}));
ResampledMap=vq;

return




% --- Executes during object creation, after setting all properties.
function SettingsAddCLowerMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SettingsAddCLowerMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function SettingsAddCUpperMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SettingsAddCUpperMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Menu_Workspace_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Workspace_Xray_Callback(hObject, eventdata, handles)
handles = AffOPT(1, hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_Workspace_Quanti_Callback(hObject, eventdata, handles)
handles = AffOPT(2, hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_Workspace_Results_Callback(hObject, eventdata, handles)
handles = AffOPT(3, hObject, eventdata, handles);
guidata(hObject, handles);
OnEstOu(hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_AddOns_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_AddOns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Menu_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Menu_Read_JEOLsun_Callback(hObject, eventdata, handles)   % Obsolete
% 
type = 1;
[Ok] = ReadConvertRawData(1,hObject, eventdata, handles);
return


% --------------------------------------------------------------------
function Menu_Convertor_Callback(hObject, eventdata, handles)
% 
PositionXMapTools = get(gcf,'Position');
XMTConverter(handles.LocBase,PositionXMapTools);
return


% --------------------------------------------------------------------
function Menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
