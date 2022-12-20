function varargout = VER_XMTModGenerator_804(varargin)
%VER_XMTMODGENERATOR_804 M-file for VER_XMTModGenerator_804.fig
%      VER_XMTMODGENERATOR_804, by itself, creates a new VER_XMTMODGENERATOR_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODGENERATOR_804 returns the handle to a new VER_XMTMODGENERATOR_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODGENERATOR_804('Property','Value',...) creates a new VER_XMTMODGENERATOR_804 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to VER_XMTModGenerator_804_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      VER_XMTMODGENERATOR_804('CALLBACK') and VER_XMTMODGENERATOR_804('CALLBACK',hObject,...) call the
%      local function named CALLBACK in VER_XMTMODGENERATOR_804.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModGenerator_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:33:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModGenerator_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModGenerator_804_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before VER_XMTModGenerator_804 is made visible.
function VER_XMTModGenerator_804_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

handles.WeClose = 0;

% - - - Data organisation - - -
Export = varargin{1};
MapNames = varargin{2};

for i=1:length(Export)
    Data(i).values = Export(i).map;
    Data(i).label = MapNames{i};
    
    if isvarname(Data(i).label)
        Data(i).variable = Data(i).label;
    else
        Data(i).variable = genvarname(Data(i).label);
    end
    
    VariableNames{i} = char(Data(i).variable);
    Data(i).type = 'input';
    Data(i).export = 0;    
end

% Export,MapsLabel,MapsReshape,GeneratorVariables,handles.LocBase,handles.activecolorbar,PositionXMapTools

% - - - Variable save - - -
handles.Data = Data;
handles.LocBase = char(varargin{5});
handles.ColorMap = varargin{6};
handles.GeneratorVariable = varargin{4};

handles.VariableNames = VariableNames;
handles.MapNames = MapNames;

PositionXMapTools = varargin{7};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.9,0.9]);

set(gcf,'Position',PositionGui);

guidata(hObject, handles);

% - - - Update GUI - - -
axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');
colormap(handles.ColorMap);

set(handles.LISTMAP,'String',VariableNames,'Value',1);

GeneratorVariable = handles.GeneratorVariable;
LabGVar = '';
for i=1:length(GeneratorVariable)
    LabGVar{i} = GeneratorVariable(i).Title;
end
set(handles.MenuGenerVari,'String',LabGVar,'Value',1);

%keyboard

% Update Plot
guidata(hObject, handles);
PlotFunction(handles);

UpdateGeneratorVariablesDisplay(hObject, eventdata, handles);
UpdateTable(handles);

handles.gcf = gcf;

% Choose default command line output for VER_XMTModGenerator_804
handles.output = hObject;

% Update handles structure 
guidata(hObject, handles);

% UIWAIT makes VER_XMTModGenerator_804 wait for user response (see UIRESUME)
uiwait(handles.figure1);

return




% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModGenerator_804_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


if isempty(handles)
    varargout{1} = 0;
else
    varargout{1} = handles.output1;
    
    delete(hObject);
end


return


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



% --- Executes on button press in APPLY.
function APPLY_Callback(hObject, eventdata, handles)
% 


handles.output1 = handles.Data;

handles.WeClose = 1;

guidata(hObject, handles);
close(handles.gcf);

return




function PlotFunction(handles)
%
Data = handles.Data;

axes(handles.Axe_Map);

SelectedMap = get(handles.LISTMAP,'Value');

Data2Plot = Data(SelectedMap).values;
DataMin = min(Data2Plot(:));
DataMax = max(Data2Plot(:));

imagesc(Data2Plot), axis image, 
hc = colorbar('peer',handles.Axe_Map,'vertical');
set(handles.Axe_Map,'xtick',[], 'ytick',[]); 

set(handles.EditMin,'String',num2str(DataMin));
set(handles.EditMax,'String',num2str(DataMax));

return



function UpdateTable(handles)
%
Data = handles.Data;

Count = 0;

for i = 1:length(Data)
    Table2Display{i,1} = char(Data(i).label);
    Table2Display{i,2} = char(Data(i).variable);
    Table2Display{i,3} = char(Data(i).type);
    if isequal(Data(i).type,'output')
        Count = Count+1;
    end
    %Table2Display{i,4} = Data(i).export;
end

if Count > 0
    set(handles.APPLY,'Enable','on','String',['EXIT & SAVE ',num2str(Count),' maps in XMapTools']);
else
    set(handles.APPLY,'Enable','off','String','EXIT & SAVE maps (not yet available)');
end

set(handles.TABLE,'ColumnEditable',logical([0,0,0]))
set(handles.TABLE,'ColumnFormat',{'char','char','char'})
set(handles.TABLE,'ColumnName',{'Map Name','Variable','Type'})
set(handles.TABLE,'ColumnWidth',{'auto','auto','auto'})


set(handles.TABLE,'Data',Table2Display)
drawnow 

return


function UpdateGeneratorVariablesDisplay(hObject, eventdata, handles)
%

GeneratorVariable = handles.GeneratorVariable;

Where = get(handles.MenuGenerVari,'Value');


%keyboard    

for i = 1:length(GeneratorVariable(Where).Code)
    
    TheCode = char(GeneratorVariable(Where).Code{i});
    
    [Success,Error] = CheckAndRunCode('Check', TheCode, hObject, handles);

    Table2Display{i,1} = TheCode;
    
    if ~Success
        Table2Display{i,2} = 'Fail';
    else
        Table2Display{i,2} = 'Ok';
    end    
end

set(handles.TABLE_VARI,'ColumnEditable',logical([0,0]))
set(handles.TABLE_VARI,'ColumnFormat',{'char','char'})
set(handles.TABLE_VARI,'ColumnName',{'Code','Check'})
set(handles.TABLE_VARI,'ColumnWidth',{180,45})

set(handles.TABLE_VARI,'Data',Table2Display);
drawnow 

return



% --- Executes on selection change in LISTMAP.
function LISTMAP_Callback(hObject, eventdata, handles)
% 
PlotFunction(handles);
return

% --- Executes during object creation, after setting all properties.
function LISTMAP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LISTMAP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditMin_Callback(hObject, eventdata, handles)
%
CMin = str2num(get(handles.EditMin,'String'));
CMax = str2num(get(handles.EditMax,'String'));
if CMin < CMax
    axes(handles.Axe_Map)
    caxis([CMin,CMax]);
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
%
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


% --- Executes on button press in ButtonAuto.
function ButtonAuto_Callback(hObject, eventdata, handles)
%
lesInd = get(handles.Axe_Map,'child');
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

axes(handles.Axe_Map)
if Val > 1
    if NTriee(Val) < NTriee(length(NTriee)-Val)
        % V1.4.2 sans caxis
        set(handles.Axe_Map,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        %set(handles.Axe_Map,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        %caxis([NTriee(Val),NTriee(length(NTriee)-Val)]);
    end
else
    return % no posibility to update (size  = 0)
end

set(handles.EditMax,'String',num2str(NTriee(length(NTriee)-Val)));
set(handles.EditMin,'String',num2str(NTriee(Val)));

guidata(hObject,handles);
return

% --- Executes on button press in ExportFigures.
function ExportFigures_Callback(hObject, eventdata, handles)
% hObject    handle to ExportFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function TABLE_CreateFcn(hObject, eventdata, handles)
%
return



function InputCode_Callback(hObject, eventdata, handles)
% hObject    handle to InputCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputCode as text
%        str2double(get(hObject,'String')) returns contents of InputCode as a double


% --- Executes during object creation, after setting all properties.
function InputCode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function [Success,Error,handles] = CheckAndRunCode(Mode, TheCode, hObject, handles)
%
Error = '';
Success = 0;

Data = handles.Data;
VariableNames = handles.VariableNames;
MapNames = handles.MapNames;

% Find null pixels (2.6.1)
ValSum = zeros(size(Data(1).values));
for i = 1:length(Data)
    ValSum = ValSum + Data(i).values;
end
UndefinedPx = find(ValSum == 0);

% Clean and remove the spaces
TheCodeNoSpace = '';
Compt = 0;
for i=1:length(TheCode)
    if ~isequal(TheCode(i),' ')
        Compt = Compt+1;
        TheCodeNoSpace = [TheCodeNoSpace,TheCode(i)];
    end
end

% add the ";"
if ~isequal(TheCodeNoSpace(end),';')
    TheCodeNoSpace(1,end+1) = ';';
end

% Check the output variable name: 
Str2 = strread(TheCodeNoSpace,'%s','delimiter','=');
switch length(Str2)
    case 0
        Error = 'ERROR: This is not a valid MATLAB code.';
        %set(handles.DispError,'Visible','on','String',Error);
        return
    case 1
        Error = 'ERROR: ''='' is missing.';
        %set(handles.DispError,'Visible','on','String',Error);
        return
    case 2
        
    otherwise
        Error = 'ERROR';
        %set(handles.DispError,'Visible','on','String',Error)
        %keyboard
        return
        
end 

OutputVariable = Str2{1};
OutputName = OutputVariable;
RawCode = Str2{2};

if ~isvarname(OutputVariable);
    OutputVariable = genvarname(OutputVariable);
end


% Check that this map does not exist ...
TestMapNames = find(ismember(MapNames,OutputName));
TestVariableNames = find(ismember(VariableNames,OutputVariable));

if TestMapNames 
    switch Data(TestMapNames).type
        case 'input'
            Error = 'This map cannot be replaced (input data).';
            %set(handles.DispError,'Visible','on','String',Error);
            return
    end
    
    switch Mode
    
        case 'Single'
            ButtonName = questdlg('This map already exists; do you want to replace it?','XMapTools Generator','Yes', 'No (cancel)', 'Yes');

            switch ButtonName
                case 'No (cancel)'
                    
                    return
            end
       
        case 'Check'
            Error = 'This map cannot be replaced (input data).';
            %set(handles.DispError,'Visible','on','String',Error);
            return
            
            
    end
    
    Where = TestMapNames;
    ReplaceMap = 1;
else
    Where = length(Data)+1;
    ReplaceMap = 0;
end

% Check RawCode and add spaces
StrCode = RawCode;
for i = 1:length(RawCode)
    
    % check for + and - operators or parentheses
    if isequal(RawCode(i),'+') || isequal(RawCode(i),'-') || isequal(RawCode(i),'(') || isequal(RawCode(i),')') || isequal(RawCode(i),';')
        StrCode(i) = ' ';
    end
    
    if isequal(RawCode(i),'.')
        if i+1 <= length(RawCode)
            % Check for operators at i+1
            if isequal(RawCode(i+1),'*') || isequal(RawCode(i+1),'/') || isequal(RawCode(i+1),'^')
                StrCode(i) = ' ';
                StrCode(i+1) = ' ';
                Skip = 1;
            end
        else
            Skip = 0; 
        end
    else
        Skip = 0; 
    end
    
    if ~Skip
        % check for normal *, / and ^ operators
        if isequal(RawCode(i),'*') || isequal(RawCode(i),'/') || isequal(RawCode(i),'^') 
            StrCode(i) = ' ';
        end
    end
end
 
VarNum = strread(StrCode,'%s');
ComptVar = 0;

for i = 1:length(VarNum)    
    Test = isstrprop(VarNum{i},'digit');
    Test2 = isstrprop(VarNum{i},'punct');
    
    % Check for digits with '.':
    WhereDot = find(Test2);
    if isequal(length(WhereDot),1)
        Test = Test+Test2;
    end
    
    if ~isequal(sum(Test),length(Test))
        % we have a variable, let's check:
        if ~isvarname(VarNum{i})
            Error = ['ERROR: "',VarNum{i},'" is not a valid variable name.'];
            %set(handles.DispError,'Visible','on','String',Error);
            return
        end
        
        if ~ismember(VarNum{i},VariableNames)
            Error = ['ERROR: "',VarNum{i},'" is not available.'];
            %set(handles.DispError,'Visible','on','String',Error);
            return
        else
            ComptVar = ComptVar+1;
            VarList{ComptVar} = VarNum{i};
        end
    end   
end

% If we are here we can continue and generate the variables...
for i = 1:length(Data);
    eval([char(Data(i).variable),' = Data(i).values;']);
end

try
    %disp(['NewVariable = ',RawCode])
    eval(['NewVariable = ',RawCode]) 
    
catch ME
    %keyboard
    Error = ME.message
    %set(handles.DispError,'Visible','on','String',Error);
    return
end

 
switch Mode
    
    case 'Single'
        
        eval(['NewVariable = ',RawCode])
        
        disp(['  # New variable: ',char(OutputVariable), ' (map: ',char(OutputName),')']);
        
        WhereNaN = find(isnan(NewVariable));
        WhereInf = find(isinf(NewVariable));
        
        if length(WhereNaN)
            NewVariable(WhereNaN) = zeros(size(WhereNaN));
            disp(['  ',num2str(length(WhereNaN)),' NaNs have been replaced by Zeros']);
        end
        
        if length(WhereInf)
            NewVariable(WhereInf) = zeros(size(WhereInf));
            disp(['  ',num2str(length(WhereInf)),' Inf have been replaced by Zeros']);
        end
        
        % new 1.6.2
        if length(UndefinedPx)
            NewVariable(UndefinedPx) = zeros(size(UndefinedPx));
            disp(['  ',num2str(length(UndefinedPx)),' undefined values have been replaced by Zeros']);
        end
        
        disp(' ') 
        
        % We save the result: 
        Data(Where).values = NewVariable;
        Data(Where).label = OutputName;
        Data(Where).variable = OutputVariable;
        Data(Where).type = 'output';
        Data(Where).export = 1;

        handles.Data = Data;

        for i = 1:length(Data)
            VariableNames{i} = char(Data(i).variable);
            MapNames{i} = char(Data(i).label);
        end
        handles.VariableNames = VariableNames;
        handles.MapNames = MapNames;

        set(handles.LISTMAP,'String',MapNames,'Value',Where);

        % Update Plot
        guidata(hObject, handles);
        PlotFunction(handles);

        UpdateTable(handles);

        if ReplaceMap
            set(handles.DispError,'Visible','on','String',['The map of "',char(OutputVariable),'" has been updated'],'ForegroundColor',[0 0 1]);
        else
            set(handles.DispError,'Visible','on','String',['The map of "',char(OutputVariable),'" has been generated'],'ForegroundColor',[0 0 1]); 
        end
end


Success = 1;

return






% --- Executes on button press in GENERATE.
function GENERATE_Callback(hObject, eventdata, handles)
% 

set(handles.DispError,'Visible','off','ForegroundColor',[1 0 0]);
set(handles.DispError2,'Visible','off');

TheCode = get(handles.InputCode,'String');

if isequal(TheCode,'type your code here...');
    Error = 'Seriously?';
    set(handles.DispError,'Visible','on','String',Error);
    return
end

[Success,Error,handles] = CheckAndRunCode('Single', TheCode, hObject, handles);

if ~Success
    set(handles.DispError,'Visible','on','String',Error);
end
    

return


% --- Executes on selection change in MenuGenerVari.
function MenuGenerVari_Callback(hObject, eventdata, handles)
%

if isequal(get(handles.MenuGenerVari,'Value'),0)
    keyboard
end

UpdateGeneratorVariablesDisplay(hObject, eventdata, handles);
set(handles.DispError2,'Visible','off');
return

% --- Executes during object creation, after setting all properties.
function MenuGenerVari_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MenuGenerVari (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GENERATE_FILE.
function GENERATE_FILE_Callback(hObject, eventdata, handles)
%

set(handles.DispError,'Visible','off','ForegroundColor',[1 0 0]);
set(handles.DispError2,'Visible','off');

GeneratorVariable = handles.GeneratorVariable;
Where = get(handles.MenuGenerVari,'Value');

%keyboard 
ComptOk = 0;
for i = 1:length(GeneratorVariable(Where).Code)
    
    TheCode = char(GeneratorVariable(Where).Code{i});
    
    [Success,Error,handles] = CheckAndRunCode('Check', TheCode, hObject, handles);
    
    if Success
        [Success,Error,handles] = CheckAndRunCode('Single', TheCode, hObject, handles);
        ComptOk = ComptOk + 1;
    end
    
end

if ComptOk
    set(handles.DispError2,'String',['Success, ',num2str(ComptOk),' new maps have been created'],'ForegroundColor',[0 0 1],'Visible','On');
else
    set(handles.DispError2,'String',['Oups, it seems that you cannot generate any of these maps with your variables!'],'ForegroundColor',[1 0 0],'Visible','On');
end
drawnow

guidata(hObject, handles);

return

    
