function varargout = VER_XMTConverter_804(varargin)
% VER_XMTCONVERTER_804 MATLAB code for VER_XMTConverter_804.fig
%      VER_XMTCONVERTER_804, by itself, creates a new VER_XMTCONVERTER_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTCONVERTER_804 returns the handle to a new VER_XMTCONVERTER_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTCONVERTER_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTCONVERTER_804.M with the given input arguments.
%
%      VER_XMTCONVERTER_804('Property','Value',...) creates a new VER_XMTCONVERTER_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTConverter_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTConverter_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTConverter_804

% Last Modified by GUIDE v2.5 26-Feb-2020 17:49:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTConverter_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTConverter_804_OutputFcn, ...
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


% --- Executes just before VER_XMTConverter_804 is made visible.
function VER_XMTConverter_804_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VER_XMTConverter_804 (see VARARGIN)

handles.LocBase = varargin{2}; 
PositionXMapTools = varargin{3}; 

axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.9,0.9]);

set(gcf,'Position',PositionGui);

handles.Recipe = 0;

handles.WhereState = 0;

handles.WhereStateDestination = '';
handles.WhereStateSource = '';

Data4Conv.Map.NbMaps = 0;
Data4Conv.Map.ListMaps = '';
Data4Conv.Map.ListMapCopied = [];

handles.MapCoord = [0,0,0,0];

Data4Conv.Std.NbElem = 0;
Data4Conv.Std.ListElem = '';
Data4Conv.Std.ListCoor = {'X','Y'};
Data4Conv.Std.NbDataset = 0;
Data4Conv.Std.Dataset(1).Data = [];
Data4Conv.Std.Dataset(1).Com1 = '';
Data4Conv.Std.Dataset(1).DataCoor = [];
Data4Conv.Std.Dataset(1).Com2 = '';
Data4Conv.Std.Dataset(1).IsInMap = [];

handles.Data4Conv = Data4Conv;

handles = OnEstOu(handles);

% Choose default command line output for VER_XMTConverter_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTConverter_804 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTConverter_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = {1};



function [handles] = OnEstOu(handles)
%

% Methods:  (3) EPMA - JEOL SUN 
%           (4) EPMA - JEOL WINDOWS
%           (6) LA-ICP-MS


ValidSelections = [3,4,6];     % UPDATE HERE!
IsSpotRequired = [1,1,0];

FormatMenu = get(handles.FormatMenu,'Value');

MapCoord = handles.MapCoord;
set(handles.Xmin,'String',num2str(MapCoord(1)),'Enable','Off');
set(handles.Xmax,'String',num2str(MapCoord(2)),'Enable','Off');
set(handles.Ymax,'String',num2str(MapCoord(3)),'Enable','Off');
set(handles.Ymin,'String',num2str(MapCoord(4)),'Enable','Off');

set(handles.Button_SetDest,'Visible','Off');
set(handles.FormatMenu,'Enable','Off');
set(handles.Select_Map,'Visible','Off');
set(handles.Select_Std,'Visible','Off');
set(handles.GenClassification,'Visible','Off');
set(handles.GenStandards,'Visible','Off');

if isequal(handles.WhereState,0)         
    set(handles.FormatMenu,'Enable','On');

elseif isequal(handles.WhereState,1)         % Menu selected
    set(handles.FormatMenu,'Enable','On');
    set(handles.Button_SetDest,'Visible','On');
    
elseif isequal(handles.WhereState,2)         % Dest folder selected
    set(handles.Select_Map,'Visible','On');
    
elseif isequal(handles.WhereState,3)     % maps have been copied
    set(handles.GenClassification,'Visible','On');
    
elseif isequal(handles.WhereState,4)     % Classification.txt has been generated
    set(handles.Select_Std,'Visible','On');

elseif isequal(handles.WhereState,5)     % Standard data read
    set(handles.Select_Std,'Visible','On');
    set(handles.GenStandards,'Visible','On');
    
end 
    
    

if find(ismember(ValidSelections,FormatMenu))
    
    if length(handles.WhereStateDestination) > 3
        
        Where = find(ismember(ValidSelections,FormatMenu));

        Data4Conv = handles.Data4Conv;

        % Maps
        
        if Data4Conv.Map.NbMaps > 0 
            
            Data2TableMap = cell(Data4Conv.Map.NbMaps,3);
            
            for i = 1:Data4Conv.Map.NbMaps
                
                Data2TableMap(i,1) = Data4Conv.Map.ListMaps(i);
                Data2TableMap(i,2) = {'Copied to -->'};
                Data2TableMap(i,3) = Data4Conv.Map.ListMapCopied(i);
            end
            
            set(handles.Table_Maps,'Units','pixels');
            PositionTable = get(handles.Table_Maps,'Position');
            set(handles.Table_Maps,'Units','normalized');
            set(handles.Table_Maps,'Data',Data2TableMap,'ColumnWidth',{0.30*PositionTable(3),0.399*PositionTable(3),0.30*PositionTable(3)});
            
            set(handles.Table_Maps,'Visible','On');
            set(handles.Select_Map,'Visible','Off');
            
            
            set(handles.Xmin,'Visible','On')
            set(handles.Xmax,'Visible','On')
            set(handles.Ymax,'Visible','On')
            set(handles.Ymin,'Visible','On')
            
            set(handles.text_1,'Visible','On')
            set(handles.text_2,'Visible','On')
            set(handles.text_3,'Visible','On')
            set(handles.text_4,'Visible','On')
            
        else
            set(handles.Table_Maps,'Visible','Off');
        end

        % Std
        if IsSpotRequired(Where) > 0
            
            if Data4Conv.Std.NbDataset >= 1 
                
                Data2TableStd = cell(1000,1+2+length(Data4Conv.Std.ListElem)+2);
                Compt = 0;
                for i = 1:Data4Conv.Std.NbDataset
                    for j = 1:length(Data4Conv.Std.Dataset(i).Com1)
                        Compt = Compt+1;
                        
                        if Data4Conv.Std.Dataset(i).IsInMap(j) > 0
                            Data2TableStd(Compt,1) = {'Yes'};
                        else
                            Data2TableStd(Compt,1) = {'No'};
                        end
                         
                        Data2TableStd(Compt,2) = Data4Conv.Std.Dataset(i).Com1(j);
                        Data2TableStd(Compt,3) = Data4Conv.Std.Dataset(i).Com2(j);
                
                        Data2TableStd(Compt,4:end-2) = num2cell(Data4Conv.Std.Dataset(i).Data(j,:));
                        
                        Data2TableStd(Compt,end-1:end) = num2cell(Data4Conv.Std.Dataset(i).DataCoor(j,:));
                    end
                end
                    
                Data2TableStd = Data2TableStd(1:Compt,:);
                set(handles.Table_Std,'Data',Data2TableStd);
                
                set(handles.Table_Std,'ColumnName',['In Map','Comment (summary)','Comment (stage)',Data4Conv.Std.ListElem,'X','Y']);
                set(handles.Table_Std,'Visible','On');
                
                %set(handles.GenStandards,'Visible','On');
            else
                
                
                %keyboard 
                set(handles.Table_Std,'Visible','Off');
            end
        else
            %set(handles.Select_Std,'Visible','Off');
            set(handles.Table_Std,'Visible','Off');
        end
        
    else
        %set(handles.Button_SetDest,'Visible','On');
        
        set(handles.Table_Maps,'Visible','Off');
        set(handles.Table_Std,'Visible','Off');
        %set(handles.Select_Map,'Visible','Off');
        %set(handles.Select_Std,'Visible','Off');
    end
        
        
        
else
    %set(handles.Button_SetDest,'Visible','Off');
    
    set(handles.Table_Maps,'Visible','Off');
    set(handles.Table_Std,'Visible','Off');
    %set(handles.Select_Map,'Visible','Off');
    %set(handles.Select_Std,'Visible','Off');
    
    %set(handles.GenClassification,'Visible','Off');
    %set(handles.GenStandards,'Visible','Off');
    
    set(handles.Xmin,'Visible','Off')
    set(handles.Xmax,'Visible','Off')
    set(handles.Ymax,'Visible','Off')
    set(handles.Ymin,'Visible','Off')
    
    set(handles.text_1,'Visible','Off')
    set(handles.text_2,'Visible','Off')
    set(handles.text_3,'Visible','Off')
    set(handles.text_4,'Visible','Off')
end
    
  


return






% --- Executes on selection change in FormatMenu.
function FormatMenu_Callback(hObject, eventdata, handles)
%
ValidSelections = [3,4,6];     % UPDATE HERE!

if find(ismember(ValidSelections,get(hObject,'Value')))
    handles.WhereState = 1;
    handles.Recipe = find(ismember(ValidSelections,get(hObject,'Value')));
    
    switch handles.Recipe
        case 1      % SUN JEOL
            Comment_Maps = {'> Required JEOL files (MAPS)','   2 files per map (XX): XX.cnd & XX_map.txt'};
            Comment_Spots = {'> Required JEOL files (STD)','   2 files per dataset: summary.txt & stage.txt'};
        
        case 2      % SUN WINDOWS
            Comment_Maps = {'> Required JEOL files (MAPS):','   2 files per map (X): data00X.cnd & data00X.csv'};   
            Comment_Spots = {'> Required JEOL files (STD)','   1 file per dataset: summary.csv'};
            
    end
    
    set(handles.Comment_Maps,'String',Comment_Maps)
    set(handles.Comment_Spots,'String',Comment_Spots)      
    
else
    handles.WhereState = 0;
    handles.Recipe = 0;
end
[handles] = OnEstOu(handles);
guidata(hObject, handles);  
return



% --- Executes during object creation, after setting all properties.
function FormatMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FormatMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Select_Map.
function Select_Map_Callback(hObject, eventdata, handles)
%

WhereSource = uigetdir(cd, ['Pick a Directory']);
WhereDestination = handles.WhereStateDestination;

Data4Conv = handles.Data4Conv;

if isequal(WhereSource,WhereDestination)
    errordlg('The source and destination directories must be different!','Error')
    return
end

hWait = waitbar(1,'Copying the maps, please wait...');

Compt = 0;
for i = 1:1000
    FileName = num2str(i);
    
    switch handles.Recipe
        case 1          % JEOL SUN

            if exist([WhereSource,'/',FileName,'.cnd']) && exist([WhereSource,'/',FileName,'_map.txt'])
                [Name] = ReadCndFileMapSUN([WhereSource,'/',FileName,'.cnd']);
                
                [Success,Message,MessageID] = copyfile([WhereSource,'/',FileName,'_map.txt'],[WhereDestination,'/',Name,'.txt']);
                
                if Success
                    disp(['>> Copying ',FileName,'_map.txt  ->  ',Name,'.txt   -  Done']);
                    
                    Compt = Compt+1;
                    
                    Data4Conv.Map.NbMaps = Compt;
                    Data4Conv.Map.ListMaps{Compt} = [FileName,'_map.txt'];
                    Data4Conv.Map.ListMapCopied{Compt} = [Name,'.txt'];
                    
                else
                    disp('  ')
                    disp(['** WARNING ** ',FileName,'_map.txt  not found']);
                    disp('  ')
                end
                
            else
                break
            end
            
            
        case 2      % JEOL WIN
            
            if i >= 10
                Frag = 'Data0';
            else
                Frag = 'Data00';
            end
                
            
            if exist([WhereSource,'/',Frag,FileName,'.cnd']) && exist([WhereSource,'/',Frag,FileName,'.csv'])
                
                [Name,MapCoord] = ReadCndFileMapWIN([WhereSource,'/',Frag,FileName,'.cnd']);
                
                [Success,Message,MessageID] = copyfile([WhereSource,'/',Frag,FileName,'.csv'],[WhereDestination,'/',Name,'.csv']);
                
                if Success
                    disp(['>> Copying ',FileName,'_map.txt  ->  ',Name,'.txt   -  Done']);
                    
                    Compt = Compt+1;
                    
                    Data4Conv.Map.NbMaps = Compt;
                    Data4Conv.Map.ListMaps{Compt} = [Frag,FileName,'.csv'];
                    Data4Conv.Map.ListMapCopied{Compt} = [Name,'.csv'];
                    
                else
                    disp('  ')
                    disp(['** WARNING ** ',FileName,'_map.txt  not found']);
                    disp('  ')
                end
                
            else
                break
            end
            
            
            
            
    end
end

handles.WhereStateSource = WhereSource;
handles.Data4Conv = Data4Conv;

if isequal(handles.Recipe,1)
    % Extract the map coordinates
    [MapCoord] = ReadZeroCndFile([WhereSource,'/0.cnd']);

    disp('  '); disp('  ');
    disp('>> Coordinates extracted from 0.cnd ');
end

handles.MapCoord = MapCoord;

close(hWait);

handles.WhereState = 3;

[handles] = OnEstOu(handles);

guidata(hObject, handles);  
return



function [Name,MapCoord] = ReadCndFileMapWIN(FileName)
% Subroutine to read a cnd map file.
%

fid = fopen(FileName);

X = zeros(4,1);
Y = zeros(4,1);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr) > 1

            if isequal(TheStr{1},'$XM_ELEM_NAME%0')
                Name = TheStr{2};
            end

            if isequal(TheStr{1},'$XM_ELEM_WDS_CRYSTAL_NAME%0')
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

            if isequal(TheStr{1},'$XM_AP_SA_STAGE_POS%0_1')
                X(1) = str2num(TheStr{2});
                Y(1) = str2num(TheStr{3});
            end
            
            if isequal(TheStr{1},'$XM_AP_SA_STAGE_POS%0_2')
                X(2) = str2num(TheStr{2});
                Y(2) = str2num(TheStr{3});
            end

            if isequal(TheStr{1},'$XM_AP_SA_STAGE_POS%0_3')
                X(3) = str2num(TheStr{2});
                Y(3) = str2num(TheStr{3});
            end

            if isequal(TheStr{1},'$XM_AP_SA_STAGE_POS%0_4')
                X(4) = str2num(TheStr{2});
                Y(4) = str2num(TheStr{3});
            end
            
        end
    end
end

MapCoord = [max(X),min(X),max(Y),min(Y)];

return

function [Name] = ReadCndFileMapSUN(FileName)
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






% --- Executes on button press in Select_Std.
function Select_Std_Callback(hObject, eventdata, handles)
%

WhereSource = handles.WhereStateSource;


Data4Conv = handles.Data4Conv;
NbDataset = Data4Conv.Std.NbDataset;

WhereDS = NbDataset+1;

[filename, pathname, filterindex] = uigetfile({'*.txt','TEXT-file (*.txt)';'*.csv','CSV-file (*.csv)'; ...
    '*.*',  'All Files (*.*)'},'Select SUMMARY file...');

switch handles.Recipe
    case 1          % JEOL SUN
        DataTEMP = ReadSummaryFileSUN([pathname,filename]);
    case 2
        DataTEMP = ReadSummaryFileWIN([pathname,filename]);   
end
        
Data4Conv.Std.NbDataset = WhereDS;

for i = 1:length(DataTEMP.Labels)
    
    El = DataTEMP.Labels{i};
    Where = find(ismember(Data4Conv.Std.ListElem,El));
    
    if isempty(Where)
        Idx = length(Data4Conv.Std.ListElem)+1;
        Data4Conv.Std.ListElem{Idx} = El;
    else
        Idx = Where;
    end
    
    Data4Conv.Std.Dataset(WhereDS).Data(:,Idx) = DataTEMP.Data(:,i);
end

Data4Conv.Std.Dataset(WhereDS).Com1 = DataTEMP.Comments';

switch handles.Recipe
    case 1          % JEOL SUN
        [filename, pathname, filterindex] = uigetfile({'*.txt','TEXT-file (*.txt)';'*.csv','CSV-file (*.csv)'; ...
            '*.*',  'All Files (*.*)'},'Select STAGE file...');
        
        [Coord,Comment] = ReadStageFile([pathname,filename]);
        
        
    case 2
        Coord = DataTEMP.Coord;
        Comment = DataTEMP.Comments;   
end

Data4Conv.Std.Dataset(WhereDS).DataCoor = Coord;
Data4Conv.Std.Dataset(WhereDS).Com2 = Comment';

MapCoord = handles.MapCoord;

IsInMap = zeros(size(Coord,1),1);


for i = 1:length(IsInMap)
    switch handles.Recipe
        case 1          % JEOL SUN
            if Coord(i,1) > MapCoord(1) &&  Coord(i,1) < MapCoord(2) && Coord(i,2) > MapCoord(4) &&  Coord(i,2) < MapCoord(3)
                IsInMap(i) =1;
            end
        case 2
            if Coord(i,1) < MapCoord(1) &&  Coord(i,1) > MapCoord(2) && Coord(i,2) < MapCoord(3) &&  Coord(i,2) > MapCoord(4)
                IsInMap(i) =1;
            end
    end
end

Data4Conv.Std.Dataset(WhereDS).IsInMap = IsInMap;


% CHECK SIZE BEFORE TO CONTINUE?


handles.Data4Conv = Data4Conv;

handles.WhereState = 5;

[handles] = OnEstOu(handles);
guidata(hObject, handles); 
return




function [Coord,Comment] = ReadStageFile(FileName)
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
                
                WhereComment = find(ismember(Labels,'Comment'));
                
                Compt = 0;
                while 1
                    TheLine = fgetl(fid);
                    if length(TheLine) > 10
                        Compt = Compt+1;
                        TheStr = strread(TheLine,'%s','delimiter','\t');
                        Coord(Compt,2) = str2double(TheStr(WhereX));    % INVERTED (SUN)    
                        Coord(Compt,1) = str2double(TheStr(WhereY));    % INVERTED (SUN)     
                        Comment{Compt} = TheStr{WhereComment};
                    else
                        break
                    end
                    
                    
                end
            end
        end
    end
end

return

function [Data] = ReadSummaryFileSUN(FileName)
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

%Data.Labels{end+1} = 'X';
%Data.Labels{end+1} = 'Y';

return

function [DataOk] = ReadSummaryFileWIN(FileName)
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

            if isequal(TheStr{1},'Point')
                Data.Labels = TheStr(2:end);   % we skip the raw number
                
                NbLabels = length(Data.Labels);
                Compt = 0;
                while 1
                    TheLine = fgetl(fid);
                    TheStr = strread(TheLine,'%s');
                    if length(TheStr) > 10
                        Compt = Compt+1;
                        Data.Data(Compt,:) = str2double(TheStr(end-(NbLabels-1):end-1));
                        Data.Comments{Compt} = strcat(TheStr{2:end-NbLabels});
                    else
                        break
                    end
                    
                    
                end
            end
        end
    end
end

Labels = Data.Labels;
Type = zeros(size(Labels));
Compt = 0;

for i = 1:length(Labels)
    if isequal(Labels{i},'Comment')
        Type(i) = 1;
    elseif isequal(Labels{i},'X')
        Type(i) = 2;
    elseif isequal(Labels{i},'Y')  
        Type(i) = 3;
    elseif length(Labels{i}) > 6
        if isequal(Labels{i}(end-6:end),'(Mass%)')
            Compt = Compt+1;
            Elem{Compt} = Labels{i}(1:end-7);
            Type(i) = 4;
        end
    end
end

% We exclude the total: 

WhereOk = find(Type == 4)-1;    % 
WhereOk = WhereOk(1:end-1);     % Exclude the total

DataOk.Labels = Elem(1:end-1);
DataOk.Data = Data.Data(:,WhereOk);

DataOk.Comments = Data.Comments;

WhereX = find(Type == 2)-1;
WhereY = find(Type == 3)-1;

DataOk.Coord = [Data.Data(:,WhereX),Data.Data(:,WhereY)];

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



% --- Executes on button press in Button_SetDest.
function Button_SetDest_Callback(hObject, eventdata, handles)
% 
WhereDestination = uigetdir(cd, ['Create the Map Directory']);


% Check if the destination folder is empty (should be empty)
Files = dir(WhereDestination);

for i = 1:length(Files)
    if Files(i).bytes > 0
        
        Answer = questdlg(char('Directory is not empty and files will be deleted. Continue?'),'Warning','Yes','No','Yes');
        
        if ~isequal(Answer,'Yes')
            return
        end
        
        [SUCCESS,MESSAGE,MESSAGEID] = rmdir(WhereDestination,'s');
        [SUCCESS,MESSAGE,MESSAGEID] = mkdir(WhereDestination);
        
        handles.WhereStateDestination = WhereDestination;
        handles.WhereState = 2;
        
        handles = OnEstOu(handles);
        guidata(hObject, handles);
        
        return
    end
end

handles.WhereState = 2;

handles.WhereStateDestination = WhereDestination;
handles = OnEstOu(handles);
guidata(hObject, handles);  
return


% --- Executes on button press in GenClassification.
function GenClassification_Callback(hObject, eventdata, handles)
%

WhereDestination = handles.WhereStateDestination;

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

handles.WhereState = 4;
[handles] = OnEstOu(handles);
guidata(hObject, handles);  
return


% --- Executes on button press in GenStandards.
function GenStandards_Callback(hObject, eventdata, handles)
%

WhereDestination = handles.WhereStateDestination;
MapCoord = handles.MapCoord;
Data4Conv = handles.Data4Conv;

ElList = Data4Conv.Std.ListElem;


fid = fopen([WhereDestination,'/Standards.txt'],'w');
fprintf(fid,'\n\n%s\n','>1');
fprintf(fid,'%f\t%f\t%f\t%f\n',MapCoord);
fprintf(fid,'\n\n%s\n','>2');
for i=1:length(ElList)
    fprintf(fid,'%s\t',ElList{i});
end
fprintf(fid,'%s\t%s','X','Y');
fprintf(fid,'\n\n\n%s\n','>3');


for i = 1:Data4Conv.Std.NbDataset
	for j = 1:length(Data4Conv.Std.Dataset(i).Com1)
        
        if Data4Conv.Std.Dataset(i).IsInMap(j)
            ConvInd = Data4Conv.Std.Dataset(i).Data(j,:);
            
            for iC = 1:numel(ConvInd)
                if ConvInd(iC) > 0
                    fprintf(fid,'%f\t',ConvInd(iC));
                else
                    fprintf(fid,'%f\t',0);
                end
            end
            fprintf(fid,'%f\t',Data4Conv.Std.Dataset(i).DataCoor(j,1));
            fprintf(fid,'%f\n',Data4Conv.Std.Dataset(i).DataCoor(j,2));
        end
    end
end

fclose(fid);

%keyboard

cd(WhereDestination);    % Implemented in XMapTools

close(gcf);

return






function Xmin_Callback(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xmin as text
%        str2double(get(hObject,'String')) returns contents of Xmin as a double


% --- Executes during object creation, after setting all properties.
function Xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xmax_Callback(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xmax as text
%        str2double(get(hObject,'String')) returns contents of Xmax as a double


% --- Executes during object creation, after setting all properties.
function Xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ymin_Callback(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ymin as text
%        str2double(get(hObject,'String')) returns contents of Ymin as a double


% --- Executes during object creation, after setting all properties.
function Ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ymax_Callback(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ymin as text
%        str2double(get(hObject,'String')) returns contents of Ymin as a double


% --- Executes during object creation, after setting all properties.
function Ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunOnEstOu.
function RunOnEstOu_Callback(hObject, eventdata, handles)
%
OnEstOu(handles);
return
